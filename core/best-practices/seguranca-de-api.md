# Segurança de API — checklist para devs e reviewers

## Por rota (o mínimo, sempre)

- **AuthN + AuthZ por RECURSO** (não só por rota): o usuário pode ver ESTE id? (IDOR/BOLA é o
  bug nº1 de API). Cross-tenant → responda 404, não 403 (anti-enumeração).
- Validação de entrada no BORDO (schema/DTO): tipo, tamanho, formato, allowlist de enum — nunca
  confiar no front. Mass assignment: bind explícito de campos, nunca o objeto inteiro do request.
- Erros sem vazamento: nada de stack trace, SQL, path interno ou PII em resposta/log de erro.

## Transversal

- Segredos SÓ em cofre/env — nunca em código, config commitada, log ou mensagem de erro.
- Rate limit em endpoints de escrita/login/busca; idempotência em pagamentos e webhooks
  (chave de idempotência + validação de assinatura do webhook).
- SQL/comando: parametrizado SEMPRE — concatenação de entrada do usuário é P0 automático.
- CORS explícito (nunca `*` com credenciais); headers de segurança (CSP, HSTS) conforme o canal.
- Dependências: lockfile + verificação de vulnerabilidade conhecida na esteira.

## Para o reviewer (P0 = bloqueia sozinho)

P0: injeção, authz ausente por recurso, segredo exposto, PII em log.
P1: validação de entrada ausente, rate limit ausente em rota sensível, erro verboso.
Achou segredo? Reporte ONDE (arquivo:linha) sem reproduzir o valor — e a rotação vira task.
