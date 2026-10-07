-- =====================================================================
-- 02_povoamento.sql
-- Projeto: Parque de Diversões (AV3 - Criação e Povoamento)
--
-- Povoamento coerente com as regras do minimundo. Dados fictícios:
-- os CPFs têm dígito verificador válido, mas não pertencem a pessoas reais.
--
-- PRÉ-REQUISITO: executar 01_ddl.sql antes (ele já recria tudo do zero).
-- As sequences começam em 1; os códigos citados nos comentários
-- (atração 1..13, peça 1..10, revisão 1..16) dependem disso.
--
-- Ordem: respeita as FKs. OPERADOR é inserido sem brinquedo e atualizado
-- (UPDATE) depois que BRINQUEDO existe (dependência circular, ver 03).
-- =====================================================================

-- ---------------------------------------------------------------------
-- ÁREA (5)
-- ---------------------------------------------------------------------
INSERT INTO area (nome, tema, tamanho_m2)
    VALUES ('Zona Medieval', 'Idade Média e fantasia', 12000);
INSERT INTO area (nome, tema, tamanho_m2)
    VALUES ('Zona Espacial', 'Exploração espacial', 15000);
INSERT INTO area (nome, tema, tamanho_m2)
    VALUES ('Zona Aquática', 'Aventura aquática', 10000);
INSERT INTO area (nome, tema, tamanho_m2)
    VALUES ('Zona Infantil', 'Diversão para crianças', 8000);
INSERT INTO area (nome, tema, tamanho_m2)
    VALUES ('Praça dos Shows', 'Espetáculos ao vivo', 6000);

-- ---------------------------------------------------------------------
-- FUNCIONÁRIO (22) - 5 técnicos, 12 operadores, 5 artistas
-- ---------------------------------------------------------------------
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('08289064594', 'Rafael', 'Albuquerque Nunes', TO_DATE('1985-06-18', 'YYYY-MM-DD'), TO_DATE('2018-03-12', 'YYYY-MM-DD'), 4200.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('78557830408', 'Camila', 'Nogueira Prado', TO_DATE('1990-11-02', 'YYYY-MM-DD'), TO_DATE('2019-07-01', 'YYYY-MM-DD'), 4000.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('34019575118', 'Marcos Vinícius', 'Teixeira Lima', TO_DATE('1988-02-25', 'YYYY-MM-DD'), TO_DATE('2020-02-17', 'YYYY-MM-DD'), 3800.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('47389777680', 'Letícia', 'Barbosa Reis', TO_DATE('1996-08-30', 'YYYY-MM-DD'), TO_DATE('2022-05-09', 'YYYY-MM-DD'), 3300.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('74082869697', 'José Carlos', 'Menezes Filho', TO_DATE('1982-01-09', 'YYYY-MM-DD'), TO_DATE('2017-04-03', 'YYYY-MM-DD'), 3900.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('18427896867', 'Ana Beatriz', 'Souza Cardoso', TO_DATE('1993-04-21', 'YYYY-MM-DD'), TO_DATE('2019-01-14', 'YYYY-MM-DD'), 3100.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('31073946100', 'Pedro Henrique', 'Lima Barreto', TO_DATE('1986-12-12', 'YYYY-MM-DD'), TO_DATE('2018-09-10', 'YYYY-MM-DD'), 5300.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('27200463612', 'Larissa', 'Cavalcanti Mota', TO_DATE('1995-07-07', 'YYYY-MM-DD'), TO_DATE('2020-06-22', 'YYYY-MM-DD'), 3000.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('89597373564', 'Thiago', 'Ribeiro Falcão', TO_DATE('1994-03-16', 'YYYY-MM-DD'), TO_DATE('2021-01-11', 'YYYY-MM-DD'), 2900.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('08469019350', 'Mariana', 'Ferreira Lacerda', TO_DATE('1999-10-05', 'YYYY-MM-DD'), TO_DATE('2023-03-06', 'YYYY-MM-DD'), 2600.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('75658024099', 'Gustavo', 'Araújo Pessoa', TO_DATE('1991-05-29', 'YYYY-MM-DD'), TO_DATE('2019-11-25', 'YYYY-MM-DD'), 3000.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('14931820999', 'Juliana', 'Pereira Gouveia', TO_DATE('2001-09-14', 'YYYY-MM-DD'), TO_DATE('2024-02-05', 'YYYY-MM-DD'), 2500.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('80451081340', 'Bruno', 'Carvalho Dias', TO_DATE('2002-01-28', 'YYYY-MM-DD'), TO_DATE('2024-08-19', 'YYYY-MM-DD'), 2400.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('94831189057', 'Fernanda', 'Duarte Campos', TO_DATE('1997-06-03', 'YYYY-MM-DD'), TO_DATE('2022-10-03', 'YYYY-MM-DD'), 2800.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('84057617647', 'Ricardo', 'Tavares Brandão', TO_DATE('1978-08-11', 'YYYY-MM-DD'), TO_DATE('2015-02-02', 'YYYY-MM-DD'), 5800.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('66572706583', 'Patrícia', 'Mendonça Vieira', TO_DATE('1987-02-19', 'YYYY-MM-DD'), TO_DATE('2016-06-13', 'YYYY-MM-DD'), 5400.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('34517212793', 'Diego', 'Santana Freire', TO_DATE('1992-09-23', 'YYYY-MM-DD'), TO_DATE('2021-04-05', 'YYYY-MM-DD'), 3200.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('99146944621', 'Beatriz', 'Montenegro Alves', TO_DATE('1989-12-30', 'YYYY-MM-DD'), TO_DATE('2016-08-01', 'YYYY-MM-DD'), 5000.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('52009029917', 'Otávio', 'Rangel Siqueira', TO_DATE('1984-03-08', 'YYYY-MM-DD'), TO_DATE('2017-10-16', 'YYYY-MM-DD'), 4500.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('31956646078', 'Isadora', 'Villar Bezerra', TO_DATE('1998-11-17', 'YYYY-MM-DD'), TO_DATE('2023-07-10', 'YYYY-MM-DD'), 4100.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('23353768963', 'Caio', 'Fontes Medeiros', TO_DATE('1995-02-14', 'YYYY-MM-DD'), TO_DATE('2022-01-31', 'YYYY-MM-DD'), 3600.00);
INSERT INTO funcionario (cpf, primeiro_nome, sobrenome, data_nascimento, data_admissao, salario)
    VALUES ('31631553160', 'Henrique', 'Gouveia Lins', TO_DATE('1994-05-20', 'YYYY-MM-DD'), TO_DATE('2023-09-04', 'YYYY-MM-DD'), 3500.00);

-- ---------------------------------------------------------------------
-- TELEFONE_FUNCIONARIO
-- ---------------------------------------------------------------------
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('08289064594', '81924886242');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('78557830408', '81932929187');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('34019575118', '81925694124');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('47389777680', '81919865167');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('74082869697', '81928611622');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('18427896867', '81961694073');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('31073946100', '81955172097');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('27200463612', '81954744269');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('89597373564', '81904812654');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('08469019350', '81980924094');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('75658024099', '81905737441');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('75658024099', '81922680571');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('14931820999', '81929632831');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('14931820999', '81935108298');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('80451081340', '81999680464');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('94831189057', '81901040976');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('84057617647', '81979602982');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('66572706583', '81904985101');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('66572706583', '81930040923');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('34517212793', '81998734790');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('99146944621', '81975589394');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('52009029917', '81923212598');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('52009029917', '81928440777');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('31956646078', '81990560468');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('31956646078', '81922872761');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('23353768963', '81967062573');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('31631553160', '81990269117');
INSERT INTO telefone_funcionario (cpf_funcionario, telefone)
    VALUES ('31631553160', '81914907238');

-- ---------------------------------------------------------------------
-- TECNICO (5)
-- ---------------------------------------------------------------------
INSERT INTO tecnico (cpf, especialidade)
    VALUES ('08289064594', 'Mecânica');
INSERT INTO tecnico (cpf, especialidade)
    VALUES ('78557830408', 'Elétrica');
INSERT INTO tecnico (cpf, especialidade)
    VALUES ('34019575118', 'Hidráulica');
INSERT INTO tecnico (cpf, especialidade)
    VALUES ('47389777680', 'Estrutural');
INSERT INTO tecnico (cpf, especialidade)
    VALUES ('31631553160', 'Pneumática');

-- ---------------------------------------------------------------------
-- OPERADOR (12) - codigo_brinquedo_opera entra NULL; ver UPDATE mais abaixo
-- ---------------------------------------------------------------------
INSERT INTO operador (cpf, nivel_certificacao, codigo_brinquedo_opera)
    VALUES ('74082869697', 3, NULL);
INSERT INTO operador (cpf, nivel_certificacao, codigo_brinquedo_opera)
    VALUES ('18427896867', 2, NULL);
INSERT INTO operador (cpf, nivel_certificacao, codigo_brinquedo_opera)
    VALUES ('31073946100', 3, NULL);
INSERT INTO operador (cpf, nivel_certificacao, codigo_brinquedo_opera)
    VALUES ('27200463612', 2, NULL);
INSERT INTO operador (cpf, nivel_certificacao, codigo_brinquedo_opera)
    VALUES ('89597373564', 2, NULL);
INSERT INTO operador (cpf, nivel_certificacao, codigo_brinquedo_opera)
    VALUES ('08469019350', 1, NULL);
INSERT INTO operador (cpf, nivel_certificacao, codigo_brinquedo_opera)
    VALUES ('75658024099', 2, NULL);
INSERT INTO operador (cpf, nivel_certificacao, codigo_brinquedo_opera)
    VALUES ('14931820999', 1, NULL);
INSERT INTO operador (cpf, nivel_certificacao, codigo_brinquedo_opera)
    VALUES ('80451081340', 1, NULL);
INSERT INTO operador (cpf, nivel_certificacao, codigo_brinquedo_opera)
    VALUES ('94831189057', 2, NULL);
INSERT INTO operador (cpf, nivel_certificacao, codigo_brinquedo_opera)
    VALUES ('84057617647', 3, NULL);
INSERT INTO operador (cpf, nivel_certificacao, codigo_brinquedo_opera)
    VALUES ('66572706583', 3, NULL);

-- ---------------------------------------------------------------------
-- ARTISTA (5) e ESPECIALIDADE_ARTISTICA (multivalorado)
-- ---------------------------------------------------------------------
INSERT INTO artista (cpf, cache_padrao)
    VALUES ('34517212793', 800.00);
INSERT INTO artista (cpf, cache_padrao)
    VALUES ('99146944621', 1500.00);
INSERT INTO artista (cpf, cache_padrao)
    VALUES ('52009029917', 1200.00);
INSERT INTO artista (cpf, cache_padrao)
    VALUES ('31956646078', 1800.00);
INSERT INTO artista (cpf, cache_padrao)
    VALUES ('23353768963', 1000.00);
INSERT INTO especialidade_artistica (cpf_artista, especialidade)
    VALUES ('34517212793', 'Palhaço');
INSERT INTO especialidade_artistica (cpf_artista, especialidade)
    VALUES ('34517212793', 'Malabarista');
INSERT INTO especialidade_artistica (cpf_artista, especialidade)
    VALUES ('99146944621', 'Cantora');
INSERT INTO especialidade_artistica (cpf_artista, especialidade)
    VALUES ('99146944621', 'Atriz');
INSERT INTO especialidade_artistica (cpf_artista, especialidade)
    VALUES ('52009029917', 'Mágico');
INSERT INTO especialidade_artistica (cpf_artista, especialidade)
    VALUES ('52009029917', 'Ilusionista');
INSERT INTO especialidade_artistica (cpf_artista, especialidade)
    VALUES ('52009029917', 'Mímico');
INSERT INTO especialidade_artistica (cpf_artista, especialidade)
    VALUES ('31956646078', 'Acrobata');
INSERT INTO especialidade_artistica (cpf_artista, especialidade)
    VALUES ('31956646078', 'Trapezista');
INSERT INTO especialidade_artistica (cpf_artista, especialidade)
    VALUES ('31956646078', 'Motociclista de globo');
INSERT INTO especialidade_artistica (cpf_artista, especialidade)
    VALUES ('23353768963', 'Ator');
INSERT INTO especialidade_artistica (cpf_artista, especialidade)
    VALUES ('23353768963', 'Espadachim');

-- ---------------------------------------------------------------------
-- ATRAÇÃO + subtipo (8 brinquedos e 5 espetáculos)
-- Cada atração recebe seq_atracao.NEXTVAL; o subtipo reutiliza o MESMO valor via CURRVAL.
-- Gerente só nos brinquedos de alta capacidade (>= 24 lugares), na mesma área do brinquedo:
--   1 -> Ricardo (só administra, não opera), 3 -> Pedro (também opera),
--   4 -> Fernanda (opera outro brinquedo, o 3), 7 -> Gustavo e 8 -> Juliana (também operam).
-- Os brinquedos 2, 5 e 6 (capacidade < 24) ficam sem gerente.
-- ---------------------------------------------------------------------
-- código 1
INSERT INTO atracao (codigo, nome, capacidade, nome_area)
    VALUES (seq_atracao.NEXTVAL, 'Dragão de Fogo', 24, 'Zona Medieval');
INSERT INTO brinquedo (codigo, restricao_altura, velocidade_maxima, categoria, cpf_gerente)
    VALUES (seq_atracao.CURRVAL, 140, 85.0, 'Radical', '84057617647');
-- código 2
INSERT INTO atracao (codigo, nome, capacidade, nome_area)
    VALUES (seq_atracao.NEXTVAL, 'Torre do Castelo', 20, 'Zona Medieval');
INSERT INTO brinquedo (codigo, restricao_altura, velocidade_maxima, categoria, cpf_gerente)
    VALUES (seq_atracao.CURRVAL, 130, 70.0, 'Radical', NULL);
-- código 3
INSERT INTO atracao (codigo, nome, capacidade, nome_area)
    VALUES (seq_atracao.NEXTVAL, 'Foguete Órion', 28, 'Zona Espacial');
INSERT INTO brinquedo (codigo, restricao_altura, velocidade_maxima, categoria, cpf_gerente)
    VALUES (seq_atracao.CURRVAL, 140, 95.0, 'Radical', '31073946100');
-- código 4
INSERT INTO atracao (codigo, nome, capacidade, nome_area)
    VALUES (seq_atracao.NEXTVAL, 'Órbita Galáctica', 30, 'Zona Espacial');
INSERT INTO brinquedo (codigo, restricao_altura, velocidade_maxima, categoria, cpf_gerente)
    VALUES (seq_atracao.CURRVAL, 120, 60.0, 'Radical', '94831189057');
-- código 5
INSERT INTO atracao (codigo, nome, capacidade, nome_area)
    VALUES (seq_atracao.NEXTVAL, 'Tobogã Tsunami', 16, 'Zona Aquática');
INSERT INTO brinquedo (codigo, restricao_altura, velocidade_maxima, categoria, cpf_gerente)
    VALUES (seq_atracao.CURRVAL, 110, 45.0, 'Aquático', NULL);
-- código 6
INSERT INTO atracao (codigo, nome, capacidade, nome_area)
    VALUES (seq_atracao.NEXTVAL, 'Rio Selvagem', 12, 'Zona Aquática');
INSERT INTO brinquedo (codigo, restricao_altura, velocidade_maxima, categoria, cpf_gerente)
    VALUES (seq_atracao.CURRVAL, 100, 30.0, 'Aquático', NULL);
-- código 7
INSERT INTO atracao (codigo, nome, capacidade, nome_area)
    VALUES (seq_atracao.NEXTVAL, 'Carrossel Encantado', 40, 'Zona Infantil');
INSERT INTO brinquedo (codigo, restricao_altura, velocidade_maxima, categoria, cpf_gerente)
    VALUES (seq_atracao.CURRVAL, 0, 10.0, 'Infantil', '75658024099');
-- código 8
INSERT INTO atracao (codigo, nome, capacidade, nome_area)
    VALUES (seq_atracao.NEXTVAL, 'Trenzinho Mágico', 30, 'Zona Infantil');
INSERT INTO brinquedo (codigo, restricao_altura, velocidade_maxima, categoria, cpf_gerente)
    VALUES (seq_atracao.CURRVAL, 0, 15.0, 'Infantil', '14931820999');
-- código 9
INSERT INTO atracao (codigo, nome, capacidade, nome_area)
    VALUES (seq_atracao.NEXTVAL, 'Torneio dos Cavaleiros', 300, 'Zona Medieval');
INSERT INTO espetaculo (codigo, duracao, categoria_show, capacidade_plateia)
    VALUES (seq_atracao.CURRVAL, 45, 'Teatral', 300);
-- código 10
INSERT INTO atracao (codigo, nome, capacidade, nome_area)
    VALUES (seq_atracao.NEXTVAL, 'Odisseia Estelar', 250, 'Zona Espacial');
INSERT INTO espetaculo (codigo, duracao, categoria_show, capacidade_plateia)
    VALUES (seq_atracao.CURRVAL, 50, 'Musical', 250);
-- código 11
INSERT INTO atracao (codigo, nome, capacidade, nome_area)
    VALUES (seq_atracao.NEXTVAL, 'Circo das Estrelas', 400, 'Praça dos Shows');
INSERT INTO espetaculo (codigo, duracao, categoria_show, capacidade_plateia)
    VALUES (seq_atracao.CURRVAL, 60, 'Circense', 400);
-- código 12
INSERT INTO atracao (codigo, nome, capacidade, nome_area)
    VALUES (seq_atracao.NEXTVAL, 'Gala Musical do Parque', 500, 'Praça dos Shows');
INSERT INTO espetaculo (codigo, duracao, categoria_show, capacidade_plateia)
    VALUES (seq_atracao.CURRVAL, 40, 'Musical', 500);
-- código 13
INSERT INTO atracao (codigo, nome, capacidade, nome_area)
    VALUES (seq_atracao.NEXTVAL, 'Teatro de Fantoches', 120, 'Zona Infantil');
INSERT INTO espetaculo (codigo, duracao, categoria_show, capacidade_plateia)
    VALUES (seq_atracao.CURRVAL, 30, 'Teatral', 120);

-- ---------------------------------------------------------------------
-- OPERADOR -> BRINQUEDO (relacionamento Opera): agora que BRINQUEDO existe
-- ---------------------------------------------------------------------
UPDATE operador SET codigo_brinquedo_opera = 1 WHERE cpf = '74082869697';
UPDATE operador SET codigo_brinquedo_opera = 2 WHERE cpf = '18427896867';
UPDATE operador SET codigo_brinquedo_opera = 3 WHERE cpf = '31073946100';
UPDATE operador SET codigo_brinquedo_opera = 4 WHERE cpf = '27200463612';
UPDATE operador SET codigo_brinquedo_opera = 5 WHERE cpf = '89597373564';
UPDATE operador SET codigo_brinquedo_opera = 6 WHERE cpf = '08469019350';
UPDATE operador SET codigo_brinquedo_opera = 7 WHERE cpf = '75658024099';
UPDATE operador SET codigo_brinquedo_opera = 8 WHERE cpf = '14931820999';
UPDATE operador SET codigo_brinquedo_opera = 1 WHERE cpf = '80451081340';
UPDATE operador SET codigo_brinquedo_opera = 3 WHERE cpf = '94831189057';
UPDATE operador SET codigo_brinquedo_opera = 5 WHERE cpf = '66572706583';
-- Ricardo Tavares (administrativo) gerencia o brinquedo 1 e não opera nenhum:
-- por isso codigo_brinquedo_opera permanece NULL para ele.

-- ---------------------------------------------------------------------
-- CLIENTE (12)
-- ---------------------------------------------------------------------
INSERT INTO cliente (cpf, primeiro_nome, sobrenome, rua, numero, bairro, cidade, cep, email)
    VALUES ('97565733334', 'Lucas Gabriel', 'Almeida Pereira', 'Rua do Hospício', '120', 'Boa Vista', 'Recife', '50050050', 'lucas.almeida@email.com');
INSERT INTO cliente (cpf, primeiro_nome, sobrenome, rua, numero, bairro, cidade, cep, email)
    VALUES ('81816089419', 'Mariana', 'Costa Lima', 'Av. Conselheiro Aguiar', '2450', 'Boa Viagem', 'Recife', '51020020', 'mariana.costa@email.com');
INSERT INTO cliente (cpf, primeiro_nome, sobrenome, rua, numero, bairro, cidade, cep, email)
    VALUES ('70257605878', 'Rafael', 'Monteiro Silva', 'Rua Real da Torre', '801', 'Madalena', 'Recife', '50610000', 'rafael.monteiro@email.com');
INSERT INTO cliente (cpf, primeiro_nome, sobrenome, rua, numero, bairro, cidade, cep, email)
    VALUES ('28911860107', 'Ana Clara', 'Barros Neves', 'Estrada do Encanamento', '55', 'Casa Forte', 'Recife', '52070000', 'anaclara.barros@email.com');
INSERT INTO cliente (cpf, primeiro_nome, sobrenome, rua, numero, bairro, cidade, cep, email)
    VALUES ('62279786710', 'Felipe', 'Santos Araújo', 'Rua da Aurora', '310', 'Santo Amaro', 'Recife', '50040000', 'felipe.santos@email.com');
INSERT INTO cliente (cpf, primeiro_nome, sobrenome, rua, numero, bairro, cidade, cep, email)
    VALUES ('28028765467', 'Beatriz', 'Oliveira Gomes', 'Av. Caxangá', '1900', 'Cordeiro', 'Recife', '50711000', 'beatriz.oliveira@email.com');
INSERT INTO cliente (cpf, primeiro_nome, sobrenome, rua, numero, bairro, cidade, cep, email)
    VALUES ('13393065815', 'Eduardo', 'Cavalcanti Rocha', 'Rua Padre Carapuceiro', '700', 'Boa Viagem', 'Recife', '51020280', 'eduardo.cavalcanti@email.com');
INSERT INTO cliente (cpf, primeiro_nome, sobrenome, rua, numero, bairro, cidade, cep, email)
    VALUES ('50154817139', 'Camila', 'Ferraz Lins', 'Av. Beberibe', '4100', 'Beberibe', 'Recife', '52110000', 'camila.ferraz@email.com');
INSERT INTO cliente (cpf, primeiro_nome, sobrenome, rua, numero, bairro, cidade, cep, email)
    VALUES ('37413521016', 'Henrique', 'Matos Dantas', 'Rua do Futuro', '90', 'Graças', 'Recife', '52050000', 'henrique.matos@email.com');
INSERT INTO cliente (cpf, primeiro_nome, sobrenome, rua, numero, bairro, cidade, cep, email)
    VALUES ('47202606674', 'Isabela', 'Nunes Pires', 'Av. Presidente Kennedy', '1200', 'Piedade', 'Jaboatão dos Guararapes', '54400000', 'isabela.nunes@email.com');
INSERT INTO cliente (cpf, primeiro_nome, sobrenome, rua, numero, bairro, cidade, cep, email)
    VALUES ('94571710550', 'João Pedro', 'Xavier Brito', 'Rua Direita', '45', 'Centro', 'Olinda', '53020000', 'joaopedro.xavier@email.com');
INSERT INTO cliente (cpf, primeiro_nome, sobrenome, rua, numero, bairro, cidade, cep, email)
    VALUES ('06537026555', 'Larissa', 'Tenório Vasconcelos', 'Av. Dantas Barreto', '620', 'São José', 'Recife', '50020000', 'larissa.tenorio@email.com');

-- ---------------------------------------------------------------------
-- TELEFONE_CLIENTE
-- ---------------------------------------------------------------------
INSERT INTO telefone_cliente (cpf_cliente, telefone)
    VALUES ('97565733334', '81912281270');
INSERT INTO telefone_cliente (cpf_cliente, telefone)
    VALUES ('81816089419', '81952198413');
INSERT INTO telefone_cliente (cpf_cliente, telefone)
    VALUES ('81816089419', '81946216160');
INSERT INTO telefone_cliente (cpf_cliente, telefone)
    VALUES ('70257605878', '81997198600');
INSERT INTO telefone_cliente (cpf_cliente, telefone)
    VALUES ('28911860107', '81958569735');
INSERT INTO telefone_cliente (cpf_cliente, telefone)
    VALUES ('28911860107', '81913359451');
INSERT INTO telefone_cliente (cpf_cliente, telefone)
    VALUES ('62279786710', '81976549257');
INSERT INTO telefone_cliente (cpf_cliente, telefone)
    VALUES ('28028765467', '81993291286');
INSERT INTO telefone_cliente (cpf_cliente, telefone)
    VALUES ('13393065815', '81965376750');
INSERT INTO telefone_cliente (cpf_cliente, telefone)
    VALUES ('50154817139', '81941967860');
INSERT INTO telefone_cliente (cpf_cliente, telefone)
    VALUES ('37413521016', '81997573849');
INSERT INTO telefone_cliente (cpf_cliente, telefone)
    VALUES ('37413521016', '81926712740');
INSERT INTO telefone_cliente (cpf_cliente, telefone)
    VALUES ('47202606674', '81998780612');
INSERT INTO telefone_cliente (cpf_cliente, telefone)
    VALUES ('94571710550', '81977109376');
INSERT INTO telefone_cliente (cpf_cliente, telefone)
    VALUES ('94571710550', '81998522425');
INSERT INTO telefone_cliente (cpf_cliente, telefone)
    VALUES ('06537026555', '81922381992');

-- ---------------------------------------------------------------------
-- PEÇA (10) - código via seq_peca (1..10)
-- ---------------------------------------------------------------------
-- código 1
INSERT INTO peca (codigo, nome, fabricante, estoque_atual)
    VALUES (seq_peca.NEXTVAL, 'Rolamento de esferas 6205', 'SKF', 40);
-- código 2
INSERT INTO peca (codigo, nome, fabricante, estoque_atual)
    VALUES (seq_peca.NEXTVAL, 'Correia dentada trapezoidal', 'Gates', 18);
-- código 3
INSERT INTO peca (codigo, nome, fabricante, estoque_atual)
    VALUES (seq_peca.NEXTVAL, 'Cabo de aço 12mm (rolo 50m)', 'Belgo', 6);
-- código 4
INSERT INTO peca (codigo, nome, fabricante, estoque_atual)
    VALUES (seq_peca.NEXTVAL, 'Motor elétrico trifásico 15cv', 'WEG', 3);
-- código 5
INSERT INTO peca (codigo, nome, fabricante, estoque_atual)
    VALUES (seq_peca.NEXTVAL, 'Sensor de proximidade indutivo', 'Siemens', 25);
-- código 6
INSERT INTO peca (codigo, nome, fabricante, estoque_atual)
    VALUES (seq_peca.NEXTVAL, 'Trava de segurança hidráulica', 'Parker', 12);
-- código 7
INSERT INTO peca (codigo, nome, fabricante, estoque_atual)
    VALUES (seq_peca.NEXTVAL, 'Painel de comando CLP', 'Schneider', 4);
-- código 8
INSERT INTO peca (codigo, nome, fabricante, estoque_atual)
    VALUES (seq_peca.NEXTVAL, 'Bomba d''água centrífuga 5cv', 'KSB', 5);
-- código 9
INSERT INTO peca (codigo, nome, fabricante, estoque_atual)
    VALUES (seq_peca.NEXTVAL, 'Kit cinto de segurança de carrinho', 'Sparco', 30);
-- código 10
INSERT INTO peca (codigo, nome, fabricante, estoque_atual)
    VALUES (seq_peca.NEXTVAL, 'Refletor LED 200W', 'Philips', 60);

-- ---------------------------------------------------------------------
-- EVENTO (6)
-- ---------------------------------------------------------------------
INSERT INTO evento (nome, data_inicio, data_termino, descricao)
    VALUES ('Palhaço Comediante', TO_DATE('2026-09-01', 'YYYY-MM-DD'), TO_DATE('2026-09-30', 'YYYY-MM-DD'), 'Esquetes de humor e malabarismo circulando pelas áreas e filas do parque.');
INSERT INTO evento (nome, data_inicio, data_termino, descricao)
    VALUES ('Pirotecnia Noturna', TO_DATE('2026-09-05', 'YYYY-MM-DD'), TO_DATE('2026-09-20', 'YYYY-MM-DD'), 'Show de fogos sincronizado com música e performance aérea, nos fins de semana.');
INSERT INTO evento (nome, data_inicio, data_termino, descricao)
    VALUES ('Globo da Morte', TO_DATE('2026-09-12', 'YYYY-MM-DD'), TO_DATE('2026-09-13', 'YYYY-MM-DD'), 'Apresentação de acrobacia radical de motos dentro do globo de aço.');
INSERT INTO evento (nome, data_inicio, data_termino, descricao)
    VALUES ('Parada Medieval', TO_DATE('2026-09-01', 'YYYY-MM-DD'), TO_DATE('2026-09-30', 'YYYY-MM-DD'), 'Desfile de cavaleiros, arautos e músicos pela Zona Medieval.');
INSERT INTO evento (nome, data_inicio, data_termino, descricao)
    VALUES ('Mágico Itinerante', TO_DATE('2026-08-15', 'YYYY-MM-DD'), TO_DATE('2026-09-27', 'YYYY-MM-DD'), 'Truques de mágica e ilusionismo próximos às praças de alimentação.');
INSERT INTO evento (nome, data_inicio, data_termino, descricao)
    VALUES ('Bolhas Gigantes', TO_DATE('2026-09-06', 'YYYY-MM-DD'), TO_DATE('2026-09-20', 'YYYY-MM-DD'), 'Show de bolhas de sabão gigantes para o público infantil.');

-- ---------------------------------------------------------------------
-- SESSÃO (18) - entidade fraca de ESPETÁCULO; vagas = plateia - reservas - demais ocupações
-- ---------------------------------------------------------------------
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (9, 1, TO_DATE('2026-09-05', 'YYYY-MM-DD'), INTERVAL '11:00' HOUR TO MINUTE, 180);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (9, 2, TO_DATE('2026-09-05', 'YYYY-MM-DD'), INTERVAL '15:00' HOUR TO MINUTE, 150);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (9, 1, TO_DATE('2026-09-06', 'YYYY-MM-DD'), INTERVAL '11:00' HOUR TO MINUTE, 120);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (9, 1, TO_DATE('2026-09-12', 'YYYY-MM-DD'), INTERVAL '11:00' HOUR TO MINUTE, 160);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (9, 2, TO_DATE('2026-09-12', 'YYYY-MM-DD'), INTERVAL '15:00' HOUR TO MINUTE, 116);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (10, 1, TO_DATE('2026-09-05', 'YYYY-MM-DD'), INTERVAL '19:00' HOUR TO MINUTE, 88);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (10, 1, TO_DATE('2026-09-06', 'YYYY-MM-DD'), INTERVAL '19:00' HOUR TO MINUTE, 141);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (10, 1, TO_DATE('2026-09-13', 'YYYY-MM-DD'), INTERVAL '19:00' HOUR TO MINUTE, 150);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (11, 1, TO_DATE('2026-09-05', 'YYYY-MM-DD'), INTERVAL '14:00' HOUR TO MINUTE, 154);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (11, 2, TO_DATE('2026-09-05', 'YYYY-MM-DD'), INTERVAL '17:00' HOUR TO MINUTE, 254);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (11, 1, TO_DATE('2026-09-12', 'YYYY-MM-DD'), INTERVAL '14:00' HOUR TO MINUTE, 264);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (11, 1, TO_DATE('2026-09-19', 'YYYY-MM-DD'), INTERVAL '14:00' HOUR TO MINUTE, 165);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (12, 1, TO_DATE('2026-09-06', 'YYYY-MM-DD'), INTERVAL '20:00' HOUR TO MINUTE, 243);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (12, 1, TO_DATE('2026-09-13', 'YYYY-MM-DD'), INTERVAL '20:00' HOUR TO MINUTE, 211);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (12, 1, TO_DATE('2026-09-20', 'YYYY-MM-DD'), INTERVAL '20:00' HOUR TO MINUTE, 330);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (13, 1, TO_DATE('2026-09-06', 'YYYY-MM-DD'), INTERVAL '10:30' HOUR TO MINUTE, 70);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (13, 1, TO_DATE('2026-09-13', 'YYYY-MM-DD'), INTERVAL '10:30' HOUR TO MINUTE, 49);
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    VALUES (13, 2, TO_DATE('2026-09-13', 'YYYY-MM-DD'), INTERVAL '14:30' HOUR TO MINUTE, 47);

-- ---------------------------------------------------------------------
-- REVISÃO (16) - 2 por brinquedo, todos os técnicos participam (código via seq_revisao)
-- ---------------------------------------------------------------------
-- revisão 1
INSERT INTO revisao (codigo, data, horario, descricao, cpf_tecnico, codigo_brinquedo)
    VALUES (seq_revisao.NEXTVAL, TO_DATE('2026-06-08', 'YYYY-MM-DD'), INTERVAL '08:00' HOUR TO MINUTE, 'Revisão do painel de comando e dos sensores de segurança', '78557830408', 1);
-- revisão 2
INSERT INTO revisao (codigo, data, horario, descricao, cpf_tecnico, codigo_brinquedo)
    VALUES (seq_revisao.NEXTVAL, TO_DATE('2026-08-10', 'YYYY-MM-DD'), INTERVAL '08:00' HOUR TO MINUTE, 'Verificação de bombas, vedações e travas hidráulicas', '34019575118', 1);
-- revisão 3
INSERT INTO revisao (codigo, data, horario, descricao, cpf_tecnico, codigo_brinquedo)
    VALUES (seq_revisao.NEXTVAL, TO_DATE('2026-06-15', 'YYYY-MM-DD'), INTERVAL '07:30' HOUR TO MINUTE, 'Verificação de bombas, vedações e travas hidráulicas', '34019575118', 2);
-- revisão 4
INSERT INTO revisao (codigo, data, horario, descricao, cpf_tecnico, codigo_brinquedo)
    VALUES (seq_revisao.NEXTVAL, TO_DATE('2026-08-17', 'YYYY-MM-DD'), INTERVAL '07:00' HOUR TO MINUTE, 'Inspeção estrutural e reaperto de fixações', '47389777680', 2);
-- revisão 5
INSERT INTO revisao (codigo, data, horario, descricao, cpf_tecnico, codigo_brinquedo)
    VALUES (seq_revisao.NEXTVAL, TO_DATE('2026-06-22', 'YYYY-MM-DD'), INTERVAL '07:00' HOUR TO MINUTE, 'Inspeção estrutural e reaperto de fixações', '47389777680', 3);
-- revisão 6
INSERT INTO revisao (codigo, data, horario, descricao, cpf_tecnico, codigo_brinquedo)
    VALUES (seq_revisao.NEXTVAL, TO_DATE('2026-08-24', 'YYYY-MM-DD'), INTERVAL '08:00' HOUR TO MINUTE, 'Inspeção do sistema pneumático e das portas de acesso', '31631553160', 3);
-- revisão 7
INSERT INTO revisao (codigo, data, horario, descricao, cpf_tecnico, codigo_brinquedo)
    VALUES (seq_revisao.NEXTVAL, TO_DATE('2026-06-29', 'YYYY-MM-DD'), INTERVAL '08:00' HOUR TO MINUTE, 'Inspeção do sistema pneumático e das portas de acesso', '31631553160', 4);
-- revisão 8
INSERT INTO revisao (codigo, data, horario, descricao, cpf_tecnico, codigo_brinquedo)
    VALUES (seq_revisao.NEXTVAL, TO_DATE('2026-08-31', 'YYYY-MM-DD'), INTERVAL '08:00' HOUR TO MINUTE, 'Inspeção de rodas, trilhos e sistema de frenagem', '08289064594', 4);
-- revisão 9
INSERT INTO revisao (codigo, data, horario, descricao, cpf_tecnico, codigo_brinquedo)
    VALUES (seq_revisao.NEXTVAL, TO_DATE('2026-07-06', 'YYYY-MM-DD'), INTERVAL '06:30' HOUR TO MINUTE, 'Inspeção de rodas, trilhos e sistema de frenagem', '08289064594', 5);
-- revisão 10
INSERT INTO revisao (codigo, data, horario, descricao, cpf_tecnico, codigo_brinquedo)
    VALUES (seq_revisao.NEXTVAL, TO_DATE('2026-09-07', 'YYYY-MM-DD'), INTERVAL '07:30' HOUR TO MINUTE, 'Revisão do painel de comando e dos sensores de segurança', '78557830408', 5);
-- revisão 11
INSERT INTO revisao (codigo, data, horario, descricao, cpf_tecnico, codigo_brinquedo)
    VALUES (seq_revisao.NEXTVAL, TO_DATE('2026-07-13', 'YYYY-MM-DD'), INTERVAL '08:00' HOUR TO MINUTE, 'Revisão do painel de comando e dos sensores de segurança', '78557830408', 6);
-- revisão 12
INSERT INTO revisao (codigo, data, horario, descricao, cpf_tecnico, codigo_brinquedo)
    VALUES (seq_revisao.NEXTVAL, TO_DATE('2026-09-14', 'YYYY-MM-DD'), INTERVAL '06:30' HOUR TO MINUTE, 'Verificação de bombas, vedações e travas hidráulicas', '34019575118', 6);
-- revisão 13
INSERT INTO revisao (codigo, data, horario, descricao, cpf_tecnico, codigo_brinquedo)
    VALUES (seq_revisao.NEXTVAL, TO_DATE('2026-07-20', 'YYYY-MM-DD'), INTERVAL '06:30' HOUR TO MINUTE, 'Verificação de bombas, vedações e travas hidráulicas', '34019575118', 7);
-- revisão 14
INSERT INTO revisao (codigo, data, horario, descricao, cpf_tecnico, codigo_brinquedo)
    VALUES (seq_revisao.NEXTVAL, TO_DATE('2026-09-01', 'YYYY-MM-DD'), INTERVAL '06:30' HOUR TO MINUTE, 'Inspeção estrutural e reaperto de fixações', '47389777680', 7);
-- revisão 15
INSERT INTO revisao (codigo, data, horario, descricao, cpf_tecnico, codigo_brinquedo)
    VALUES (seq_revisao.NEXTVAL, TO_DATE('2026-07-27', 'YYYY-MM-DD'), INTERVAL '06:30' HOUR TO MINUTE, 'Inspeção estrutural e reaperto de fixações', '47389777680', 8);
-- revisão 16
INSERT INTO revisao (codigo, data, horario, descricao, cpf_tecnico, codigo_brinquedo)
    VALUES (seq_revisao.NEXTVAL, TO_DATE('2026-09-08', 'YYYY-MM-DD'), INTERVAL '08:00' HOUR TO MINUTE, 'Inspeção do sistema pneumático e das portas de acesso', '31631553160', 8);

-- ---------------------------------------------------------------------
-- USA - peças por revisão. As revisões 3, 8 e 14 são de rotina, sem troca de peças.
-- Custo = valor de repor a peça NAQUELA revisão (0 = saiu do estoque, sem compra);
-- a mesma peça e quantidade aparecem com custos diferentes em revisões diferentes.
-- ---------------------------------------------------------------------
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (1, 7, 4, 14576.74);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (1, 5, 2, 542.89);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (1, 4, 2, 15037.29);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (2, 5, 2, 386.51);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (4, 9, 6, 1337.79);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (4, 10, 2, 300.74);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (4, 1, 4, 343.99);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (5, 10, 4, 502.49);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (5, 1, 6, 601.28);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (5, 9, 2, 0.00);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (6, 6, 2, 1237.70);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (7, 6, 4, 2074.58);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (7, 5, 1, 201.98);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (9, 2, 4, 505.29);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (9, 9, 2, 355.47);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (9, 1, 2, 256.19);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (10, 10, 2, 373.13);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (10, 7, 4, 19119.52);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (10, 4, 2, 16564.16);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (11, 5, 4, 790.96);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (11, 4, 2, 18045.02);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (12, 5, 1, 288.47);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (13, 5, 6, 0.00);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (13, 6, 2, 1228.60);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (13, 8, 2, 5924.50);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (15, 9, 6, 1209.50);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (15, 3, 4, 2862.02);
INSERT INTO usa (codigo_revisao, codigo_peca, quantidade_de_pecas, custo)
    VALUES (16, 6, 4, 0.00);

-- ---------------------------------------------------------------------
-- INGRESSO (41) - todo cliente compra pelo menos um (código via seq_ingresso)
-- ---------------------------------------------------------------------
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-05', 'YYYY-MM-DD'), 'Digital', '97565733334');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-05', 'YYYY-MM-DD'), 'Física', '62279786710');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-05', 'YYYY-MM-DD'), 'Digital', '13393065815');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-05', 'YYYY-MM-DD'), 'Digital', '13393065815');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-05', 'YYYY-MM-DD'), 'Física', '94571710550');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-06', 'YYYY-MM-DD'), 'Digital', '81816089419');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-06', 'YYYY-MM-DD'), 'Física', '28028765467');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-06', 'YYYY-MM-DD'), 'Física', '50154817139');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-06', 'YYYY-MM-DD'), 'Física', '50154817139');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-06', 'YYYY-MM-DD'), 'Física', '50154817139');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-06', 'YYYY-MM-DD'), 'Física', '06537026555');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-12', 'YYYY-MM-DD'), 'Digital', '97565733334');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-12', 'YYYY-MM-DD'), 'Digital', '97565733334');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-12', 'YYYY-MM-DD'), 'Física', '70257605878');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-12', 'YYYY-MM-DD'), 'Digital', '13393065815');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-12', 'YYYY-MM-DD'), 'Digital', '13393065815');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-12', 'YYYY-MM-DD'), 'Digital', '13393065815');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-12', 'YYYY-MM-DD'), 'Digital', '37413521016');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-12', 'YYYY-MM-DD'), 'Digital', '37413521016');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-12', 'YYYY-MM-DD'), 'Digital', '37413521016');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-13', 'YYYY-MM-DD'), 'Física', '81816089419');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-13', 'YYYY-MM-DD'), 'Física', '28911860107');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-13', 'YYYY-MM-DD'), 'Física', '28911860107');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-13', 'YYYY-MM-DD'), 'Digital', '50154817139');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-13', 'YYYY-MM-DD'), 'Digital', '50154817139');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-13', 'YYYY-MM-DD'), 'Digital', '50154817139');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-13', 'YYYY-MM-DD'), 'Física', '47202606674');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-13', 'YYYY-MM-DD'), 'Física', '47202606674');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-19', 'YYYY-MM-DD'), 'Física', '70257605878');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-19', 'YYYY-MM-DD'), 'Física', '70257605878');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-19', 'YYYY-MM-DD'), 'Física', '62279786710');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-19', 'YYYY-MM-DD'), 'Física', '62279786710');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-19', 'YYYY-MM-DD'), 'Digital', '37413521016');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-19', 'YYYY-MM-DD'), 'Digital', '37413521016');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-19', 'YYYY-MM-DD'), 'Física', '94571710550');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-20', 'YYYY-MM-DD'), 'Física', '28911860107');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-20', 'YYYY-MM-DD'), 'Física', '28028765467');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-20', 'YYYY-MM-DD'), 'Digital', '47202606674');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-20', 'YYYY-MM-DD'), 'Digital', '47202606674');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-20', 'YYYY-MM-DD'), 'Digital', '47202606674');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, TO_DATE('2026-09-20', 'YYYY-MM-DD'), 'Digital', '06537026555');

-- ---------------------------------------------------------------------
-- TRABALHA_EM (29) - histórico de alocação; data_fim NULL = alocação atual
-- ---------------------------------------------------------------------
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('08289064594', 'Zona Medieval', TO_DATE('2018-03-12', 'YYYY-MM-DD'), TO_DATE('2020-12-31', 'YYYY-MM-DD'));
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('08289064594', 'Zona Espacial', TO_DATE('2021-01-01', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('78557830408', 'Zona Aquática', TO_DATE('2019-07-01', 'YYYY-MM-DD'), TO_DATE('2023-02-28', 'YYYY-MM-DD'));
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('78557830408', 'Zona Infantil', TO_DATE('2023-03-01', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('34019575118', 'Zona Aquática', TO_DATE('2020-02-17', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('47389777680', 'Zona Medieval', TO_DATE('2022-05-09', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('74082869697', 'Zona Infantil', TO_DATE('2017-04-03', 'YYYY-MM-DD'), TO_DATE('2019-12-31', 'YYYY-MM-DD'));
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('74082869697', 'Zona Medieval', TO_DATE('2020-01-01', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('18427896867', 'Zona Medieval', TO_DATE('2019-01-14', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('31073946100', 'Zona Espacial', TO_DATE('2018-09-10', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('27200463612', 'Zona Infantil', TO_DATE('2020-06-22', 'YYYY-MM-DD'), TO_DATE('2021-12-31', 'YYYY-MM-DD'));
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('27200463612', 'Zona Espacial', TO_DATE('2022-01-01', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('89597373564', 'Zona Aquática', TO_DATE('2021-01-11', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('08469019350', 'Zona Aquática', TO_DATE('2023-03-06', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('75658024099', 'Zona Infantil', TO_DATE('2019-11-25', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('14931820999', 'Zona Infantil', TO_DATE('2024-02-05', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('80451081340', 'Zona Medieval', TO_DATE('2024-08-19', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('94831189057', 'Zona Aquática', TO_DATE('2022-10-03', 'YYYY-MM-DD'), TO_DATE('2023-06-30', 'YYYY-MM-DD'));
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('94831189057', 'Zona Espacial', TO_DATE('2023-07-01', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('84057617647', 'Zona Medieval', TO_DATE('2015-02-02', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('66572706583', 'Zona Medieval', TO_DATE('2016-06-13', 'YYYY-MM-DD'), TO_DATE('2018-12-31', 'YYYY-MM-DD'));
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('66572706583', 'Zona Aquática', TO_DATE('2019-01-01', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('34517212793', 'Praça dos Shows', TO_DATE('2021-04-05', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('99146944621', 'Praça dos Shows', TO_DATE('2016-08-01', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('52009029917', 'Praça dos Shows', TO_DATE('2017-10-16', 'YYYY-MM-DD'), TO_DATE('2022-12-31', 'YYYY-MM-DD'));
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('52009029917', 'Zona Infantil', TO_DATE('2023-01-01', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('31956646078', 'Praça dos Shows', TO_DATE('2023-07-10', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('23353768963', 'Zona Medieval', TO_DATE('2022-01-31', 'YYYY-MM-DD'), NULL);
INSERT INTO trabalha_em (cpf_funcionario, nome_area, data_inicio, data_fim)
    VALUES ('31631553160', 'Zona Espacial', TO_DATE('2023-09-04', 'YYYY-MM-DD'), NULL);

-- ---------------------------------------------------------------------
-- RESERVA (19) - quantidade nunca excede os ingressos do cliente naquele dia
-- ---------------------------------------------------------------------
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('62279786710', 11, 2, TO_DATE('2026-09-05', 'YYYY-MM-DD'), 1);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('13393065815', 11, 1, TO_DATE('2026-09-05', 'YYYY-MM-DD'), 2);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('94571710550', 11, 2, TO_DATE('2026-09-05', 'YYYY-MM-DD'), 1);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('28028765467', 9, 1, TO_DATE('2026-09-06', 'YYYY-MM-DD'), 1);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('50154817139', 13, 1, TO_DATE('2026-09-06', 'YYYY-MM-DD'), 1);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('06537026555', 13, 1, TO_DATE('2026-09-06', 'YYYY-MM-DD'), 1);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('97565733334', 9, 2, TO_DATE('2026-09-12', 'YYYY-MM-DD'), 2);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('13393065815', 11, 1, TO_DATE('2026-09-12', 'YYYY-MM-DD'), 2);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('37413521016', 9, 1, TO_DATE('2026-09-12', 'YYYY-MM-DD'), 2);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('81816089419', 12, 1, TO_DATE('2026-09-13', 'YYYY-MM-DD'), 1);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('47202606674', 12, 1, TO_DATE('2026-09-13', 'YYYY-MM-DD'), 1);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('70257605878', 11, 1, TO_DATE('2026-09-19', 'YYYY-MM-DD'), 1);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('62279786710', 11, 1, TO_DATE('2026-09-19', 'YYYY-MM-DD'), 2);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('37413521016', 11, 1, TO_DATE('2026-09-19', 'YYYY-MM-DD'), 2);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('94571710550', 11, 1, TO_DATE('2026-09-19', 'YYYY-MM-DD'), 1);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('28911860107', 12, 1, TO_DATE('2026-09-20', 'YYYY-MM-DD'), 1);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('28028765467', 12, 1, TO_DATE('2026-09-20', 'YYYY-MM-DD'), 1);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('47202606674', 12, 1, TO_DATE('2026-09-20', 'YYYY-MM-DD'), 2);
INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao, data_sessao, quantidade_de_reservas)
    VALUES ('06537026555', 12, 1, TO_DATE('2026-09-20', 'YYYY-MM-DD'), 1);

-- ---------------------------------------------------------------------
-- SE_APRESENTA_EM - todo artista em pelo menos um evento e todo evento com pelo menos um artista
-- ---------------------------------------------------------------------
INSERT INTO se_apresenta_em (cpf_artista, nome_evento)
    VALUES ('34517212793', 'Palhaço Comediante');
INSERT INTO se_apresenta_em (cpf_artista, nome_evento)
    VALUES ('99146944621', 'Pirotecnia Noturna');
INSERT INTO se_apresenta_em (cpf_artista, nome_evento)
    VALUES ('31956646078', 'Pirotecnia Noturna');
INSERT INTO se_apresenta_em (cpf_artista, nome_evento)
    VALUES ('31956646078', 'Globo da Morte');
INSERT INTO se_apresenta_em (cpf_artista, nome_evento)
    VALUES ('23353768963', 'Parada Medieval');
INSERT INTO se_apresenta_em (cpf_artista, nome_evento)
    VALUES ('99146944621', 'Parada Medieval');
INSERT INTO se_apresenta_em (cpf_artista, nome_evento)
    VALUES ('52009029917', 'Mágico Itinerante');
INSERT INTO se_apresenta_em (cpf_artista, nome_evento)
    VALUES ('34517212793', 'Mágico Itinerante');
INSERT INTO se_apresenta_em (cpf_artista, nome_evento)
    VALUES ('34517212793', 'Bolhas Gigantes');
INSERT INTO se_apresenta_em (cpf_artista, nome_evento)
    VALUES ('52009029917', 'Bolhas Gigantes');

-- ---------------------------------------------------------------------
-- MENTORA - mentor sempre mais antigo que o mentorado; Fernanda tem dois mentores
-- ---------------------------------------------------------------------
INSERT INTO mentora (cpf_mentor, cpf_mentorado)
    VALUES ('84057617647', '74082869697');
INSERT INTO mentora (cpf_mentor, cpf_mentorado)
    VALUES ('84057617647', '31073946100');
INSERT INTO mentora (cpf_mentor, cpf_mentorado)
    VALUES ('74082869697', '80451081340');
INSERT INTO mentora (cpf_mentor, cpf_mentorado)
    VALUES ('31073946100', '94831189057');
INSERT INTO mentora (cpf_mentor, cpf_mentorado)
    VALUES ('74082869697', '94831189057');
INSERT INTO mentora (cpf_mentor, cpf_mentorado)
    VALUES ('66572706583', '89597373564');
INSERT INTO mentora (cpf_mentor, cpf_mentorado)
    VALUES ('08289064594', '78557830408');
INSERT INTO mentora (cpf_mentor, cpf_mentorado)
    VALUES ('78557830408', '47389777680');
INSERT INTO mentora (cpf_mentor, cpf_mentorado)
    VALUES ('08289064594', '34019575118');
INSERT INTO mentora (cpf_mentor, cpf_mentorado)
    VALUES ('99146944621', '34517212793');
INSERT INTO mentora (cpf_mentor, cpf_mentorado)
    VALUES ('99146944621', '31956646078');
INSERT INTO mentora (cpf_mentor, cpf_mentorado)
    VALUES ('52009029917', '23353768963');
INSERT INTO mentora (cpf_mentor, cpf_mentorado)
    VALUES ('31073946100', '27200463612');
INSERT INTO mentora (cpf_mentor, cpf_mentorado)
    VALUES ('74082869697', '18427896867');
INSERT INTO mentora (cpf_mentor, cpf_mentorado)
    VALUES ('34019575118', '31631553160');

-- ---------------------------------------------------------------------
-- FREQUENTA (68) - cliente em dia de ingresso; operador sempre de um brinquedo que opera
-- ---------------------------------------------------------------------
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('97565733334', TO_DATE('2026-09-05', 'YYYY-MM-DD'), INTERVAL '09:40' HOUR TO MINUTE, '18427896867');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('97565733334', TO_DATE('2026-09-05', 'YYYY-MM-DD'), INTERVAL '10:15' HOUR TO MINUTE, '75658024099');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('97565733334', TO_DATE('2026-09-05', 'YYYY-MM-DD'), INTERVAL '16:45' HOUR TO MINUTE, '18427896867');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('62279786710', TO_DATE('2026-09-05', 'YYYY-MM-DD'), INTERVAL '15:10' HOUR TO MINUTE, '08469019350');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('62279786710', TO_DATE('2026-09-05', 'YYYY-MM-DD'), INTERVAL '16:45' HOUR TO MINUTE, '89597373564');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('62279786710', TO_DATE('2026-09-05', 'YYYY-MM-DD'), INTERVAL '17:30' HOUR TO MINUTE, '08469019350');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('13393065815', TO_DATE('2026-09-05', 'YYYY-MM-DD'), INTERVAL '13:45' HOUR TO MINUTE, '27200463612');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('13393065815', TO_DATE('2026-09-05', 'YYYY-MM-DD'), INTERVAL '16:00' HOUR TO MINUTE, '74082869697');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('13393065815', TO_DATE('2026-09-05', 'YYYY-MM-DD'), INTERVAL '16:45' HOUR TO MINUTE, '75658024099');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('94571710550', TO_DATE('2026-09-05', 'YYYY-MM-DD'), INTERVAL '12:30' HOUR TO MINUTE, '18427896867');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('94571710550', TO_DATE('2026-09-05', 'YYYY-MM-DD'), INTERVAL '14:20' HOUR TO MINUTE, '27200463612');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('81816089419', TO_DATE('2026-09-06', 'YYYY-MM-DD'), INTERVAL '09:40' HOUR TO MINUTE, '66572706583');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('81816089419', TO_DATE('2026-09-06', 'YYYY-MM-DD'), INTERVAL '11:00' HOUR TO MINUTE, '27200463612');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('81816089419', TO_DATE('2026-09-06', 'YYYY-MM-DD'), INTERVAL '13:45' HOUR TO MINUTE, '27200463612');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('28028765467', TO_DATE('2026-09-06', 'YYYY-MM-DD'), INTERVAL '10:15' HOUR TO MINUTE, '14931820999');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('28028765467', TO_DATE('2026-09-06', 'YYYY-MM-DD'), INTERVAL '14:20' HOUR TO MINUTE, '27200463612');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('50154817139', TO_DATE('2026-09-06', 'YYYY-MM-DD'), INTERVAL '10:15' HOUR TO MINUTE, '80451081340');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('50154817139', TO_DATE('2026-09-06', 'YYYY-MM-DD'), INTERVAL '11:00' HOUR TO MINUTE, '75658024099');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('50154817139', TO_DATE('2026-09-06', 'YYYY-MM-DD'), INTERVAL '15:10' HOUR TO MINUTE, '75658024099');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('06537026555', TO_DATE('2026-09-06', 'YYYY-MM-DD'), INTERVAL '12:30' HOUR TO MINUTE, '18427896867');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('06537026555', TO_DATE('2026-09-06', 'YYYY-MM-DD'), INTERVAL '13:45' HOUR TO MINUTE, '18427896867');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('97565733334', TO_DATE('2026-09-12', 'YYYY-MM-DD'), INTERVAL '12:30' HOUR TO MINUTE, '74082869697');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('97565733334', TO_DATE('2026-09-12', 'YYYY-MM-DD'), INTERVAL '17:30' HOUR TO MINUTE, '18427896867');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('70257605878', TO_DATE('2026-09-12', 'YYYY-MM-DD'), INTERVAL '12:30' HOUR TO MINUTE, '18427896867');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('70257605878', TO_DATE('2026-09-12', 'YYYY-MM-DD'), INTERVAL '17:30' HOUR TO MINUTE, '08469019350');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('13393065815', TO_DATE('2026-09-12', 'YYYY-MM-DD'), INTERVAL '13:45' HOUR TO MINUTE, '31073946100');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('13393065815', TO_DATE('2026-09-12', 'YYYY-MM-DD'), INTERVAL '16:45' HOUR TO MINUTE, '18427896867');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('13393065815', TO_DATE('2026-09-12', 'YYYY-MM-DD'), INTERVAL '17:30' HOUR TO MINUTE, '08469019350');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('37413521016', TO_DATE('2026-09-12', 'YYYY-MM-DD'), INTERVAL '13:45' HOUR TO MINUTE, '08469019350');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('37413521016', TO_DATE('2026-09-12', 'YYYY-MM-DD'), INTERVAL '16:45' HOUR TO MINUTE, '08469019350');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('81816089419', TO_DATE('2026-09-13', 'YYYY-MM-DD'), INTERVAL '15:10' HOUR TO MINUTE, '27200463612');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('81816089419', TO_DATE('2026-09-13', 'YYYY-MM-DD'), INTERVAL '17:30' HOUR TO MINUTE, '18427896867');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('28911860107', TO_DATE('2026-09-13', 'YYYY-MM-DD'), INTERVAL '09:40' HOUR TO MINUTE, '89597373564');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('28911860107', TO_DATE('2026-09-13', 'YYYY-MM-DD'), INTERVAL '13:45' HOUR TO MINUTE, '08469019350');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('50154817139', TO_DATE('2026-09-13', 'YYYY-MM-DD'), INTERVAL '10:15' HOUR TO MINUTE, '66572706583');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('50154817139', TO_DATE('2026-09-13', 'YYYY-MM-DD'), INTERVAL '14:20' HOUR TO MINUTE, '14931820999');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('50154817139', TO_DATE('2026-09-13', 'YYYY-MM-DD'), INTERVAL '15:10' HOUR TO MINUTE, '31073946100');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('50154817139', TO_DATE('2026-09-13', 'YYYY-MM-DD'), INTERVAL '16:45' HOUR TO MINUTE, '27200463612');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('47202606674', TO_DATE('2026-09-13', 'YYYY-MM-DD'), INTERVAL '11:00' HOUR TO MINUTE, '14931820999');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('47202606674', TO_DATE('2026-09-13', 'YYYY-MM-DD'), INTERVAL '14:20' HOUR TO MINUTE, '18427896867');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('47202606674', TO_DATE('2026-09-13', 'YYYY-MM-DD'), INTERVAL '17:30' HOUR TO MINUTE, '75658024099');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('70257605878', TO_DATE('2026-09-19', 'YYYY-MM-DD'), INTERVAL '11:00' HOUR TO MINUTE, '18427896867');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('70257605878', TO_DATE('2026-09-19', 'YYYY-MM-DD'), INTERVAL '13:45' HOUR TO MINUTE, '75658024099');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('70257605878', TO_DATE('2026-09-19', 'YYYY-MM-DD'), INTERVAL '16:00' HOUR TO MINUTE, '18427896867');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('62279786710', TO_DATE('2026-09-19', 'YYYY-MM-DD'), INTERVAL '10:15' HOUR TO MINUTE, '66572706583');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('62279786710', TO_DATE('2026-09-19', 'YYYY-MM-DD'), INTERVAL '15:10' HOUR TO MINUTE, '31073946100');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('62279786710', TO_DATE('2026-09-19', 'YYYY-MM-DD'), INTERVAL '16:00' HOUR TO MINUTE, '75658024099');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('37413521016', TO_DATE('2026-09-19', 'YYYY-MM-DD'), INTERVAL '13:45' HOUR TO MINUTE, '14931820999');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('37413521016', TO_DATE('2026-09-19', 'YYYY-MM-DD'), INTERVAL '14:20' HOUR TO MINUTE, '14931820999');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('37413521016', TO_DATE('2026-09-19', 'YYYY-MM-DD'), INTERVAL '16:00' HOUR TO MINUTE, '89597373564');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('37413521016', TO_DATE('2026-09-19', 'YYYY-MM-DD'), INTERVAL '16:45' HOUR TO MINUTE, '14931820999');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('94571710550', TO_DATE('2026-09-19', 'YYYY-MM-DD'), INTERVAL '11:00' HOUR TO MINUTE, '14931820999');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('94571710550', TO_DATE('2026-09-19', 'YYYY-MM-DD'), INTERVAL '13:45' HOUR TO MINUTE, '31073946100');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('94571710550', TO_DATE('2026-09-19', 'YYYY-MM-DD'), INTERVAL '14:20' HOUR TO MINUTE, '27200463612');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('28911860107', TO_DATE('2026-09-20', 'YYYY-MM-DD'), INTERVAL '09:40' HOUR TO MINUTE, '14931820999');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('28911860107', TO_DATE('2026-09-20', 'YYYY-MM-DD'), INTERVAL '11:00' HOUR TO MINUTE, '27200463612');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('28911860107', TO_DATE('2026-09-20', 'YYYY-MM-DD'), INTERVAL '13:45' HOUR TO MINUTE, '14931820999');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('28911860107', TO_DATE('2026-09-20', 'YYYY-MM-DD'), INTERVAL '17:30' HOUR TO MINUTE, '14931820999');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('28028765467', TO_DATE('2026-09-20', 'YYYY-MM-DD'), INTERVAL '09:40' HOUR TO MINUTE, '89597373564');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('28028765467', TO_DATE('2026-09-20', 'YYYY-MM-DD'), INTERVAL '11:00' HOUR TO MINUTE, '31073946100');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('28028765467', TO_DATE('2026-09-20', 'YYYY-MM-DD'), INTERVAL '17:30' HOUR TO MINUTE, '80451081340');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('47202606674', TO_DATE('2026-09-20', 'YYYY-MM-DD'), INTERVAL '10:15' HOUR TO MINUTE, '80451081340');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('47202606674', TO_DATE('2026-09-20', 'YYYY-MM-DD'), INTERVAL '12:30' HOUR TO MINUTE, '18427896867');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('47202606674', TO_DATE('2026-09-20', 'YYYY-MM-DD'), INTERVAL '13:45' HOUR TO MINUTE, '75658024099');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('06537026555', TO_DATE('2026-09-20', 'YYYY-MM-DD'), INTERVAL '09:40' HOUR TO MINUTE, '89597373564');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('06537026555', TO_DATE('2026-09-20', 'YYYY-MM-DD'), INTERVAL '10:15' HOUR TO MINUTE, '66572706583');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('06537026555', TO_DATE('2026-09-20', 'YYYY-MM-DD'), INTERVAL '12:30' HOUR TO MINUTE, '74082869697');
INSERT INTO frequenta (cpf_cliente, data, horario_visita, cpf_operador)
    VALUES ('06537026555', TO_DATE('2026-09-20', 'YYYY-MM-DD'), INTERVAL '15:10' HOUR TO MINUTE, '75658024099');

COMMIT;
