-- =====================================================================
-- 05_av4_plsql.sql

-- Organização (tag [PL n] = item do checklist de PL da AV4):
--   Parte 1  Infraestrutura: tabela/sequence de log
--   Parte 2  Subprogramas standalone: FUNCTION e PROCEDURE
--   Parte 3  PACKAGE pkg_parque (especificação + corpo)
--   Parte 4  TRIGGERS: de comando e de linha
--   Parte 5  Blocos anônimos de demonstração (cada um termina em ROLLBACK,
--            então o banco volta ao estado anterior e o script é reexecutável)
--   Parte 6  Verificação: objetos válidos, erros de compilação, função no SQL
--
-- A saída do DBMS_OUTPUT aparece sozinha no painel de resultados do Live
-- SQL. Em SQL*Plus / SQL Developer, rode antes: SET SERVEROUTPUT ON
-- =====================================================================


-- =====================================================================
-- PARTE 1 - INFRAESTRUTURA DE LOG
-- =====================================================================
-- DROPs primeiro (na 1ª execução, ORA-00942 e ORA-02289 são esperados).
DROP TABLE log_operacao CASCADE CONSTRAINTS;
DROP SEQUENCE seq_log_operacao;

CREATE SEQUENCE seq_log_operacao START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE TABLE log_operacao (
    codigo     NUMBER(8)      NOT NULL,
    tabela     VARCHAR2(30)   NOT NULL,
    operacao   VARCHAR2(10)   NOT NULL,
    detalhe    VARCHAR2(200),
    usuario    VARCHAR2(128)  NOT NULL,
    data_hora  TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT pk_log_operacao    PRIMARY KEY (codigo),
    CONSTRAINT ck_log_operacao_op CHECK (operacao IN ('INSERT', 'UPDATE', 'DELETE'))
);


-- =====================================================================
-- PARTE 2 - SUBPROGRAMAS STANDALONE
-- =====================================================================

-- ---------------------------------------------------------------------
-- [PL 5] CREATE FUNCTION   fn_ocupacao_sessao
-- Percentual de ocupação de uma sessão: (capacidade - vagas) / capacidade.
-- Retorna NULL se a sessão não existir (em vez de estourar exceção).
-- Usa [PL 13] SELECT ... INTO, [PL 6] %TYPE e [PL 15] EXCEPTION WHEN.
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_ocupacao_sessao (
    p_codigo_espetaculo IN sessao.codigo_espetaculo%TYPE,
    p_numero            IN sessao.numero%TYPE,
    p_data              IN sessao.data%TYPE
) RETURN NUMBER
IS
    v_capacidade espetaculo.capacidade_plateia%TYPE;
    v_vagas      sessao.vagas_disponiveis%TYPE;
BEGIN
    SELECT e.capacidade_plateia, s.vagas_disponiveis
      INTO v_capacidade, v_vagas
      FROM sessao s
      JOIN espetaculo e ON e.codigo = s.codigo_espetaculo
     WHERE s.codigo_espetaculo = p_codigo_espetaculo
       AND s.numero            = p_numero
       AND s.data              = p_data;

    RETURN ROUND((v_capacidade - v_vagas) / v_capacidade * 100, 1);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END fn_ocupacao_sessao;
/


-- ---------------------------------------------------------------------
-- [PL 4] CREATE PROCEDURE   pr_reajustar_salarios
-- [PL 16] parâmetros IN (nivel, percentual) e OUT (qtd, nova folha).
-- Reajusta o salário dos operadores de um nível de certificação e devolve
-- quantos foram afetados e a nova folha desse grupo.
-- Rejeita percentual fora de 0..20 com erro de aplicação (-20002).
-- ---------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE pr_reajustar_salarios (
    p_nivel         IN  operador.nivel_certificacao%TYPE,
    p_percentual    IN  NUMBER,
    p_qtd_afetados  OUT NUMBER,
    p_folha_nova    OUT NUMBER
)
IS
BEGIN
    IF p_percentual IS NULL OR p_percentual < 0 OR p_percentual > 20 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Percentual de reajuste deve estar entre 0 e 20.');
    END IF;

    UPDATE funcionario
       SET salario = ROUND(salario * (1 + p_percentual / 100), 2)
     WHERE cpf IN (SELECT cpf FROM operador WHERE nivel_certificacao = p_nivel);

    p_qtd_afetados := SQL%ROWCOUNT;

    SELECT NVL(SUM(salario), 0)
      INTO p_folha_nova
      FROM funcionario
     WHERE cpf IN (SELECT cpf FROM operador WHERE nivel_certificacao = p_nivel);
END pr_reajustar_salarios;
/


-- =====================================================================
-- PARTE 3 - PACKAGE pkg_parque
-- =====================================================================

-- ---------------------------------------------------------------------
-- [PL 17] CREATE OR REPLACE PACKAGE (especificação = interface pública)
-- Reúne tipos, exceção e constantes públicos e a assinatura dos
-- subprogramas. Quem usa o pacote só enxerga isto, não o corpo.
-- ---------------------------------------------------------------------
CREATE OR REPLACE PACKAGE pkg_parque AS

    -- [PL 1] RECORD: uma linha do resumo de manutenção por brinquedo.
    TYPE t_resumo_brinquedo IS RECORD (
        codigo        atracao.codigo%TYPE,
        nome          atracao.nome%TYPE,
        nome_area     atracao.nome_area%TYPE,
        qtd_revisoes  NUMBER,
        custo_pecas   NUMBER
    );

    -- [PL 2] TABLE: coleção de records (array associativo indexado por inteiro)
    -- e coleção de CPFs (nested table, precisa de BULK COLLECT para ser preenchida).
    TYPE t_tab_resumo IS TABLE OF t_resumo_brinquedo INDEX BY PLS_INTEGER;
    TYPE t_lista_cpf  IS TABLE OF funcionario.cpf%TYPE;

    -- Exceção do domínio: sessão sem nenhuma vaga.
    e_sem_vagas EXCEPTION;

    -- Limites (em %) usados na classificação da ocupação.
    c_limite_lotada CONSTANT NUMBER := 95;
    c_limite_alta   CONSTANT NUMBER := 70;
    c_limite_media  CONSTANT NUMBER := 40;

    FUNCTION fn_classificar_ocupacao (p_percentual IN NUMBER) RETURN VARCHAR2;

    PROCEDURE pr_resumo_brinquedos (p_resumo OUT t_tab_resumo);

    PROCEDURE pr_reservar (
        p_cpf_cliente       IN     reserva.cpf_cliente%TYPE,
        p_codigo_espetaculo IN     reserva.codigo_espetaculo%TYPE,
        p_numero_sessao     IN     reserva.numero_sessao%TYPE,
        p_data_sessao       IN     reserva.data_sessao%TYPE,
        p_quantidade        IN OUT NUMBER,
        p_status            OUT    VARCHAR2
    );

    FUNCTION fn_distancia_mentoria (p_cpf IN funcionario.cpf%TYPE) RETURN NUMBER;

    PROCEDURE pr_relatorio_sessoes (p_data IN DATE);

END pkg_parque;
/


-- ---------------------------------------------------------------------
-- [PL 18] CREATE OR REPLACE PACKAGE BODY (implementação, escondida)
-- ---------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY pkg_parque AS

    -- Exceção privada do corpo, ligada ao erro ORA-02291 (FK sem pai).
    e_fk_violada EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_fk_violada, -2291);

    ------------------------------------------------------------------
    -- [PL 8] IF / ELSIF: rótulo de ocupação da sessão.
    ------------------------------------------------------------------
    FUNCTION fn_classificar_ocupacao (p_percentual IN NUMBER) RETURN VARCHAR2
    IS
    BEGIN
        IF p_percentual IS NULL THEN
            RETURN 'Sessão inexistente';
        ELSIF p_percentual >= c_limite_lotada THEN
            RETURN 'Lotada';
        ELSIF p_percentual >= c_limite_alta THEN
            RETURN 'Alta demanda';
        ELSIF p_percentual >= c_limite_media THEN
            RETURN 'Moderada';
        ELSE
            RETURN 'Baixa';
        END IF;
    END fn_classificar_ocupacao;

    ------------------------------------------------------------------
    -- [PL 12] FOR ... IN (cursor FOR LOOP) preenchendo a coleção de
    -- records [PL 1][PL 2]. Todos os brinquedos entram, inclusive os
    -- que nunca foram revisados (LEFT JOIN).
    ------------------------------------------------------------------
    PROCEDURE pr_resumo_brinquedos (p_resumo OUT t_tab_resumo)
    IS
        v_i PLS_INTEGER := 0;
    BEGIN
        FOR r IN (SELECT a.codigo,
                         a.nome,
                         a.nome_area,
                         COUNT(DISTINCT rv.codigo) AS qtd_revisoes,
                         NVL(SUM(u.custo), 0)      AS custo_pecas
                    FROM brinquedo b
                    JOIN atracao a       ON a.codigo = b.codigo
                    LEFT JOIN revisao rv ON rv.codigo_brinquedo = b.codigo
                    LEFT JOIN usa u      ON u.codigo_revisao = rv.codigo
                   GROUP BY a.codigo, a.nome, a.nome_area
                   ORDER BY a.codigo)
        LOOP
            v_i := v_i + 1;
            p_resumo(v_i).codigo       := r.codigo;
            p_resumo(v_i).nome         := r.nome;
            p_resumo(v_i).nome_area    := r.nome_area;
            p_resumo(v_i).qtd_revisoes := r.qtd_revisoes;
            p_resumo(v_i).custo_pecas  := r.custo_pecas;
        END LOOP;
    END pr_resumo_brinquedos;

    ------------------------------------------------------------------
    -- [PL 16] IN / OUT / IN OUT: p_quantidade entra com o pedido e sai
    -- com o que foi de fato reservado; p_status devolve o resultado.
    -- [PL 13] SELECT ... INTO ... FOR UPDATE trava a sessão enquanto a
    -- reserva é decidida; [PL 15] trata cada falha possível.
    ------------------------------------------------------------------
    PROCEDURE pr_reservar (
        p_cpf_cliente       IN     reserva.cpf_cliente%TYPE,
        p_codigo_espetaculo IN     reserva.codigo_espetaculo%TYPE,
        p_numero_sessao     IN     reserva.numero_sessao%TYPE,
        p_data_sessao       IN     reserva.data_sessao%TYPE,
        p_quantidade        IN OUT NUMBER,
        p_status            OUT    VARCHAR2
    )
    IS
        v_vagas sessao.vagas_disponiveis%TYPE;
    BEGIN
        p_status := 'OK';

        IF p_quantidade IS NULL OR p_quantidade < 1 THEN
            p_quantidade := 0;
            p_status := 'ERRO: quantidade deve ser maior que zero';
            RETURN;
        END IF;

        SELECT vagas_disponiveis
          INTO v_vagas
          FROM sessao
         WHERE codigo_espetaculo = p_codigo_espetaculo
           AND numero            = p_numero_sessao
           AND data              = p_data_sessao
           FOR UPDATE;

        IF v_vagas = 0 THEN
            RAISE e_sem_vagas;
        ELSIF p_quantidade > v_vagas THEN
            -- Reserva parcial: reduz o pedido ao que ainda existe.
            p_quantidade := v_vagas;
            p_status := 'PARCIAL: só havia ' || v_vagas || ' vaga(s)';
        END IF;

        INSERT INTO reserva (cpf_cliente, codigo_espetaculo, numero_sessao,
                             data_sessao, quantidade_de_reservas)
        VALUES (p_cpf_cliente, p_codigo_espetaculo, p_numero_sessao,
                p_data_sessao, p_quantidade);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_quantidade := 0;
            p_status := 'ERRO: sessão inexistente';
        WHEN e_sem_vagas THEN
            p_quantidade := 0;
            p_status := 'ERRO: sessão esgotada';
        WHEN DUP_VAL_ON_INDEX THEN
            p_quantidade := 0;
            p_status := 'ERRO: cliente já tem reserva nesta sessão';
        WHEN e_fk_violada THEN
            p_quantidade := 0;
            p_status := 'ERRO: cliente não cadastrado';
        WHEN OTHERS THEN
            p_quantidade := 0;
            p_status := 'ERRO: ' || SQLERRM;
    END pr_reservar;

    ------------------------------------------------------------------
    -- [PL 11] WHILE LOOP: sobe a cadeia de mentoria até o topo e devolve
    -- quantos níveis existem acima do funcionário. Se houver mais de um
    -- mentor, segue o de menor CPF (MIN) para o resultado ser
    -- determinístico. O limite de 10 níveis protege contra ciclos.
    ------------------------------------------------------------------
    FUNCTION fn_distancia_mentoria (p_cpf IN funcionario.cpf%TYPE) RETURN NUMBER
    IS
        v_atual   funcionario.cpf%TYPE := p_cpf;
        v_mentor  funcionario.cpf%TYPE;
        v_niveis  NUMBER := 0;
        v_subindo BOOLEAN := TRUE;
    BEGIN
        WHILE v_subindo AND v_niveis < 10 LOOP
            SELECT MIN(cpf_mentor)
              INTO v_mentor
              FROM mentora
             WHERE cpf_mentorado = v_atual;

            IF v_mentor IS NULL THEN
                v_subindo := FALSE;
            ELSE
                v_atual  := v_mentor;
                v_niveis := v_niveis + 1;
            END IF;
        END LOOP;
        RETURN v_niveis;
    END fn_distancia_mentoria;

    ------------------------------------------------------------------
    -- [PL 14] CURSOR explícito com parâmetro: OPEN / FETCH / CLOSE
    -- [PL 10] LOOP ... EXIT WHEN c%NOTFOUND
    -- [PL 7]  %ROWTYPE do cursor
    -- [PL 9]  CASE WHEN para sugerir a ação operacional
    ------------------------------------------------------------------
    PROCEDURE pr_relatorio_sessoes (p_data IN DATE)
    IS
        CURSOR c_sessoes (cp_data DATE) IS
            SELECT s.codigo_espetaculo,
                   a.nome AS espetaculo,
                   s.numero,
                   EXTRACT(HOUR FROM s.horario)   AS hora,
                   EXTRACT(MINUTE FROM s.horario) AS minuto,
                   s.vagas_disponiveis
              FROM sessao s
              JOIN atracao a ON a.codigo = s.codigo_espetaculo
             WHERE s.data = cp_data
             ORDER BY s.horario, s.numero;

        v_sessao  c_sessoes%ROWTYPE;
        v_pct     NUMBER;
        v_classe  VARCHAR2(20);
        v_acao    VARCHAR2(40);
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Sessões em ' || TO_CHAR(p_data, 'DD/MM/YYYY'));

        OPEN c_sessoes(p_data);
        LOOP
            FETCH c_sessoes INTO v_sessao;
            EXIT WHEN c_sessoes%NOTFOUND;

            v_pct    := fn_ocupacao_sessao(v_sessao.codigo_espetaculo, v_sessao.numero, p_data);
            v_classe := fn_classificar_ocupacao(v_pct);

            v_acao := CASE
                          WHEN v_classe = 'Lotada'       THEN 'Encerrar a venda de vagas'
                          WHEN v_classe = 'Alta demanda' THEN 'Reforçar a equipe de apoio'
                          WHEN v_classe = 'Moderada'     THEN 'Manter operação normal'
                          ELSE 'Divulgar a sessão'
                      END;

            DBMS_OUTPUT.PUT_LINE('  ' || LPAD(TO_CHAR(v_sessao.hora), 2, '0') || ':'
                                 || LPAD(TO_CHAR(v_sessao.minuto), 2, '0') || ' '
                                 || RPAD(v_sessao.espetaculo, 26) || ' sessão ' || v_sessao.numero
                                 || ' | ' || TO_CHAR(v_pct) || '% | ' || v_classe
                                 || ' -> ' || v_acao);
        END LOOP;

        IF c_sessoes%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  (nenhuma sessão nesta data)');
        END IF;
        CLOSE c_sessoes;
    END pr_relatorio_sessoes;

END pkg_parque;
/


-- =====================================================================
-- PARTE 4 - TRIGGERS
-- =====================================================================

-- ---------------------------------------------------------------------
-- [PL 19] TRIGGER DE COMANDO (statement-level): sem FOR EACH ROW.
-- Dispara UMA vez por comando DML em RESERVA, mesmo que o comando atinja
-- 100 linhas (ou nenhuma). Registra quem fez que tipo de operação.
-- INSERTING / UPDATING / DELETING dizem qual comando disparou.
-- ---------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_reserva_comando
AFTER INSERT OR UPDATE OR DELETE ON reserva
DECLARE
    v_operacao log_operacao.operacao%TYPE;
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
    ELSE
        v_operacao := 'DELETE';
    END IF;

    INSERT INTO log_operacao (codigo, tabela, operacao, detalhe, usuario)
    VALUES (seq_log_operacao.NEXTVAL, 'RESERVA', v_operacao,
            'COMANDO: um comando ' || v_operacao || ' executado sobre RESERVA',
            SYS_CONTEXT('USERENV', 'SESSION_USER'));
END trg_reserva_comando;
/


-- ---------------------------------------------------------------------
-- [PL 20] TRIGGER DE LINHA (row-level): FOR EACH ROW.
-- Dispara uma vez POR LINHA de RESERVA afetada e enxerga :OLD e :NEW.
-- Regra de negócio: a reserva consome vagas da SESSÃO.
--   INSERT -> subtrai :NEW.quantidade
--   UPDATE -> subtrai só a diferença (:NEW - :OLD)
--   DELETE -> devolve :OLD.quantidade
-- Se faltar vaga, recusa a operação com erro -20001.
-- BEFORE: valida antes de gravar. Não há tabela mutante: o trigger
-- altera SESSAO, não a própria RESERVA.
-- ---------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_reserva_vagas
BEFORE INSERT OR UPDATE OF quantidade_de_reservas OR DELETE ON reserva
FOR EACH ROW
DECLARE
    v_vagas    sessao.vagas_disponiveis%TYPE;
    v_delta    NUMBER;
    v_operacao log_operacao.operacao%TYPE;
BEGIN
    -- INSERTING/UPDATING/DELETING só valem em código PL/SQL, não dentro de
    -- um comando SQL; por isso o valor vai antes para uma variável.
    IF INSERTING THEN
        v_operacao := 'INSERT';
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
    ELSE
        v_operacao := 'DELETE';
    END IF;

    IF DELETING THEN
        UPDATE sessao
           SET vagas_disponiveis = vagas_disponiveis + :OLD.quantidade_de_reservas
         WHERE codigo_espetaculo = :OLD.codigo_espetaculo
           AND numero            = :OLD.numero_sessao
           AND data              = :OLD.data_sessao;

        INSERT INTO log_operacao (codigo, tabela, operacao, detalhe, usuario)
        VALUES (seq_log_operacao.NEXTVAL, 'RESERVA', v_operacao,
                'LINHA: devolveu ' || :OLD.quantidade_de_reservas || ' vaga(s) da sessão '
                || :OLD.numero_sessao || ' do espetáculo ' || :OLD.codigo_espetaculo,
                SYS_CONTEXT('USERENV', 'SESSION_USER'));
    ELSE
        IF INSERTING THEN
            v_delta := :NEW.quantidade_de_reservas;
        ELSE
            v_delta := :NEW.quantidade_de_reservas - :OLD.quantidade_de_reservas;
        END IF;

        SELECT vagas_disponiveis
          INTO v_vagas
          FROM sessao
         WHERE codigo_espetaculo = :NEW.codigo_espetaculo
           AND numero            = :NEW.numero_sessao
           AND data              = :NEW.data_sessao;

        IF v_delta > v_vagas THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Sem vagas: pedido de ' || v_delta || ' e restam ' || v_vagas || '.');
        END IF;

        UPDATE sessao
           SET vagas_disponiveis = vagas_disponiveis - v_delta
         WHERE codigo_espetaculo = :NEW.codigo_espetaculo
           AND numero            = :NEW.numero_sessao
           AND data              = :NEW.data_sessao;

        INSERT INTO log_operacao (codigo, tabela, operacao, detalhe, usuario)
        VALUES (seq_log_operacao.NEXTVAL, 'RESERVA', v_operacao,
                'LINHA: variação de ' || v_delta || ' vaga(s) na sessão '
                || :NEW.numero_sessao || ' do espetáculo ' || :NEW.codigo_espetaculo,
                SYS_CONTEXT('USERENV', 'SESSION_USER'));
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Sessão inexistente: deixa a FK de RESERVA recusar com ORA-02291.
        NULL;
END trg_reserva_vagas;
/


-- ---------------------------------------------------------------------
-- [PL 20] Segundo TRIGGER DE LINHA, agora com cláusula WHEN:
-- só dispara se o salário realmente mudou. Proíbe redução de salário
-- (irredutibilidade) e registra todo aumento no log.
-- ---------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_funcionario_salario
BEFORE UPDATE OF salario ON funcionario
FOR EACH ROW
WHEN (NEW.salario <> OLD.salario)
BEGIN
    IF :NEW.salario < :OLD.salario THEN
        RAISE_APPLICATION_ERROR(-20010,
            'Redução de salário não permitida (CPF ' || :OLD.cpf || ').');
    END IF;

    INSERT INTO log_operacao (codigo, tabela, operacao, detalhe, usuario)
    VALUES (seq_log_operacao.NEXTVAL, 'FUNCIONARIO', 'UPDATE',
            'LINHA: CPF ' || :OLD.cpf || ' salário ' || :OLD.salario || ' -> ' || :NEW.salario,
            SYS_CONTEXT('USERENV', 'SESSION_USER'));
END trg_funcionario_salario;
/


-- =====================================================================
-- PARTE 5 - BLOCOS ANÔNIMOS DE DEMONSTRAÇÃO
-- =====================================================================

-- ---------------------------------------------------------------------
-- Demo A  [PL 3 bloco anônimo | PL 4 procedure | PL 16 IN/OUT | PL 20 trigger de linha | PL 15 exceções]
-- Reajusta 10% dos operadores nível 1, mostra o log do trigger e prova
-- que o trigger barra redução de salário. Termina em ROLLBACK.
-- ---------------------------------------------------------------------
DECLARE
    v_qtd    NUMBER;
    v_folha  NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Demo A: reajuste e irredutibilidade ---');

    pr_reajustar_salarios(1, 10, v_qtd, v_folha);
    DBMS_OUTPUT.PUT_LINE('Operadores nível 1 reajustados: ' || v_qtd
                         || ' | nova folha do grupo: R$ ' || v_folha);

    FOR l IN (SELECT detalhe FROM log_operacao WHERE tabela = 'FUNCIONARIO' ORDER BY codigo)
    LOOP
        DBMS_OUTPUT.PUT_LINE('  log: ' || l.detalhe);
    END LOOP;

    -- Percentual inválido: a procedure recusa com -20002.
    BEGIN
        pr_reajustar_salarios(1, 50, v_qtd, v_folha);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Reajuste de 50% recusado: ' || SQLERRM);
    END;

    -- Redução de salário: o trigger de linha recusa com -20010.
    BEGIN
        UPDATE funcionario SET salario = salario - 100 WHERE cpf = '80451081340';
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Redução recusada pelo trigger: ' || SQLERRM);
    END;

    ROLLBACK;
END;
/


-- ---------------------------------------------------------------------
-- Demo B  [PL 3 | PL 6 %TYPE | PL 7 %ROWTYPE | PL 13 SELECT INTO | PL 15 NO_DATA_FOUND / TOO_MANY_ROWS]
-- SELECT ... INTO exige EXATAMENTE uma linha: zero linhas dá
-- NO_DATA_FOUND e mais de uma dá TOO_MANY_ROWS.
-- ---------------------------------------------------------------------
DECLARE
    v_func     funcionario%ROWTYPE;                 -- linha inteira de FUNCIONARIO
    v_cpf      operador.cpf%TYPE := '84057617647';  -- mesmo tipo da coluna
    v_nivel    operador.nivel_certificacao%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Demo B: SELECT INTO e exceções ---');

    SELECT * INTO v_func FROM funcionario WHERE cpf = v_cpf;
    SELECT nivel_certificacao INTO v_nivel FROM operador WHERE cpf = v_cpf;
    DBMS_OUTPUT.PUT_LINE('Funcionário: ' || v_func.primeiro_nome || ' ' || v_func.sobrenome
                         || ' | salário R$ ' || v_func.salario || ' | nível ' || v_nivel);

    BEGIN
        SELECT * INTO v_func FROM funcionario WHERE cpf = '00000000000';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND: nenhum funcionário com esse CPF.');
    END;

    BEGIN
        SELECT * INTO v_func FROM funcionario WHERE salario > 3000;
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS: a consulta devolveu várias linhas.');
    END;
END;
/


-- ---------------------------------------------------------------------
-- Demo C  [PL 1 RECORD | PL 2 TABLE | PL 9 CASE | PL 12 FOR numérico | PL 11 WHILE via função]
-- Resumo de manutenção por brinquedo (coleção de records) e, com uma
-- nested table + BULK COLLECT, a distância de cada gerente ao topo da
-- cadeia de mentoria.
-- ---------------------------------------------------------------------
DECLARE
    v_resumo   pkg_parque.t_tab_resumo;
    v_linha    pkg_parque.t_resumo_brinquedo;
    v_gerentes pkg_parque.t_lista_cpf;
    v_nome     funcionario.primeiro_nome%TYPE;
    v_faixa    VARCHAR2(10);
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Demo C: coleções, record e CASE ---');

    pkg_parque.pr_resumo_brinquedos(v_resumo);
    FOR i IN v_resumo.FIRST .. v_resumo.LAST LOOP
        v_linha := v_resumo(i);
        v_faixa := CASE
                       WHEN v_linha.custo_pecas > 20000 THEN 'ALTO'
                       WHEN v_linha.custo_pecas > 5000  THEN 'MÉDIO'
                       ELSE 'BAIXO'
                   END;
        DBMS_OUTPUT.PUT_LINE(RPAD(v_linha.nome, 22) || RPAD(v_linha.nome_area, 16)
                             || v_linha.qtd_revisoes || ' revisões | peças R$ '
                             || TO_CHAR(v_linha.custo_pecas, 'FM999G990D00') || ' | custo ' || v_faixa);
    END LOOP;

    SELECT cpf_gerente
      BULK COLLECT INTO v_gerentes
      FROM brinquedo
     WHERE cpf_gerente IS NOT NULL
     ORDER BY cpf_gerente;

    FOR i IN 1 .. v_gerentes.COUNT LOOP
        SELECT primeiro_nome INTO v_nome FROM funcionario WHERE cpf = v_gerentes(i);
        DBMS_OUTPUT.PUT_LINE('Gerente ' || RPAD(v_nome, 10) || ' está a '
                             || pkg_parque.fn_distancia_mentoria(v_gerentes(i))
                             || ' nível(is) do topo da mentoria');
    END LOOP;
END;
/


-- ---------------------------------------------------------------------
-- Demo D  [PL 16 IN OUT / OUT | PL 15 exceções | PL 20 trigger de linha]
-- Cinco chamadas a pkg_parque.pr_reservar, uma por desfecho possível.
-- A sessão 2 do Teatro de Fantoches (código 13) em 13/09 tem 47 vagas.
-- Termina em ROLLBACK, devolvendo as vagas.
-- ---------------------------------------------------------------------
DECLARE
    v_qtd     NUMBER;
    v_status  VARCHAR2(100);
    v_vagas   sessao.vagas_disponiveis%TYPE;

    PROCEDURE tentar (p_cpf VARCHAR2, p_cod NUMBER, p_num NUMBER, p_data DATE, p_pedido NUMBER) IS
    BEGIN
        v_qtd := p_pedido;
        pkg_parque.pr_reservar(p_cpf, p_cod, p_num, p_data, v_qtd, v_status);
        DBMS_OUTPUT.PUT_LINE('pedido ' || RPAD(p_pedido, 3) || '-> reservado ' || RPAD(v_qtd, 3)
                             || '| ' || v_status);
    END tentar;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Demo D: reservas ---');

    -- 1) Pedido maior que as vagas: vira reserva PARCIAL (IN OUT devolve 47).
    tentar('94571710550', 13, 2, DATE '2026-09-13', 60);
    SELECT vagas_disponiveis INTO v_vagas
      FROM sessao WHERE codigo_espetaculo = 13 AND numero = 2 AND data = DATE '2026-09-13';
    DBMS_OUTPUT.PUT_LINE('   vagas restantes (trigger de linha): ' || v_vagas);

    -- 2) Agora a sessão está esgotada.
    tentar('06537026555', 13, 2, DATE '2026-09-13', 1);

    -- 3) Sessão que não existe.
    tentar('28028765467', 13, 9, DATE '2026-12-31', 1);

    -- 4) Cliente que já reservou esta sessão (PK de RESERVA).
    tentar('13393065815', 11, 1, DATE '2026-09-12', 1);

    -- 5) CPF que não é cliente (FK -> ORA-02291).
    tentar('99999999999', 11, 1, DATE '2026-09-12', 1);

    ROLLBACK;
END;
/


-- ---------------------------------------------------------------------
-- Demo E  [PL 19 trigger de comando x PL 20 trigger de linha | PL 10 EXIT WHEN | PL 14 cursor]
-- Um único UPDATE atinge 4 reservas de 20/09: o trigger de COMANDO grava
-- 1 linha de log; o trigger de LINHA grava 4. Depois, o relatório de
-- sessões do dia usa o cursor explícito do pacote.
-- ---------------------------------------------------------------------
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Demo E: trigger de comando x trigger de linha ---');

    UPDATE reserva
       SET quantidade_de_reservas = quantidade_de_reservas
     WHERE data_sessao = DATE '2026-09-20';
    DBMS_OUTPUT.PUT_LINE('Reservas atingidas pelo UPDATE: ' || SQL%ROWCOUNT);

    FOR l IN (SELECT SUBSTR(detalhe, 1, INSTR(detalhe, ':') - 1) AS tipo_trigger,
                     COUNT(*) AS execucoes
                FROM log_operacao
               WHERE tabela = 'RESERVA'
               GROUP BY SUBSTR(detalhe, 1, INSTR(detalhe, ':') - 1)
               ORDER BY 1)
    LOOP
        DBMS_OUTPUT.PUT_LINE('  trigger de ' || RPAD(l.tipo_trigger, 8) || ': '
                             || l.execucoes || ' execução(ões) registrada(s)');
    END LOOP;
    ROLLBACK;

    DBMS_OUTPUT.PUT_LINE('--- Relatório de sessões ---');
    pkg_parque.pr_relatorio_sessoes(DATE '2026-09-13');
    pkg_parque.pr_relatorio_sessoes(DATE '2026-12-25');
END;
/


-- =====================================================================
-- PARTE 6 - VERIFICAÇÃO
-- =====================================================================

-- Todos os objetos PL/SQL devem estar VALID.
SELECT object_type, object_name, status
  FROM user_objects
 WHERE object_type IN ('FUNCTION', 'PROCEDURE', 'PACKAGE', 'PACKAGE BODY', 'TRIGGER')
 ORDER BY object_type, object_name;

-- Erros de compilação (deve voltar VAZIO). Se aparecer linha, mande o
-- NAME, LINE e TEXT para a equipe.
SELECT name, type, line, text
  FROM user_errors
 ORDER BY name, type, sequence;

-- A função PL/SQL também pode ser chamada de dentro de uma consulta SQL.
SELECT s.codigo_espetaculo,
       s.numero,
       TO_CHAR(s.data, 'DD/MM/YYYY')                       AS data_sessao,
       fn_ocupacao_sessao(s.codigo_espetaculo, s.numero, s.data) AS ocupacao_pct,
       pkg_parque.fn_classificar_ocupacao(
           fn_ocupacao_sessao(s.codigo_espetaculo, s.numero, s.data)) AS situacao
  FROM sessao s
 ORDER BY ocupacao_pct DESC, s.data;
