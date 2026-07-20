# validar-squad.ps1 - validacao deterministica dos papeis do squad (gate de codigo, nao de prompt).
# Uso: pwsh -File validar-squad.ps1 [-Raiz <pasta do projeto>]   (funciona em powershell 5.1 e pwsh 7+)
# Sem -Raiz, deriva a raiz da PROPRIA localizacao (o script e instalado em <raiz>\squad\scripts\)
# - nunca do diretorio atual, que pode ser outro projeto.
# Exit 0 = OK · Exit 1 = erros encontrados
param([string]$Raiz)

if (-not $Raiz) { $Raiz = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..')) }
Write-Host ("Raiz do squad: " + $Raiz)
$erros = @(); $avisos = @()
$dirs = @((Join-Path $Raiz 'squad\_equipe'), (Join-Path $Raiz '.claude\agents')) | Where-Object { Test-Path $_ }
if (-not $dirs) { Write-Host 'ERRO: nenhuma pasta de papeis encontrada (squad\_equipe ou .claude\agents)'; exit 1 }

$vistos = @{}
foreach ($d in $dirs) {
    foreach ($f in Get-ChildItem $d -Filter 'squad-*.md') {
        $c = [IO.File]::ReadAllText($f.FullName)
        $rel = $f.FullName.Substring($Raiz.Length).TrimStart('\')

        # frontmatter obrigatorio
        if ($c -notmatch '(?s)^---.*?name:\s*\S+.*?---') { $erros += "$rel : frontmatter sem 'name:'" }
        if ($c -notmatch '(?s)^---.*?description:\s*\S+.*?---') { $erros += "$rel : frontmatter sem 'description:'" }

        # placeholders e slots nao resolvidos
        foreach ($m in [regex]::Matches($c, '\{\{[A-Za-z_]+\}\}')) { $erros += "$rel : placeholder nao resolvido $($m.Value)" }
        if ($c -match '<slug-do-papel>|<REPO-') { $avisos += "$rel : slot de template pendente de ajuste (<...>)" }
        if ($c -match 'AJUSTAR NA INSTALA') { $avisos += "$rel : marcador 'AJUSTAR NA INSTALACAO' presente" }

        # secoes de harness minimas
        if ($c -notmatch 'Regras inviol') { $erros += "$rel : sem secao 'Regras inviolaveis'" }
        if (($c -notmatch 'Formato de sa') -and ($c -notmatch 'Veredito')) { $erros += "$rel : sem formato de saida definido ('Formato de saida' ou 'Veredito')" }

        # acao irreversivel precisa do freio
        if (($c -match '(?i)publica|enviar|aplicar em prod|pagar|deletar|agendar|impulsionar|mergear') -and ($c -notmatch '(?i)NUNCA|humano executa|gate humano|ato humano|manual do')) {
            $avisos += "$rel : menciona acao potencialmente irreversivel sem freio explicito"
        }

        # colisao de pasta de artefato (dono unico) - tolerante as duas ordens da frase
        $donos = @()
        foreach ($m in [regex]::Matches($c, '(?i)NICO escritor[^`]{0,60}`([^`]+)`')) { $donos += $m.Groups[1].Value }
        foreach ($m in [regex]::Matches($c, '(?i)`([^`]+)`[^`]{0,60}NICO escritor')) { $donos += $m.Groups[1].Value }
        foreach ($pasta in ($donos | ForEach-Object { $_.ToLower() } | Sort-Object -Unique)) {
            if ($vistos.ContainsKey($pasta) -and $vistos[$pasta] -ne $f.Name) { $erros += "$rel : pasta '$pasta' ja e de $($vistos[$pasta]) (colisao de dono unico)" }
            else { $vistos[$pasta] = $f.Name }
        }
    }
}

if ($avisos) { Write-Host "AVISOS ($($avisos.Count)):"; $avisos | ForEach-Object { Write-Host "  ! $_" } }
if ($erros)  { Write-Host "ERROS ($($erros.Count)):";  $erros  | ForEach-Object { Write-Host "  X $_" }; exit 1 }
Write-Host ("OK - " + ($dirs -join ' + ') + " validados sem erros" + $(if ($avisos) { " ($($avisos.Count) avisos)" }))
exit 0
