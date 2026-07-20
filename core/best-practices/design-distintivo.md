# Design distintivo — para o front NÃO ter cara de IA

> Leitura OBRIGATÓRIA de squad-ux, squad-dev-front e squad-dev-mobile antes de qualquer tela nova
> ou redesign. Destilado da abordagem de design da Anthropic (skill frontend-design), adaptado ao
> harness do SquadKit. **Regra de adaptação: os fatos canônicos do projeto (design system,
> identidade, tokens existentes) SEMPRE vencem — esta prática governa os eixos que o projeto
> deixa livres.**

## Por que existe

Cliente percebe UI feita por IA. O design gerado hoje se aglomera em 3 caras reconhecíveis:
(1) fundo creme (~#F4F1EA) + serifa display de alto contraste + acento terracota;
(2) fundo quase-preto + um acento verde-ácido/vermelhão;
(3) layout "jornal" com hairlines, radius zero e colunas densas.
As três são legítimas SE o brief pedir — mas são **defaults, não escolhas**. Onde o brief deixa um
eixo livre, não gaste essa liberdade num default. Antes de aprovar seu plano, pergunte-se: "eu
chegaria neste mesmo visual para um brief parecido de OUTRO assunto?" Se sim, revise.

## Ancore no assunto

A identidade distintiva nasce do MUNDO do assunto: materiais, instrumentos, vocabulário, artefatos
próprios. Se o brief não define o assunto, defina você (assunto concreto + público + o único
trabalho da página) e DECLARE a escolha. Construa com o conteúdo real — nunca lorem ipsum.

## O plano vem antes do código (dois passes)

**Passe 1 — plano compacto de tokens:**
- **Cor**: paleta de 4–6 hex NOMEADOS (nome que remete ao assunto, não "primary/secondary").
- **Tipo**: 2+ papéis tipográficos — display com personalidade (usada com contenção), corpo
  complementar, utilitária p/ dados se precisar. A dupla display+corpo não pode ser a que você
  usaria em qualquer projeto.
- **Layout**: conceito em 1 frase + wireframe ASCII para comparar alternativas.
- **Assinatura**: O elemento único pelo qual a página será lembrada — UM só.

**Passe 2 — crítica anti-default:** revise o plano contra o brief ANTES de codar; toda parte que
parecer o default genérico é revisada (diga o que mudou e por quê). Só então escreva o código,
seguindo o plano à risca — toda cor e tipo derivam dele.

## Princípios de execução

- **Hero é tese**: abra com a coisa mais característica do mundo do assunto (headline, imagem,
  demo, momento interativo). "Número grande + label pequeno + stat + gradiente" é a resposta
  template — só use se for genuinamente a melhor.
- **Estrutura é informação**: numeração (01/02/03), eyebrows e divisores só quando codificam algo
  verdadeiro do conteúdo (sequência real, timeline) — nunca decoração.
- **Movimento deliberado**: um momento orquestrado > efeitos espalhados; excesso de animação é
  assinatura de IA. Menos costuma ser mais.
- **Gaste a ousadia num lugar só**: o elemento-assinatura é o memorável; o resto fica quieto e
  disciplinado. Regra da Chanel: antes de entregar, tire um acessório.
- **Complexidade casa com a visão**: maximalista pede execução elaborada; minimal pede precisão
  cirúrgica de espaçamento/tipo/detalhe.
- **CSS**: cuidado com especificidade que se cancela (classe de seção × elemento) — clássico em
  paddings/margens entre seções.

## Texto é material de design

- Escreva do lado do usuário da tela: nomeie pelo que a pessoa controla ("notificações", não
  "config de webhook"). Específico > esperto.
- Voz ativa; o controle diz o que acontece ("Salvar alterações", não "Enviar"); a ação mantém o
  MESMO nome no fluxo inteiro (botão "Publicar" → toast "Publicado").
- Erro explica o que houve e como resolver — sem se desculpar, sem vagueza. Tela vazia é convite
  à ação, não um "nada por aqui :(".
- Registro conversacional: verbos simples, sentence case, zero enchimento; cada elemento faz UM
  trabalho.

## Piso de qualidade (sem anunciar) + harness

Responsivo até mobile · foco de teclado visível · `prefers-reduced-motion` respeitado ·
contraste AA. **Evidência (contrato do SquadKit)**: screenshot/gravação do resultado real em
desktop E mobile anexada à entrega — critique a própria tela olhando a imagem antes do review.
O revisor tem "parece template de IA?" como critério explícito de reprovação (P1).
