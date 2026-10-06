# Parque de Diversões — AV3: Criação e Povoamento

Banco de Dados — CIn/UFPE

**Equipe:** Samuel de Almeida Farias Nascimento, Davi de Souza Mello, Maria Cláudia Silva Rocha,
Pedro Wellington Ferreira Felizola Lucena, Guilherme Calistrato Nunes.

Scripts Oracle SQL gerados a partir do **Esquema Relacional Normalizado** da AV2 (23 tabelas).

## Estrutura

```
bd/
├── README.md
└── sql/
    ├── 00_drop.sql                 remove tabelas e sequences (para reexecutar do zero)
    ├── 01_sequences.sql            CREATE SEQUENCE (4)
    ├── 02_tables.sql               CREATE TABLE (23), com CONSTRAINT e CHECK
    ├── 03_alter_constraints.sql    FK circular entre OPERADOR e BRINQUEDO
    ├── 04_populate.sql             INSERT INTO (povoamento)
    └── 05_verificacao.sql          consultas de conferência (opcional)
```

## Como executar (Oracle Live SQL)

Executar **nesta ordem**, cada arquivo como um script completo:

1. `00_drop.sql` — só se for reexecutar. Na primeira vez, os erros ORA-00942 / ORA-02289 são esperados.
2. `01_sequences.sql`
3. `02_tables.sql`
4. `03_alter_constraints.sql`
5. `04_populate.sql`
6. `05_verificacao.sql` — opcional

O `04_populate.sql` depende das sequences começarem em 1 (os códigos de atração, peça e revisão usados
nas chaves estrangeiras são os gerados em sequência). Por isso o `00_drop.sql` antes de reexecutar.

## Checklist da entrega

| Exigência | Onde |
|---|---|
| `CREATE TABLE` | `02_tables.sql` (23 tabelas) |
| `INSERT INTO` | `04_populate.sql` |
| `CONSTRAINT` em `CREATE TABLE` | `02_tables.sql` — toda constraint é nomeada: 23 `PRIMARY KEY`, 27 `FOREIGN KEY`, 2 `UNIQUE` (inclui a FK adicionada em `03`) |
| `CREATE SEQUENCE` | `01_sequences.sql` — `seq_atracao`, `seq_peca`, `seq_revisao`, `seq_ingresso` |
| `CHECK` em `CREATE TABLE` | `02_tables.sql` — 31 checks |

## Decisões de modelagem

**Sequences.** Só nas chaves geradas pelo sistema: código de atração, de peça, de revisão e número de ingresso.
`BRINQUEDO` e `ESPETACULO` herdam o código da atração (inserção em `ATRACAO` com `NEXTVAL` e no subtipo com
`CURRVAL`). CPF, nome de área/evento e número de sessão não usam sequence: são identificadores naturais ou
discriminador de entidade fraca.

**FK circular.** `BRINQUEDO.cpf_gerente → OPERADOR` (Gerencia) e `OPERADOR.codigo_brinquedo_opera → BRINQUEDO`
(Opera) se referenciam mutuamente. `OPERADOR` é criada sem a FK de brinquedo, que entra em
`03_alter_constraints.sql`. No povoamento, os operadores entram com `codigo_brinquedo_opera` nulo e recebem
o brinquedo por `UPDATE` depois que `BRINQUEDO` existe.

**Gerencia e Opera são fatos independentes.** Um gerente pode não operar nenhum brinquedo ou operar o mesmo
que gerencia (a consulta 2 de `05_verificacao.sql` mostra os dois casos). `uq_brinquedo_gerente` garante que um
operador gerencia no máximo um brinquedo.

**Horários.** `VARCHAR2(5)` no formato `HH24:MI`, validado por `CHECK` com `REGEXP_LIKE`, porque o tipo `DATE`
do Oracle sempre carrega data e hora.

**Frequenta.** O brinquedo visitado não é coluna da tabela: obtém-se por junção com `OPERADOR`
(decisão de 3FN da AV2). A chave primária é `(cpf_cliente, data, horario_visita)`: essa chave inteira determina
`cpf_operador`, e o operador determina o brinquedo, ou seja, `(cpf_cliente, data, horario_visita) → cpf_operador →
codigo_brinquedo` (correção da AV2: `cpf_cliente` sozinho não determina o operador).

**Nomes das colunas.** Seguem o esquema da AV2, inclusive `usa.quantidade_de_pecas` e
`reserva.quantidade_de_reservas`.

**Campos opcionais (nulos).** `operador.codigo_brinquedo_opera` (operador sem brinquedo), `brinquedo.cpf_gerente`
(brinquedo sem gerente) e `trabalha_em.data_fim` (alocação atual).

**Principais `CHECK`s.** CPF com 11 dígitos, CEP com 8, e-mail e telefone em formato válido; salário e
capacidades positivos; funcionário admitido com 18 anos ou mais; categorias de brinquedo
(Radical/Infantil/Aquático) e de show (Musical/Teatral/Circense); local do ingresso (Digital/Física);
nível de certificação de 1 a 3; término de evento e de alocação não anterior ao início; ninguém mentora a si mesmo.

**Regras do modelo conceitual que o SQL puro não impõe.** Especialização total e disjunta (todo funcionário
é exatamente um entre técnico/operador/artista; toda atração é exatamente brinquedo ou espetáculo) e
cardinalidades mínimas 1 entre tabelas (ex.: toda área tem ao menos uma atração, todo evento ao menos um
artista) dependem de gatilhos ou da aplicação. O povoamento as respeita, e as consultas de verificação as exibem.

## Povoamento

Dados fictícios, no tema do parque. Os CPFs têm dígito verificador válido, mas não pertencem a pessoas reais.

| Tabela | Linhas | Tabela | Linhas |
|---|---:|---|---:|
| area | 5 | sessao | 18 |
| funcionario | 22 | revisao | 16 |
| tecnico | 5 | usa | 28 |
| operador | 12 | ingresso | 41 |
| artista | 5 | trabalha_em | 29 |
| atracao | 13 | reserva | 19 |
| brinquedo | 8 | se_apresenta_em | 10 |
| espetaculo | 5 | mentora | 15 |
| cliente | 12 | frequenta | 68 |
| peca | 10 | telefone_funcionario | 28 |
| evento | 6 | telefone_cliente | 16 |
| especialidade_artistica | 12 | | |

Coerência entre tabelas:

- Todo brinquedo tem ao menos um operador e duas revisões; todo técnico faz ao menos uma revisão.
- Há gerente que não opera (brinquedo 1), gerentes que também operam (brinquedos 3 e 5) e brinquedos sem gerente.
- Há revisões de rotina sem peças, peças repostas sem custo (saíram do estoque) e a mesma peça, com a mesma
  quantidade, custando valores diferentes em revisões diferentes.
- Funcionários com histórico de alocação em várias áreas, sem sobreposição de períodos, sempre com uma única
  alocação atual; nenhuma alocação começa antes da admissão.
- Cadeia de mentoria de dois níveis, um mentorado com dois mentores, e mentor sempre mais antigo na empresa.
- Todo cliente compra ao menos um ingresso; visitas a brinquedos só ocorrem em dias com ingresso do cliente,
  atendidas por um operador que de fato opera aquele brinquedo.
- Reservas nunca excedem os ingressos do cliente naquele dia, e vagas disponíveis + reservas nunca excedem a
  capacidade da plateia.
