-- =====================================================================
-- 01_sequences.sql
-- Projeto: Parque de Diversões (AV3 - Criação e Povoamento)
-- Sequences para as chaves primárias geradas pelo sistema.
--
-- CPF, Nome (Área/Evento) e Numero de Sessão NÃO usam sequence:
-- são identificadores naturais ou discriminadores de entidade fraca.
-- =====================================================================

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
