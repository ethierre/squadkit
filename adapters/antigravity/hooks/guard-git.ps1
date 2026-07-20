# Hook beforeToolExecution (Google Antigravity) — guarda de bypass de git do Squad {{PROJETO}}.
# ATENCAO: hooks do Antigravity 2.0 sao novos — confirme o schema em antigravity.google/docs/hooks
# na sua versao (o comando exige PATH ABSOLUTO; dialeto CLI usa allow_tool em vez de decision).
# Protocolo IDE: le JSON do stdin (toolCall.args.CommandLine), responde {"decision":"allow"|"deny"};
# exit 0 SEMPRE (exit != 0 nao e um veto valido no Antigravity).

$inp = [Console]::In.ReadToEnd()
$cmd = $null
try {
    $j = $inp | ConvertFrom-Json
    if ($j.toolCall -and $j.toolCall.args -and $j.toolCall.args.CommandLine) { $cmd = [string]$j.toolCall.args.CommandLine }
    elseif ($j.tool_input -and $j.tool_input.command) { $cmd = [string]$j.tool_input.command }
} catch { }
if (-not $cmd) { Write-Output '{"decision":"allow"}'; exit 0 }

$suspeito = $null
if ($cmd -match '(?i)git\b') {
    if ($cmd -match '--no-verify') { $suspeito = '--no-verify' }
    elseif ($cmd -match '(?i)core\.hooksPath') { $suspeito = 'core.hooksPath override' }
    elseif ($cmd -match '--no-gpg-sign') { $suspeito = '--no-gpg-sign' }
}
if ($suspeito) {
    $msg = 'BLOQUEADO (guarda de git do SquadKit): ' + $suspeito + ' contorna verificacao. Investigue a causa; nao pule o gate.'
    Write-Output ('{"decision":"deny","reason":"' + $msg.Replace('"', '\"') + '"}')
} else {
    Write-Output '{"decision":"allow"}'
}
exit 0
