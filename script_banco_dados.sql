-- ============================================================================
-- SCRIPT MASTER: INFRAESTRUTURA DE DADOS - PROJETO FAROL IFC
-- OBJETIVO: Criação, saneamento e consolidação das camadas analíticas (AC1 a AC4)
-- BANCO DE DADOS: PostgreSQL 17
-- ============================================================================

-- ----------------------------------------------------------------------------
-- TABELA PRINCIPAL: Ingestão Bruta
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.dados_ifc_neabi (
    id SERIAL PRIMARY KEY,
    campus VARCHAR(100),
    categoria VARCHAR(50), 
    cor_raca VARCHAR(50),
    possui_necessidade_especial VARCHAR(50),
    necessidades_especiais TEXT,
    dt_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- ETAPA AC1: Visão Filtrada do Corpo Discente
-- ============================================================================
DROP VIEW IF EXISTS public.vw_dados_ifc_neabi CASCADE;

CREATE VIEW public.vw_dados_ifc_neabi AS
SELECT *
FROM public.dados_ifc_neabi
WHERE categoria = 'Discente'; 

-- ============================================================================
-- ETAPA AC2: Inteligência de Necessidades Específicas e Neurodivergência
-- ============================================================================
DROP VIEW IF EXISTS public.vw_acessibilidade_final CASCADE;

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
    
    -- Classificação da Necessidade Principal para engenharia visual
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

-- ============================================================================
-- ETAPA AC3: SERVIDORES - PERFIL RACIAL E INTERSECCIONALIDADE
-- ============================================================================
DROP VIEW IF EXISTS public.vw_ac3_servidores_interseccional CASCADE;

CREATE VIEW public.vw_ac3_servidores_interseccional AS
SELECT
    campus,
    categoria,

    -- Tratamento preventivo de strings nulas
    COALESCE(cor_raca, 'Não Declarado') AS cor_raca,
    COALESCE(possui_necessidade_especial, 'Não Informado') AS possui_necessidade_especial,

    -- Agrupamento Étnico-Racial com blindagem contra herança de NULLs
    CASE
        WHEN cor_raca IN ('Preta', 'Parda') THEN 'Negros (Pretos/Pardos)'
        WHEN cor_raca = 'Branca' THEN 'Branca'
        WHEN cor_raca = 'Indígena' THEN 'Indígena'
        WHEN cor_raca = 'Amarela (de origem oriental)' THEN 'Amarela'
        WHEN cor_raca IN ('Não Informado', 'Não declarada', 'Não Declarado') OR cor_raca IS NULL THEN 'Não Declarado'
        ELSE 'Outros'
    END AS grupo_etnico
FROM public.dados_ifc_neabi
WHERE categoria IN ('Docente', 'Técnico', 'Técnico Administrativo');

-- ============================================================================
-- ETAPA AC4 - CAMADA DE CONSOLIDAÇÃO COMPARATIVA
-- OBJETIVO: Consolidar e padronizar os dados étnico-raciais de estudantes
--           e servidores para utilização nas análises comparativas.
-- ============================================================================

DROP VIEW IF EXISTS public.vw_ac4_prova_comparativo CASCADE;

CREATE VIEW public.vw_ac4_prova_comparativo AS
SELECT
    campus,

    CASE
        WHEN categoria IN ('Docente', 'Técnico Administrativo', 'Técnico')
            THEN 'Servidor (Docente/Técnico)'
        WHEN categoria = 'Discente'
            THEN 'Aluno (Discente)'
        ELSE 'Outros'
    END AS grupo_comunidade,

    COALESCE(cor_raca, 'Não Declarado') AS cor_raca,

    CASE
        WHEN cor_raca IN ('Preta', 'Parda')
            THEN 'Negros (Pretos/Pardos)'
        WHEN cor_raca = 'Branca'
            THEN 'Branca'
        WHEN cor_raca = 'Indígena'
            THEN 'Indígena'
        WHEN cor_raca = 'Amarela (de origem oriental)'
            THEN 'Amarela'
        WHEN cor_raca IN ('Não Informado', 'Não declarada', 'Não Declarado')
             OR cor_raca IS NULL
            THEN 'Não Declarado'
        ELSE 'Outros'
    END AS grupo_etnico,

    COUNT(*) AS total_pessoas

FROM public.dados_ifc_neabi

GROUP BY
    campus,

    CASE
        WHEN categoria IN ('Docente', 'Técnico Administrativo', 'Técnico')
            THEN 'Servidor (Docente/Técnico)'
        WHEN categoria = 'Discente'
            THEN 'Aluno (Discente)'
        ELSE 'Outros'
    END,

    COALESCE(cor_raca, 'Não Declarado'),

    CASE
        WHEN cor_raca IN ('Preta', 'Parda')
            THEN 'Negros (Pretos/Pardos)'
        WHEN cor_raca = 'Branca'
            THEN 'Branca'
        WHEN cor_raca = 'Indígena'
            THEN 'Indígena'
        WHEN cor_raca = 'Amarela (de origem oriental)'
            THEN 'Amarela'
        WHEN cor_raca IN ('Não Informado', 'Não declarada', 'Não Declarado')
             OR cor_raca IS NULL
            THEN 'Não Declarado'
        ELSE 'Outros'
    END;

-- ============================================================================
-- ETAPA AC4: VIEWS COMPARATIVAS INSTITUCIONAIS (PERCENTUALIZADAS)
-- ============================================================================

-- 1. View Comparativa Étnico-Racial
DROP VIEW IF EXISTS public.vw_ac4_prova_comparativo_percentual CASCADE;

CREATE VIEW public.vw_ac4_prova_comparativo_percentual AS
WITH dados_consolidados AS (
    SELECT
        campus,
        CASE
            WHEN categoria IN ('Docente', 'Técnico Administrativo', 'Técnico') THEN 'Servidor (Docente/Técnico)'
            WHEN categoria = 'Discente' THEN 'Aluno (Discente)'
            ELSE 'Outros'
        END AS group_comunidade,
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
    GROUP BY campus, 2, 3
)
SELECT
    campus,
    group_comunidade,
    grupo_etnico,
    total_pessoas,
    -- Window Function para cálculo proporcional dinâmico na fonte
    ROUND(
        (total_pessoas::numeric / SUM(total_pessoas) OVER (PARTITION BY campus, group_comunidade)) * 100, 2
    ) AS percentual_grupo
FROM dados_consolidados;

-- 2. View Comparativa de Acessibilidade (PNE)
DROP VIEW IF EXISTS public.vw_ac4_prova_comparativo_pne_percentual CASCADE;

CREATE VIEW public.vw_ac4_prova_comparativo_pne_percentual AS
WITH dados_consolidados AS (
    SELECT
        campus,
        CASE
            WHEN categoria IN ('Docente', 'Técnico Administrativo', 'Técnico') THEN 'Servidor (Docente/Técnico)'
            WHEN categoria = 'Discente' THEN 'Aluno (Discente)'
            ELSE 'Outros'
        END AS group_comunidade,
        CASE 
            WHEN possui_necessidade_especial = 'Sim' THEN 'Possui PNE'
            WHEN possui_necessidade_especial = 'Não' THEN 'Não Possui PNE'
            ELSE 'Não Informado'
        END AS status_pne,
        COUNT(*) AS total_pessoas
    FROM public.dados_ifc_neabi
    GROUP BY campus, 2, 3
)
SELECT
    campus,
    grupo_comunidade,
    status_pne,
    total_pessoas,
    -- Window Function para cálculo proporcional analítico por categoria e campus
    ROUND(
        (total_pessoas::numeric / SUM(total_pessoas) OVER (PARTITION BY campus, group_comunidade)) * 100, 2
    ) AS percentual_grupo
FROM dados_consolidados;
