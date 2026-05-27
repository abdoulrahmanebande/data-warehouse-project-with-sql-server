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

![System Architecture Diagram](docs/architecture.png)
