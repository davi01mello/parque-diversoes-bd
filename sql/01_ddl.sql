-- =====================================================================
-- 01_ddl.sql
-- Projeto: Parque de Diversões (AV3 - Criação e Povoamento)
-- Banco de Dados - CIn/UFPE
--
-- Script de DDL completo, em 4 partes:
--   1) DROP de todas as tabelas e sequences (reexecução sem erro de duplicação)
--   2) CREATE SEQUENCE
--   3) CREATE TABLE (23 tabelas do Esquema Relacional Normalizado da AV2)
--   4) ALTER TABLE da FK circular OPERADOR <-> BRINQUEDO
--
-- Boas práticas aplicadas:
--   * DROPs no início, na ordem: tabelas sem dependentes -> tabelas com
--     dependentes -> sequences.
--   * Menor tipo de dado que comporta a informação, com margem segura, e
--     tipos nativos (datas em DATE, horários em INTERVAL; nada de texto).
--   * Nomes padronizados (minúsculas, snake_case, tabelas no singular) e
--     constraints nomeadas: pk_ / fk_ / uq_ / ck_ + tabela + coluna.
--
-- Na PRIMEIRA execução, os erros ORA-00942 (tabela inexistente) e
-- ORA-02289 (sequence inexistente) dos DROPs são esperados e inofensivos.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1) DROP: remove tudo para poder reexecutar o script do zero
-- ---------------------------------------------------------------------
-- Ordem: primeiro as tabelas que ninguém referencia, depois as que têm
-- dependentes, e por fim as sequences. OPERADOR e BRINQUEDO se referenciam
-- mutuamente (FK circular); CASCADE CONSTRAINTS resolve esse par.
DROP TABLE frequenta               CASCADE CONSTRAINTS;
DROP TABLE mentora                 CASCADE CONSTRAINTS;
DROP TABLE se_apresenta_em         CASCADE CONSTRAINTS;
DROP TABLE reserva                 CASCADE CONSTRAINTS;
DROP TABLE usa                     CASCADE CONSTRAINTS;
DROP TABLE trabalha_em             CASCADE CONSTRAINTS;
DROP TABLE ingresso                CASCADE CONSTRAINTS;
DROP TABLE revisao                 CASCADE CONSTRAINTS;
DROP TABLE sessao                  CASCADE CONSTRAINTS;
DROP TABLE especialidade_artistica CASCADE CONSTRAINTS;
DROP TABLE telefone_cliente        CASCADE CONSTRAINTS;
DROP TABLE telefone_funcionario    CASCADE CONSTRAINTS;
DROP TABLE espetaculo              CASCADE CONSTRAINTS;
DROP TABLE brinquedo               CASCADE CONSTRAINTS;
DROP TABLE artista                 CASCADE CONSTRAINTS;
DROP TABLE operador                CASCADE CONSTRAINTS;
DROP TABLE tecnico                 CASCADE CONSTRAINTS;
DROP TABLE atracao                 CASCADE CONSTRAINTS;
DROP TABLE evento                  CASCADE CONSTRAINTS;
DROP TABLE peca                    CASCADE CONSTRAINTS;
DROP TABLE cliente                 CASCADE CONSTRAINTS;
DROP TABLE funcionario             CASCADE CONSTRAINTS;
DROP TABLE area                    CASCADE CONSTRAINTS;

DROP SEQUENCE seq_atracao;
DROP SEQUENCE seq_peca;
DROP SEQUENCE seq_revisao;
DROP SEQUENCE seq_ingresso;

-- ---------------------------------------------------------------------
-- 2) CREATE SEQUENCE: chaves geradas pelo sistema
-- ---------------------------------------------------------------------
-- CPF, Nome (Área/Evento) e Número de Sessão NÃO usam sequence: são
-- identificadores naturais ou discriminador de entidade fraca.

-- Código da atração. Brinquedo e Espetáculo herdam o MESMO valor
-- (inserir em ATRACAO com NEXTVAL e no subtipo com CURRVAL).
CREATE SEQUENCE seq_atracao
    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- Código da peça de reposição.
CREATE SEQUENCE seq_peca
    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- Código da revisão (entidade associativa Técnico x Brinquedo).
CREATE SEQUENCE seq_revisao
    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- Número do ingresso.
CREATE SEQUENCE seq_ingresso
    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


-- ---------------------------------------------------------------------
-- 3) CREATE TABLE
-- ---------------------------------------------------------------------
-- Ordem de criação: quem tem FK vem depois de quem ela referencia.
-- Horários: INTERVAL DAY(0) TO SECOND(0) guarda só a hora do dia (o tipo
-- DATE sempre carrega data + hora, e a data já está na coluna 'data').
-- A FK OPERADOR -> BRINQUEDO fica de fora aqui (dependência circular com
-- BRINQUEDO -> OPERADOR) e é adicionada na parte 4.

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
    salario          NUMBER(8,2)  NOT NULL,
    CONSTRAINT pk_funcionario        PRIMARY KEY (cpf),
    CONSTRAINT ck_funcionario_cpf           CHECK (REGEXP_LIKE(cpf, '^[0-9]{11}$')),
    CONSTRAINT ck_funcionario_salario       CHECK (salario > 0),
    -- admitido com pelo menos 18 anos completos (216 meses)
    CONSTRAINT ck_funcionario_admissao      CHECK (ADD_MONTHS(data_nascimento, 216) <= data_admissao)
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
    cache_padrao NUMBER(8,2)  NOT NULL,
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
    velocidade_maxima NUMBER(4,1)   NOT NULL,   -- em km/h
    categoria         VARCHAR2(12)  NOT NULL,
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
    categoria_show     VARCHAR2(12)  NOT NULL,
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
    horario            INTERVAL DAY(0) TO SECOND(0)  NOT NULL,
    vagas_disponiveis  NUMBER(5)    NOT NULL,
    CONSTRAINT pk_sessao             PRIMARY KEY (codigo_espetaculo, numero, data),
    CONSTRAINT fk_sessao_espetaculo  FOREIGN KEY (codigo_espetaculo) REFERENCES espetaculo (codigo),
    CONSTRAINT ck_sessao_numero      CHECK (numero > 0),
    CONSTRAINT ck_sessao_horario     CHECK (horario >= INTERVAL '00:00' HOUR TO MINUTE),
    CONSTRAINT ck_sessao_vagas       CHECK (vagas_disponiveis >= 0)
);

CREATE TABLE revisao (
    codigo            NUMBER(6)      NOT NULL,
    data              DATE           NOT NULL,
    horario           INTERVAL DAY(0) TO SECOND(0)  NOT NULL,
    descricao         VARCHAR2(200)  NOT NULL,
    cpf_tecnico       VARCHAR2(11)   NOT NULL,
    codigo_brinquedo  NUMBER(6)      NOT NULL,
    CONSTRAINT pk_revisao            PRIMARY KEY (codigo),
    CONSTRAINT fk_revisao_tecnico    FOREIGN KEY (cpf_tecnico) REFERENCES tecnico (cpf),
    CONSTRAINT fk_revisao_brinquedo  FOREIGN KEY (codigo_brinquedo) REFERENCES brinquedo (codigo),
    CONSTRAINT ck_revisao_horario    CHECK (horario >= INTERVAL '00:00' HOUR TO MINUTE)
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
    custo           NUMBER(8,2)  NOT NULL,   -- custo de repor a peça NAQUELA revisão (0 = saiu do estoque)
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
    horario_visita  INTERVAL DAY(0) TO SECOND(0)  NOT NULL,
    cpf_operador    VARCHAR2(11)  NOT NULL,   -- o brinquedo é obtido via OPERADOR (ver AV2, 3FN)
    CONSTRAINT pk_frequenta            PRIMARY KEY (cpf_cliente, data, horario_visita),
    CONSTRAINT fk_frequenta_cliente    FOREIGN KEY (cpf_cliente) REFERENCES cliente (cpf),
    CONSTRAINT fk_frequenta_operador   FOREIGN KEY (cpf_operador) REFERENCES operador (cpf),
    CONSTRAINT ck_frequenta_horario    CHECK (horario_visita >= INTERVAL '00:00' HOUR TO MINUTE)
);


-- ---------------------------------------------------------------------
-- 4) ALTER TABLE: FK circular
-- ---------------------------------------------------------------------
-- BRINQUEDO.cpf_gerente           -> OPERADOR.cpf     (Gerencia)
-- OPERADOR.codigo_brinquedo_opera -> BRINQUEDO.codigo (Opera)
-- Nenhuma das duas tabelas pode nascer com as duas FKs. OPERADOR é criada
-- sem a FK de brinquedo, que entra aqui, depois que BRINQUEDO existe.

ALTER TABLE operador
    ADD CONSTRAINT fk_operador_brinquedo
    FOREIGN KEY (codigo_brinquedo_opera) REFERENCES brinquedo (codigo);
