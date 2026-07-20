# Engenharia agêntica — o método Karpathy aplicado (pré-voo de todo executor)

> Origem: framework de Andrej Karpathy (2026) — a linha dura entre **vibe coding** ("prompt and
> pray") e **agentic engineering** (spec, diff review, eval loops, disciplina). O SquadKit É
> engenharia agêntica em produto; este doc destila as 5 "Karpathy Guidelines" como o **pré-voo**
> que todo papel executor roda ANTES de produzir. Funciona como "metacognição protética": a
> estrutura externa que força a autoavaliação que o modelo não faz sozinho.

## O pré-voo (5 passos, na ordem)

**1. Suposições à mesa** — liste as suposições de que a implementação depende. Explícita na spec?
Siga. Inferida e óbvia? Anote e siga. **Inferida e consequente? PARE e confirme** (protocolo de
clarificação: opções numeradas com recomendação). Sempre pergunte: existe abordagem mais simples?

**2. Restrição de simplicidade (teste do engenheiro sênior)** — o plano passa em TODOS:
- zero feature além do explicitamente pedido;
- zero abstração para caso de uso único;
- zero "flexibilidade"/configurabilidade não pedida;
- zero tratamento de erro para cenário impossível.
Se um sênior olharia e diria "overcomplicated" → reescreva para o mínimo viável. (O review pega
depois via gap `não-pedido`; este passo evita ANTES.)

**3. Restrição de mudança cirúrgica** — identifique as linhas exatas que a task exige e toque SÓ
nelas: não reformate código adjacente, não refatore código funcionando, não "melhore" de
passagem; preserve o estilo existente; código morto pré-existente se MENCIONA (não se deleta);
só remova import/variável órfã que VOCÊ criou. **Teste: toda linha do diff rastreia diretamente
ao pedido/CA** — linha órfã de pedido é defeito de escopo.

**4. Critério de sucesso verificável antes de começar** — a task vaga vira objetivo testável
("adicionar validação" → "escrever os testes de entrada inválida e fazê-los passar"). No SquadKit
isso JÁ é o §10 do SPEC + CA-n — se não der para definir o critério, volte ao passo 1 (a dúvida é
de spec, não de código).

**5. Execute e PROVE** — rode a verificação do passo 4 e reporte COM a evidência ("aqui está a
saída"), nunca com asserção ("confia, funciona"). Falhou? Investigue e re-execute — não declare
conclusão. (= nosso invariante de evidência executada.)

## Rédea (calibre a autonomia pela consequência, não pelo hype)

Karpathy migrou de 80/20 (escrevendo) para 20/80 (delegando) — mas com rédea proporcional ao
risco. No squad, o orquestrador calibra por task:
- **Assistida** (mudança irreversível/sensível): humano aprova o PLANO antes do código.
- **Supervisionada** (padrão): esteira normal — spec → dev → review → gate humano no merge.
- **Autônoma** (rotina de baixo risco, regressão congelada): roda direto; humano vê o relatório.

## Anti-padrões nomeados (para o reviewer citar)

`vibe-coding` (produzir sem spec/critério) · `sycophancy` (concordar com o pedido errado em vez
de apontar) · `vitória prematura` (feito sem evidência) · `refatoração fantasma` (mudança fora
do escopo do diff) · `over-engineering` (falhou no teste do sênior).
