param(
  [string]$ZipPath = (Join-Path $PSScriptRoot "../dist/Halorum.zip"),
  [string]$ThemeRoot = (Join-Path $PSScriptRoot "..")
)
$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression.FileSystem
$ThemeRoot = (Resolve-Path -LiteralPath $ThemeRoot).Path

# Validate the actual archive, independently of the packaging exclusion rules.
$required = @("theme.yaml", "settings.yaml", "templates/index.html", "templates/post.html")
foreach ($directory in @("public", "templates")) {
  $files = @(Get-ChildItem -LiteralPath (Join-Path $ThemeRoot $directory) -Recurse -File -Force)
  if ($files.Count -eq 0) { throw "Empty runtime directory: $directory" }
  $required += $files | ForEach-Object { $_.FullName.Substring($ThemeRoot.Length + 1).Replace("\", "/") }
}
# Public assets must also have been copied by Astro to the served templates tree.
$required += Get-ChildItem -LiteralPath (Join-Path $ThemeRoot "public") -Recurse -File -Force |
  ForEach-Object { "templates/" + $_.FullName.Substring((Join-Path $ThemeRoot "public").Length + 1).Replace("\", "/") }
foreach ($kind in @("styles", "fonts", "images")) {
  $files = @(Get-ChildItem -LiteralPath (Join-Path $ThemeRoot "public/assets/theme/dist/$kind") -File)
  if ($files.Count -eq 0) { throw "Missing bundled $kind" }
}

$archive = [System.IO.Compression.ZipFile]::OpenRead((Resolve-Path -LiteralPath $ZipPath).Path)
try {
  $entries = [System.Collections.Generic.Dictionary[string, System.IO.Compression.ZipArchiveEntry]]::new([System.StringComparer]::Ordinal)
  foreach ($entry in $archive.Entries) {
    $name = $entry.FullName
    if ($name -match "(^|/)(node_modules|\.git|\.astro|\.vscode|\.idea)/|^dist/|\.zip$" -or $name.Contains("\")) {
      throw "Forbidden archive entry: $name"
    }
    $entries.Add($name, $entry)
  }
  foreach ($name in ($required | Sort-Object -Unique)) {
    if (-not $entries.ContainsKey($name)) { throw "Missing archive entry: $name" }
    $source = Join-Path $ThemeRoot $name
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) { throw "Missing build output: $name" }
    $stream = $entries[$name].Open()
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
      $actual = [BitConverter]::ToString($sha.ComputeHash($stream)).Replace("-", "")
      # Use .NET for both streams: Windows PowerShell launched from pwsh may
      # inherit a module path that does not expose Get-FileHash.
      $sourceStream = [System.IO.File]::OpenRead($source)
      try {
        $expected = [BitConverter]::ToString($sha.ComputeHash($sourceStream)).Replace("-", "")
      } finally { $sourceStream.Dispose() }
      if ($actual -ne $expected) { throw "Archive content mismatch: $name" }
    } finally {
      $sha.Dispose()
      $stream.Dispose()
    }
  }
} finally { $archive.Dispose() }
Write-Output "Verified theme package: $ZipPath"
