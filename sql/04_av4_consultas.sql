-- =====================================================================
-- 04_av4_consultas.sql
-- Projeto: Parque de Diversões (AV4 - Consultas sobre tabelas relacionais)
-- Disciplina: Banco de Dados (IF685) - CIn/UFPE
--
-- Equipe: Samuel de Almeida Farias Nascimento
--         Davi de Souza Mello
--         Maria Cláudia Silva Rocha
--         Pedro Wellington Ferreira Felizola Lucena
--         Guilherme Calistrato Nunes
--
-- PRÉ-REQUISITO (nesta ordem, no Oracle Live SQL):
--   1) 01_ddl.sql   2) 02_povoamento.sql   3) ESTE arquivo   4) 05_av4_plsql.sql
-- Para reexecutar este arquivo, rode antes 01_ddl.sql e 02_povoamento.sql de
-- novo: o ALTER TABLE da seção 1 só pode ser aplicado uma vez.
--
-- Organização (cada comando traz a pergunta de negócio e o item do checklist):
--   Seção 1  DDL/DML: ALTER TABLE, CREATE INDEX, INSERT, UPDATE, DELETE
--   Seção 2  Consultas simples: WHERE, BETWEEN, IN, LIKE, IS NULL, ORDER BY
--   Seção 3  Junções e agregações: INNER JOIN, MAX/MIN/AVG/COUNT, GROUP BY, HAVING
--   Seção 4  Junções externas: LEFT, RIGHT e FULL OUTER JOIN
--   Seção 5  Subconsultas: operador relacional, IN, ANY, ALL (+ EXISTS)
--   Seção 6  Operações de conjunto: UNION, INTERSECT, MINUS
--   Seção 7  Visões (CREATE VIEW) e consultas sobre elas
--   Seção 8  GRANT / REVOKE (comentado: não executa no Live SQL)
--
-- Datas de referência são fixas (ex.: DATE '2026-09-30') para o resultado
-- ser reprodutível. Horários são INTERVAL; usamos EXTRACT(HOUR FROM ...).
-- =====================================================================


-- =====================================================================
-- SEÇÃO 1 - DDL / DML
-- =====================================================================

-- ---------------------------------------------------------------------
-- [SQL 1] ALTER TABLE
-- Regra nova: o parque passa a cobrar valor por ingresso e a controlar a
-- situação operacional de cada brinquedo. O DEFAULT preenche as linhas que
-- já existem; as CHECKs mantêm o domínio válido.
-- ---------------------------------------------------------------------
ALTER TABLE ingresso ADD (valor NUMBER(6,2) DEFAULT 80 NOT NULL);
ALTER TABLE ingresso ADD CONSTRAINT ck_ingresso_valor CHECK (valor > 0);

ALTER TABLE brinquedo ADD (situacao VARCHAR2(20) DEFAULT 'Operando' NOT NULL);
ALTER TABLE brinquedo ADD CONSTRAINT ck_brinquedo_situacao
    CHECK (situacao IN ('Operando', 'Em manutenção', 'Fechado'));


-- ---------------------------------------------------------------------
-- [SQL 2] CREATE INDEX
-- Índices B-Tree nas colunas que mais filtram/juntam nas consultas abaixo.
-- PK e UNIQUE já ganham índice automático; FK NÃO ganha no Oracle.
-- ---------------------------------------------------------------------
-- Filtro por período de visita (BETWEEN / receita por data).
CREATE INDEX idx_ingresso_data_visita ON ingresso (data_visita);

-- FK sem índice: junção frequenta -> operador (visitas por brinquedo).
CREATE INDEX idx_frequenta_operador ON frequenta (cpf_operador);

-- Índice composto: busca de funcionário por sobrenome (+ nome).
CREATE INDEX idx_funcionario_nome ON funcionario (sobrenome, primeiro_nome);

-- Índice baseado em função: busca de e-mail sem diferenciar maiúsculas
-- (WHERE UPPER(email) = ...). Só é usado quando a consulta repete UPPER().
CREATE INDEX idx_cliente_email_upper ON cliente (UPPER(email));


-- ---------------------------------------------------------------------
-- [SQL 3] INSERT INTO
-- Novos registros que também criam casos-limite úteis nas consultas:
-- cliente sem ingresso, peça nunca usada, brinquedo sem gerente/operador.
-- ---------------------------------------------------------------------
-- Dois clientes novos (e-mail gmail): Gabriel compra ingressos, Sofia ainda não.
INSERT INTO cliente (cpf, primeiro_nome, sobrenome, rua, numero, bairro, cidade, cep, email)
    VALUES ('12345678909', 'Gabriel', 'Torres Lins', 'Rua da Aurora', '410', 'Boa Vista', 'Recife', '50050000', 'gabriel.torres@gmail.com');
INSERT INTO cliente (cpf, primeiro_nome, sobrenome, rua, numero, bairro, cidade, cep, email)
    VALUES ('23456789173', 'Sofia', 'Ramos Pontes', 'Av. Presidente Kennedy', '1500', 'Bairro Novo', 'Olinda', '53030000', 'sofia.ramos@gmail.com');

INSERT INTO telefone_cliente (cpf_cliente, telefone) VALUES ('12345678909', '81987654321');

-- Gabriel compra dois ingressos para o fim de setembro (sequence + CHECK de canal).
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, DATE '2026-09-26', 'Digital', '12345678909');
INSERT INTO ingresso (numero, data_visita, local_compra, cpf_cliente)
    VALUES (seq_ingresso.NEXTVAL, DATE '2026-09-27', 'Física', '12345678909');

-- Uma peça em estoque que nunca foi usada e uma peça obsoleta sem estoque.
INSERT INTO peca (codigo, nome, fabricante, estoque_atual)
    VALUES (seq_peca.NEXTVAL, 'Mola de suspensão do carrinho', 'Bosch', 15);
INSERT INTO peca (codigo, nome, fabricante, estoque_atual)
    VALUES (seq_peca.NEXTVAL, 'Lâmpada de sinalização (modelo antigo)', 'Osram', 0);

-- Novo brinquedo: ATRACAO (NEXTVAL) + BRINQUEDO (CURRVAL, mesmo código).
-- Nasce fechado e sem gerente, aguardando contratação de operador.
INSERT INTO atracao (codigo, nome, capacidade, nome_area)
    VALUES (seq_atracao.NEXTVAL, 'Roda-Gigante Aurora', 36, 'Zona Infantil');
INSERT INTO brinquedo (codigo, restricao_altura, velocidade_maxima, categoria, cpf_gerente, situacao)
    VALUES (seq_atracao.CURRVAL, 90, 8.0, 'Infantil', NULL, 'Fechado');

-- INSERT ... SELECT: abre uma sessão das 20h em 27/09 para cada espetáculo
-- Musical, aproveitando a capacidade da plateia como vagas iniciais.
INSERT INTO sessao (codigo_espetaculo, numero, data, horario, vagas_disponiveis)
    SELECT e.codigo, 1, DATE '2026-09-27', INTERVAL '20:00' HOUR TO MINUTE, e.capacidade_plateia
      FROM espetaculo e
     WHERE e.categoria_show = 'Musical';


-- ---------------------------------------------------------------------
-- [SQL 4] UPDATE
-- ---------------------------------------------------------------------
-- (a) Reajuste de 5% para operadores de certificação nível 3 (subconsulta).
UPDATE funcionario
   SET salario = ROUND(salario * 1.05, 2)
 WHERE cpf IN (SELECT cpf FROM operador WHERE nivel_certificacao = 3);

-- (b) Tabela de preços: ingresso digital tem desconto (R$ 70) ...
UPDATE ingresso
   SET valor = 70
 WHERE local_compra = 'Digital';

-- ... e dias cobertos por um evento especial (Globo da Morte) custam R$ 15 a mais.
UPDATE ingresso i
   SET valor = valor + 15
 WHERE EXISTS (SELECT 1
                 FROM evento e
                WHERE e.nome = 'Globo da Morte'
                  AND i.data_visita BETWEEN e.data_inicio AND e.data_termino);

-- (c) Brinquedos com revisão agendada depois de 13/09 entram em manutenção.
UPDATE brinquedo
   SET situacao = 'Em manutenção'
 WHERE codigo IN (SELECT codigo_brinquedo
                    FROM revisao
                   WHERE data > DATE '2026-09-13');


-- ---------------------------------------------------------------------
-- [SQL 5] DELETE
-- Limpeza do cadastro de peças: remove peças sem estoque que nunca foram
-- usadas em nenhuma revisão (a FK de USA impediria apagar peça já usada).
-- ---------------------------------------------------------------------
DELETE FROM peca
 WHERE estoque_atual = 0
   AND codigo NOT IN (SELECT codigo_peca FROM usa);

COMMIT;


-- =====================================================================
-- SEÇÃO 2 - CONSULTAS SIMPLES
-- =====================================================================

-- ---------------------------------------------------------------------
-- Consulta 1  [SQL 6 SELECT-FROM-WHERE | SQL 7 BETWEEN | SQL 21 ORDER BY]
-- Quais funcionários admitidos entre 2019 e 2022 têm salário entre
-- R$ 3.000 e R$ 4.500? Do maior para o menor salário.
-- ---------------------------------------------------------------------
SELECT f.cpf,
       f.primeiro_nome || ' ' || f.sobrenome AS nome,
       f.salario,
       TO_CHAR(f.data_admissao, 'DD/MM/YYYY') AS admissao
  FROM funcionario f
 WHERE f.data_admissao BETWEEN DATE '2019-01-01' AND DATE '2022-12-31'
   AND f.salario BETWEEN 3000 AND 4500
 ORDER BY f.salario DESC, f.primeiro_nome;


-- ---------------------------------------------------------------------
-- Consulta 2  [SQL 8 IN | SQL 9 LIKE | SQL 21 ORDER BY]
-- Clientes de Recife ou Olinda para a campanha de e-mail: quem tem e-mail
-- gmail OU primeiro nome começando com "M".
-- ---------------------------------------------------------------------
SELECT c.cpf, c.primeiro_nome, c.cidade, c.email
  FROM cliente c
 WHERE c.cidade IN ('Recife', 'Olinda')
   AND (c.email LIKE '%@gmail.com' OR c.primeiro_nome LIKE 'M%')
 ORDER BY c.cidade, c.primeiro_nome;


-- ---------------------------------------------------------------------
-- Consulta 3  [SQL 10 IS NULL]
-- Quais brinquedos estão sem gerente? (Gerencia é (0,1): nulo = sem gerente.)
-- ---------------------------------------------------------------------
SELECT a.codigo, a.nome, a.nome_area, b.categoria, b.situacao
  FROM brinquedo b
  JOIN atracao a ON a.codigo = b.codigo
 WHERE b.cpf_gerente IS NULL
 ORDER BY a.codigo;


-- ---------------------------------------------------------------------
-- Consulta 4  [SQL 10 IS NOT NULL | SQL 11 INNER JOIN]
-- Histórico: alocações já ENCERRADAS (data_fim preenchida), com quantos
-- dias o funcionário ficou na área. Ordem: mais longas primeiro.
-- ---------------------------------------------------------------------
SELECT f.primeiro_nome || ' ' || f.sobrenome AS funcionario,
       t.nome_area,
       TO_CHAR(t.data_inicio, 'DD/MM/YYYY') AS inicio,
       TO_CHAR(t.data_fim, 'DD/MM/YYYY')    AS fim,
       (t.data_fim - t.data_inicio)         AS dias_na_area
  FROM trabalha_em t
  JOIN funcionario f ON f.cpf = t.cpf_funcionario
 WHERE t.data_fim IS NOT NULL
 ORDER BY dias_na_area DESC;


-- =====================================================================
-- SEÇÃO 3 - JUNÇÕES E AGREGAÇÕES
-- =====================================================================

-- ---------------------------------------------------------------------
-- Consulta 5  [SQL 11 INNER JOIN | SQL 15 COUNT | SQL 22 GROUP BY | SQL 21 ORDER BY]
-- Quais brinquedos mais recebem visitas? FREQUENTA só guarda o operador;
-- o brinquedo vem de OPERADOR -> BRINQUEDO -> ATRACAO (junção de 4 tabelas).
-- ---------------------------------------------------------------------
SELECT a.nome AS brinquedo,
       a.nome_area,
       COUNT(*)                     AS total_visitas,
       COUNT(DISTINCT fq.cpf_cliente) AS clientes_distintos
  FROM frequenta fq
  JOIN operador o  ON o.cpf    = fq.cpf_operador
  JOIN brinquedo b ON b.codigo = o.codigo_brinquedo_opera
  JOIN atracao a   ON a.codigo = b.codigo
 GROUP BY a.nome, a.nome_area
 ORDER BY total_visitas DESC, a.nome;


-- ---------------------------------------------------------------------
-- Consulta 6  [SQL 12 MAX | SQL 13 MIN | SQL 14 AVG | SQL 15 COUNT | SQL 22 GROUP BY | SQL 23 HAVING]
-- Perfil salarial das áreas: considerando só as alocações ATUAIS, quais
-- áreas têm pelo menos 3 funcionários e média acima de R$ 3.000?
-- WHERE filtra linhas ANTES de agrupar; HAVING filtra os grupos DEPOIS.
-- ---------------------------------------------------------------------
SELECT t.nome_area,
       COUNT(*)                AS qtd_funcionarios,
       MIN(f.salario)          AS menor_salario,
       MAX(f.salario)          AS maior_salario,
       ROUND(AVG(f.salario),2) AS salario_medio,
       SUM(f.salario)          AS folha_mensal
  FROM trabalha_em t
  JOIN funcionario f ON f.cpf = t.cpf_funcionario
 WHERE t.data_fim IS NULL
 GROUP BY t.nome_area
HAVING COUNT(*) >= 3
   AND AVG(f.salario) > 3000
 ORDER BY salario_medio DESC;


-- ---------------------------------------------------------------------
-- Consulta 7  [SQL 12 MAX | SQL 14 AVG | SQL 15 COUNT | SQL 22 GROUP BY | SQL 23 HAVING]
-- Receita de ingressos por dia de visita e canal de venda, só para os
-- dias/canais com 3 ou mais ingressos (usa a coluna "valor" do ALTER).
-- O maior ingresso do dia revela o adicional de R$ 15 dos dias de evento.
-- ---------------------------------------------------------------------
SELECT TO_CHAR(i.data_visita, 'DD/MM/YYYY') AS dia,
       i.local_compra,
       COUNT(*)               AS ingressos,
       SUM(i.valor)           AS receita,
       ROUND(AVG(i.valor), 2) AS ticket_medio,
       MAX(i.valor)           AS maior_ingresso
  FROM ingresso i
 GROUP BY i.data_visita, i.local_compra
HAVING COUNT(*) >= 3
 ORDER BY i.data_visita, receita DESC;


-- =====================================================================
-- SEÇÃO 4 - JUNÇÕES EXTERNAS
-- =====================================================================

-- ---------------------------------------------------------------------
-- Consulta 8  [SQL 16 LEFT OUTER JOIN | SQL 15 COUNT | SQL 22 GROUP BY | SQL 21 ORDER BY]
-- Custo de manutenção de TODOS os brinquedos, inclusive os que nunca foram
-- revisados (o INNER JOIN esconderia a Roda-Gigante recém-criada).
-- COUNT(rv.codigo) ignora NULL, então brinquedo sem revisão dá 0.
-- ---------------------------------------------------------------------
SELECT a.codigo,
       a.nome AS brinquedo,
       b.situacao,
       COUNT(DISTINCT rv.codigo)  AS revisoes,
       NVL(SUM(u.custo), 0)       AS custo_pecas
  FROM brinquedo b
  JOIN atracao a        ON a.codigo = b.codigo
  LEFT JOIN revisao rv  ON rv.codigo_brinquedo = b.codigo
  LEFT JOIN usa u       ON u.codigo_revisao = rv.codigo
 GROUP BY a.codigo, a.nome, b.situacao
 ORDER BY custo_pecas DESC, a.codigo;


-- ---------------------------------------------------------------------
-- Consulta 9  [SQL 16 RIGHT OUTER JOIN | SQL 22 GROUP BY]
-- Estoque x consumo: TODAS as peças e quanto de cada uma já foi usado em
-- revisões. A tabela "preservada" fica à direita (PECA); peça sem uso
-- aparece com total 0.
-- ---------------------------------------------------------------------
SELECT p.codigo,
       p.nome,
       p.estoque_atual,
       NVL(SUM(u.quantidade_de_pecas), 0) AS unidades_usadas
  FROM usa u
 RIGHT OUTER JOIN peca p ON p.codigo = u.codigo_peca
 GROUP BY p.codigo, p.nome, p.estoque_atual
 ORDER BY unidades_usadas, p.codigo;


-- ---------------------------------------------------------------------
-- Consulta 10  [SQL 16 FULL OUTER JOIN | SQL 10 IS NULL]
-- Auditoria da gerência: o FULL OUTER JOIN entre OPERADOR e BRINQUEDO
-- (via cpf_gerente) mostra de uma vez (1) gerentes titulares,
-- (2) operadores que não gerenciam nada e (3) brinquedos sem gerente.
-- ---------------------------------------------------------------------
SELECT f.primeiro_nome AS operador,
       a.nome          AS brinquedo_gerenciado,
       CASE
            WHEN o.cpf IS NULL THEN 'Brinquedo sem gerente'
            WHEN b.codigo IS NULL THEN 'Operador que não gerencia'
            ELSE 'Gerente titular'
       END AS situacao_gerencia
  FROM operador o
  FULL OUTER JOIN brinquedo b ON b.cpf_gerente = o.cpf
  LEFT JOIN funcionario f     ON f.cpf = o.cpf
  LEFT JOIN atracao a         ON a.codigo = b.codigo
 ORDER BY situacao_gerencia, operador, brinquedo_gerenciado;


-- =====================================================================
-- SEÇÃO 5 - SUBCONSULTAS
-- =====================================================================

-- ---------------------------------------------------------------------
-- Consulta 11  [SQL 17 subconsulta com operador relacional | SQL 21 ORDER BY]
-- Quem ganha acima da média salarial do parque, e quanto acima?
-- A subconsulta escalar devolve UMA linha, então cabe com ">".
-- ---------------------------------------------------------------------
SELECT f.primeiro_nome || ' ' || f.sobrenome AS funcionario,
       f.salario,
       ROUND(f.salario - (SELECT AVG(salario) FROM funcionario), 2) AS acima_da_media
  FROM funcionario f
 WHERE f.salario > (SELECT AVG(salario) FROM funcionario)
 ORDER BY acima_da_media DESC;


-- ---------------------------------------------------------------------
-- Consulta 12  [SQL 18 subconsulta com IN | SQL 11 INNER JOIN]
-- Clientes que reservaram algum espetáculo MUSICAL (subconsulta devolve
-- vários CPFs). Depois, as peças que NUNCA foram usadas (NOT IN; seguro
-- aqui porque usa.codigo_peca é NOT NULL - com NULL o NOT IN falharia).
-- ---------------------------------------------------------------------
SELECT c.cpf, c.primeiro_nome, c.sobrenome
  FROM cliente c
 WHERE c.cpf IN (SELECT r.cpf_cliente
                   FROM reserva r
                   JOIN espetaculo e ON e.codigo = r.codigo_espetaculo
                  WHERE e.categoria_show = 'Musical')
 ORDER BY c.primeiro_nome;

SELECT p.codigo, p.nome, p.estoque_atual
  FROM peca p
 WHERE p.codigo NOT IN (SELECT u.codigo_peca FROM usa u)
 ORDER BY p.codigo;


-- ---------------------------------------------------------------------
-- Consulta 13  [SQL 19 subconsulta com ANY]
-- Brinquedos mais rápidos que PELO MENOS UM brinquedo aquático
-- (> ANY equivale a > MIN da subconsulta).
-- ---------------------------------------------------------------------
SELECT a.nome AS brinquedo, b.categoria, b.velocidade_maxima
  FROM brinquedo b
  JOIN atracao a ON a.codigo = b.codigo
 WHERE b.velocidade_maxima > ANY (SELECT velocidade_maxima
                                    FROM brinquedo
                                   WHERE categoria = 'Aquático')
 ORDER BY b.velocidade_maxima DESC;


-- ---------------------------------------------------------------------
-- Consulta 14  [SQL 20 subconsulta com ALL | SQL 11 INNER JOIN]
-- Operadores que ganham mais que TODOS os técnicos (> ALL equivale a
-- > MAX da subconsulta). Se a subconsulta fosse vazia, ALL seria
-- verdadeiro para todos - pegadinha clássica.
-- ---------------------------------------------------------------------
SELECT f.primeiro_nome || ' ' || f.sobrenome AS operador,
       o.nivel_certificacao,
       f.salario
  FROM operador o
  JOIN funcionario f ON f.cpf = o.cpf
 WHERE f.salario > ALL (SELECT f2.salario
                          FROM tecnico t
                          JOIN funcionario f2 ON f2.cpf = t.cpf)
 ORDER BY f.salario DESC;


-- ---------------------------------------------------------------------
-- Consulta 15  [extra: subconsulta correlacionada com NOT EXISTS | SQL 11 INNER JOIN]
-- Sessões que ainda NÃO têm nenhuma reserva (a subconsulta depende da
-- linha externa, por isso é reavaliada para cada sessão).
-- ---------------------------------------------------------------------
SELECT a.nome AS espetaculo,
       s.numero,
       TO_CHAR(s.data, 'DD/MM/YYYY') AS data_sessao,
       s.vagas_disponiveis
  FROM sessao s
  JOIN atracao a ON a.codigo = s.codigo_espetaculo
 WHERE NOT EXISTS (SELECT 1
                     FROM reserva r
                    WHERE r.codigo_espetaculo = s.codigo_espetaculo
                      AND r.numero_sessao     = s.numero
                      AND r.data_sessao       = s.data)
 ORDER BY s.data, a.nome, s.numero;


-- ---------------------------------------------------------------------
-- Consulta 16  [extra: subconsulta na cláusula FROM (inline view) + função analítica]
-- Pódio dos 3 brinquedos mais visitados. RANK() não pode ser filtrado no
-- mesmo nível do WHERE, por isso a consulta é aninhada em uma inline view.
-- ---------------------------------------------------------------------
SELECT posicao, brinquedo, visitas
  FROM (SELECT a.nome AS brinquedo,
               COUNT(*) AS visitas,
               RANK() OVER (ORDER BY COUNT(*) DESC) AS posicao
          FROM frequenta fq
          JOIN operador o ON o.cpf = fq.cpf_operador
          JOIN atracao a  ON a.codigo = o.codigo_brinquedo_opera
         GROUP BY a.nome)
 WHERE posicao <= 3
 ORDER BY posicao, brinquedo;


-- =====================================================================
-- SEÇÃO 6 - OPERAÇÕES DE CONJUNTO
-- =====================================================================

-- ---------------------------------------------------------------------
-- Consulta 17  [SQL 24 UNION]
-- Lista única de contatos (funcionários + clientes). Os dois SELECT têm o
-- mesmo número e tipo de colunas; UNION remove linhas duplicadas.
-- ---------------------------------------------------------------------
SELECT 'Funcionário' AS tipo,
       f.primeiro_nome || ' ' || f.sobrenome AS nome,
       t.telefone
  FROM funcionario f
  JOIN telefone_funcionario t ON t.cpf_funcionario = f.cpf
UNION
SELECT 'Cliente',
       c.primeiro_nome || ' ' || c.sobrenome,
       t.telefone
  FROM cliente c
  JOIN telefone_cliente t ON t.cpf_cliente = c.cpf
 ORDER BY tipo, nome;


-- ---------------------------------------------------------------------
-- Consulta 18  [SQL 24 INTERSECT | SQL 18 IN]
-- Clientes que compraram ingresso DIGITAL e também FÍSICO (interseção dos
-- dois conjuntos de CPFs), com o nome vindo de uma subconsulta IN.
-- ---------------------------------------------------------------------
SELECT c.cpf, c.primeiro_nome, c.sobrenome
  FROM cliente c
 WHERE c.cpf IN (SELECT cpf_cliente FROM ingresso WHERE local_compra = 'Digital'
                 INTERSECT
                 SELECT cpf_cliente FROM ingresso WHERE local_compra = 'Física')
 ORDER BY c.primeiro_nome;


-- ---------------------------------------------------------------------
-- Consulta 19  [SQL 24 MINUS | SQL 18 IN]
-- Clientes que têm ingresso mas NUNCA reservaram um espetáculo
-- (conjunto de quem compra MENOS conjunto de quem reserva).
-- ---------------------------------------------------------------------
SELECT c.cpf, c.primeiro_nome, c.sobrenome
  FROM cliente c
 WHERE c.cpf IN (SELECT cpf_cliente FROM ingresso
                 MINUS
                 SELECT cpf_cliente FROM reserva)
 ORDER BY c.primeiro_nome;


-- =====================================================================
-- SEÇÃO 7 - VISÕES
-- =====================================================================

-- ---------------------------------------------------------------------
-- [SQL 25] CREATE VIEW  vw_ocupacao_sessao
-- Ocupação de cada sessão (lugares ocupados / capacidade) e quantas vagas
-- foram reservadas por clientes. LEFT JOIN mantém sessões sem reserva.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_ocupacao_sessao AS
SELECT a.nome                         AS espetaculo,
       s.codigo_espetaculo,
       s.numero,
       s.data,
       s.horario,
       e.capacidade_plateia,
       s.vagas_disponiveis,
       ROUND((e.capacidade_plateia - s.vagas_disponiveis)
             / e.capacidade_plateia * 100, 1) AS ocupacao_pct,
       NVL(SUM(r.quantidade_de_reservas), 0)   AS vagas_reservadas
  FROM sessao s
  JOIN espetaculo e ON e.codigo = s.codigo_espetaculo
  JOIN atracao a    ON a.codigo = e.codigo
  LEFT JOIN reserva r ON r.codigo_espetaculo = s.codigo_espetaculo
                     AND r.numero_sessao     = s.numero
                     AND r.data_sessao       = s.data
 GROUP BY a.nome, s.codigo_espetaculo, s.numero, s.data, s.horario,
          e.capacidade_plateia, s.vagas_disponiveis;

-- ---------------------------------------------------------------------
-- [SQL 25] CREATE VIEW  vw_funcionario_cargo
-- Unifica a generalização de Funcionário (técnico, operador, artista) em
-- uma só relação com a coluna "cargo". UNION ALL: sem custo de dedup,
-- pois um funcionário pertence a no máximo um subtipo.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_funcionario_cargo AS
SELECT f.cpf, f.primeiro_nome || ' ' || f.sobrenome AS nome, 'Técnico' AS cargo, f.salario
  FROM funcionario f JOIN tecnico t ON t.cpf = f.cpf
UNION ALL
SELECT f.cpf, f.primeiro_nome || ' ' || f.sobrenome, 'Operador', f.salario
  FROM funcionario f JOIN operador o ON o.cpf = f.cpf
UNION ALL
SELECT f.cpf, f.primeiro_nome || ' ' || f.sobrenome, 'Artista', f.salario
  FROM funcionario f JOIN artista a ON a.cpf = f.cpf;


-- ---------------------------------------------------------------------
-- Consulta 20  [SQL 25 uso da VIEW | SQL 21 ORDER BY]
-- Sessões com mais de 50% de ocupação, da mais cheia para a mais vazia.
-- ---------------------------------------------------------------------
SELECT espetaculo,
       numero,
       TO_CHAR(data, 'DD/MM/YYYY') AS data_sessao,
       capacidade_plateia,
       ocupacao_pct,
       vagas_reservadas
  FROM vw_ocupacao_sessao
 WHERE ocupacao_pct > 50
 ORDER BY ocupacao_pct DESC, data;


-- ---------------------------------------------------------------------
-- Consulta 21  [SQL 25 uso da VIEW | SQL 22 GROUP BY | SQL 14 AVG | SQL 15 COUNT | SQL 17 subconsulta]
-- Ocupação média por turno do dia. EXTRACT(HOUR FROM horario) lê a hora
-- do INTERVAL; o CASE classifica o turno numa inline view para que o
-- GROUP BY use o nome do turno (e não repita a expressão).
-- ---------------------------------------------------------------------
SELECT turno,
       COUNT(*)                   AS sessoes,
       ROUND(AVG(ocupacao_pct),1) AS ocupacao_media
  FROM (SELECT v.ocupacao_pct,
               CASE
                    WHEN EXTRACT(HOUR FROM v.horario) < 12 THEN '1-Manhã'
                    WHEN EXTRACT(HOUR FROM v.horario) < 18 THEN '2-Tarde'
                    ELSE '3-Noite'
               END AS turno
          FROM vw_ocupacao_sessao v)
 GROUP BY turno
 ORDER BY turno;


-- ---------------------------------------------------------------------
-- Consulta 22  [SQL 25 uso da VIEW | SQL 17 subconsulta correlacionada]
-- Quem ganha acima da média do PRÓPRIO cargo (técnico, operador ou
-- artista). A subconsulta correlacionada recalcula a média por cargo.
-- ---------------------------------------------------------------------
SELECT v.cargo, v.nome, v.salario
  FROM vw_funcionario_cargo v
 WHERE v.salario > (SELECT AVG(v2.salario)
                      FROM vw_funcionario_cargo v2
                     WHERE v2.cargo = v.cargo)
 ORDER BY v.cargo, v.salario DESC;


-- =====================================================================
-- SEÇÃO 8 - GRANT / REVOKE   [SQL 26]
-- =====================================================================
-- O Oracle Live SQL não permite criar usuários/roles nem conceder
-- privilégios, então os comandos abaixo ficam COMENTADOS (devem ser
-- executados por um DBA em um Oracle real, ex.: SQL*Plus como SYSTEM).
--
-- O que fazem:
--   * GRANT dá privilégios (de objeto: SELECT/INSERT/UPDATE/DELETE em uma
--     tabela ou view; de sistema: CREATE SESSION...) a um usuário ou role.
--   * REVOKE retira. Privilégio de OBJETO concedido WITH GRANT OPTION é
--     revogado em cascata; privilégio de SISTEMA concedido WITH ADMIN
--     OPTION, não.
--   * Princípio do menor privilégio: cada perfil só recebe o que precisa.
--
-- Cenário do parque: três perfis de acesso.
--
--   CREATE USER atendente  IDENTIFIED BY "Senha#Forte1";
--   CREATE USER analista   IDENTIFIED BY "Senha#Forte2";
--   CREATE ROLE role_bilheteria;
--   CREATE ROLE role_gerencia;
--
--   GRANT CREATE SESSION TO atendente, analista;
--
--   -- Bilheteria: vende ingresso e faz reservas, lê o catálogo de atrações.
--   GRANT SELECT, INSERT         ON ingresso   TO role_bilheteria;
--   GRANT SELECT, INSERT, UPDATE ON reserva    TO role_bilheteria;
--   GRANT SELECT                 ON atracao    TO role_bilheteria;
--   GRANT SELECT                 ON vw_ocupacao_sessao TO role_bilheteria;
--
--   -- Gerência: leitura dos relatórios; pode repassar a permissão.
--   GRANT SELECT ON vw_funcionario_cargo TO role_gerencia WITH GRANT OPTION;
--   GRANT SELECT ON vw_ocupacao_sessao   TO role_gerencia;
--
--   GRANT role_bilheteria TO atendente;
--   GRANT role_gerencia   TO analista;
--
--   -- Ação corretiva: atendente não pode mais alterar reservas.
--   REVOKE UPDATE ON reserva FROM role_bilheteria;
--
--   -- Desligamento do analista.
--   REVOKE role_gerencia FROM analista;
--
-- Boa prática: a visão vw_funcionario_cargo expõe salário; em produção
-- ela seria concedida só à gerência, nunca à bilheteria.
-- =====================================================================
