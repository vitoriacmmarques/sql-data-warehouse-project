# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀  
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in **data engineering, ETL development, data modeling, and business intelligence**.


## 🏗️ Data Architecture

The data architecture for this project follows the **Medallion Architecture** consisting of **Bronze**, **Silver**, and **Gold** layers. This methodology ensures data quality, reliability, and optimal performance for analytics and reporting.

### 📊 Architecture Overview

1. **Bronze Layer (Raw Data Storage)**  
   - Stores raw data as-is from source systems (ERP, CRM, third-party APIs, etc.).  
   - Data is ingested in its native format (CSV, JSON, Parquet, etc.) into a **SQL Server database**.  
   - No transformation is applied at this stage to preserve original data integrity.  

2. **Silver Layer (Data Cleansing & Standardization)**  
   - Cleansed, standardized, and transformed data is stored in this layer.  
   - This step includes **data type normalization, missing value handling, deduplication, and validation**.  
   - Data is structured in a relational model and optimized for faster access.  

3. **Gold Layer (Business-Ready Data)**  
   - Houses business-ready data modeled using a **Star Schema** for analytical queries.  
   - Fact and dimension tables are structured to support **BI dashboards, KPIs, and reporting**.  
   - This layer ensures high data accuracy, supporting **decision-making and business intelligence**.  

---

## 📖 Project Overview

This project aims to build a **modern data warehouse** and develop analytical solutions to extract valuable business insights. It involves:

### 🔹 1. Data Engineering & Warehouse Development

- Implementing **ETL pipelines** to ingest, clean, and process data.  
- Designing a **scalable and optimized database architecture**.  
- Applying **data validation rules** to ensure quality and integrity.  
- Leveraging indexing and partitioning techniques for **performance tuning**.  

### 🔹 2. Data Modeling & Business Logic

- Developing a **Star Schema** with **fact and dimension tables**.  
- Defining **business rules and calculated metrics** for analysis.  
- Implementing **historization techniques (SCD Type 1 & 2)** to track changes in data.  

### 🔹 3. Analytics & Reporting

- Writing **complex SQL queries** to extract business insights.  
- Developing **dashboards and reports** using **Power BI, Tableau, or SQL Server Reporting Services (SSRS)**.  
- Performing **trend analysis, customer segmentation, and predictive modeling**.  

🎯 This repository is an excellent resource for professionals looking to enhance their skills in:

- **SQL Development**  
- **Data Architecture**  
- **Data Engineering & ETL Development**  
- **Data Modeling**  
- **BI & Data Visualization**  
- **Performance Optimization & Query Tuning**  

---


## 📂 Repository Structure

```
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│                   
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project
```

---


## ☕ Stay Connected

Let's stay in touch! Feel free to connect with me on the following platforms:

LinkedIn: https://www.linkedin.com/in/vitoriacmmarques/

Email: vitoriacmarques@outlook.com.br



---

