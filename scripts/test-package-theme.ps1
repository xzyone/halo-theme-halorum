$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression.FileSystem
$temp = Join-Path ([System.IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString())
# Parent names must not affect repository-relative filtering.
$root = Join-Path $temp "dist/node_modules/theme"
function Put([string]$name, [string]$value = "fixture") {
  $file = Join-Path $root $name
  New-Item -ItemType Directory -Force -Path (Split-Path $file -Parent) | Out-Null
  [System.IO.File]::WriteAllText($file, $value)
}
function ExpectFailure([scriptblock]$action, [string]$pattern) {
  try { & $action } catch {
    if ($_.Exception.Message -notmatch $pattern) { throw }
    return
  }
  throw "Expected failure: $pattern"
}
try {
  Put "scripts/placeholder"
  Copy-Item "$PSScriptRoot/package-theme.ps1", "$PSScriptRoot/verify-theme-package.ps1" (Join-Path $root "scripts")
  foreach ($name in @("theme.yaml", "settings.yaml", "templates/index.html", "templates/post.html")) { Put $name }
  foreach ($name in @("styles/site.css", "fonts/site.woff2", "images/site.png")) {
    Put "public/assets/theme/dist/$name"
    Put "templates/assets/theme/dist/$name"
  }
  foreach ($name in @("dist/stale.txt", "dist/old.zip", ".git/config", ".astro/cache", ".vscode/settings.json", ".idea/config", "node_modules/pkg/file", "nested/node_modules/pkg/file", "old.zip")) { Put $name }
  $package = Join-Path $root "scripts/package-theme.ps1"
  $verify = Join-Path $root "scripts/verify-theme-package.ps1"
  $zip = Join-Path $root "dist/Halorum.zip"
  & $package
  & $verify
  & $package # Repacking must exclude the existing output and stale files.
  if ((Get-FileHash $zip).Hash -ne (Get-FileHash (Join-Path (Split-Path $root -Parent) "Halorum.zip")).Hash) { throw "Legacy copy differs" }
  foreach ($name in @("public/assets/theme/dist/styles/site.css", "templates/assets/theme/dist/fonts/site.woff2", "templates/post.html")) {
    & $package
    $archive = [System.IO.Compression.ZipFile]::Open($zip, "Update")
    try { $archive.GetEntry($name).Delete() } finally { $archive.Dispose() }
    ExpectFailure { & $verify } "Missing archive entry"
  }
  & $package
  $archive = [System.IO.Compression.ZipFile]::Open($zip, "Update")
  try { $archive.CreateEntry(".git/config") | Out-Null } finally { $archive.Dispose() }
  ExpectFailure { & $verify } "Forbidden archive entry"
  & $package
  Put "public/assets/theme/dist/images/site.png" "changed"
  ExpectFailure { & $verify } "Archive content mismatch"
  Remove-Item (Join-Path $root "templates/assets/theme/dist/images/site.png")
  ExpectFailure { & $package } "Missing archive entry"
  if (Test-Path -LiteralPath $zip) { throw "Invalid package was not removed" }
  Write-Output "Packaging regression tests passed."
} finally {
  Remove-Item -LiteralPath $temp -Recurse -Force
}
