# dashboard.ps1 - gera squad\dashboard.html a partir de squad\SPRINT.md + squad\telemetria.csv.
# Uso: pwsh -File dashboard.ps1 [-Raiz <pasta do projeto>]   (powershell 5.1 e pwsh 7+)
# Sem -Raiz, deriva a raiz da PROPRIA localizacao (instalado em <raiz>\squad\scripts\).
param([string]$Raiz)

if (-not $Raiz) { $Raiz = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..')) }
Write-Host ("Raiz do squad: " + $Raiz)

$sprintPath = Join-Path $Raiz 'squad\SPRINT.md'
$telePath   = Join-Path $Raiz 'squad\telemetria.csv'
$outPath    = Join-Path $Raiz 'squad\dashboard.html'
if (-not (Test-Path $sprintPath)) { Write-Host "ERRO: $sprintPath nao encontrado"; exit 1 }

# --- parse do board (primeira tabela markdown apos '## Board') ---
$linhas = [IO.File]::ReadAllLines($sprintPath)
$board = @(); $inBoard = $false
foreach ($l in $linhas) {
    if ($l -match '^##\s*Board') { $inBoard = $true; continue }
    if ($inBoard -and $l -match '^##\s') { break }
    if ($inBoard -and $l -match '^\|' -and $l -notmatch '^\|[-\s|]+\|$' -and $l -notmatch '^\|\s*US/Task') {
        $c = $l.Trim('|') -split '\|'
        if ($c.Count -ge 4 -and $c[0].Trim() -ne '' -and $c[0].Trim() -ne [char]8212) {
            $board += [pscustomobject]@{ Task = $c[0].Trim(); Area = $c[1].Trim(); Fase = $c[3].Trim() -replace '\*', '' }
        }
    }
}

# --- telemetria ---
$tele = @(); if (Test-Path $telePath) { $tele = @(Import-Csv $telePath) }
$totCiclos = 0; $totBugs = 0
foreach ($t in $tele) {
    if ($t.ciclos_review -match '^\d+$') { $totCiclos += [int]$t.ciclos_review }
    if ($t.bugs_encontrados -match '^\d+$') { $totBugs += [int]$t.bugs_encontrados }
}
$mediaCiclos = if ($tele.Count) { [math]::Round($totCiclos / $tele.Count, 1) } else { '-' }

# --- html ---
$fases = $board | Group-Object Fase | Sort-Object Count -Descending
$css = 'body{font-family:Segoe UI,Arial,sans-serif;background:#12141a;color:#e8e8ec;margin:0;padding:24px}h1{font-size:20px}h2{font-size:15px;color:#9aa0b4;margin-top:28px}.cards{display:flex;gap:12px;flex-wrap:wrap}.card{background:#1c1f2a;border:1px solid #2a2e3d;border-radius:10px;padding:14px 18px;min-width:130px}.card b{font-size:24px;display:block}.card span{color:#9aa0b4;font-size:12px}table{border-collapse:collapse;width:100%;margin-top:8px;font-size:13px}th,td{border-bottom:1px solid #2a2e3d;padding:7px 10px;text-align:left}th{color:#9aa0b4;font-weight:600}.fase{display:inline-block;background:#26304a;border-radius:12px;padding:2px 10px;font-size:12px}.rod{color:#5c6272;font-size:11px;margin-top:26px}'
$sb = New-Object Text.StringBuilder
[void]$sb.AppendLine("<!doctype html><html><head><meta charset='utf-8'><title>Squad Dashboard</title><style>$css</style></head><body>")
[void]$sb.AppendLine("<h1>Squad Dashboard</h1><div class='cards'>")
[void]$sb.AppendLine("<div class='card'><b>$($board.Count)</b><span>tasks no board</span></div>")
foreach ($g in $fases) { [void]$sb.AppendLine("<div class='card'><b>$($g.Count)</b><span>$([Net.WebUtility]::HtmlEncode($g.Name))</span></div>") }
[void]$sb.AppendLine("<div class='card'><b>$($tele.Count)</b><span>tasks medidas</span></div>")
[void]$sb.AppendLine("<div class='card'><b>$mediaCiclos</b><span>ciclos review (media)</span></div>")
[void]$sb.AppendLine("<div class='card'><b>$totBugs</b><span>bugs encontrados</span></div></div>")
[void]$sb.AppendLine('<h2>Board</h2><table><tr><th>Task</th><th>Area</th><th>Fase</th></tr>')
foreach ($b in $board) { [void]$sb.AppendLine("<tr><td>$([Net.WebUtility]::HtmlEncode($b.Task))</td><td>$([Net.WebUtility]::HtmlEncode($b.Area))</td><td><span class='fase'>$([Net.WebUtility]::HtmlEncode($b.Fase))</span></td></tr>") }
[void]$sb.AppendLine('</table><h2>Telemetria</h2><table><tr><th>Data</th><th>Task</th><th>Papel</th><th>Ciclos review</th><th>Bugs</th><th>Resultado</th></tr>')
foreach ($t in $tele) { [void]$sb.AppendLine("<tr><td>$($t.data)</td><td>$([Net.WebUtility]::HtmlEncode($t.task))</td><td>$($t.papel)</td><td>$($t.ciclos_review)</td><td>$($t.bugs_encontrados)</td><td>$([Net.WebUtility]::HtmlEncode($t.resultado))</td></tr>") }
[void]$sb.AppendLine("</table><div class='rod'>Gerado em $(Get-Date -Format 'yyyy-MM-dd HH:mm') a partir de SPRINT.md + telemetria.csv</div></body></html>")
[IO.File]::WriteAllText($outPath, $sb.ToString(), (New-Object Text.UTF8Encoding($false)))
Write-Host "OK - dashboard gerado: $outPath ($($board.Count) tasks, $($tele.Count) medidas)"
