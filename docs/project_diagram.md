# dbt Project Documentation and Transformation Diagram

## Short Interview Brief

This project is a dbt analytics pipeline built using a medallion-style architecture: Source -> Bronze -> Silver -> Gold.

Raw sales, returns, customer, product, date, and store tables are first registered as dbt sources. The Bronze layer keeps a clean one-to-one copy of the required source columns. The Silver layer applies data quality filters and business enrichment such as effective sales price, customer tenure, store age group, and ingestion timestamps. The Gold layer joins facts with dimensions and creates business-ready reporting marts for daily sales, monthly sales, customer metrics, customer lifetime value, product performance, and store performance.

The final output helps answer business questions like:

- How much revenue did we generate by day or month?
- Which products and stores are performing best?
- What is the return rate by product, store, or month?
- Which customers are most valuable?

## Pictorial Transformation Flow

```mermaid
flowchart LR
  classDef source fill:#e8f1ff,stroke:#2463a6,color:#111827
  classDef bronze fill:#fff1dc,stroke:#b7791f,color:#111827
  classDef silver fill:#e9f8ef,stroke:#2f855a,color:#111827
  classDef gold fill:#fff7bf,stroke:#b89b00,color:#111827
  classDef transform fill:#f4f4f5,stroke:#71717a,color:#111827

  subgraph S["Source Layer: raw operational tables"]
    S1["fact_sales"]
    S2["fact_returns"]
    S3["dim_customer"]
    S4["dim_product"]
    S5["dim_date"]
    S6["dim_store"]
  end

  subgraph B["Bronze Layer: raw column selection"]
    B1["bronze_sales"]
    B2["bronze_returns"]
    B3["bronze_customer"]
    B4["bronze_product"]
    B5["bronze_date"]
    B6["bronze_store"]
  end

  subgraph T1["Bronze transformations"]
    BT["Select business columns<br/>Keep source grain<br/>Expose raw data to dbt"]
  end

  subgraph SI["Silver Layer: cleaned and enriched entities"]
    SI1["silver_sales<br/>effective_price"]
    SI2["silver_returns<br/>valid sales_id"]
    SI3["silver_customer<br/>customer_tenure"]
    SI4["silver_product<br/>valid product_sk"]
    SI5["silver_store<br/>store_age_group"]
    SI6["silver_date<br/>valid date_sk"]
  end

  subgraph T2["Silver transformations"]
    ST["Filter null keys<br/>Add derived attributes<br/>Add ingested_at timestamp<br/>Protect division with nullif"]
  end

  subgraph G["Gold Layer: business reporting marts"]
    G1["gold_daily_sales"]
    G2["gold_monthly_summary"]
    G3["gold_customer_metrics"]
    G4["gold_product_performance"]
    G5["gold_store_performance"]
    G6["gold_customer_ltv"]
  end

  subgraph T3["Gold transformations"]
    GT["Join facts with dimensions<br/>Aggregate revenue and quantities<br/>Calculate averages and return rates<br/>Add computed_at timestamp"]
  end

  S1 --> B1
  S2 --> B2
  S3 --> B3
  S4 --> B4
  S5 --> B5
  S6 --> B6

  B1 --> BT --> SI1
  B2 --> BT --> SI2
  B3 --> BT --> SI3
  B4 --> BT --> SI4
  B5 --> BT --> SI6
  B6 --> BT --> SI5

  SI1 --> ST
  SI2 --> ST
  SI3 --> ST
  SI4 --> ST
  SI5 --> ST
  SI6 --> ST

  ST --> G1
  ST --> G2
  ST --> G3
  ST --> G4
  ST --> G5
  ST --> G6

  G1 --> GT
  G2 --> GT
  G3 --> GT
  G4 --> GT
  G5 --> GT
  G6 --> GT

  class S1,S2,S3,S4,S5,S6 source
  class B1,B2,B3,B4,B5,B6 bronze
  class SI1,SI2,SI3,SI4,SI5,SI6 silver
  class G1,G2,G3,G4,G5,G6 gold
  class BT,ST,GT transform
```

## Detailed Data Lineage

```mermaid
flowchart LR
  subgraph Sources["Sources: dbt_tutorial_dev.source"]
    fact_sales["fact_sales"]
    fact_returns["fact_returns"]
    dim_customer["dim_customer"]
    dim_product["dim_product"]
    dim_date["dim_date"]
    dim_store["dim_store"]
  end

  subgraph Bronze["Bronze models"]
    bronze_sales["bronze_sales<br/>view"]
    bronze_returns["bronze_returns<br/>view"]
    bronze_customer["bronze_customer<br/>view"]
    bronze_product["bronze_product<br/>view"]
    bronze_date["bronze_date<br/>table"]
    bronze_store["bronze_store<br/>view"]
  end

  subgraph Silver["Silver models"]
    silver_sales["silver_sales<br/>table"]
    silver_returns["silver_returns<br/>table"]
    silver_customer["silver_customer<br/>table"]
    silver_product["silver_product<br/>table"]
    silver_date["silver_date<br/>table"]
    silver_store["silver_store<br/>table"]
  end

  subgraph Gold["Gold marts"]
    gold_daily_sales["gold_daily_sales<br/>table"]
    gold_monthly_summary["gold_monthly_summary<br/>table"]
    gold_customer_metrics["gold_customer_metrics<br/>table"]
    gold_customer_ltv["gold_customer_ltv<br/>incremental"]
    gold_product_performance["gold_product_performance<br/>table"]
    gold_store_performance["gold_store_performance<br/>table"]
  end

  fact_sales --> bronze_sales --> silver_sales
  fact_returns --> bronze_returns --> silver_returns
  dim_customer --> bronze_customer --> silver_customer
  dim_product --> bronze_product --> silver_product
  dim_date --> bronze_date --> silver_date
  dim_store --> bronze_store --> silver_store

  silver_sales --> gold_daily_sales
  silver_date --> gold_daily_sales

  silver_date --> gold_monthly_summary
  silver_sales --> gold_monthly_summary
  silver_returns --> gold_monthly_summary

  silver_customer --> gold_customer_metrics
  silver_sales --> gold_customer_metrics
  silver_sales --> gold_customer_ltv

  silver_product --> gold_product_performance
  silver_sales --> gold_product_performance
  silver_returns --> gold_product_performance

  silver_store --> gold_store_performance
  silver_sales --> gold_store_performance
  silver_returns --> gold_store_performance
```

## Transformations Performed

| Layer | Transformation | Example models |
| --- | --- | --- |
| Source | Defines raw input tables in `sources.yml` | `fact_sales`, `fact_returns`, `dim_customer`, `dim_product`, `dim_date`, `dim_store` |
| Bronze | Selects required source columns and standardizes the dbt entry point for each raw table | `bronze_sales`, `bronze_returns`, `bronze_customer`, `bronze_product`, `bronze_date`, `bronze_store` |
| Silver | Removes records with missing business keys | `silver_sales`, `silver_returns`, `silver_customer`, `silver_product`, `silver_date`, `silver_store` |
| Silver | Adds derived fields for analytics | `effective_price`, `customer_tenure`, `store_age_group` |
| Silver | Adds load metadata | `ingested_at` |
| Gold | Joins fact data with dimensions | sales with date, customer, product, and store context |
| Gold | Aggregates business metrics | transaction counts, units sold, total revenue, lifetime value, refunds, return rates |
| Gold | Adds reporting metadata | `computed_at` |

## Model-Level Explanation

| Model | Inputs | Main transformation | Business use |
| --- | --- | --- | --- |
| `bronze_sales` | `fact_sales` | Selects sales transaction columns | Base sales fact table |
| `silver_sales` | `bronze_sales` | Filters missing `sales_id`, adds `effective_price`, adds `ingested_at` | Clean transaction-level sales data |
| `bronze_returns` | `fact_returns` | Selects return transaction columns | Base returns fact table |
| `silver_returns` | `bronze_returns` | Filters missing `sales_id`, adds `ingested_at` | Clean return-level data |
| `silver_customer` | `bronze_customer` | Filters missing `customer_sk`, derives `customer_tenure` | Customer segmentation |
| `silver_product` | `bronze_product` | Filters missing `product_sk`, adds `ingested_at` | Product dimension for reporting |
| `silver_date` | `bronze_date` | Filters missing `date_sk`, adds `ingested_at` | Calendar dimension for reporting |
| `silver_store` | `bronze_store` | Filters missing `store_sk`, derives `store_age_group` | Store performance segmentation |
| `gold_daily_sales` | `silver_sales`, `silver_date` | Aggregates transactions, customers, units, revenue, average transaction value by day | Daily sales dashboard |
| `gold_monthly_summary` | `silver_date`, `silver_sales`, `silver_returns` | Aggregates monthly revenue, active customers, products sold, stores, refunds, return rate | Monthly executive summary |
| `gold_customer_metrics` | `silver_customer`, `silver_sales` | Calculates orders, units purchased, total spend, average order value, revenue per order | Customer value analysis |
| `gold_customer_ltv` | `silver_sales` | Calculates lifetime value per customer as total net sales | Customer lifetime value analysis |
| `gold_product_performance` | `silver_product`, `silver_sales`, `silver_returns` | Calculates revenue, units sold, average selling price, return quantity, refund amount, return rate | Product performance analysis |
| `gold_store_performance` | `silver_store`, `silver_sales`, `silver_returns` | Calculates store transactions, customers, units, revenue, refunds, return rate | Store performance analysis |

## Simple Talking Points

1. I used dbt to structure the pipeline into Source, Bronze, Silver, and Gold layers.
2. Bronze keeps the raw data shape but selects only the columns needed for analytics.
3. Silver improves data quality by filtering null keys and adding useful business fields.
4. Gold creates final reporting marts with joins and aggregations for sales, returns, customers, customer lifetime value, products, and stores.
5. The project also includes tests for revenue and return quantity checks, plus schema tests in the model properties files.

## Project Layout

```mermaid
flowchart TD
  project["dbt_proj_to"]

  project --> config["dbt_project.yml"]
  project --> models["models/"]
  project --> macros["macros/"]
  project --> tests["tests/"]
  project --> analyses["analyses/"]
  project --> seeds["seeds/"]
  project --> snapshots["snapshots/"]

  models --> source["source/sources.yml"]
  models --> bronze["Bronze/"]
  models --> silver["Silver/"]
  models --> gold["Gold/"]

  bronze --> bronze_models["6 source staging models<br/>+ properties.yml"]
  silver --> silver_models["6 cleaned models<br/>+ properties.yml"]
  gold --> gold_models["6 analytics marts<br/>+ properties.yml"]

  macros --> describe_sources["describe_sources()"]
  macros --> list_models["list_models()"]

  tests --> positive_revenue["assert_positive_revenue.sql"]
  tests --> valid_returns["assert_valid_return_quantity.sql"]
```
