# Hook PreToolUse (Edit|Write) — regra anti-burla de testes do Squad {{PROJETO}}.
# Bloqueia alteracao de arquivo de TESTE ja rastreado no git dentro dos clones do projeto.
# Permitido: criar teste novo; editar teste ainda NAO rastreado (criado agora pelo dev);
#            caminhos liberados em {{RAIZ}}\squad\.permitir-edicao-teste (decisao humana).
# Exit 0 = permite · Exit 2 = bloqueia (mensagem no stderr volta para o agente).

$inp = [Console]::In.ReadToEnd()
try { $j = $inp | ConvertFrom-Json } catch { exit 0 }
$fp = $j.tool_input.file_path
if (-not $fp) { exit 0 }

# So vigia os clones do projeto
$clones = '{{CLONES}}'
if (-not $fp.StartsWith($clones, [StringComparison]::OrdinalIgnoreCase)) { exit 0 }

# PADROES DE ARQUIVO DE TESTE — ajuste a stack do projeto aqui
$isTest = ($fp -match '(?i)\.(spec|test)\.(ts|tsx|js|jsx)$') -or
          ($fp -match '(?i)Tests?\.cs$') -or
          ($fp -match '(?i)\\__tests__\\') -or
          ($fp -match '(?i)\\tests?\\[^\\]*\.sql$') -or
          ($fp -match '(?i)_test\.(py|go)$')
if (-not $isTest) { exit 0 }

# Criar teste NOVO e permitido
if (-not (Test-Path $fp)) { exit 0 }

# Teste existente mas ainda NAO rastreado no git (o dev acabou de cria-lo) e permitido
$tracked = $true
try {
    $dir = Split-Path $fp -Parent
    git -C $dir ls-files --error-unmatch -- $fp 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) { $tracked = $false }
} catch { $tracked = $false }
if (-not $tracked) { exit 0 }

# Excecoes aprovadas pelo humano
$allow = '{{RAIZ}}\squad\.permitir-edicao-teste'
if (Test-Path $allow) {
    $lines = Get-Content $allow | Where-Object { $_ -and ($_ -notmatch '^\s*#') }
    foreach ($l in $lines) {
        if ($fp -like ('*' + $l.Trim() + '*')) { exit 0 }
    }
}

[Console]::Error.WriteLine("BLOQUEADO (anti-burla): '$fp' e um teste EXISTENTE e rastreado. Teste existente nao se altera para passar. Se a mudanca e legitima, PARE e reporte a justificativa ao orquestrador - o humano libera adicionando o caminho em {{RAIZ}}\squad\.permitir-edicao-teste.")
exit 2
