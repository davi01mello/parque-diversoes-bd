Parque de Diversões — AV3: Criação e Povoamento

Banco de Dados — CIn/UFPE

Equipe: Samuel de Almeida Farias Nascimento, Davi de Souza Mello, Maria Cláudia Silva Rocha, Pedro Wellington Ferreira Felizola Lucena, Guilherme Calistrato Nunes.

Scripts Oracle SQL gerados a partir do Esquema Relacional Normalizado da AV2 (23 tabelas).

Estrutura
bd/
├── README.md
└── sql/
    ├── 01_ddl.sql            DROP (tabelas e sequences) + CREATE SEQUENCE + CREATE TABLE + ALTER da FK circular
    ├── 02_povoamento.sql     INSERT INTO (povoamento)
    └── 03_verificacao.sql    consultas de conferência (opcional)
Como executar (Oracle Live SQL)

Executar nesta ordem, cada arquivo como um script completo:

01_ddl.sql — começa com os DROPs, então pode ser reexecutado quantas vezes for preciso. Na primeira execução, os erros ORA-00942 (tabela inexistente) e ORA-02289 (sequence inexistente) dos DROPs são esperados.
02_povoamento.sql — depende das sequences começarem em 1 (os códigos de atração, peça e revisão usados nas chaves estrangeiras são os gerados em sequência). Por isso, sempre rodar o 01_ddl.sql antes.
03_verificacao.sql — opcional.
Checklist da entrega
Exigência	Onde
CREATE TABLE	01_ddl.sql (23 tabelas)
INSERT INTO	02_povoamento.sql
CONSTRAINT em CREATE TABLE	01_ddl.sql — toda constraint é nomeada: 23 PRIMARY KEY, 27 FOREIGN KEY, 2 UNIQUE (a FK circular entra no ALTER TABLE da parte 4)
CREATE SEQUENCE	01_ddl.sql — seq_atracao, seq_peca, seq_revisao, seq_ingresso
CHECK em CREATE TABLE	01_ddl.sql — 31 checks
Boas práticas de DDL aplicadas

DROP no início. O 01_ddl.sql começa removendo todas as tabelas e sequences, para evitar erro de duplicação ao reexecutar. Ordem: primeiro as tabelas que ninguém referencia, depois as que têm dependentes, e por fim as sequences. OPERADOR e BRINQUEDO se referenciam mutuamente, e CASCADE CONSTRAINTS resolve esse par.

Menor tipo que comporta o dado, com margem, e tipos nativos. Datas em DATE; CPF, CEP e telefone em VARCHAR2 (preservam zeros à esquerda); valores monetários em NUMBER(8,2); velocidade em NUMBER(4,1); quantidades e códigos em NUMBER com precisão dimensionada para o domínio.

Horários. INTERVAL DAY(0) TO SECOND(0) em sessao.horario, revisao.horario e frequenta.horario_visita. O tipo DATE do Oracle sempre carrega data e hora, e a data já está na coluna data; o INTERVAL guarda só a hora do dia, sem redundância e sem texto. Um CHECK garante que não seja negativo.

Nomes padronizados e descritivos. Minúsculas, snake_case, tabelas no singular, colunas com os mesmos nomes do esquema da AV2 (inclusive usa.quantidade_de_pecas e reserva.quantidade_de_reservas) e constraints no padrão pk_ / fk_ / uq_ / ck_ + tabela + coluna.

Decisões de modelagem

Sequences. Só nas chaves geradas pelo sistema: código de atração, de peça, de revisão e número de ingresso. BRINQUEDO e ESPETACULO herdam o código da atração (inserção em ATRACAO com NEXTVAL e no subtipo com CURRVAL). CPF, nome de área/evento e número de sessão não usam sequence: são identificadores naturais ou discriminador de entidade fraca.

FK circular. BRINQUEDO.cpf_gerente → OPERADOR (Gerencia) e OPERADOR.codigo_brinquedo_opera → BRINQUEDO (Opera) se referenciam mutuamente. OPERADOR é criada sem a FK de brinquedo, que entra no ALTER TABLE da parte 4 do 01_ddl.sql. No povoamento, os operadores entram com codigo_brinquedo_opera nulo e recebem o brinquedo por UPDATE depois que BRINQUEDO existe.

Gerencia e Opera são fatos independentes. Um gerente pode não operar nenhum brinquedo, operar o mesmo que gerencia ou operar outro (a consulta 2 de 03_verificacao.sql mostra os três casos). uq_brinquedo_gerente garante que um operador gerencia no máximo um brinquedo.

Frequenta. O brinquedo visitado não é coluna da tabela: obtém-se por junção com OPERADOR (decisão de 3FN da AV2). A chave primária é (cpf_cliente, data, horario_visita): essa chave inteira determina cpf_operador, e o operador determina o brinquedo, ou seja, (cpf_cliente, data, horario_visita) → cpf_operador → codigo_brinquedo (correção da AV2: cpf_cliente sozinho não determina o operador).

Campos opcionais (nulos). operador.codigo_brinquedo_opera (operador sem brinquedo), brinquedo.cpf_gerente (brinquedo sem gerente) e trabalha_em.data_fim (alocação atual).

Principais CHECKs. CPF com 11 dígitos, CEP com 8, e-mail e telefone em formato válido; salário e capacidades positivos; funcionário admitido com 18 anos ou mais; categorias de brinquedo (Radical/Infantil/Aquático) e de show (Musical/Teatral/Circense); local do ingresso (Digital/Física); nível de certificação de 1 a 3; horários não negativos; término de evento e de alocação não anterior ao início; ninguém mentora a si mesmo.

Regras do modelo conceitual que o SQL puro não impõe. Especialização total e disjunta (todo funcionário é exatamente um entre técnico/operador/artista; toda atração é exatamente brinquedo ou espetáculo) e cardinalidades mínimas 1 entre tabelas (ex.: toda área tem ao menos uma atração, todo evento ao menos um artista) dependem de gatilhos ou da aplicação. O povoamento as respeita, e as consultas de verificação as exibem.

Povoamento

Dados fictícios, no tema do parque. Os CPFs têm dígito verificador válido, mas não pertencem a pessoas reais.

Tabela	Linhas	Tabela	Linhas
area	5	sessao	18
funcionario	22	revisao	16
tecnico	5	usa	28
operador	12	ingresso	41
artista	5	trabalha_em	29
atracao	13	reserva	19
brinquedo	8	se_apresenta_em	10
espetaculo	5	mentora	15
cliente	12	frequenta	68
peca	10	telefone_funcionario	28
evento	6	telefone_cliente	16
especialidade_artistica	12		

Coerência entre tabelas:

Todo brinquedo tem ao menos um operador e duas revisões; todo técnico faz ao menos uma revisão.
Só os brinquedos de alta capacidade (24 lugares ou mais) têm gerente, e o gerente é da mesma área do brinquedo. Há gerente que não opera (brinquedo 1), gerentes que também operam (brinquedos 3, 7 e 8) e gerente que opera outro brinquedo (brinquedo 4). Os brinquedos 2, 5 e 6 ficam sem gerente.
Cada operador trabalha na mesma área do brinquedo que opera.
Há revisões de rotina sem peças, peças repostas sem custo (saíram do estoque) e a mesma peça, com a mesma quantidade, custando valores diferentes em revisões diferentes.
Funcionários com histórico de alocação em várias áreas, sem sobreposição de períodos, sempre com uma única alocação atual; nenhuma alocação começa antes da admissão.
Cadeia de mentoria de dois níveis, um mentorado com dois mentores, e mentor sempre mais antigo na empresa.
Todo cliente compra ao menos um ingresso; visitas a brinquedos só ocorrem em dias com ingresso do cliente, atendidas por um operador que de fato opera aquele brinquedo.
Reservas nunca excedem os ingressos do cliente naquele dia, e vagas disponíveis + reservas nunca excedem a capacidade da plateia.
01 ddl
SQL
02 povoamento
SQL
03 verificacao
SQL
Readme
MD
Envios
Imagem e Imagem
+4
Memória
Lido · Overview, Ways Of Working
Claude Desktop (Windows)
…/bd