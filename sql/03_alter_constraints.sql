-- =====================================================================
-- 03_alter_constraints.sql
-- Projeto: Parque de Diversões (AV3 - Criação e Povoamento)
--
-- Por que este arquivo existe?
--   Há uma dependência circular entre OPERADOR e BRINQUEDO:
--     BRINQUEDO.cpf_gerente            -> OPERADOR.cpf   (Gerencia)
--     OPERADOR.codigo_brinquedo_opera  -> BRINQUEDO.codigo (Opera)
--   Nenhuma das duas tabelas pode ser criada primeiro com as duas FKs.
--   Solução: OPERADOR nasce sem a FK de brinquedo e ela é adicionada aqui,
--   depois que BRINQUEDO já existe.
-- =====================================================================

ALTER TABLE operador
    ADD CONSTRAINT fk_operador_brinquedo
    FOREIGN KEY (codigo_brinquedo_opera) REFERENCES brinquedo (codigo);
