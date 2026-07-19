# BUGS.md — Fila de bugs do Squad {{PROJETO}}

> **Dono da escrita: SÓ squad-qa.** O campo **Área** é o contrato de roteamento — sem ele o
> orquestrador não despacha. Áreas válidas: `front` · `back` · `dados` (ajuste à realidade do projeto).
> Status: `aberto` → `roteado` → `corrigido` → `re-testado-ok` (QA fecha) | `reaberto`

## Template (copiar para cada bug)

```markdown
## BUG-<nnn> · aberto
- **US/Task:** <id> · **Área:** <front|back|dados> · **Repo:** <repo>
- **Severidade:** <bloqueante|alta|média|baixa>
- **Contrato violado:** SPEC-<id> §<seção> — <o que o contrato diz>
- **Reprodução:** <passos exatos>
- **Evidência:** <saída REAL do comando/teste que falhou>
- **Caso de teste:** <qual critério Given/When/Then falhou>
- **Rota:** squad-dev-<área> (agente da task <id>)
```

## Fila

_(nenhum bug registrado)_
