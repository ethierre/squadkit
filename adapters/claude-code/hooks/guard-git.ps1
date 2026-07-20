# Hook PreToolUse (Bash) — guarda de bypass de git do Squad {{PROJETO}}.
# Detecta tentativas de contornar hooks/verificacoes: --no-verify (em qualquer posicao),
# override de core.hooksPath, --no-gpg-sign. Caso real documentado: agente usou --no-verify
# em 6 commits apesar de regras em prompt — por isso o veto e em CODIGO.
# Funciona no Claude Code E no VS Code/Copilot (que le .claude/settings.json mas IGNORA
# matchers — este script se auto-filtra: sem campo command, sai 0).
# Exit 0 = permite · Exit 2 = bloqueia

$inp = [Console]::In.ReadToEnd()
try { $j = $inp | ConvertFrom-Json } catch { exit 0 }
$cmd = $null
if ($j.tool_input -and $j.tool_input.command) { $cmd = [string]$j.tool_input.command }
if (-not $cmd) { exit 0 }

$suspeito = $null
if ($cmd -match '(?i)git\b' ) {
    if ($cmd -match '--no-verify') { $suspeito = '--no-verify (pula hooks de commit/push)' }
    elseif ($cmd -match '(?i)core\.hooksPath') { $suspeito = 'override de core.hooksPath (desvia os hooks do repo)' }
    elseif ($cmd -match '--no-gpg-sign') { $suspeito = '--no-gpg-sign (pula assinatura exigida)' }
}
if (-not $suspeito) { exit 0 }

[Console]::Error.WriteLine("BLOQUEADO (guarda de git do SquadKit): o comando usa $suspeito. Verificacao nao se contorna - se um hook esta falhando, investigue e corrija a causa (ou reporte ao humano). Comando: $cmd")
exit 2
