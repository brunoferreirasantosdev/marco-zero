param(
  [string]$FeedUrl = ""
)

$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

$pubspec = Get-Content -Raw pubspec.yaml
if ($pubspec -notmatch "version:\s*([0-9]+\.[0-9]+\.[0-9]+)") {
  throw "Não encontrei a versão em pubspec.yaml"
}
$versao = $Matches[1]

$define = @()
if ($FeedUrl) {
  $define = @("--dart-define=FEED_ATUALIZACAO=$FeedUrl")
}

flutter build windows --release @define
if ($LASTEXITCODE -ne 0) { throw "O build do Windows falhou." }

$release = "build\windows\x64\runner\Release"
$dist = "dist"
New-Item -ItemType Directory -Force -Path $dist | Out-Null
$zipNome = "marco-zero-$versao.zip"
$zip = Join-Path $dist $zipNome
if (Test-Path $zip) { Remove-Item $zip }
Compress-Archive -Path "$release\*" -DestinationPath $zip

$base = ""
if ($FeedUrl) {
  $base = $FeedUrl.Substring(0, $FeedUrl.LastIndexOf("/") + 1)
}
$urlZip = if ($base) { "$base$zipNome" } else { "https://SEU_ENDERECO/$zipNome" }
@{
  versao = $versao
  url = $urlZip
  notas = ""
} | ConvertTo-Json | Set-Content -Path (Join-Path $dist "latest.json") -Encoding utf8

Write-Output "Pacote: $zip"
Write-Output "Feed: $(Join-Path $dist 'latest.json')"
Write-Output "Publique os dois no mesmo endereço. A instalação antiga baixa o zip e se substitui."
