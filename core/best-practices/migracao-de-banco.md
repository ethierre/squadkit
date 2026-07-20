# Migração de banco — regras para papéis de dados

## Numeração e imutabilidade

- **Antes de numerar, confira o head REAL do repo** (`git ls-tree origin/<branch> -- <pasta>`) —
  planos e cards defasam; numeração colidida quebra o pipeline de todo mundo.
- Migração versionada NUNCA se edita — correção é migração NOVA. Aplicada em ambiente compartilhado,
  nem rollback edita: roll-forward.

## Toda migração nasce com

1. **Verificação embutida ou anexa**: consulta que prova o resultado (contagens antes/depois,
   constraint válida) — evidência executada, não "rodou sem erro".
2. **Plano de reversão declarado**: como voltar (migração inversa ou backup point) e o que é
   IRREVERSÍVEL (drop de coluna com dado) — irreversível exige gate humano explícito.
3. **Compatibilidade com o código vivo**: em deploy contínuo, o esquema N deve funcionar com o
   código N-1 (expand → migrate → contract; nunca renomear em um passo).

## Segurança e dados

- Zero DML de produção inventado: seed/backfill só com fonte declarada.
- Dado pessoal em migração (cópia, máscara, expurgo) = citar a base legal/decisão no comentário.
- Banco de PARCEIRO ou produção de terceiro é read-only absoluto para agentes.

## Performance

- Migração em tabela grande: estimar lock (índice concorrente quando o banco suportar; batch para
  updates massivos); janela declarada na spec se houver bloqueio.
