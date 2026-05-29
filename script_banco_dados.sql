-- ==========================================================
-- PROJETO: Análise Interseccional de Dados Institucionais - IFC
-- OBJETIVO: Criação da camada de persistência para o NEABI
-- BANCO DE DADOS: PostgreSQL 17
-- DATA: Março de 2026
-- ==========================================================

-- 1. Criação da tabela para armazenamento dos dados institucionais
-- Observação: A estrutura foi desenhada sem dados sensíveis (LGPD)
CREATE TABLE dados_ifc_neabi (
    id SERIAL PRIMARY KEY,
    campus VARCHAR(100),
    categoria VARCHAR(50), -- Discente, Docente ou Técnico
    cor_raca VARCHAR(50),
    possui_necessidade_especial VARCHAR(10) -- PcD / Necessidades Específicas
);

-- 2. Comando para conferência da carga de dados
-- Este comando foi utilizado para validar os 17.953 registros importados
SELECT * FROM dados_ifc_neabi;

-- 3. Exemplo de consulta para análise interseccional (Pretos/Pardos e PcD)
-- Esta é a inteligência que o portal Farol ainda não possui de forma direta
SELECT campus, cor_raca, possui_necessidade_especial, COUNT(*) as total
FROM dados_ifc_neabi
WHERE cor_raca IN ('Preta', 'Parda') 
  AND possui_necessidade_especial = 'Sim'
GROUP BY campus, cor_raca, possui_necessidade_especial
ORDER BY total DESC;

-- ==========================================================
-- ETAPA AC2: Inteligência de Acessibilidade e Neurodivergência
-- OBJETIVO: View para tratamento de comorbidades e flags binárias
-- ==========================================================

CREATE OR REPLACE VIEW vw_acessibilidade_final AS
SELECT 
    *,
    -- Criação de Flags Binárias para contabilização de comorbidades
    CASE WHEN necessidades_especiais ILIKE '%TEA%' OR necessidades_especiais ILIKE '%AUTIS%' THEN 1 ELSE 0 END AS flag_tea,
    CASE WHEN necessidades_especiais ILIKE '%TDAH%' THEN 1 ELSE 0 END AS flag_tdah,
    CASE WHEN necessidades_especiais ILIKE '%VISUAL%' THEN 1 ELSE 0 END AS flag_visual,
    CASE WHEN necessidades_especiais ILIKE '%AUDITIVA%' OR necessidades_especiais ILIKE '%SURD%' THEN 1 ELSE 0 END AS flag_auditiva,
    CASE WHEN necessidades_especiais ILIKE '%FÍSICA%' THEN 1 ELSE 0 END AS flag_fisica,
    CASE WHEN necessidades_especiais ILIKE '%INTELECTUAL%' THEN 1 ELSE 0 END AS flag_intelectual,
    CASE WHEN necessidades_especiais ILIKE '%ALTAS HABILIDADES%' OR necessidades_especiais ILIKE '%SUPERDOT%' THEN 1 ELSE 0 END AS flag_superdotacao,
    
    -- Classificação da Necessidade Principal para o Gráfico de Barras
    CASE 
        WHEN necessidades_especiais ILIKE '%TEA%' OR necessidades_especiais ILIKE '%AUTIS%' THEN 'TEA (Autismo)'
        WHEN necessidades_especiais ILIKE '%TDAH%' THEN 'TDAH'
        WHEN necessidades_especiais ILIKE '%ALTAS HABILIDADES%' OR necessidades_especiais ILIKE '%SUPERDOT%' THEN 'Altas Habilidades'
        WHEN necessidades_especiais ILIKE '%INTELECTUAL%' THEN 'Deficiência Intelectual'
        WHEN necessidades_especiais ILIKE '%VISUAL%' THEN 'Deficiência Visual'
        WHEN necessidades_especiais ILIKE '%AUDITIVA%' OR necessidades_especiais ILIKE '%SURD%' THEN 'Deficiência Auditiva'
        WHEN necessidades_especiais ILIKE '%FÍSICA%' THEN 'Deficiência Física'
        WHEN necessidades_especiais IS NULL OR necessidades_especiais = '[null]' THEN 'Não Possui'
        ELSE 'Outras Necessidades'
    END AS necessidade_principal
FROM public.dados_ifc_neabi;
-- ==========================================================
-- ETAPA AC3: Interseccionalidade Funcional e Auditoria de Dados
-- OBJETIVO: Views para análise de servidores (Docentes e Técnicos)
-- ==========================================================

-- 1. Limpeza de segurança para renovação da estrutura
DROP VIEW IF EXISTS vw_ac3_final_servidores CASCADE;
DROP VIEW IF EXISTS vw_ac3_servidores_interseccional CASCADE;

-- 2. Criação da View especializada para auditoria do NEABI
CREATE VIEW vw_ac3_final_servidores AS
SELECT 
    campus, 
    categoria, 
    COALESCE(cor_raca, 'Não Declarado') as cor_raca
FROM public.dados_ifc_neabi
WHERE categoria IN ('Docente', 'Técnico Administrativo');

-- 3. Criação da View para análise interseccional de Servidores
CREATE VIEW vw_ac3_servidores_interseccional AS
SELECT 
    campus,
    categoria, 
    COALESCE(cor_raca, 'Não Declarado') as cor_raca,
    COALESCE(possui_necessidade_especial, 'Não Informado') as possui_necessidade_especial,
    CASE 
        WHEN cor_raca IN ('Preta', 'Parda') THEN 'Negros (Pretos/Pardos)'
        WHEN cor_raca IS NULL OR cor_raca = 'Não Declarado' THEN 'Não Declarado'
        ELSE cor_raca 
    END AS grupo_etnico
FROM public.dados_ifc_neabi
WHERE categoria IN ('Docente', 'Técnico');

-- 4. Validação dos dados de auditoria racial (100% ausência)
SELECT 
    cor_raca, 
    COUNT(*) as total,
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()), 2) as percentual
FROM vw_ac3_final_servidores
GROUP BY cor_raca;
-- ==========================================================
-- ETAPA AC4 (PROVA FINAL): Comparativo de Diversidade
-- OBJETIVO: View para cruzar o perfil de Alunos vs Servidores
-- ==========================================================

-- 1. Limpeza de segurança
DROP VIEW IF EXISTS vw_ac4_prova_comparativo CASCADE;

-- 2. Criação da View de cruzamento (Discentes vs Servidores)
CREATE VIEW vw_ac4_prova_comparativo AS
SELECT 
    campus,
    -- Criação do super-grupo para facilitar a visualização no BI
    CASE 
        WHEN categoria IN ('Docente', 'Técnico Administrativo', 'Técnico') THEN 'Servidor (Docente/Técnico)'
        WHEN categoria = 'Discente' THEN 'Aluno (Discente)'
        ELSE 'Outros'
    END AS grupo_comunidade,
    -- Tratamento de nulos herdado da AC3
    COALESCE(cor_raca, 'Não Declarado') AS cor_raca,
    COUNT(*) as total_pessoas
FROM public.dados_ifc_neabi
GROUP BY 
    campus,
    CASE 
        WHEN categoria IN ('Docente', 'Técnico Administrativo', 'Técnico') THEN 'Servidor (Docente/Técnico)'
        WHEN categoria = 'Discente' THEN 'Aluno (Discente)'
        ELSE 'Outros'
    END,
    COALESCE(cor_raca, 'Não Declarado');
