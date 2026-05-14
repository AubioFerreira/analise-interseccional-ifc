# Engenharia de Dados e BI: Análise de Interseccionalidade (Projeto Farol IFC)

## 1. Visão Geral
Este projeto implementa uma solução de inteligência de dados focada na análise multidimensional da comunidade acadêmica do Instituto Federal Catarinense (IFC). A iniciativa visa preencher lacunas analíticas nos sistemas institucionais, especificamente no cruzamento de variáveis de **cor/raça** e categorias funcionais de servidores.

## 2. Stack Tecnológica
* **SGBD:** PostgreSQL 18.3
* **BI:** Power BI Desktop (Engine em memória)
* **Linguagens:** SQL (ANSI) e DAX
* **Gestão:** Framework Kanban (GitHub Projects)

## 3. Arquitetura de Dados e Pipeline ETL
O pipeline segue o modelo **E-T-L**:
1. **Ingestão (Extract):** Carga de dados brutos via arquivos CSV.
2. **Transformação (Transform):** Higienização via **SQL Views** no PostgreSQL, tratando nulos e normalizando nomes de categorias.
3. **Carga (Load):** Conexão via `localhost` para visualização dinâmica no Power BI.

## 4. Cronograma de Implementação
* **AC1 (Demografia):** [x] Perfil demográfico étnico-racial geral.
* **AC2 (Acessibilidade):** [x] Diagnóstico de Necessidades Específicas e Neurodivergência.
* **AC3 (Interseccionalidade Funcional):** [x] **Concluído.** Cruzamento de categoria funcional e raça de servidores com auditoria de dados.
* **AC4 (Interface):** [ ] Planejado. Refatoração UI/UX baseada no Design System institucional.

## 5. Destaques Técnicos da AC3 (Servidores)
Nesta etapa, o projeto atuou como ferramenta de **auditoria institucional**:
* **View SQL Especializada:** Criação da `vw_ac3_final_servidores` para filtrar especificamente Docentes e Técnicos Administrativos.
* **Tratamento com `COALESCE`:** Conversão de valores nulos em "Não Declarado", garantindo integridade estatística.
* **Identificação de Lacuna:** O dashboard revelou **100% de ausência de autodeclaração racial** na base de servidores, subsidiando propostas de atualização cadastral pelo NEABI.
* **Análise Geográfica:** Segmentação por Campus para identificar a densidade funcional em cada unidade do IFC.

## 6. Procedimentos de Execução
1. **Banco de Dados:** Execute o script SQL abaixo no pgAdmin:
```sql
DROP VIEW IF EXISTS vw_ac3_final_servidores CASCADE;

CREATE VIEW vw_ac3_final_servidores AS
SELECT 
    campus, 
    categoria, 
    COALESCE(cor_raca, 'Não Declarado') as cor_raca
FROM public.dados_ifc_neabi
WHERE categoria IN ('Docente', 'Técnico Administrativo');

SELECT * FROM vw_ac3_final_servidores;

---

**Responsável Técnico:** Áubio Aurélio da Rocha Ferreira

**Vínculo Institucional:** Coordenador NEABI / Técnico de Laboratório de Informática - IFC Campus Concórdia
