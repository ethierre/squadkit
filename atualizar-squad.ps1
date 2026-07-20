# atualizar-squad.ps1 - sincroniza o CORE de uma instalacao existente com esta versao do SquadKit.
# Atualiza APENAS: squad\_core, squad\scripts, squad\_catalogo (roles+exemplos).
# NUNCA toca: squad\contexto, squad\_equipe, SPRINT/DECISOES/BUGS/MODELOS/telemetria, adapters, .claude.
# Uso: pwsh -File atualizar-squad.ps1 -Destino "C:\meuprojeto"
#   Parametros do projeto vem do manifesto squad\.squadkit.json (gravado na instalacao).
#   Instalacao antiga sem manifesto: informe -Projeto -Slug -BranchIntegracao -PastaClones -Board.
param(
    [Parameter(Mandatory = $true)][string]$Destino,
    [string]$Projeto, [string]$Slug, [string]$BranchIntegracao, [string]$PastaClones, [string]$Board
)

$ErrorActionPreference = 'Stop'
$src = $PSScriptRoot

# 1) parametros: manifesto primeiro, flags sobrepoe
$manPath = Join-Path (Join-Path $Destino 'squad') '.squadkit.json'
if (Test-Path $manPath) {
    $man = Get-Content $manPath -Raw | ConvertFrom-Json
    if (-not $Projeto) { $Projeto = $man.projeto }
    if (-not $Slug) { $Slug = $man.slug }
    if (-not $BranchIntegracao) { $BranchIntegracao = $man.branch }
    if (-not $PastaClones) { $PastaClones = $man.clones }
    if (-not $Board) { $Board = $man.board }
}
foreach ($p in @(@('Projeto', $Projeto), @('Slug', $Slug), @('BranchIntegracao', $BranchIntegracao), @('PastaClones', $PastaClones), @('Board', $Board))) {
    if (-not $p[1]) { throw ('Parametro ausente: -' + $p[0] + ' (instalacao sem manifesto squad\.squadkit.json - informe os parametros originais da instalacao)') }
}

# 2) sobrescreve as arvores de core/catalogo/scripts
$pares = @(
    , @('{{PROJETO}}', $Projeto)
    , @('{{projeto}}', $Slug)
    , @('{{RAIZ_JSON}}', ($Destino.TrimEnd('\', '/')).Replace('\', '\\'))
    , @('{{RAIZ}}', $Destino.TrimEnd('\', '/'))
    , @('{{BRANCH}}', $BranchIntegracao)
    , @('{{CLONES}}', $PastaClones.TrimEnd('\', '/'))
    , @('{{BOARD}}', $Board)
)
$n = 0
foreach ($t in @(@('core', 'squad\_core'), @('scripts', 'squad\scripts'), @('roles', 'squad\_catalogo\roles'), @('exemplos', 'squad\_catalogo\exemplos'))) {
    $de = Join-Path $src $t[0]
    if (-not (Test-Path $de)) { continue }
    Get-ChildItem $de -Recurse -File | ForEach-Object {
        $rel = $_.FullName.Substring($de.Length).TrimStart('\', '/')
        $dst = Join-Path (Join-Path $Destino $t[1]) $rel
        New-Item -ItemType Directory -Force -Path (Split-Path $dst -Parent) | Out-Null
        $c = [IO.File]::ReadAllText($_.FullName)
        foreach ($p in $pares) { $c = $c.Replace($p[0], $p[1]) }
        if ($_.Extension -eq '.ps1') { [IO.File]::WriteAllText($dst, $c, [Text.Encoding]::ASCII) }
        else { [IO.File]::WriteAllText($dst, $c, (New-Object Text.UTF8Encoding($false))) }
        $n++
    }
}

# 3) atualiza o manifesto
$novo = @{
    projeto = $Projeto; slug = $Slug; raiz = $Destino.TrimEnd('\', '/')
    branch = $BranchIntegracao; clones = $PastaClones.TrimEnd('\', '/'); board = $Board
    atualizadoEm = (Get-Date -Format 'yyyy-MM-dd HH:mm')
} | ConvertTo-Json
[IO.File]::WriteAllText($manPath, $novo, (New-Object Text.UTF8Encoding($false)))

Write-Host ("Core atualizado: " + $n + " arquivos em " + $Destino) -ForegroundColor Green
Write-Host 'NAO tocados: contexto, _equipe, board/decisoes/bugs, adapters (.claude/.cursor/.agents/AGENTS.md).'
Write-Host 'Adapters mudaram nesta versao? Reinstale a IDE especifica com instalar-squad.ps1 (arquivos existentes sao preservados - apague o adapter antigo antes se quiser a versao nova).'
Write-Host ("Valide: powershell -File " + (Join-Path (Join-Path $Destino 'squad') 'scripts\validar-squad.ps1'))
