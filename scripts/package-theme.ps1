$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$themeRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$zipPath = Join-Path (Split-Path $themeRoot -Parent) "Halorum.zip"

if (Test-Path -LiteralPath $zipPath) {
  Remove-Item -LiteralPath $zipPath -Force
}

$stream = [System.IO.File]::Open($zipPath, [System.IO.FileMode]::CreateNew)
try {
  $archive = [System.IO.Compression.ZipArchive]::new($stream, [System.IO.Compression.ZipArchiveMode]::Create)
  try {
    Get-ChildItem -LiteralPath $themeRoot -Recurse -File -Force |
      Where-Object {
        $_.FullName -notmatch "\\node_modules\\" -and
        $_.FullName -notmatch "\\\.astro\\" -and
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

Write-Output $zipPath
