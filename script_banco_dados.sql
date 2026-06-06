-- ============================================================================
-- ETAPA AC1: Visão Filtrada apontando para a base principal
-- OBJETIVO: Isolar apenas os discentes direto na regra de negócio do banco
-- ============================================================================

DROP VIEW IF EXISTS public.vw_dados_ifc_neabi CASCADE;

CREATE VIEW public.vw_dados_ifc_neabi AS
SELECT *
FROM public.dados_ifc_neabi
WHERE categoria = 'Discente'; 

-- Validação para conferir se o banco apontou certinho
SELECT * FROM public.vw_dados_ifc_neabi LIMIT 10;
-- ============================================================================
-- ETAPA AC2: Inteligência de Acessibilidade e Neurodivergência (CORRIGIDA)
-- OBJETIVO: View para tratamento de comorbidades EXCLUSIVA DE ESTUDANTES
-- SOLUÇÃO: DROP prévio para evitar erro de reordenamento de colunas do Postgres
-- ============================================================================

-- 1. Força a exclusão da estrutura antiga para resetar as colunas
DROP VIEW IF EXISTS public.vw_acessibilidade_final CASCADE;

-- 2. Cria a nova estrutura perfeitamente limpa e filtrada
CREATE VIEW public.vw_acessibilidade_final AS
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
FROM public.dados_ifc_neabi
WHERE categoria ILIKE '%Disc%' 
   OR categoria ILIKE '%Alun%' 
   OR categoria ILIKE '%Estud%';

-- 3. Teste rápido de validação
SELECT * FROM public.vw_acessibilidade_final LIMIT 5;
-- ============================================================================
-- SCRIPT DE ENGENHARIA DE DADOS - ETAPA AC4 (PROVA FINAL)
-- OBJETIVO: Views Comparativas Proporcionais (Estudantes vs Servidores)
-- CODIGOS PADRONIZADOS PARA TEMA DO FAROL IFC E ACABAMENTO EXECUTIVO NO BI
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. VIEW: Comparativo Étnico-Racial Percentualizado
-- ----------------------------------------------------------------------------
DROP VIEW IF EXISTS vw_ac4_prova_comparativo_percentual CASCADE;

CREATE VIEW vw_ac4_prova_comparativo_percentual AS
WITH dados_consolidados AS (
    SELECT
        campus,
        -- Definição dos supergrupos da comunidade
        CASE
            WHEN categoria IN ('Docente', 'Técnico Administrativo', 'Técnico') THEN 'Servidor (Docente/Técnico)'
            WHEN categoria = 'Discente' THEN 'Aluno (Discente)'
            ELSE 'Outros'
        END AS group_comunidade,
        -- Tratamento unificado de categorias étnico-raciais e lacunas
        CASE
            WHEN cor_raca IN ('Preta', 'Parda') THEN 'Negros (Pretos/Pardos)'
            WHEN cor_raca = 'Branca' THEN 'Branca'
            WHEN cor_raca = 'Indígena' THEN 'Indígena'
            WHEN cor_raca = 'Amarela (de origem oriental)' THEN 'Amarela'
            WHEN cor_raca IN ('Não Informado', 'Não declarada', 'Não Declarado') OR cor_raca IS NULL THEN 'Não Declarado'
            ELSE 'Outros'
        END AS grupo_etnico,
        COUNT(*) AS total_pessoas
    FROM public.dados_ifc_neabi
    GROUP BY 
        campus,
        1, -- Referencia o CASE de group_comunidade
        2  -- Referencia o CASE de grupo_etnico
)
SELECT
    campus,
    group_comunidade,
    grupo_etnico,
    total_pessoas,
    -- Cálculo dinâmico do percentual dividindo pelo total daquela categoria no campus
    ROUND(
        (total_pessoas::numeric / SUM(total_pessoas) OVER (PARTITION BY campus, group_comunidade)) * 100,
        2
    ) AS percentual_grupo
FROM dados_consolidados;
-- ============================================================================
-- ETAPA AC3: SERVIDORES - PERFIL RACIAL E INTERSECCIONALIDADE (VERSÃO FINAL)
-- OBJETIVO: Consolidar os dados de servidores do IFC para análise racial,
--           geração de indicadores e visuais no Power BI.
-- ============================================================================

-- 1. Limpeza preventiva da estrutura antiga
DROP VIEW IF EXISTS public.vw_ac3_servidores_interseccional CASCADE;

-- 2. Criação da View oficial da AC3 (Mantendo os nomes originais do Power BI)
CREATE VIEW public.vw_ac3_servidores_interseccional AS
SELECT
    campus,
    categoria,

    -- Tratamento padrão para colunas brutas
    COALESCE(cor_raca, 'Não Declarado') AS cor_raca,
    COALESCE(possui_necessidade_especial, 'Não Informado') AS possui_necessidade_especial,

    -- [REGRA DE NEGÓCIO] Agrupamento Étnico-Racial com blindagem para NULLs
    CASE
        WHEN cor_raca IN ('Preta', 'Parda') 
            THEN 'Negros (Pretos/Pardos)'

        WHEN cor_raca = 'Branca' 
            THEN 'Branca'

        WHEN cor_raca = 'Indígena' 
            THEN 'Indígena'

        WHEN cor_raca = 'Amarela (de origem oriental)' 
            THEN 'Amarela'

        WHEN cor_raca IN ('Não Informado', 'Não declarada', 'Não Declarado') OR cor_raca IS NULL 
            THEN 'Não Declarado'

        ELSE 'Outros'
    END AS grupo_etnico

FROM public.dados_ifc_neabi
WHERE categoria IN ('Docente', 'Técnico', 'Técnico Administrativo');

-- 3. Script de validação institucional
SELECT
    grupo_etnico,
    COUNT(*) AS total
FROM public.vw_ac3_servidores_interseccional
GROUP BY grupo_etnico
ORDER BY total DESC;
-- ----------------------------------------------------------------------------
-- 2. VIEW: Comparativo de Acessibilidade (PNE) Percentualizado
-- ----------------------------------------------------------------------------
DROP VIEW IF EXISTS vw_ac4_prova_comparativo_pne_percentual CASCADE;

CREATE VIEW vw_ac4_prova_comparativo_pne_percentual AS
WITH dados_consolidados AS (
    SELECT
        campus,
        -- Definição dos supergrupos da comunidade
        CASE
            WHEN categoria IN ('Docente', 'Técnico Administrativo', 'Técnico') THEN 'Servidor (Docente/Técnico)'
            WHEN categoria = 'Discente' THEN 'Aluno (Discente)'
            ELSE 'Outros'
        END AS grupo_comunidade,
        -- Padronização da flag PNE para evitar variações de nulos e textos
        CASE 
            WHEN possui_necessidade_especial = 'Sim' THEN 'Possui PNE'
            WHEN possui_necessidade_especial = 'Não' THEN 'Não Possui PNE'
            ELSE 'Não Informado'
        END AS status_pne,
        COUNT(*) AS total_pessoas
    FROM public.dados_ifc_neabi
    GROUP BY 
        campus,
        CASE
            WHEN categoria IN ('Docente', 'Técnico Administrativo', 'Técnico') THEN 'Servidor (Docente/Técnico)'
            WHEN categoria = 'Discente' THEN 'Aluno (Discente)'
            ELSE 'Outros'
        END,
        CASE 
            WHEN possui_necessidade_especial = 'Sim' THEN 'Possui PNE'
            WHEN possui_necessidade_especial = 'Não' THEN 'Não Possui PNE'
            ELSE 'Não Informado'
        END
)
SELECT
    campus,
    grupo_comunidade,
    status_pne,
    total_pessoas,
    -- Cálculo dinâmico do percentual por grupo dentro de cada campus
    ROUND(
        (total_pessoas::numeric / SUM(total_pessoas) OVER (PARTITION BY campus, grupo_comunidade)) * 100,
        2
    ) AS percentual_grupo
FROM dados_consolidados;

-- ============================================================================
-- FIM DO SCRIPT
-- ============================================================================
