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
