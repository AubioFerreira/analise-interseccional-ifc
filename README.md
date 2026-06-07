# 📊 Engenharia de Dados e Business Intelligence Aplicados à Interseccionalidade Étnico-Racial e PNE
### Projeto Farol IFC – Módulo de Análise Étnico-Racial, Necessidades Específicas e Lacunas Informacionais

Sistema de Business Intelligence para análise da composição étnico-racial, das necessidades específicas e das lacunas informacionais da comunidade acadêmica do Instituto Federal Catarinense.

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Power_BI](https://img.shields.io/badge/PowerBI-F2C811?style=for-the-badge&logo=Power%20BI&logoColor=black)
![SQL](https://img.shields.io/badge/SQL-003B57?style=for-the-badge&logo=postgresql&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)

> **Objetivo Institucional:** Desenvolvimento de uma solução de Business Intelligence e estruturação de uma camada de persistência e governança de dados para o NEABI (Núcleo de Estudos Afro-Brasileiros e Indígenas) do IFC - Campus Concórdia. O projeto analisa de forma analítica e interseccional a comunidade acadêmica do Instituto Federal Catarinense (IFC), mitigando falhas de contaminação de contexto e evidenciando com precisão o cenário de autodeclaração étnico-racial, necessidades específicas e lacunas informacionais.

---

## 📌 Resumo Executivo

O Farol IFC é uma solução de Business Intelligence desenvolvida para apoiar a análise da composição étnico-racial e das necessidades específicas da comunidade acadêmica do Instituto Federal Catarinense (IFC).

A partir da aplicação de técnicas de Engenharia de Dados, SQL e Power BI, foram construídas camadas analíticas capazes de identificar padrões de autodeclaração racial, lacunas informacionais, distribuição de pessoas com necessidades específicas e diferenças entre estudantes e servidores.

O projeto foi desenvolvido como atividade acadêmica aplicada a um contexto institucional real, utilizando dados anonimizados e respeitando os princípios da Lei Geral de Proteção de Dados (LGPD).

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Finalidade |
|------------|------------|
| PostgreSQL 17 | Armazenamento e processamento dos dados |
| SQL | Transformação e consolidação das informações |
| Power BI | Construção dos dashboards e indicadores |
| Git | Controle de versão |
| GitHub | Hospedagem e documentação do projeto |
| Draw.io | Modelagem de dados (MER) |
| Mermaid | Representação de diagramas e arquitetura |

---

## 📸 Visualização do Painel (Data Product)

### Página 1: Capa e Painel Executivo Geral
![Capa do Dashboard](Imagens/1.png)

### Página 2: Perfil Étnico-Racial Discente (AC1) vs. Necessidades Específicas (AC2)
<p align="center">
  <img src="Imagens/2.png" width="49%" />
  <img src="Imagens/3.png" width="49%" />
</p>

### Página 3: Perfil dos Servidores (AC3) vs. Análise Comparativa Proporcional (AC4)
<p align="center">
  <img src="Imagens/4.png" width="49%" />
  <img src="Imagens/5.png" width="49%" />
  <img src="Imagens/6.png" width="49%" />
</p>

---

## 📐 Modelo Entidade-Relacionamento (MER)

O modelo abaixo representa a estrutura lógica dos dados utilizada para organizar as informações analisadas no projeto.

![MER](MER.png)

### Estrutura do Modelo

A entidade central é `DADOS_IFC_NEABI`, responsável por armazenar os registros da comunidade acadêmica.

As entidades `DIM_CAMPUS`, `DIM_CATEGORIA`, `DIM_COR_RACA` e `DIM_NECESSIDADE_ESPECIAL` representam dimensões utilizadas para classificação e segmentação dos dados.

Todos os relacionamentos possuem cardinalidade **1:N**, indicando que um mesmo campus, categoria, grupo racial ou necessidade especial pode estar associado a diversos registros da base principal.

---

## 📖 Glossário de Termos Institucionais

Para facilitar a interpretação do contexto institucional e das regras de negócio aplicadas ao pipeline, utiliza-se o seguinte mapeamento de acrônimos:

| Acrônimo / Termo | Significado Institucional | Contexto no Projeto |
| :--- | :--- | :--- |
| **IFC** | Instituto Federal Catarinense | Autarquia federal de ensino foco da análise de dados. |
| **NEABI** | Núcleo de Estudos Afro-Brasileiros e Indígenas | Núcleo proponente responsável por formular políticas de equidade. |
| **Discente** | Aluno Matriculado | Público-alvo das análises de diversidade e acessibilidade escolar. |
| **Servidor** | Corpo Funcional (Docentes e Técnicos) | Analisados quanto à ocupação de cargos e preenchimento de perfil racial. |
| **PNE** | PNE | Pessoa com Necessidade Específica | Alunos ou servidores que possuem necessidades específicas registradas nos sistemas institucionais. |
| **TAE** | Técnico-Administrativo em Educação | Categoria funcional de servidores que atuam no suporte e gestão institucional. |

---

## 📈 Descobertas Analíticas Estratégicas (Data Insights)

### Principais Resultados

* Foi identificada uma lacuna informacional de **89,73%** nos registros raciais dos servidores do IFC, totalizando aproximadamente **1.756 registros sem informação racial disponível**.

* Entre os estudantes, a lacuna observada foi de **3,86%**, indicando um nível significativamente superior de preenchimento cadastral quando comparado ao quadro funcional.

* Na análise das necessidades específicas dos estudantes, o **Transtorno do Espectro Autista (TEA)** apresentou **202 registros**, seguido pelo **TDAH**, com **173 registros**, configurando os grupos mais frequentes dentre as necessidades específicas identificadas.

---

## ⚠️ Nota Metodológica

Os percentuais apresentados neste projeto refletem exclusivamente a situação dos registros disponíveis nos sistemas institucionais do Instituto Federal Catarinense (IFC) no momento da extração e processamento dos dados.

As análises realizadas descrevem padrões de preenchimento cadastral, autodeclaração étnico-racial e informações de acessibilidade registradas administrativamente, não devendo ser interpretadas como representação demográfica exata da comunidade acadêmica ou do quadro funcional da instituição.

Dessa forma, indicadores de representatividade podem estar sujeitos a limitações decorrentes da ausência, inconsistência ou desatualização de informações nos sistemas de origem, especialmente nos casos identificados de lacuna informacional.

---

## 🔗 Artefatos do Projeto

* 📋 **Gestão Ágil (Kanban):** [Acessar o Quadro do Projeto](https://github.com/users/AubioFerreira/projects/2)
* 📐 **Modelagem de Dados:** [Visualizar o Diagrama (MER)](https://github.com/AubioFerreira/analise-interseccional-ifc/blob/main/MER.png)
* 💾 **Scripts SQL:** [Acessar códigos de criação das Views e ETL](https://github.com/AubioFerreira/analise-interseccional-ifc/blob/main/script_banco_dados.sql)
* 📊 **Dashboard BI:** [Baixar o arquivo Power BI (.pbix)](https://github.com/AubioFerreira/analise-interseccional-ifc/blob/main/Dashboard_NEABI_IFC_v1.pbix)
* 📄 **Documentação:** [Ler o Relatório Final em PDF](https://github.com/AubioFerreira/analise-interseccional-ifc/blob/main/ENGENHARIA%20DE%20DADOS%20E%20BUSINESS%20INTELLIGENCE%20APLICADOS%20%C3%80%20INTERSECCIONALIDADE%20%C3%89TNICO-RACIAL%20E%20%C3%80S%20NECESSIDADES%20ESPEC%C3%8DFICAS%20NO%20INSTITUTO%20FEDERAL%20CATARINENSE%20-%20FINAL.pdf)

---

## 1. Arquitetura de Dados e Pipeline ETL

O ecossistema de dados foi estruturado seguindo as melhores práticas corporativas para garantir governança e escalabilidade:
* **Ingestão (Extract):** Processamento de dados brutos institucionais (17.953 registros) via arquivos CSV higienizados em conformidade com as diretrizes da LGPD.
* **Transformação (Transform):** Higienização avançada e tratamento de concorrência estrutural no PostgreSQL 17. Uso de `COALESCE` para tratamento de nulos, operadores de busca textual flexíveis (`ILIKE`) para *text mining* e tratamento de comorbidades, e **Window Functions (`OVER PARTITION BY`)** para realizar cálculos percentuais dinâmicos diretamente na fonte.
* **Carga (Load):** Conexão nativa e otimizada via Power BI, consumindo dados pré-calculados pelo banco de dados. Essa arquitetura reduz significativamente o processamento necessário no Power BI, transferindo parte das regras de negócio e cálculos para o PostgreSQL, favorecendo desempenho, rastreabilidade e governança dos dados.

---

## 2. A Jornada Iterativa (Entregas por Etapa)

### 📍 AC1: Camada de Persistência e Isolamento Discente
* Estruturação da tabela principal `dados_ifc_neabi`.
* Criação da View `vw_dados_ifc_neabi` para isolamento estrito do corpo discente, corrigindo distorções históricas e garantindo cruzamentos interseccionais puros (Raça vs. PcD).

### 📍 AC2: Inteligência de Necessidades Específicas e Neurodivergência
* Desenvolvimento da View `vw_acessibilidade_final` focada exclusivamente em estudantes.
* Implementação de mapeamento textual para geração de flags binárias indexadas para estruturação visual de condições médicas especializadas (TEA, TDAH, Altas Habilidades, Deficiências Físicas e Sensoriais).

### 📍 AC3: Interseccionalidade Funcional e Homologação de Dados
* Criação da View especializada `vw_ac3_servidores_interseccional` focada estritamente no corpo funcional.
* Implementação de lógica defensiva contra nulos (`OR cor_raca IS NULL`) para blindagem de cargas futuras e consolidação do agrupamento étnico-racial unificado (`grupo_etnico`).

### 📍 AC4 (Prova Final): Visões Comparativas Proporcionais e Performance
* Criação das Views agregadas `vw_ac4_prova_comparativo_percentual` e `vw_ac4_prova_comparativo_pne_percentual`.
* Utilização de funções de janela analíticas do SQL para calcular a distribuição percentual interna de cada campus por categoria, entregando um painel executivo responsivo de alta performance.

---

## 🛠️ Pré-requisitos e Como Executar

Para reproduzir localmente este projeto de forma íntegra, siga as etapas abaixo:

1. **Banco de Dados:** Ter o PostgreSQL 17 (ou superior) instalado e rodando localmente na porta padrão (`5432`).
2. **Visualização:** Possuir o Microsoft Power BI Desktop instalado na máquina.
3. **Instalação:**
   * Crie um banco de dados vazio chamado `dados_ifc_neabi`.
   * Execute o script consolidado abaixo para gerar as tabelas, importar seus dados brutos de CSV e criar todas as camadas analíticas automatizadas.
   * Abra o arquivo `.pbix` no Power BI e atualize a credencial de banco de dados apontando para o seu `localhost`.

---

## 3. Script Master Consolidado (Single Source of Truth)

```sql
-- ============================================================================
-- SCRIPT MASTER: INFRAESTRUTURA DE DADOS - OBSERVATÓRIO NZILA
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
    possui_need_especial VARCHAR(50),
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
```

---

## 🏗️ Arquitetura Analítica do Projeto

O diagrama abaixo apresenta o fluxo de processamento dos dados desde a base principal até as camadas analíticas utilizadas na construção dos dashboards e indicadores.

```mermaid
graph TD

A["dados_ifc_neabi"]

A --> B["vw_dados_ifc_neabi"]
A --> C["vw_acessibilidade_final"]
A --> D["vw_ac3_servidores_interseccional"]
A --> E["vw_ac4_prova_comparativo"]

B --> F["AC1 - Perfil Discente"]
C --> G["AC2 - Necessidades Específicas"]
D --> H["AC3 - Servidores"]

E --> I["vw_ac4_prova_comparativo_percentual"]
E --> J["vw_ac4_prova_comparativo_pne_percentual"]

I --> K["AC4 - Comparativo Étnico-Racial"]
J --> L["AC4 - Comparativo PNE"]
```

### Estrutura das Views Analíticas

| Etapa | View |
|--------|--------|
| AC1 – Perfil Discente | `vw_dados_ifc_neabi` |
| AC2 – Necessidades Específicas | `vw_acessibilidade_final` |
| AC3 – Perfil dos Servidores | `vw_ac3_servidores_interseccional` |
| AC4 – Consolidação Comparativa | `vw_ac4_prova_comparativo` |
| AC4 – Comparativo Étnico-Racial | `vw_ac4_prova_comparativo_percentual` |
| AC4 – Comparativo de Necessidades Específicas | `vw_ac4_prova_comparativo_pne_percentual` |

> A view `vw_ac4_prova_comparativo` atua como camada intermediária de consolidação dos dados, servindo de base para a geração das views percentuais utilizadas nos dashboards comparativos da AC4.
---

## 🎯 Competências Aplicadas

- Engenharia de Dados
- SQL Avançado
- PostgreSQL
- Modelagem de Dados
- ETL
- Business Intelligence
- Power BI
- Governança de Dados
- Visualização de Dados
- Controle de Versão com Git e GitHub

---

## 📌 Conclusão

O projeto demonstrou a aplicação prática de conceitos de Engenharia de Dados e Business Intelligence em um contexto institucional real.

Por meio da utilização de PostgreSQL, SQL e Power BI, foi possível estruturar um ambiente analítico capaz de apoiar discussões relacionadas à diversidade étnico-racial, necessidades específicas e qualidade dos registros institucionais.

Os resultados produzidos podem servir como subsídio para ações de gestão, planejamento institucional e fortalecimento das políticas de inclusão do Instituto Federal Catarinense.
