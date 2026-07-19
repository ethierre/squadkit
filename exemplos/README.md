# Exemplos de squads sob medida (gerados do ROLE-TEMPLATE)

Papéis prontos para copiar (`.claude\agents\` do projeto + resolver placeholders) ou usar como
referência do que o `/montar-squad` gera. Mapeamento dos casos reais:

| Projeto | Como montar |
|---|---|
| **APPAI** (PO, dev, arquiteto, QA) | Só catálogo: `-Papeis po,arquiteto,dev-back,dev-front,qa` |
| **Canal YouTube** (copy, revisor, media manager, marketing, tráfego) | catálogo `marketing` + os 4 papéis de `youtube\` |
| **AIDC7** (especialista OCR, dev, arquiteto, PO) | `-Papeis po,arquiteto,dev-back,qa` + `aidc7\squad-especialista-ocr.md` |
| **PBM varejo farma** (análise de vendas, relatórios, programas PBM) | os 2 papéis de `pbm-farma\` + catálogo `gerente` se quiser status report |

Regra de ouro ao criar os seus: manter as seções [INVARIANTE] do `roles\ROLE-TEMPLATE.md` —
são elas que carregam o harness (evidência, honestidade de dado, dono único, gate humano em ação
irreversível).
