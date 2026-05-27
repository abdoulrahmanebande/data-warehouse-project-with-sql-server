# 📊 Corporate Sales Data Warehouse (SQL Server)
## End-to-End Analytics Platform Architecture (Medallion & Star Schema)

[![Database](https://img.shields.io/badge/Database-SQL_Server_2022-red.svg?style=flat-square&logo=microsoft-sql-server&logoColor=white)](https://www.microsoft.com/en-us/sql-server/)
[![Architecture](https://img.shields.io/badge/Architecture-Medallion_(Bronze_Silver_Gold)-blue.svg?style=flat-square)](https://learn.microsoft.com/en-us/azure/databricks/lakehouse/medallion)
[![Modeling](https://img.shields.io/badge/Data_Modeling-Dimensional_Star_Schema-green.svg?style=flat-square)](https://en.wikipedia.org/wiki/Star_schema)
[![Engine](https://img.shields.io/badge/Engine-T--SQL_/_ETL-orange.svg?style=flat-square)](https://learn.microsoft.com/en-us/sql/t-sql/language-reference)

An enterprise-grade, modern Data Warehouse (DWH) platform built natively on **Microsoft SQL Server**, implementing a structured **Medallion Architecture** to ingest, process, clean, and model complex corporate sales data. 

This platform acts as a centralized "Single Source of Truth," consolidating disparate transactional and source systems into a unified, high-performance **Dimensional Star Schema** optimized for executive Business Intelligence (BI), automated reporting, and strategic data-driven decision-making.

---

## 🏗️ 1. High-Level Enterprise System Architecture

The platform processes data sequentially through three structural validation and optimization zones (Bronze $\rightarrow$ Silver $\rightarrow$ Gold). This separation decouples storage systems from high-intensity computing workloads, mitigating resource contention on online transactional systems and providing complete data immutability.

Below is the complete architectural layout mapped out from ingestion nodes to consumption schemas:

![System Architecture Diagram](docs/data_architecture.png)

---

## 🔄 2. Data Flow & End-to-End Data Lineage

The orchestration of historical and transactional pipelines follows a strict, unidirectional lineage map. Every record contains ingestion metadata columns allowing full auditability, tracing data steps backwards from final BI dashboards directly to the originating source database logs.

![Data Flow and Lineage Diagram](docs/data_flow.png)

### 🥉 The Bronze Layer (Raw Storage Zone)
* **Strategic Role:** Acts as an ingestion landing zone. Data is structurally identical to the raw source data pipelines without any alterations, index drops, or transformations.
* **Engineering Purpose:** Maximizes historical traceability, isolates production systems from operational degradation during extractions, and serves as an immutable point-in-time recovery source for debugging pipeline failures.

### 🥈 The Silver Layer (Enrichment & Operational Zone)
* **Strategic Role:** Cleans, normalizes, and prepares data records into structurally valid corporate entities.
* **Engineering Operations Implemented:**
  * **Data Cleaning:** Stripping whitespace, filtering corrupt payloads, and mapping default constraints to historical null entries.
  * **Standardization:** Conforming disparate date encodings (ISO 8601), standardization of address fields, and casting accurate system data types.
  * **Derived Columns:** Calculating structural temporal states, transactional net flags, and runtime transaction IDs.
  * **Data Enrichment:** Injecting foreign code descriptive fields and system-wide categorical master data lookups.

### 🥇 The Gold Layer (Analytical & Consumption Zone)
* **Strategic Role:** Exposes optimized structural metrics ready for public presentation, automated ingestion interfaces, and executive querying.
* **Engineering Purpose:** Implements custom analytical optimizations, pre-computed summary metrics, and structured relational constraints allowing minimal execution latency for analytics software.

---

## 🗄️ 3. Integration Model & Relational Topography

The internal relational model across staging areas manages the relational integrity of operational records, facilitating predictable processing paths during high-throughput parallel transactions.

![Integration Model Diagram](docs/data_integration_model.png)

---

## 📐 4. Analytical Gold Data Model (Star Schema)

The consumption tier implements a highly performant **Dimensional Star Schema Model**. This architecture isolates transactional quantitative measurements into a central, heavily indexed Fact table, surrounded by descriptive, flat Dimension tables to optimize performance during complex analytical filtering.

![Dimensional Star Schema Model](docs/data_model.png)

### 📊 Fact Table Design
* **`fact_sales`**: Houses immutable sales metrics, granular transactional values, financial figures, and physical quantities.

### 👥 Dimension Table Topography
* **`dim_customers`**: Consolidates customer profiles, demographics, historical tier classification, and master record variables.
* **`dim_products`**: Houses items inventory profiles, product categories, historical costs, and manufacturing descriptive metrics.
  
---

## 🚀 5. Implementation Stack & Technical Execution

* **Storage Engine:** Microsoft SQL Server (Relational Engine, Optimized Filegroups).
* **Data Definition Language:** Structured Transact-SQL (T-SQL) and SQL scripts establishing primary/foreign keys, clustered Columnstore indexes for large analytical metrics, and non-clustered indexes on dimensional foreign constraints.

---

## 📁 6. Local Workspace Setup Guidelines

To provision this ecosystem inside a local runtime environment, clone the version control repository and run the setup scripts sequentially:

```bash
# 1. Clone the version control repository locally
git clone [https://github.com/your-username/your-repository-name.git](https://github.com/your-username/your-repository-name.git)
cd your-repository-name
