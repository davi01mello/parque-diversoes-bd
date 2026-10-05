-- =====================================================================
-- 00_drop.sql
-- Projeto: Parque de Diversões (AV3 - Criação e Povoamento)
-- Remove todas as tabelas e sequences, para reexecutar tudo do zero.
--
-- Na PRIMEIRA execução, os erros ORA-00942 (tabela inexistente) e
-- ORA-02289 (sequence inexistente) são esperados e podem ser ignorados.
-- CASCADE CONSTRAINTS dispensa se preocupar com a ordem das FKs.
-- =====================================================================

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
