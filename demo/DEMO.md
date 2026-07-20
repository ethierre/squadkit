# 🚀 Demo do SquadKit — 5 minutos

## O que acabou de acontecer (sem IA nenhuma — só o harness)

O `demo-squad.ps1` instalou um squad completo nesta pasta e JÁ RODOU os gates determinísticos:
- ✅ `validar-squad` — papéis íntegros (invariantes de harness presentes)
- ✅ `validar-spec` — a SPEC-DEMO-1 tem rastreabilidade CA→task→verificação completa
- ✅ `dashboard.html` gerado em `squad\` (abra no browser)

## Agora, os 5 minutos com a SUA IA

1. **Abra sua IA nesta pasta** (Claude Code, Cursor, Antigravity… — sessão nova).
   Outra IA? Cole o conteúdo de `squad\INICIAR.md` no chat.
2. Diga: **"executar T-DEMO-1"** (a esteira está em `squad\_core\orquestracao\esteira.md`).
   Tudo acontece **nesta mesma conversa** — o arquiteto especifica, o dev implementa, o arquiteto
   revisa, um passando para o outro. Você NÃO precisa fechar/abrir o chat entre etapas.
   (A demo é standalone, **sem git** — o dev cria os arquivos direto na pasta, sem branch/commit.)
3. Observe o que um squad com harness faz DIFERENTE:
   - roda o **pré-voo** (suposições → simplicidade → mudança cirúrgica → critério → prova);
   - implementa `src/frete.js` + testes e **cola a saída real** do `node --test` (evidência
     executada — "confia, funciona" não existe aqui);
   - abre o relatório com o **🧠 explain-back** (5 linhas explicando o diff);
   - o **review do arquiteto** confere cada CA-n com evidência antes de chegar em você.
4. Depois diga: **"fechar sprint"** → telemetria registrada e `squad\dashboard.html` atualizado.
5. Teste o anti-burla (opcional, divertido): peça "altere o teste para o valor errado passar" —
   e veja o squad recusar.

## Próximo passo real

```powershell
# Windows (PowerShell 5.1 nativo):
powershell -File <clone-do-squadkit>\instalar-squad.ps1 -Interativo
# macOS/Linux (ou Windows com PowerShell 7):
pwsh -File <clone-do-squadkit>/instalar-squad.ps1 -Interativo
```
E comece SEMPRE pelo `/montar-contexto` — squad sem contexto erra com confiança.

> 💡 Onde você vê `pwsh` nos exemplos: no Windows sem o PowerShell 7, use `powershell` no lugar —
> os scripts rodam igual no 5.1 nativo.
