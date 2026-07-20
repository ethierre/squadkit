# Qualidade de spec — "unit tests for English" (valida a ESCRITA antes do gate humano)

Conceito (padrão spec-kit): antes de o humano aprovar uma SPEC, gere um **checklist que testa o
TEXTO da spec** — não o sistema. Barateia o gate: o humano revisa uma spec já auditada.

## Como gerar (o arquiteto, em contexto fresco, ANTES do gate)

Para cada domínio tocado pela spec (api/segurança/UX/dados/conteúdo), derive itens que perguntam
sobre a ESCRITA:

- ✅ CERTO: "O 'carregamento rápido' do CA-3 está quantificado (ms/percentil)? [Clareza, §5]"
- ✅ CERTO: "Há requisito de rollback definido para a falha de migração? [Gap]"
- ✅ CERTO: "'Usuário' no §2 e 'operador' no §4 são a mesma persona? [Ambiguidade]"
- ❌ ERRADO: "Verificar que o sistema carrega em menos de 2s" (isso testa o SISTEMA — é o §10,
  não este checklist).

## Regras

1. **≥80% dos itens com referência de rastreabilidade**: `[§X]`, `[CA-n]`, `[Gap]`,
   `[Ambiguidade]`, `[Conflito]`, `[Premissa]`.
2. Item aponta ausência/vagueza/conflito — nunca começa com "verificar/testar/confirmar
   comportamento".
3. Checklist reprovado (item aberto relevante) = a spec VOLTA ao especificador antes do gate
   humano; item aberto irrelevante = marcado N/A com justificativa.
4. O checklist vive junto da spec (`specs\CHECKLIST-<id>.md`) e o resultado entra no log de
   clarificações (§11 da spec).

## Gatilhos típicos por categoria

Clareza (adjetivo sem métrica) · Completude (fluxo de erro? estado vazio? permissão?) ·
Consistência (termos, unidades, moeda/fuso) · Testabilidade (todo CA tem forma objetiva de
passar/falhar?) · Rastreabilidade (CA órfão de task? task órfã de CA?) · Premissas (defaults
assumidos estão declarados?).
