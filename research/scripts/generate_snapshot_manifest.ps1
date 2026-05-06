param(
    [string]$ExtractedPath = ".\research\extracted",
    [string]$OutputPath = ".\research\snapshot_manifest.csv",
    [string]$GameVersion = "PC 1.123.85.1020",
    [string]$ExtractedDate = (Get-Date -Format "yyyy-MM-dd")
)

$resolvedRoot = Resolve-Path -LiteralPath $ExtractedPath -ErrorAction Stop
$rootPath = $resolvedRoot.Path.TrimEnd('\')

$rows = Get-ChildItem -LiteralPath $rootPath -Recurse -File |
    Where-Object { $_.Extension -ieq ".xml" } |
    Sort-Object FullName |
    ForEach-Object {
        $relativePath = $_.FullName.Substring($rootPath.Length).TrimStart('\') -replace '\\', '/'
        $hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant()

        [PSCustomObject]@{
            relative_path  = $relativePath
            sha256         = $hash
            file_size      = $_.Length
            extracted_date = $ExtractedDate
            game_version   = $GameVersion
        }
    }

$rowList = @($rows)

if ($rowList.Count -eq 0) {
    "relative_path,sha256,file_size,extracted_date,game_version" |
        Set-Content -LiteralPath $OutputPath -Encoding UTF8
} else {
    $rowList | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding UTF8
}

Write-Host "Wrote $($rowList.Count) XML hash rows to $OutputPath"
