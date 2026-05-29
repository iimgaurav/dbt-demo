# dbt_proj_to

Production-style dbt analytics project for retail sales, returns, customers, products, stores, and calendar dates.

## Architecture

The project follows a medallion layout:

- Source: raw tables registered in `models/source/sources.yml`
- Bronze: raw column selection from source tables
- Silver: cleaned and enriched business entities
- Gold: reporting marts and KPIs for analytics

## Key Outputs

- `gold_daily_sales`: daily sales, customers, units, revenue, and average selling price
- `gold_monthly_summary`: monthly revenue, activity, refunds, and return rate
- `gold_customer_metrics`: customer spend and order behavior
- `gold_customer_ltv`: customer lifetime value
- `gold_product_performance`: product revenue, returns, refunds, and return rate
- `gold_store_performance`: store revenue, transactions, customers, refunds, and return rate

## Production Controls

- Folder-level materialization rules are defined in `dbt_project.yml`
- Source, model, and column documentation is defined in YAML property files
- Key columns have `unique` and `not_null` tests
- Custom data tests validate positive revenue and valid return quantity
- Build artifacts such as `target/`, `logs/`, and `dbt_packages/` are ignored by git

## Useful Commands

```powershell
dbt parse
dbt build
dbt test
dbt docs generate
dbt docs serve
```

See `docs/project_diagram.md` for the interview brief, pictorial transformation diagram, lineage, and model-level explanation.
