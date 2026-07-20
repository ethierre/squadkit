# Hook beforeShellExecution (Cursor) — guarda de bypass de git do Squad {{PROJETO}}.
# ATENCAO: hooks do Cursor estao em BETA (schema pode mudar) — confira cursor.com/docs/hooks
# na sua versao. Default do Cursor e fail-OPEN; considere failClosed nas configs do time.
# Protocolo: le JSON do stdin, responde JSON no stdout {"permission":"allow"|"deny"}; exit 0 sempre.

$inp = [Console]::In.ReadToEnd()
$cmd = $null
try {
    $j = $inp | ConvertFrom-Json
    foreach ($campo in @('command', 'commandLine', 'shell_command')) {
        if ($j.PSObject.Properties[$campo] -and $j.$campo) { $cmd = [string]$j.$campo; break }
    }
    if (-not $cmd -and $j.tool_input -and $j.tool_input.command) { $cmd = [string]$j.tool_input.command }
} catch { }
if (-not $cmd) { Write-Output '{"permission":"allow"}'; exit 0 }

$suspeito = $null
if ($cmd -match '(?i)git\b') {
    if ($cmd -match '--no-verify') { $suspeito = '--no-verify' }
    elseif ($cmd -match '(?i)core\.hooksPath') { $suspeito = 'core.hooksPath override' }
    elseif ($cmd -match '--no-gpg-sign') { $suspeito = '--no-gpg-sign' }
}
if ($suspeito) {
    $msg = 'BLOQUEADO (guarda de git do SquadKit): ' + $suspeito + ' contorna verificacao. Investigue a causa do hook que falhou; nao pule o gate.'
    Write-Output ('{"permission":"deny","userMessage":"' + $msg.Replace('"', '\"') + '"}')
} else {
    Write-Output '{"permission":"allow"}'
}
exit 0
