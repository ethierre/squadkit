# demo-squad.ps1 - experiencia de 5 minutos: instala um squad de exemplo, semeia contexto+spec
# validados e roda os gates deterministicos na hora. Depois e so abrir sua IA e "executar T-DEMO-1".
# Uso: pwsh -File demo-squad.ps1 [-Destino <pasta>] [-Ide claude,cursor,...]
param(
    [string]$Destino = (Join-Path (Get-Location).Path 'squadkit-demo'),
    [string[]]$Ide = @('claude')
)

$ErrorActionPreference = 'Stop'
$src = $PSScriptRoot

Write-Host '=== SquadKit DEMO ===' -ForegroundColor Cyan
& (Join-Path $src 'instalar-squad.ps1') -Projeto 'Frete Rapido (demo)' -Slug fretedemo -Destino $Destino -Perfil enxuto -Ide $Ide -Board 'nenhum (demo)' | Out-Host

# semeia contexto + spec + telemetria de exemplo
Copy-Item (Join-Path (Join-Path $src 'demo') '_INDICE.md')   (Join-Path (Join-Path (Join-Path $Destino 'squad') 'contexto') '_INDICE.md') -Force
Copy-Item (Join-Path (Join-Path $src 'demo') 'HISTORICO.md') (Join-Path (Join-Path (Join-Path $Destino 'squad') 'contexto') 'HISTORICO.md') -Force
Copy-Item (Join-Path (Join-Path $src 'demo') 'SPEC-DEMO-1.md') (Join-Path (Join-Path (Join-Path $Destino 'squad') 'specs') 'SPEC-DEMO-1.md') -Force
Copy-Item (Join-Path (Join-Path $src 'demo') 'telemetria-seed.csv') (Join-Path (Join-Path $Destino 'squad') 'telemetria.csv') -Force
Copy-Item (Join-Path (Join-Path $src 'demo') 'DEMO.md') (Join-Path $Destino 'DEMO.md') -Force

Write-Host ''
Write-Host '--- Gates deterministicos (o harness funcionando SEM IA) ---' -ForegroundColor Cyan
& (Join-Path (Join-Path (Join-Path $Destino 'squad') 'scripts') 'validar-squad.ps1') -Raiz $Destino
& (Join-Path (Join-Path (Join-Path $Destino 'squad') 'scripts') 'validar-spec.ps1') -Spec (Join-Path (Join-Path (Join-Path $Destino 'squad') 'specs') 'SPEC-DEMO-1.md')
& (Join-Path (Join-Path (Join-Path $Destino 'squad') 'scripts') 'dashboard.ps1') -Raiz $Destino

Write-Host ''
Write-Host '=== PRONTO! Seus 5 minutos: ===' -ForegroundColor Green
Write-Host ('  1. Abra sua IA em: ' + $Destino + '   (outra IA? cole squad\INICIAR.md no chat)')
Write-Host '  2. Diga: "executar T-DEMO-1"'
Write-Host '  3. Depois: "fechar sprint"  ->  veja squad\dashboard.html'
Write-Host ('  Roteiro completo: ' + (Join-Path $Destino 'DEMO.md'))
