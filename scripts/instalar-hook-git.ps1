# instalar-hook-git.ps1 - instala o hook anti-burla UNIVERSAL (git pre-commit) em um repo.
# Vale para QUALQUER IDE/CLI (nao so Claude Code): bloqueia commit que MODIFICA arquivo de teste
# ja rastreado, salvo caminhos liberados em squad\.permitir-edicao-teste.
# Uso: pwsh -File instalar-hook-git.ps1 -Repo <caminho do repositorio git>
# Nota honesta: git commit --no-verify pula hooks. Por isso as regras dos papeis PROIBEM
# --no-verify - o hook e uma camada a mais do harness, nao a unica.
param([Parameter(Mandatory = $true)][string]$Repo)

$ErrorActionPreference = 'Stop'
$raiz = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
$allow = (Join-Path (Join-Path $raiz 'squad') '.permitir-edicao-teste') -replace '\\', '/'
$gitDir = Join-Path $Repo '.git'
if (-not (Test-Path $gitDir)) { throw "Nao e um repositorio git: $Repo" }
$hooksDir = Join-Path $gitDir 'hooks'
New-Item -ItemType Directory -Force -Path $hooksDir | Out-Null
$pre = Join-Path $hooksDir 'pre-commit'

if ((Test-Path $pre) -and ((Get-Content $pre -Raw) -notmatch 'SquadKit anti-burla')) {
    Copy-Item $pre "$pre.bak" -Force
    Write-Host ("AVISO: pre-commit existente salvo em " + $pre + ".bak") -ForegroundColor Yellow
}

$linhas = @(
    '#!/bin/sh'
    '# SquadKit anti-burla (gerado por instalar-hook-git.ps1) - nao editar manualmente'
    ('ALLOW=''' + $allow + '''')
    'STATUS=0'
    'for f in $(git diff --cached --name-only --diff-filter=M); do'
    '  case "$f" in'
    '    *.spec.ts|*.spec.tsx|*.spec.js|*.spec.jsx|*.test.ts|*.test.tsx|*.test.js|*.test.jsx|*Tests.cs|*Test.cs|*_test.py|*_test.go|*__tests__*|*tests/*.sql)'
    '      ok=0'
    '      if [ -f "$ALLOW" ]; then'
    '        while IFS= read -r line || [ -n "$line" ]; do'
    '          case "$line" in ""|"#"*) continue ;; esac'
    '          case "$f" in *"$line"*) ok=1 ;; esac'
    '        done < "$ALLOW"'
    '      fi'
    '      if [ "$ok" -eq 0 ]; then'
    '        echo "BLOQUEADO (anti-burla SquadKit): $f e teste existente MODIFICADO."'
    '        echo "Teste nao se altera para passar. Mudanca legitima: humano libera o caminho em:"'
    ('        echo "  ' + $allow + '"')
    '        STATUS=1'
    '      fi ;;'
    '  esac'
    'done'
    'exit $STATUS'
)
[IO.File]::WriteAllText($pre, (($linhas -join "`n") + "`n"), (New-Object Text.UTF8Encoding($false)))
Write-Host ("Hook anti-burla instalado em " + $pre) -ForegroundColor Green
Write-Host ("Allowlist: " + $allow)
