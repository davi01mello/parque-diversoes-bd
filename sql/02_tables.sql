-- =====================================================================
-- 02_tables.sql
-- Projeto: Parque de Diversões (AV3 - Criação e Povoamento)
-- Criação das 23 tabelas do Esquema Relacional Normalizado (AV2).
--
-- Convenções:
--   * Toda constraint é nomeada: pk_ / fk_ / uq_ / ck_ + tabela.
--   * Horários são guardados como VARCHAR2(5) no formato 'HH24:MI'
--     (o tipo DATE do Oracle sempre carrega data + hora).
--   * Ordem de criação: quem tem FK vem depois de quem ela referencia.
--   * A FK OPERADOR -> BRINQUEDO fica de fora aqui (dependência circular
--     com BRINQUEDO -> OPERADOR) e é adicionada em 03_alter_constraints.sql.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1) Tabelas sem dependência
-- ---------------------------------------------------------------------

CREATE TABLE area (
    nome        VARCHAR2(40)  NOT NULL,
    tema        VARCHAR2(60)  NOT NULL,
    tamanho_m2  NUMBER(8)     NOT NULL,
    CONSTRAINT pk_area         PRIMARY KEY (nome),
    CONSTRAINT ck_area_tamanho CHECK (tamanho_m2 > 0)
);

CREATE TABLE funcionario (
    cpf              VARCHAR2(11)  NOT NULL,
    primeiro_nome    VARCHAR2(40)  NOT NULL,
    sobrenome        VARCHAR2(60)  NOT NULL,
    data_nascimento  DATE          NOT NULL,
    data_admissao    DATE          NOT NULL,
    salario          NUMBER(10,2)  NOT NULL,
    CONSTRAINT pk_funcionario        PRIMARY KEY (cpf),
    CONSTRAINT ck_func_cpf           CHECK (REGEXP_LIKE(cpf, '^[0-9]{11}$')),
    CONSTRAINT ck_func_salario       CHECK (salario > 0),
    -- admitido com pelo menos 18 anos completos (216 meses)
    CONSTRAINT ck_func_admissao      CHECK (ADD_MONTHS(data_nascimento, 216) <= data_admissao)
);

CREATE TABLE cliente (
    cpf            VARCHAR2(11)  NOT NULL,
    primeiro_nome  VARCHAR2(40)  NOT NULL,
    sobrenome      VARCHAR2(60)  NOT NULL,
    rua            VARCHAR2(80)  NOT NULL,
    numero         VARCHAR2(10)  NOT NULL,
    bairro         VARCHAR2(40)  NOT NULL,
    cidade         VARCHAR2(40)  NOT NULL,
    cep            VARCHAR2(8)   NOT NULL,
    email          VARCHAR2(80)  NOT NULL,
    CONSTRAINT pk_cliente        PRIMARY KEY (cpf),
    CONSTRAINT uq_cliente_email  UNIQUE (email),
    CONSTRAINT ck_cliente_cpf    CHECK (REGEXP_LIKE(cpf, '^[0-9]{11}$')),
    CONSTRAINT ck_cliente_cep    CHECK (REGEXP_LIKE(cep, '^[0-9]{8}$')),
    CONSTRAINT ck_cliente_email  CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'))
);

CREATE TABLE peca (
    codigo         NUMBER(6)     NOT NULL,
    nome           VARCHAR2(60)  NOT NULL,
    fabricante     VARCHAR2(40)  NOT NULL,
    estoque_atual  NUMBER(5)     NOT NULL,
    CONSTRAINT pk_peca          PRIMARY KEY (codigo),
    CONSTRAINT ck_peca_estoque  CHECK (estoque_atual >= 0)
);

CREATE TABLE evento (
    nome          VARCHAR2(40)   NOT NULL,
    data_inicio   DATE           NOT NULL,
    data_termino  DATE           NOT NULL,
    descricao     VARCHAR2(200)  NOT NULL,
    CONSTRAINT pk_evento        PRIMARY KEY (nome),
    CONSTRAINT ck_evento_datas  CHECK (data_termino >= data_inicio)
);


-- ---------------------------------------------------------------------
-- 2) Atração e subtipos de Funcionário
-- ---------------------------------------------------------------------

CREATE TABLE atracao (
    codigo      NUMBER(6)     NOT NULL,
    nome        VARCHAR2(60)  NOT NULL,
    capacidade  NUMBER(5)     NOT NULL,
    nome_area   VARCHAR2(40)  NOT NULL,   -- Localizada_Em (1,1)
    CONSTRAINT pk_atracao             PRIMARY KEY (codigo),
    CONSTRAINT fk_atracao_area        FOREIGN KEY (nome_area) REFERENCES area (nome),
    CONSTRAINT ck_atracao_capacidade  CHECK (capacidade > 0)
);

CREATE TABLE tecnico (
    cpf            VARCHAR2(11)  NOT NULL,
    especialidade  VARCHAR2(40)  NOT NULL,
    CONSTRAINT pk_tecnico              PRIMARY KEY (cpf),
    CONSTRAINT fk_tecnico_funcionario  FOREIGN KEY (cpf) REFERENCES funcionario (cpf)
);

CREATE TABLE operador (
    cpf                      VARCHAR2(11)  NOT NULL,
    nivel_certificacao       NUMBER(1)     NOT NULL,   -- 1 = básico ... 3 = avançado
    codigo_brinquedo_opera   NUMBER(6),                -- Opera (0,1): nulo = não opera nenhum brinquedo
    CONSTRAINT pk_operador              PRIMARY KEY (cpf),
    CONSTRAINT fk_operador_funcionario  FOREIGN KEY (cpf) REFERENCES funcionario (cpf),
    CONSTRAINT ck_operador_nivel        CHECK (nivel_certificacao BETWEEN 1 AND 3)
    -- fk_operador_brinquedo: ver 03_alter_constraints.sql
);

CREATE TABLE artista (
    cpf          VARCHAR2(11)  NOT NULL,
    cache_padrao NUMBER(10,2)  NOT NULL,
    CONSTRAINT pk_artista              PRIMARY KEY (cpf),
    CONSTRAINT fk_artista_funcionario  FOREIGN KEY (cpf) REFERENCES funcionario (cpf),
    CONSTRAINT ck_artista_cache        CHECK (cache_padrao >= 0)
);


-- ---------------------------------------------------------------------
-- 3) Subtipos de Atração
-- ---------------------------------------------------------------------

CREATE TABLE brinquedo (
    codigo            NUMBER(6)     NOT NULL,
    restricao_altura  NUMBER(3)     NOT NULL,   -- em cm; 0 = sem restrição
    velocidade_maxima NUMBER(5,1)   NOT NULL,   -- em km/h
    categoria         VARCHAR2(10)  NOT NULL,
    cpf_gerente       VARCHAR2(11),             -- Gerencia (0,1): nulo = sem gerente
    CONSTRAINT pk_brinquedo            PRIMARY KEY (codigo),
    CONSTRAINT fk_brinquedo_atracao    FOREIGN KEY (codigo) REFERENCES atracao (codigo),
    CONSTRAINT fk_brinquedo_gerente    FOREIGN KEY (cpf_gerente) REFERENCES operador (cpf),
    -- um operador gerencia no máximo um brinquedo
    CONSTRAINT uq_brinquedo_gerente    UNIQUE (cpf_gerente),
    CONSTRAINT ck_brinquedo_altura     CHECK (restricao_altura >= 0),
    CONSTRAINT ck_brinquedo_velocidade CHECK (velocidade_maxima > 0),
    CONSTRAINT ck_brinquedo_categoria  CHECK (categoria IN ('Radical', 'Infantil', 'Aquático'))
);

CREATE TABLE espetaculo (
    codigo             NUMBER(6)     NOT NULL,
    duracao            NUMBER(3)     NOT NULL,   -- em minutos
    categoria_show     VARCHAR2(10)  NOT NULL,
    capacidade_plateia NUMBER(5)     NOT NULL,
    CONSTRAINT pk_espetaculo            PRIMARY KEY (codigo),
    CONSTRAINT fk_espetaculo_atracao    FOREIGN KEY (codigo) REFERENCES atracao (codigo),
    CONSTRAINT ck_espetaculo_duracao    CHECK (duracao > 0),
    CONSTRAINT ck_espetaculo_plateia    CHECK (capacidade_plateia > 0),
    CONSTRAINT ck_espetaculo_categoria  CHECK (categoria_show IN ('Musical', 'Teatral', 'Circense'))
);


-- ---------------------------------------------------------------------
-- 4) Atributos multivalorados (extraídos na 1FN)
-- ---------------------------------------------------------------------

CREATE TABLE telefone_funcionario (
    cpf_funcionario  VARCHAR2(11)  NOT NULL,
    telefone         VARCHAR2(11)  NOT NULL,
    CONSTRAINT pk_telefone_funcionario     PRIMARY KEY (cpf_funcionario, telefone),
    CONSTRAINT fk_telefone_func_funcionario FOREIGN KEY (cpf_funcionario) REFERENCES funcionario (cpf),
    CONSTRAINT ck_telefone_func_numero     CHECK (REGEXP_LIKE(telefone, '^[0-9]{10,11}$'))
);

CREATE TABLE telefone_cliente (
    cpf_cliente  VARCHAR2(11)  NOT NULL,
    telefone     VARCHAR2(11)  NOT NULL,
    CONSTRAINT pk_telefone_cliente      PRIMARY KEY (cpf_cliente, telefone),
    CONSTRAINT fk_telefone_cli_cliente  FOREIGN KEY (cpf_cliente) REFERENCES cliente (cpf),
    CONSTRAINT ck_telefone_cli_numero   CHECK (REGEXP_LIKE(telefone, '^[0-9]{10,11}$'))
);

CREATE TABLE especialidade_artistica (
    cpf_artista    VARCHAR2(11)  NOT NULL,
    especialidade  VARCHAR2(40)  NOT NULL,
    CONSTRAINT pk_especialidade_artistica  PRIMARY KEY (cpf_artista, especialidade),
    CONSTRAINT fk_espec_artistica_artista  FOREIGN KEY (cpf_artista) REFERENCES artista (cpf)
);


-- ---------------------------------------------------------------------
-- 5) Sessão (entidade fraca), Revisão (associativa) e Ingresso
-- ---------------------------------------------------------------------

CREATE TABLE sessao (
    codigo_espetaculo  NUMBER(6)    NOT NULL,
    numero             NUMBER(2)    NOT NULL,
    data               DATE         NOT NULL,
    horario            VARCHAR2(5)  NOT NULL,
    vagas_disponiveis  NUMBER(5)    NOT NULL,
    CONSTRAINT pk_sessao             PRIMARY KEY (codigo_espetaculo, numero, data),
    CONSTRAINT fk_sessao_espetaculo  FOREIGN KEY (codigo_espetaculo) REFERENCES espetaculo (codigo),
    CONSTRAINT ck_sessao_numero      CHECK (numero > 0),
    CONSTRAINT ck_sessao_horario     CHECK (REGEXP_LIKE(horario, '^([01][0-9]|2[0-3]):[0-5][0-9]$')),
    CONSTRAINT ck_sessao_vagas       CHECK (vagas_disponiveis >= 0)
);

CREATE TABLE revisao (
    codigo            NUMBER(6)      NOT NULL,
    data              DATE           NOT NULL,
    horario           VARCHAR2(5)    NOT NULL,
    descricao         VARCHAR2(200)  NOT NULL,
    cpf_tecnico       VARCHAR2(11)   NOT NULL,
    codigo_brinquedo  NUMBER(6)      NOT NULL,
    CONSTRAINT pk_revisao            PRIMARY KEY (codigo),
    CONSTRAINT fk_revisao_tecnico    FOREIGN KEY (cpf_tecnico) REFERENCES tecnico (cpf),
    CONSTRAINT fk_revisao_brinquedo  FOREIGN KEY (codigo_brinquedo) REFERENCES brinquedo (codigo),
    CONSTRAINT ck_revisao_horario    CHECK (REGEXP_LIKE(horario, '^([01][0-9]|2[0-3]):[0-5][0-9]$'))
);

CREATE TABLE ingresso (
    numero        NUMBER(8)     NOT NULL,
    data_visita   DATE          NOT NULL,
    local_compra  VARCHAR2(10)  NOT NULL,
    cpf_cliente   VARCHAR2(11)  NOT NULL,   -- Compra (1,1)
    CONSTRAINT pk_ingresso          PRIMARY KEY (numero),
    CONSTRAINT fk_ingresso_cliente  FOREIGN KEY (cpf_cliente) REFERENCES cliente (cpf),
    CONSTRAINT ck_ingresso_local    CHECK (local_compra IN ('Digital', 'Física'))
);


-- ---------------------------------------------------------------------
-- 6) Relacionamentos N:N, auto-relacionamento e ternário
-- ---------------------------------------------------------------------

CREATE TABLE trabalha_em (
    cpf_funcionario  VARCHAR2(11)  NOT NULL,
    nome_area        VARCHAR2(40)  NOT NULL,
    data_inicio      DATE          NOT NULL,
    data_fim         DATE,                     -- nulo = alocação atual
    CONSTRAINT pk_trabalha_em              PRIMARY KEY (cpf_funcionario, nome_area),
    CONSTRAINT fk_trabalha_em_funcionario  FOREIGN KEY (cpf_funcionario) REFERENCES funcionario (cpf),
    CONSTRAINT fk_trabalha_em_area         FOREIGN KEY (nome_area) REFERENCES area (nome),
    CONSTRAINT ck_trabalha_em_datas        CHECK (data_fim IS NULL OR data_fim >= data_inicio)
);

CREATE TABLE usa (
    codigo_revisao  NUMBER(6)     NOT NULL,
    codigo_peca     NUMBER(6)     NOT NULL,
    quantidade_de_pecas NUMBER(4) NOT NULL,
    custo           NUMBER(10,2)  NOT NULL,   -- custo de repor a peça NAQUELA revisão (0 = saiu do estoque)
    CONSTRAINT pk_usa            PRIMARY KEY (codigo_revisao, codigo_peca),
    CONSTRAINT fk_usa_revisao    FOREIGN KEY (codigo_revisao) REFERENCES revisao (codigo),
    CONSTRAINT fk_usa_peca       FOREIGN KEY (codigo_peca) REFERENCES peca (codigo),
    CONSTRAINT ck_usa_quantidade CHECK (quantidade_de_pecas > 0),
    CONSTRAINT ck_usa_custo      CHECK (custo >= 0)
);

CREATE TABLE reserva (
    cpf_cliente        VARCHAR2(11)  NOT NULL,
    codigo_espetaculo  NUMBER(6)     NOT NULL,
    numero_sessao      NUMBER(2)     NOT NULL,
    data_sessao        DATE          NOT NULL,
    quantidade_de_reservas NUMBER(2) NOT NULL,
    CONSTRAINT pk_reserva             PRIMARY KEY (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao),
    CONSTRAINT fk_reserva_cliente     FOREIGN KEY (cpf_cliente) REFERENCES cliente (cpf),
    CONSTRAINT fk_reserva_sessao      FOREIGN KEY (codigo_espetaculo, numero_sessao, data_sessao)
                                      REFERENCES sessao (codigo_espetaculo, numero, data),
    CONSTRAINT ck_reserva_quantidade  CHECK (quantidade_de_reservas > 0)
);

CREATE TABLE se_apresenta_em (
    cpf_artista  VARCHAR2(11)  NOT NULL,
    nome_evento  VARCHAR2(40)  NOT NULL,
    CONSTRAINT pk_se_apresenta_em       PRIMARY KEY (cpf_artista, nome_evento),
    CONSTRAINT fk_se_apresenta_artista  FOREIGN KEY (cpf_artista) REFERENCES artista (cpf),
    CONSTRAINT fk_se_apresenta_evento   FOREIGN KEY (nome_evento) REFERENCES evento (nome)
);

CREATE TABLE mentora (
    cpf_mentor     VARCHAR2(11)  NOT NULL,
    cpf_mentorado  VARCHAR2(11)  NOT NULL,
    CONSTRAINT pk_mentora            PRIMARY KEY (cpf_mentor, cpf_mentorado),
    CONSTRAINT fk_mentora_mentor     FOREIGN KEY (cpf_mentor) REFERENCES funcionario (cpf),
    CONSTRAINT fk_mentora_mentorado  FOREIGN KEY (cpf_mentorado) REFERENCES funcionario (cpf),
    -- ninguém mentora a si mesmo
    CONSTRAINT ck_mentora_distintos  CHECK (cpf_mentor <> cpf_mentorado)
);

CREATE TABLE frequenta (
    cpf_cliente     VARCHAR2(11)  NOT NULL,
    data            DATE          NOT NULL,
    horario_visita  VARCHAR2(5)   NOT NULL,
    cpf_operador    VARCHAR2(11)  NOT NULL,   -- o brinquedo é obtido via OPERADOR (ver AV2, 3FN)
    CONSTRAINT pk_frequenta            PRIMARY KEY (cpf_cliente, data, horario_visita),
    CONSTRAINT fk_frequenta_cliente    FOREIGN KEY (cpf_cliente) REFERENCES cliente (cpf),
    CONSTRAINT fk_frequenta_operador   FOREIGN KEY (cpf_operador) REFERENCES operador (cpf),
    CONSTRAINT ck_frequenta_horario    CHECK (REGEXP_LIKE(horario_visita, '^([01][0-9]|2[0-3]):[0-5][0-9]$'))
);
