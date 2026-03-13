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