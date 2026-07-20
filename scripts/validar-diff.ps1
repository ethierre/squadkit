# validar-diff.ps1 - orcamento de diff (enforcement da "mudanca cirurgica" em codigo).
# Task cujo diff excede o limite = reprova automatica -> volta ao arquiteto para fatiar.
# Uso: pwsh -File validar-diff.ps1 -Repo <clone> -Branch <branch da task> [-Base <branch>] [-Limite <n>]
#   Base default = branch do manifesto squad\.squadkit.json; Limite default = diffMaximo do
#   manifesto (fallback 400 linhas somando insercoes+delecoes).
# Exit 0 = dentro do orcamento · Exit 1 = estourou (ou erro)
param(
    [Parameter(Mandatory = $true)][string]$Repo,
    [Parameter(Mandatory = $true)][string]$Branch,
    [string]$Base,
    [int]$Limite = 0
)

$ErrorActionPreference = 'Stop'
$raiz = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
$manPath = Join-Path (Join-Path $raiz 'squad') '.squadkit.json'
if (Test-Path $manPath) {
    $man = Get-Content $manPath -Raw | ConvertFrom-Json
    if (-not $Base) { $Base = $man.branch }
    if ($Limite -le 0 -and $man.PSObject.Properties['diffMaximo']) { $Limite = [int]$man.diffMaximo }
}
if (-not $Base) { $Base = 'develop' }
if ($Limite -le 0) { $Limite = 400 }

if (-not (Test-Path (Join-Path $Repo '.git'))) { Write-Host "ERRO: nao e um repositorio git: $Repo"; exit 1 }
# PS 5.1: stderr de comando nativo sob ErrorActionPreference=Stop mata o script -> baixa o EAP nos gits
$eapOld = $ErrorActionPreference; $ErrorActionPreference = 'SilentlyContinue'
$stat = (git -C $Repo diff --shortstat "origin/$Base...$Branch" 2>&1) -join ' '
if ($LASTEXITCODE -ne 0) { $stat = (git -C $Repo diff --shortstat "$Base...$Branch" 2>&1) -join ' ' }
$ok = ($LASTEXITCODE -eq 0)
$ErrorActionPreference = $eapOld
if (-not $ok) { Write-Host "ERRO: nao consegui calcular o diff $Base...$Branch em $Repo"; exit 1 }
if ($stat -notmatch 'file') {
    Write-Host ("diff $Base...$Branch : 0 linhas (limite: $Limite)")
    Write-Host 'OK - dentro do orcamento de diff.'
    exit 0
}

$ins = 0; $del = 0; $arq = 0
if ($stat -match '(\d+) file') { $arq = [int]$Matches[1] }
if ($stat -match '(\d+) insertion') { $ins = [int]$Matches[1] }
if ($stat -match '(\d+) deletion') { $del = [int]$Matches[1] }
$total = $ins + $del

Write-Host ("diff $Base...$Branch : $arq arquivos, +$ins/-$del = $total linhas (limite: $Limite)")
if ($total -gt $Limite) {
    Write-Host "ESTOUROU O ORCAMENTO DE DIFF - reprova automatica." -ForegroundColor Red
    Write-Host "Acao: volta ao squad-arquiteto para FATIAR a task (mudanca cirurgica: diffs menores,"
    Write-Host "revisaveis, cada um rastreando ao pedido). Se o tamanho e legitimo (ex.: arquivo"
    Write-Host "gerado), o humano ajusta diffMaximo no squad\.squadkit.json ou aprova excecao explicita."
    exit 1
}
Write-Host "OK - dentro do orcamento de diff."
exit 0
