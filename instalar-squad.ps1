# instalar-squad.ps1 - instancia o squad em um projeto novo, para QUALQUER CLI/IDE de IA.
# Funciona em Windows PowerShell 5.1 e em pwsh 7+ (Windows/macOS/Linux).
# Uso:
#   pwsh -File instalar-squad.ps1 -Projeto "APPAI" -Destino "C:\appai" `
#        [-Perfil produto | -Papeis pm,arquiteto,...] [-Ide claude,cursor] `
#        [-Slug appai] [-BranchIntegracao main] [-PastaClones _repos] [-Board "GitLab Issues"]
# IDEs suportadas: claude (Claude Code) · cursor · antigravity (Google) · codex (OpenAI) ·
#   vscode (Copilot) · generico (qualquer IA). O AGENTS.md (padrao agents.md) e instalado SEMPRE
#   na raiz - e a camada canonica lida por 28+ ferramentas.
param(
    [string]$Projeto,
    [string]$Destino,
    [string]$Slug,
    [string]$BranchIntegracao = 'develop',
    [string]$PastaClones,
    [string]$Board = 'Azure DevOps',
    [string]$Perfil = 'dev-completo',
    [string[]]$Papeis,
    [string[]]$Ide = @('claude'),
    [switch]$Interativo   # onboarding guiado: perguntas em vez de flags (usuario nao-tecnico)
)

$ErrorActionPreference = 'Stop'

# Onboarding guiado
if ($Interativo) {
    Write-Host ''
    Write-Host '=== SquadKit - instalacao guiada ===' -ForegroundColor Cyan
    if (-not $Projeto) { $Projeto = Read-Host '1/6 Nome do projeto ou do trabalho (ex: APPAI, Canal Youtube, Financas da Casa)' }
    if (-not $Destino) { $Destino = Read-Host '2/6 Pasta onde instalar (ex: C:\meuprojeto - sera criada se nao existir)' }
    $perfisDisp = ((Get-Content (Join-Path $PSScriptRoot 'perfis.json') -Raw | ConvertFrom-Json).PSObject.Properties.Name) -join ' | '
    Write-Host ('    Perfis: ' + $perfisDisp)
    Write-Host '    Dica: "sob-medida" deixa a IA desenhar o time para voce (recomendado se tem duvida).'
    $r = Read-Host '3/6 Perfil do squad [Enter = sob-medida]'
    $Perfil = if ($r) { $r } else { 'sob-medida' }
    Write-Host '    IDEs: claude | cursor | antigravity | codex | vscode | generico (pode listar varias com virgula)'
    $r = Read-Host '4/6 Qual IA/editor voce usa? [Enter = claude]'
    $Ide = @($(if ($r) { $r } else { 'claude' }))
    $r = Read-Host '5/6 Se tem repositorios git: branch de integracao [Enter = develop; irrelevante fora de software]'
    if ($r) { $BranchIntegracao = $r }
    $r = Read-Host '6/6 Onde voce acompanha tarefas? (ex: Azure DevOps, GitLab, Trello, Planilha) [Enter = Azure DevOps]'
    if ($r) { $Board = $r }
    Write-Host ''
}
if (-not $Projeto -or -not $Destino) { throw 'Informe -Projeto e -Destino (ou rode com -Interativo para a instalacao guiada).' }

# via "powershell -File", listas com virgula chegam como string unica -> normaliza
$Ide = @($Ide | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim().ToLower() } | Where-Object { $_ })
if ($Papeis) { $Papeis = @($Papeis | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { $_ }) }
if (-not $Slug) { $Slug = ($Projeto.ToLower() -replace '[^a-z0-9]', '') }
if (-not $PastaClones) { $PastaClones = Join-Path $Destino ('_repos' + $Slug) }
elseif (-not [IO.Path]::IsPathRooted($PastaClones)) { $PastaClones = Join-Path $Destino $PastaClones }

$src = $PSScriptRoot
New-Item -ItemType Directory -Force -Path $Destino | Out-Null
$copiados = @()

function Copy-Arvore([string]$De, [string]$Para) {
    if (-not (Test-Path $De)) { return }
    Get-ChildItem $De -Recurse -File -Force | ForEach-Object {
        $rel = $_.FullName.Substring($De.Length).TrimStart('\', '/')
        $dst = Join-Path $Para $rel
        if (Test-Path $dst) { Write-Host ("  AVISO: ja existe, preservado: " + $dst) -ForegroundColor Yellow }
        else {
            New-Item -ItemType Directory -Force -Path (Split-Path $dst -Parent) | Out-Null
            Copy-Item $_.FullName $dst
            $script:copiados += $dst
        }
    }
}

# 1) memoria compartilhada + core (fonte unica entre IDEs) + scripts + catalogo/exemplos
Copy-Arvore (Join-Path $src 'squad') (Join-Path $Destino 'squad')
Copy-Arvore (Join-Path $src 'core') (Join-Path (Join-Path $Destino 'squad') '_core')
Copy-Arvore (Join-Path $src 'scripts') (Join-Path (Join-Path $Destino 'squad') 'scripts')
Copy-Arvore (Join-Path $src 'roles') (Join-Path (Join-Path (Join-Path $Destino 'squad') '_catalogo') 'roles')
Copy-Arvore (Join-Path $src 'exemplos') (Join-Path (Join-Path (Join-Path $Destino 'squad') '_catalogo') 'exemplos')

# 2) papeis do perfil escolhido -> squad\_equipe (neutro) e .claude\agents (se claude)
$perfis = Get-Content (Join-Path $src 'perfis.json') -Raw | ConvertFrom-Json
if (-not $Papeis -or $Papeis.Count -eq 0) {
    $prop = $perfis.PSObject.Properties[$Perfil]
    if (-not $prop) { throw ('Perfil desconhecido: ' + $Perfil + '. Disponiveis: ' + (($perfis.PSObject.Properties.Name) -join ', ')) }
    $Papeis = @($prop.Value)
}
$equipeDir = Join-Path (Join-Path $Destino 'squad') '_equipe'
New-Item -ItemType Directory -Force -Path $equipeDir | Out-Null
$usaClaude = $Ide -contains 'claude'
if ($usaClaude) { New-Item -ItemType Directory -Force -Path (Join-Path (Join-Path $Destino '.claude') 'agents') | Out-Null }
$instalados = @()
foreach ($papel in $Papeis) {
    $rf = Join-Path (Join-Path $src 'roles') ('squad-' + $papel + '.md')
    if (-not (Test-Path $rf)) {
        $catalogo = (Get-ChildItem (Join-Path $src 'roles') -Filter 'squad-*.md').BaseName -replace '^squad-', ''
        Write-Host ('  ERRO: papel inexistente: ' + $papel + ' (disponiveis: ' + ($catalogo -join ', ') + ')') -ForegroundColor Red
        continue
    }
    foreach ($destPapel in @($equipeDir) + $(if ($usaClaude) { @(Join-Path (Join-Path $Destino '.claude') 'agents') } else { @() })) {
        $dst = Join-Path $destPapel ('squad-' + $papel + '.md')
        if (-not (Test-Path $dst)) { Copy-Item $rf $dst; $copiados += $dst }
    }
    $instalados += $papel
}

# 3) adapters por IDE (generico + AGENTS.md canonico vao SEMPRE)
Copy-Item (Join-Path (Join-Path $src 'adapters') (Join-Path 'generico' 'INICIAR.md')) (Join-Path (Join-Path $Destino 'squad') 'INICIAR.md') -ErrorAction SilentlyContinue
if (Test-Path (Join-Path (Join-Path $Destino 'squad') 'INICIAR.md')) { $copiados += (Join-Path (Join-Path $Destino 'squad') 'INICIAR.md') }
$agmd = Join-Path $Destino 'AGENTS.md'
if (-not (Test-Path $agmd)) { Copy-Item (Join-Path (Join-Path $src 'adapters') (Join-Path 'codex' 'AGENTS.md')) $agmd; $copiados += $agmd }
foreach ($i in $Ide) {
    switch ($i) {
        'claude' {
            Copy-Arvore (Join-Path (Join-Path $src 'adapters') (Join-Path 'claude-code' 'skills')) (Join-Path (Join-Path $Destino '.claude') 'skills')
            Copy-Arvore (Join-Path (Join-Path $src 'adapters') (Join-Path 'claude-code' 'hooks')) (Join-Path (Join-Path $Destino '.claude') 'hooks')
            $stJson = Join-Path (Join-Path $src 'adapters') (Join-Path 'claude-code' 'settings.json')
            $stDst = Join-Path (Join-Path $Destino '.claude') 'settings.json'
            if ((Test-Path $stJson) -and (-not (Test-Path $stDst))) { Copy-Item $stJson $stDst; $copiados += $stDst }
            $skillDe = Join-Path (Join-Path (Join-Path $Destino '.claude') 'skills') 'projeto-squad'
            $skillPara = Join-Path (Join-Path (Join-Path $Destino '.claude') 'skills') ($Slug + '-squad')
            if ((Test-Path $skillDe) -and (-not (Test-Path $skillPara))) {
                Move-Item $skillDe $skillPara
                $copiados = $copiados | ForEach-Object { $_.Replace($skillDe, $skillPara) }
            }
        }
        'cursor'  {
            Copy-Arvore (Join-Path (Join-Path $src 'adapters') (Join-Path 'cursor' 'rules')) (Join-Path (Join-Path $Destino '.cursor') 'rules')
            Copy-Arvore (Join-Path (Join-Path $src 'adapters') (Join-Path 'cursor' 'hooks')) (Join-Path (Join-Path $Destino '.cursor') 'hooks')
            $ch = Join-Path (Join-Path $Destino '.cursor') 'hooks.json'
            if (-not (Test-Path $ch)) { Copy-Item (Join-Path (Join-Path $src 'adapters') (Join-Path 'cursor' 'hooks.json')) $ch; $copiados += $ch }
        }
        'codex'   { } # coberto pelo AGENTS.md canonico (sempre instalado)
        'antigravity' {
            Copy-Arvore (Join-Path (Join-Path $src 'adapters') (Join-Path 'antigravity' 'workflows')) (Join-Path (Join-Path $Destino '.agents') 'workflows')
            Copy-Arvore (Join-Path (Join-Path $src 'adapters') (Join-Path 'antigravity' 'hooks')) (Join-Path (Join-Path $Destino '.agents') 'hooks')
            $ag = Join-Path (Join-Path $Destino '.agents') 'agents.md'
            if (-not (Test-Path $ag)) { New-Item -ItemType Directory -Force -Path (Split-Path $ag -Parent) | Out-Null; Copy-Item (Join-Path (Join-Path $src 'adapters') (Join-Path 'antigravity' 'agents.md')) $ag; $copiados += $ag }
            $ah = Join-Path (Join-Path $Destino '.agents') 'hooks.json'
            if (-not (Test-Path $ah)) { Copy-Item (Join-Path (Join-Path $src 'adapters') (Join-Path 'antigravity' 'hooks.json')) $ah; $copiados += $ah }
        }
        'vscode'  { $d = Join-Path (Join-Path $Destino '.github') 'copilot-instructions.md'; if (-not (Test-Path $d)) { New-Item -ItemType Directory -Force -Path (Split-Path $d -Parent) | Out-Null; Copy-Item (Join-Path (Join-Path $src 'adapters') (Join-Path 'vscode' 'copilot-instructions.md')) $d; $copiados += $d } }
        'generico' { }
        default   { Write-Host ('  AVISO: IDE desconhecida: ' + $i + ' (suportadas: claude, cursor, antigravity, codex, vscode, generico)') -ForegroundColor Yellow }
    }
}

# 4) placeholders (pares ordenados: hashtable colidiria PROJETO/projeto por case-insensitividade)
$pares = @(
    , @('{{PROJETO}}', $Projeto)
    , @('{{projeto}}', $Slug)
    , @('{{RAIZ_JSON}}', ($Destino.TrimEnd('\', '/')).Replace('\', '\\'))
    , @('{{RAIZ}}', $Destino.TrimEnd('\', '/'))
    , @('{{BRANCH}}', $BranchIntegracao)
    , @('{{CLONES}}', $PastaClones.TrimEnd('\', '/'))
    , @('{{BOARD}}', $Board)
)
$trocados = 0
foreach ($f in $copiados) {
    if ($f -notmatch '\.(md|mdc|json|ps1|txt|csv|yaml|yml)$') { continue }
    $c = [IO.File]::ReadAllText($f)
    $c2 = $c
    foreach ($p in $pares) { $c2 = $c2.Replace($p[0], $p[1]) }
    if ($c2 -ne $c) {
        if ($f -match '\.ps1$') { [IO.File]::WriteAllText($f, $c2, [Text.Encoding]::ASCII) }
        else { [IO.File]::WriteAllText($f, $c2, (New-Object Text.UTF8Encoding($false))) }
        $trocados++
    }
}

# 5) manifesto da instalacao (usado pelo atualizar-squad.ps1)
$manifesto = @{
    projeto = $Projeto; slug = $Slug; raiz = $Destino.TrimEnd('\', '/')
    branch = $BranchIntegracao; clones = $PastaClones.TrimEnd('\', '/'); board = $Board
    ides = $Ide; papeis = $instalados; diffMaximo = 400
    instaladoEm = (Get-Date -Format 'yyyy-MM-dd HH:mm')
} | ConvertTo-Json
[IO.File]::WriteAllText((Join-Path (Join-Path $Destino 'squad') '.squadkit.json'), $manifesto, (New-Object Text.UTF8Encoding($false)))

Write-Host ''
Write-Host ("Squad '" + $Projeto + "' instalado em " + $Destino) -ForegroundColor Green
Write-Host ("  IDEs: " + ($Ide -join ', ') + " | perfil: " + $Perfil + " | papeis: " + ($instalados -join ', '))
Write-Host ("  arquivos copiados: " + $copiados.Count + " | com placeholders resolvidos: " + $trocados)
Write-Host ''
Write-Host 'PROXIMOS PASSOS:'
Write-Host '  1. Abra sua IA na pasta do projeto (qualquer IDE instalada; outra IA: squad\INICIAR.md)'
Write-Host '  2. PRIMEIRO: rode montar-contexto (base de conhecimento + fatos canonicos)'
Write-Host '  3. DEPOIS: rode montar-squad (o time se molda ao contexto; modelos = sua escolha)'
Write-Host '  4. Teste de fumaca com 1 demanda real e feche com fechar-sprint (telemetria+dashboard)'
Write-Host '  Detalhes: PERSONALIZACAO.md do template.'
