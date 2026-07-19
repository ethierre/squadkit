# Spec-driven — trabalhar contra especificação (qualquer domínio)

Regra de ouro: **nunca produza a partir de pedido solto.** Todo entregável nasce de uma spec:
código ← SDD · tela ← SPEC-UX · campanha ← BRIEF-MKT · análise ← pedido com objetivo/período/recorte ·
rotina ← CHECKLIST versionado.

## Por quê

Pedido em linguagem natural solta produz resultado de baixa assertividade e retrabalho; contrato
explícito produz resultado VERIFICÁVEL. A spec é o acordo entre quem pede, quem faz e quem revisa —
os três leem o mesmo documento.

## O mínimo de uma spec (qualquer domínio)

1. **Objetivo** — o problema, em linguagem de quem pediu.
2. **Escopo e FORA de escopo** — o fora-de-escopo evita "melhorias" não pedidas.
3. **Contrato/critérios verificáveis** — formatos, exemplos, Given/When/Then ou checklist.
4. **Definição de pronto** — comandos/verificações objetivas + resultado esperado.

## Protocolo de clarificação (orçamento de perguntas — padrão spec-kit)

Ao especificar, varra a spec contra estas categorias: escopo · dados/entidades · UX/estados ·
não-funcionais · integrações · casos de borda · terminologia. Para cada lacuna REAL:
- **Máximo 5 perguntas por sessão**, UMA por vez, priorizadas por Impacto × Incerteza.
- Formato múltipla-escolha com **recomendação** ("Recomendo A porque...") — decisão humana barata.
- Cada resposta é **integrada na seção certa da spec** (requisito vago vira métrica; termo
  conflitante é normalizado — substituído, não duplicado) E logada em "§Clarificações / Sessão".
- **Default razoável não vira pergunta** — vira registro em "Premissas assumidas" (auditável).

## Diante de ambiguidade (a regra que separa squad bom de squad perigoso)

- Ambiguidade DENTRO da spec → **PARE e devolva a pergunta** com sua recomendação. Nunca escolha
  em silêncio.
- Spec parecer errada → a correção é NA SPEC (com aprovação de quem decide), nunca improvisada
  no entregável.
- No modo "executar" (task já planejada), perguntas abertas com recomendação do especificador não
  travam — siga a recomendação e REGISTRE a decisão no relatório.

## Divergência

Entregável que diverge do contrato é DEFEITO, não interpretação — mesmo que "pareça melhor".
Melhorias viram proposta para a próxima spec.
