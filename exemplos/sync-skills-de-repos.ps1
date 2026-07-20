# sync-skills.ps1 — EXEMPLO OPCIONAL: sincroniza .claude/skills dos repos do projeto (GitLab API,
# ref {{BRANCH}}) para {{RAIZ}}\squad\skills-cache\. So faz sentido se os repos versionam skills.
# Copie para squad\scripts\ e AJUSTE: $gitlab (URL da sua instancia) e a lista $repos (ids/nomes).
param(
    [string]$Ref = '{{BRANCH}}',
    [string]$CacheDir = '{{RAIZ}}\squad\skills-cache'
)

$ErrorActionPreference = 'Stop'
$gitlab = 'https://gitlab.example.com/api/v4'   # <- AJUSTAR para a URL da sua instancia GitLab

# PAT: env var tem precedencia; fallback = extrair do remote de um clone local (nunca hardcodar aqui)
$tok = $env:GITLAB_PAT_SQUAD
if (-not $tok) {
    $cloneRef = '{{CLONES}}\<REPO-PRINCIPAL>'    # <- AJUSTAR
    if (Test-Path $cloneRef) {
        $remote = git -C $cloneRef remote get-url origin
        $tok = $remote -replace '^https://oauth2:([^@]+)@.*', '$1'
    }
}
if (-not $tok) { throw 'PAT nao encontrado (env GITLAB_PAT_SQUAD ou remote do clone).' }
$h = @{ 'PRIVATE-TOKEN' = $tok }

# <- AJUSTAR: um item por repo que versiona skills
$repos = @(
    @{ id = 0; name = '<repo-1>' }
)

$total = 0
foreach ($r in $repos) {
    $tree = Invoke-RestMethod -Headers $h -Uri "$gitlab/projects/$($r.id)/repository/tree?path=.claude/skills&ref=$Ref&recursive=true&per_page=100"
    $blobs = @($tree | Where-Object { $_.type -eq 'blob' })
    foreach ($b in $blobs) {
        $rel = $b.path -replace '^\.claude/skills/', ''
        $dest = Join-Path (Join-Path $CacheDir $r.name) ($rel -replace '/', '\')
        New-Item -ItemType Directory -Force -Path (Split-Path $dest -Parent) | Out-Null
        $enc = [uri]::EscapeDataString($b.path)
        Invoke-RestMethod -Headers $h -Uri "$gitlab/projects/$($r.id)/repository/files/$enc/raw?ref=$Ref" -OutFile $dest
    }
    $total += $blobs.Count
    Write-Host ("  {0}: {1} arquivos" -f $r.name, $blobs.Count)
}
Write-Host ("OK - {0} arquivos em {1} (ref={2})" -f $total, $CacheDir, $Ref)
