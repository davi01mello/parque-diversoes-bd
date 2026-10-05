-- =====================================================================
-- 05_verificacao.sql
-- Projeto: Parque de Diversões (AV3 - Criação e Povoamento)
-- Consultas de conferência (opcional): mostram que o povoamento exercita
-- as regras do minimundo. Todas usam SQL padrão, sem recursos de um SGBD só.
-- =====================================================================

-- 1) Atrações por área e tipo (especialização disjunta-total)
SELECT a.nome_area, a.codigo, a.nome,
       CASE WHEN b.codigo IS NOT NULL THEN 'Brinquedo' ELSE 'Espetáculo' END AS tipo
FROM atracao a
LEFT JOIN brinquedo b ON b.codigo = a.codigo
ORDER BY a.nome_area, a.codigo;

-- 2) Gerencia x Opera são fatos independentes:
--    o gerente pode não operar nenhum brinquedo, ou operar o mesmo que gerencia
SELECT b.codigo AS brinquedo,
       a.nome AS nome_brinquedo,
       f.primeiro_nome || ' ' || f.sobrenome AS gerente,
       CASE WHEN o.codigo_brinquedo_opera IS NULL THEN 'não opera nenhum brinquedo'
            WHEN o.codigo_brinquedo_opera = b.codigo THEN 'também opera este brinquedo'
            ELSE 'opera outro brinquedo' END AS situacao_como_operador
FROM brinquedo b
JOIN atracao a ON a.codigo = b.codigo
JOIN operador o ON o.cpf = b.cpf_gerente
JOIN funcionario f ON f.cpf = o.cpf
ORDER BY b.codigo;

-- 3) Histórico de alocação (relacionamento temporal Trabalha_Em)
--    data_fim vazia = alocação atual
SELECT f.primeiro_nome || ' ' || f.sobrenome AS funcionario,
       t.nome_area, t.data_inicio, t.data_fim
FROM trabalha_em t
JOIN funcionario f ON f.cpf = t.cpf_funcionario
WHERE t.cpf_funcionario IN (SELECT cpf_funcionario FROM trabalha_em
                            GROUP BY cpf_funcionario HAVING COUNT(*) > 1)
ORDER BY f.primeiro_nome, t.data_inicio;

-- 4) Custo de reposição de peças por brinquedo (entidade associativa Revisão + Usa)
SELECT a.nome AS brinquedo,
       COUNT(DISTINCT r.codigo) AS revisoes,
       COALESCE(SUM(u.custo), 0) AS custo_total
FROM brinquedo b
JOIN atracao a ON a.codigo = b.codigo
JOIN revisao r ON r.codigo_brinquedo = b.codigo
LEFT JOIN usa u ON u.codigo_revisao = r.codigo
GROUP BY a.nome
ORDER BY custo_total DESC;

-- 5) Ocupação das sessões (entidade fraca Sessão + Reserva)
SELECT a.nome AS espetaculo, s.data, s.numero, s.horario,
       e.capacidade_plateia,
       e.capacidade_plateia - s.vagas_disponiveis AS ocupadas,
       COALESCE(SUM(r.quantidade), 0) AS reservadas
FROM sessao s
JOIN espetaculo e ON e.codigo = s.codigo_espetaculo
JOIN atracao a ON a.codigo = e.codigo
LEFT JOIN reserva r ON r.codigo_espetaculo = s.codigo_espetaculo
                   AND r.numero_sessao = s.numero
                   AND r.data_sessao = s.data
GROUP BY a.nome, s.data, s.numero, s.horario, e.capacidade_plateia, s.vagas_disponiveis
ORDER BY s.data, s.horario;

-- 6) Visitas por brinquedo (relacionamento ternário Frequenta: o brinquedo vem do operador)
SELECT a.nome AS brinquedo, COUNT(*) AS visitas
FROM frequenta f
JOIN operador o ON o.cpf = f.cpf_operador
JOIN atracao a ON a.codigo = o.codigo_brinquedo_opera
GROUP BY a.nome
ORDER BY visitas DESC;

-- 7) Cadeia de mentoria (auto-relacionamento Mentora)
SELECT mt.primeiro_nome || ' ' || mt.sobrenome AS mentor,
       md.primeiro_nome || ' ' || md.sobrenome AS mentorado
FROM mentora m
JOIN funcionario mt ON mt.cpf = m.cpf_mentor
JOIN funcionario md ON md.cpf = m.cpf_mentorado
ORDER BY mt.primeiro_nome, md.primeiro_nome;
