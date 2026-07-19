# DECISOES.md — ADR-lite da sprint (Squad {{PROJETO}})

> **Dono da escrita: SÓ squad-arquiteto.** Decisões estruturais grandes viram ADR formal no repo do
> projeto; aqui ficam as decisões táticas que todos os agentes precisam respeitar.
> Formato: uma entrada por decisão, mais recente no topo.

## Decisões vigentes (herdadas do projeto — não rediscutir)  ← PREENCHER NA INSTALAÇÃO

- **Branch de integração = `{{BRANCH}}`** em todos os repos.
- **Squad nunca mergeia**: push só de branch `squad/*`; humano aprova; merge é manual do humano.
- _(adicione aqui as regras invioláveis do projeto: convenções de wire/API, tipos de dado sensíveis
  como dinheiro/data, multi-tenancy, "never do" — no 7Risk, ex.: camelCase no fio, dinheiro=string,
  NUMERIC(18,2) em reais, RLS por tenant)_
- **Fatos canônicos completos**: ver §Fatos canônicos de `contexto\_INDICE.md` — resolve
  contradições entre documentos.

## Decisões da sprint

_(formato: `### AD-SQ-<n> · <data> · <título>` — Contexto / Decisão / Consequência)_
