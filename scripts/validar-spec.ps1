# validar-spec.ps1 - gate deterministico: a SPEC esta completa e rastreavel para ir ao despacho?
# Checa: secoes criticas (3/5/10) preenchidas + RASTREABILIDADE CA->task->verificacao
# (versao deterministica do /analyze do spec-kit, sobre as chaves CA-n).
# Uso: pwsh -File validar-spec.ps1 -Spec <caminho da SPEC-*.md>
# Exit 0 = OK · Exit 1 = incompleta
param([Parameter(Mandatory = $true)][string]$Spec)

if (-not (Test-Path $Spec)) { Write-Host "ERRO: arquivo nao encontrado: $Spec"; exit 1 }
$c = [IO.File]::ReadAllText($Spec)
$erros = @(); $avisos = @()

function CorpoSecao([string]$n) {
    if ($c -match "(?sm)^##\s*$n\..*?(?=^##\s|\z)") { return $Matches[0] }
    return $null
}

# 1) secoes criticas preenchidas
foreach ($sec in @('3', '5', '10')) {
    $corpo = CorpoSecao $sec
    if ($null -eq $corpo) { $erros += "secao $sec : ausente"; continue }
    $semTitulo = $corpo -replace '(?m)^##.*$', ''
    $linhas = @($semTitulo -split "`n" | Where-Object { $_.Trim() -and ($_.Trim() -notmatch '^<.*>$') })
    if ($linhas.Count -lt 3) { $erros += "secao $sec : corpo insuficiente ($($linhas.Count) linhas uteis; minimo 3)" }
    if ($corpo -match '<(o que|ex\.:|payloads|derivado|comando exato|1.3 paragrafos)') { $erros += "secao $sec : texto de template nao preenchido" }
}
$s10 = CorpoSecao '10'
if ($s10 -and ($s10 -notmatch '\|.*\|.*\|')) { $erros += "secao 10 : sem tabela de verificacao (comando + resultado esperado)" }
if ($c -match '\{\{[A-Za-z_]+\}\}') { $erros += "placeholders {{...}} nao resolvidos" }
if ($c -match '(?i)status.*rascunho') { $avisos += "SPEC em status rascunho (ok no modo executar; gate na esteira completa)" }

# 2) rastreabilidade CA -> task -> verificacao
$s5 = CorpoSecao '5'; $s7 = CorpoSecao '7'
$cas = @()
if ($s5) { $cas = @([regex]::Matches($s5, 'CA-\d+') | ForEach-Object { $_.Value } | Sort-Object -Unique) }
if ($cas.Count -eq 0) {
    $avisos += "secao 5 sem criterios CA-n numerados - rastreabilidade CA->task nao verificavel"
} else {
    $emTasks = @(); if ($s7) { $emTasks = @([regex]::Matches($s7, 'CA-\d+') | ForEach-Object { $_.Value } | Sort-Object -Unique) }
    $emVerif = @(); if ($s10) { $emVerif = @([regex]::Matches($s10, 'CA-\d+') | ForEach-Object { $_.Value } | Sort-Object -Unique) }
    foreach ($ca in $cas) {
        if ($emTasks -notcontains $ca) { $erros += "rastreabilidade: $ca (secao 5) sem task que o cubra na secao 7" }
        if ($emVerif -notcontains $ca) { $avisos += "rastreabilidade: $ca sem verificacao explicita na secao 10" }
    }
    foreach ($ca in $emTasks) {
        if ($cas -notcontains $ca) { $erros += "rastreabilidade: secao 7 referencia $ca que NAO existe na secao 5" }
    }
    $cob = @($cas | Where-Object { $emTasks -contains $_ }).Count
    Write-Host ("cobertura CA->task: " + $cob + "/" + $cas.Count + " | CA->verificacao(10): " + @($cas | Where-Object { $emVerif -contains $_ }).Count + "/" + $cas.Count)
}

if ($avisos) { Write-Host "AVISOS ($($avisos.Count)):"; $avisos | ForEach-Object { Write-Host "  ! $_" } }
if ($erros)  { Write-Host "SPEC REPROVADA ($($erros.Count)):"; $erros | ForEach-Object { Write-Host "  X $_" }; exit 1 }
Write-Host "OK - SPEC apta para despacho: $Spec"
exit 0
