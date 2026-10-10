# Checklist da AV4 - Parque de Diversões

Equipe: Samuel de Almeida Farias Nascimento, Davi de Souza Mello, Maria Cláudia Silva Rocha, Pedro Wellington Ferreira Felizola Lucena e Guilherme Calistrato Nunes.

Arquivos entregues (executar nesta ordem no Oracle Live SQL): `sql/01_ddl.sql` -> `sql/02_povoamento.sql` -> `sql/04_av4_consultas.sql` -> `sql/05_av4_plsql.sql`.

46 itens: 26 de SQL e 20 de PL/SQL. A coluna "Linha" é a linha do arquivo onde o item aparece pela primeira vez.

## SQL (`sql/04_av4_consultas.sql`)

| # | Item | Onde está | Linha |
|---|------|-----------|-------|
| 1 | ALTER TABLE | Seção 1: `ALTER TABLE ... ADD` (valor do ingresso, situação do brinquedo) + CHECKs | 37 |
| 2 | CREATE INDEX | 4 índices: simples, FK, composto e baseado em função | 51 |
| 3 | INSERT INTO | Clientes, ingressos, peças, brinquedo novo (sequence) e `INSERT ... SELECT` | 70 |
| 4 | UPDATE | Reajuste com subconsulta, preço do ingresso com `EXISTS`, manutenção de brinquedos | 110 |
| 5 | DELETE | Remove peças obsoletas sem estoque e nunca usadas (`NOT IN`) | 139 |
| 6 | SELECT-FROM-WHERE | Consulta 1: admitidos 2019-2022 por faixa salarial | 155 |
| 7 | BETWEEN | Consulta 1 (datas e salário) | 155 |
| 8 | IN | Consulta 2: clientes de Recife/Olinda | 170 |
| 9 | LIKE | Consulta 2: e-mail gmail ou nome começando com M | 170 |
| 10 | IS NULL / IS NOT NULL | Consulta 3 (brinquedos sem gerente) e Consulta 4 (alocações encerradas) | 182 |
| 11 | INNER JOIN | Consulta 4 e Consulta 5 (junção de 4 tabelas) | 193 |
| 12 | MAX | Consulta 6 (maior salário por área) e Consulta 7 | 230 |
| 13 | MIN | Consulta 6 (menor salário por área) | 230 |
| 14 | AVG | Consulta 6 (média salarial) e Consulta 7 (ticket médio) | 230 |
| 15 | COUNT | Consulta 5 (visitas), Consulta 6 e Consulta 7 | 213 |
| 16 | LEFT / RIGHT / FULL OUTER JOIN | Consulta 8 (LEFT), Consulta 9 (RIGHT), Consulta 10 (FULL) | 273 |
| 17 | Subconsulta com operador relacional | Consulta 11 (salário > média) e Consulta 22 (correlacionada) | 332 |
| 18 | Subconsulta com IN | Consulta 12 (reservaram musical), 18 e 19 | 345 |
| 19 | Subconsulta com ANY | Consulta 13: mais rápidos que algum aquático | 365 |
| 20 | Subconsulta com ALL | Consulta 14: operadores que ganham mais que todos os técnicos | 379 |
| 21 | ORDER BY | Em quase todas as consultas (ex.: Consulta 1, 5, 20) | 155 |
| 22 | GROUP BY | Consulta 5, 6, 7, 8, 9 e 21 | 213 |
| 23 | HAVING | Consulta 6 e Consulta 7 | 230 |
| 24 | UNION / INTERSECT / MINUS | Consulta 17 (UNION), 18 (INTERSECT), 19 (MINUS) | 436 |
| 25 | CREATE VIEW | `vw_ocupacao_sessao` e `vw_funcionario_cargo` + Consultas 20 a 22 sobre elas | 485 |
| 26 | GRANT / REVOKE | Seção 8: roles e usuários, comentado (não executa no Live SQL), com explicação | 575 |

## PL/SQL (`sql/05_av4_plsql.sql`)

| # | Item | Onde está | Linha |
|---|------|-----------|-------|
| 1 | RECORD | `t_resumo_brinquedo` na especificação do pacote; usado na Demo C | 130 |
| 2 | TABLE (coleção) | `t_tab_resumo` (array associativo) e `t_lista_cpf` (nested table) | 139 |
| 3 | Bloco anônimo | Demos A a E (Parte 5) | 521 |
| 4 | CREATE PROCEDURE | `pr_reajustar_salarios` | 87 |
| 5 | CREATE FUNCTION | `fn_ocupacao_sessao` | 56 |
| 6 | %TYPE | Parâmetros e variáveis de quase todos os subprogramas | 59 |
| 7 | %ROWTYPE | `c_sessoes%ROWTYPE` no pacote; `funcionario%ROWTYPE` na Demo B | 326 |
| 8 | IF / ELSIF | `fn_classificar_ocupacao` | 183 |
| 9 | CASE WHEN | Ação sugerida em `pr_relatorio_sessoes`; faixa de custo na Demo C | 327 |
| 10 | LOOP ... EXIT WHEN | Laço do cursor explícito em `pr_relatorio_sessoes` | 325 |
| 11 | WHILE LOOP | `fn_distancia_mentoria` | 295 |
| 12 | FOR ... IN LOOP | Cursor FOR em `pr_resumo_brinquedos`; FOR numérico nas Demos C e A | 202 |
| 13 | SELECT ... INTO | `fn_ocupacao_sessao`, `pr_reservar`, Demo B | 59 |
| 14 | CURSOR (OPEN/FETCH/CLOSE) | `c_sessoes` com parâmetro em `pr_relatorio_sessoes` | 324 |
| 15 | EXCEPTION WHEN | `pr_reservar` (5 exceções), `fn_ocupacao_sessao`, Demos A e B | 59 |
| 16 | Parâmetros IN / OUT / IN OUT | `pr_reajustar_salarios` (IN/OUT) e `pr_reservar` (IN OUT) | 88 |
| 17 | CREATE PACKAGE | `pkg_parque` (especificação) | 124 |
| 18 | PACKAGE BODY | `pkg_parque` (corpo) | 174 |
| 19 | TRIGGER de comando | `trg_reserva_comando` (sem FOR EACH ROW) | 387 |
| 20 | TRIGGER de linha | `trg_reserva_vagas` e `trg_funcionario_salario` (FOR EACH ROW, :OLD/:NEW) | 414 |

## Notas

- GRANT/REVOKE (SQL 26) não executa no Live SQL (não há CREATE USER/ROLE nem concessão de privilégios); os comandos estão comentados na Seção 8 com a explicação do que cada um faz.
- O `ALTER TABLE` (SQL 1) só pode rodar uma vez; para repetir tudo, rode `01_ddl.sql` e `02_povoamento.sql` de novo antes.
- Todos os blocos de demonstração de PL/SQL terminam em `ROLLBACK`, então o banco volta ao estado anterior.
- Horários são `INTERVAL`; as consultas usam `EXTRACT(HOUR FROM horario)`.
