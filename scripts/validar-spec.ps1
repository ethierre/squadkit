# validar-spec.ps1 - gate deterministico: a SPEC esta completa para ir ao despacho?
# Uso: pwsh -File validar-spec.ps1 -Spec <caminho da SPEC-*.md>
# Exit 0 = OK · Exit 1 = incompleta
param([Parameter(Mandatory = $true)][string]$Spec)

if (-not (Test-Path $Spec)) { Write-Host "ERRO: arquivo nao encontrado: $Spec"; exit 1 }
$c = [IO.File]::ReadAllText($Spec)
$erros = @()

# secoes criticas: 3 (contratos), 5 (criterios), 10 (definicao de pronto)
foreach ($sec in @('3', '5', '10')) {
    if ($c -match "(?sm)^##\s*$sec\..*?(?=^##\s|\z)") {
        $corpo = $Matches[0] -replace '(?m)^##.*$', ''
        $linhas = @($corpo -split "`n" | Where-Object { $_.Trim() -and ($_.Trim() -notmatch '^<.*>$') })
        if ($linhas.Count -lt 3) { $erros += "secao $sec : corpo insuficiente ($($linhas.Count) linhas uteis; minimo 3)" }
        if ($corpo -match '<(o que|ex\.:|payloads|derivado|comando exato|1.3 paragrafos)') { $erros += "secao $sec : texto de template nao preenchido" }
    } else { $erros += "secao $sec : ausente" }
}

# status e placeholders
if ($c -match '\{\{[A-Za-z_]+\}\}') { $erros += "placeholders {{...}} nao resolvidos" }
if ($c -match '(?i)status.*rascunho') { Write-Host "AVISO: SPEC em status rascunho (ok no modo executar; gate na esteira completa)" }

# definicao de pronto precisa de comandos concretos
if ($c -match "(?sm)^##\s*10\..*?(?=^##\s|\z)") {
    if ($Matches[0] -notmatch '\|.*\|.*\|') { $erros += "secao 10 : sem tabela de verificacao (comando + resultado esperado)" }
}

if ($erros) { Write-Host "SPEC INCOMPLETA ($($erros.Count)):"; $erros | ForEach-Object { Write-Host "  X $_" }; exit 1 }
Write-Host "OK - SPEC apta para despacho: $Spec"
exit 0
