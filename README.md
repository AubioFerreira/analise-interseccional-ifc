# 📊 Engenharia de Dados e BI: Observatório Nzila (Extensão Portal Farol IFC)

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Power_BI](https://img.shields.io/badge/PowerBI-F2C811?style=for-the-badge&logo=Power%20BI&logoColor=black)
![SQL](https://img.shields.io/badge/SQL-003B57?style=for-the-badge&logo=postgresql&logoColor=white)

> **Objetivo Institucional:** Solução de Business Intelligence e criação de uma camada de persistência de dados para o NEABI. O projeto analisa a comunidade acadêmica do Instituto Federal Catarinense (IFC), evidenciando o apagamento de dados de autodeclaração étnico-racial no quadro funcional, contrastando-o com a diversidade discente.

## 🔗 Artefatos do Projeto

* 📋 **Gestão Ágil (Kanban):** [Acessar o Quadro do Projeto](https://github.com/users/AubioFerreira/projects/2)
* 📐 **Modelagem de Dados:** [Visualizar o Diagrama (MER)](https://github.com/AubioFerreira/analise-interseccional-ifc/blob/main/MER.drawio.png)
* 💾 **Scripts SQL:** [Acessar códigos de criação das Views e ETL]https://github.com/AubioFerreira/analise-interseccional-ifc/blob/main/script_banco_dados.sql
* 📊 **Dashboard BI:** [Baixar o arquivo Power BI (.pbix)](https://github.com/AubioFerreira/analise-interseccional-ifc/blob/main/Dashboard_NEABI_IFC_v1.pbix)
* 📄 **Documentação:** [Ler o Relatório Final em PDF](./caminho-do-relatorio.pdf)
---

## 1. Arquitetura de Dados e Pipeline ETL

O pipeline foi construído seguindo o padrão ouro de extração, transformação e carga (ETL):
* **Ingestão (Extract):** Carga de dados brutos institucionais (17.953 registros) via arquivos CSV com sanitização de dados sensíveis (LGPD).
* **Transformação (Transform):** Higienização e criação de Views no PostgreSQL 17. Uso de `COALESCE` para tratamento de nulos, `ILIKE` para text mining de comorbidades e `CASE WHEN` para super-agrupamentos.
* **Carga (Load):** Conexão direta `localhost` e modelagem relacional (Muitos para Muitos) no Power BI.

---

## 2. A Jornada do Projeto: Entregas por Etapa (ACs)

O ecossistema foi construído de forma iterativa, consolidando a fonte única da verdade no banco de dados:

### 📍 AC1: Camada de Persistência e Interseccionalidade
* Criação da tabela principal `dados_ifc_neabi`.
* Elaboração de consultas interseccionais avançadas (ex: mapeamento simultâneo de alunos Pretos/Pardos que também são PcD), entregando uma inteligência que o portal Farol original não possui de forma direta.

### 📍 AC2: Inteligência de Acessibilidade e Neurodivergência
* Criação da View `vw_acessibilidade_final`.
* Varredura textual para mapear as necessidades específicas e geração de flags binárias para estruturação visual de comorbidades (TEA, TDAH, Altas Habilidades, etc.).

### 📍 AC3: Interseccionalidade Funcional e Auditoria de Dados
* Criação de duas Views focadas no corpo de servidores: `vw_ac3_final_servidores` e `vw_ac3_servidores_interseccional`.
* Auditoria oficial que comprovou **100% de ausência de autodeclaração racial** ("Não Informado") entre servidores.
* Tratamento de agrupamento étnico (aglutinando Pretos e Pardos) e tratamento de nulos em necessidades especiais.

### 📍 AC4 (Prova Final): Comparativo de Diversidade e Refatoração UI/UX
* Criação da View `vw_ac4_prova_comparativo`.
* Super-agrupamento de categorias para viabilizar o cruzamento visual entre "Servidores" e "Alunos".
* Refatoração do dashboard em 4 páginas independentes com segmentadores nativos e design system responsivo.

---

## 3. Procedimentos de Execução (Script Master)

Abaixo, o roteiro completo de banco de dados (Single Source of Truth) para reprodução de toda a infraestrutura do projeto no PostgreSQL:

```sql
-- ==========================================================
-- PROJETO: Análise Interseccional de Dados Institucionais - IFC
-- OBJETIVO: Criação da camada de persistência para o NEABI
-- BANCO DE DADOS: PostgreSQL 17
-- DATA: Março de 2026
-- ==========================================================

-- 1. Criação da tabela para armazenamento dos dados institucionais
CREATE TABLE dados_ifc_neabi (
    id SERIAL PRIMARY KEY,
    campus VARCHAR(100),
    categoria VARCHAR(50), 
    cor_raca VARCHAR(50),
    possui_necessidade_especial VARCHAR(10) 
);

-- 2. Comando para conferência da carga de dados
SELECT * FROM dados_ifc_neabi;

-- 3. Exemplo de consulta para análise interseccional (Pretos/Pardos e PcD)
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
    CASE WHEN necessidades_especiais ILIKE '%TEA%' OR necessidades_especiais ILIKE '%AUTIS%' THEN 1 ELSE 0 END AS flag_tea,
    CASE WHEN necessidades_especiais ILIKE '%TDAH%' THEN 1 ELSE 0 END AS flag_tdah,
    CASE WHEN necessidades_especiais ILIKE '%VISUAL%' THEN 1 ELSE 0 END AS flag_visual,
    CASE WHEN necessidades_especiais ILIKE '%AUDITIVA%' OR necessidades_especiais ILIKE '%SURD%' THEN 1 ELSE 0 END AS flag_auditiva,
    CASE WHEN necessidades_especiais ILIKE '%FÍSICA%' THEN 1 ELSE 0 END AS flag_fisica,
    CASE WHEN necessidades_especiais ILIKE '%INTELECTUAL%' THEN 1 ELSE 0 END AS flag_intelectual,
    CASE WHEN necessidades_especiais ILIKE '%ALTAS HABILIDADES%' OR necessidades_especiais ILIKE '%SUPERDOT%' THEN 1 ELSE 0 END AS flag_superdotacao,
    
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
    CASE 
        WHEN categoria IN ('Docente', 'Técnico Administrativo', 'Técnico') THEN 'Servidor (Docente/Técnico)'
        WHEN categoria = 'Discente' THEN 'Aluno (Discente)'
        ELSE 'Outros'
    END AS grupo_comunidade,
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
