# Engenharia de Dados e Business Intelligence aplicados à Interseccionalidade Étnico-Racial e PNE: Uma Extensão do Portal Farol IFC

## 1. Visão Geral

Este projeto implementa uma solução de inteligência de dados focada na análise multidimensional da comunidade acadêmica do Instituto Federal Catarinense (IFC). A iniciativa visa preencher lacunas analíticas identificadas nos sistemas institucionais vigentes, especificamente no que tange ao cruzamento de variáveis de cor/raça e necessidades específicas do corpo docente e técnico-administrativo.

## 2. Stack Tecnológica e Infraestrutura

* **SGBD Relacional:** PostgreSQL 18.3 (x86_64-windows-msvc)
* **Camada de Visualização:** Power BI Desktop (Engine de análise em memória)
* **Linguagens de Consulta:** SQL (ANSI) e DAX (Data Analysis Expressions)
* **Ambiente de Gerenciamento:** pgAdmin 4.x
* **Metodologia de Gestão:** Framework Kanban via GitHub Projects

## 3. Arquitetura de Dados e Pipeline de ETL

O projeto processa um dataset consolidado de 17.953 registros. O pipeline de dados compreende as seguintes etapas:

1. **Ingestão:** Carga de dados brutos via arquivos planos (CSV).
2. **Saneamento:** Normalização de campos categóricos e tratamento de valores nulos nas colunas `cor/raça` e `necessidades_especiais`.
3. **Governança e Privacidade:** Anonimização de registros para garantir o compliance com a Lei Geral de Proteção de Dados (LGPD).
4. **Persistência:** Estruturação de esquemas relacionais no PostgreSQL para garantir integridade e performance em consultas complexas.

## 4. Cronograma Técnico de Implementação (Roadmap)

A evolução do projeto é pautada na entrega incremental de dashboards analíticos, estruturada conforme o cronograma de Atividades Acadêmicas (AC):

* **AC1 (Baseline):** Implementação da infraestrutura de dados e dashboard de perfil demográfico étnico-racial geral.
* **AC2 (Acessibilidade):** Expansão da camada de BI para diagnóstico de Necessidades Específicas e Neurodivergência (TEA/TDAH) com segmentação por campus.
* **AC3 (Interseccionalidade):** Desenvolvimento de lógica para cruzamento de dados de servidores, correlacionando categoria funcional, raça e PNE.
* **AC4 (Interface):** Refatoração de UI/UX baseada no Design System institucional e consolidação da documentação técnica para integração ao ecossistema Farol.

## 5. Procedimentos de Instalação e Execução

1. **Deploy do Banco de Dados:** Executar o script DDL contido no diretório `/sql` no servidor PostgreSQL.
2. **Carga de Dados:** Importar o arquivo `dados_IFC_limpos.csv` respeitando o delimitador `;` e a codificação UTF-8.
3. **Conectividade BI:** Abrir o arquivo `.pbix`, atualizar a string de conexão para o ambiente local e carregar as visualizações.

---

**Responsável Técnico:** Áubio Aurélio da Rocha Ferreira

**Vínculo Institucional:** Coordenador NEABI / Técnico de Laboratório de Informática - IFC Campus Concórdia
