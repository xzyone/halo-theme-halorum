$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$themeRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$distPath = Join-Path $themeRoot "dist"
$zipFileName = "Halorum.zip"
$zipPath = Join-Path $distPath $zipFileName
$legacyZipPath = Join-Path (Split-Path $themeRoot -Parent) $zipFileName

if (-not (Test-Path -LiteralPath $distPath)) {
  New-Item -ItemType Directory -Path $distPath | Out-Null
}

if (Test-Path -LiteralPath $zipPath) {
  Remove-Item -LiteralPath $zipPath -Force
}

$stream = [System.IO.File]::Open($zipPath, [System.IO.FileMode]::CreateNew)
try {
  $archive = [System.IO.Compression.ZipArchive]::new($stream, [System.IO.Compression.ZipArchiveMode]::Create)
  try {
    Get-ChildItem -LiteralPath $themeRoot -Recurse -File -Force |
      Where-Object {
        $normalizedPath = $_.FullName.Replace("\", "/")
        $normalizedPath -notmatch "/node_modules/" -and
        $normalizedPath -notmatch "/\\.git/" -and
        $normalizedPath -notmatch "/\\.astro/" -and
        $normalizedPath -notmatch "/dist/" -and
        $normalizedPath -notmatch "/\\.vscode/" -and
        $normalizedPath -notmatch "/\\.idea/" -and
        $_.Extension -ne ".zip"
      } |
      ForEach-Object {
        $relativePath = $_.FullName.Substring($themeRoot.Length + 1).Replace("\", "/")
        $entry = $archive.CreateEntry($relativePath, [System.IO.Compression.CompressionLevel]::Optimal)
        $inputStream = [System.IO.File]::OpenRead($_.FullName)
        try {
          $entryStream = $entry.Open()
          try {
            $inputStream.CopyTo($entryStream)
          } finally {
            $entryStream.Dispose()
          }
        } finally {
          $inputStream.Dispose()
        }
      }
  } finally {
    $archive.Dispose()
  }
} finally {
  $stream.Dispose()
}

Copy-Item -LiteralPath $zipPath -Destination $legacyZipPath -Force

Write-Output $zipPath
