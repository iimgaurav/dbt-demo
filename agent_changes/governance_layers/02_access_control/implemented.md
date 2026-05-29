# Access Control (Databricks Community Edition)
- **Permissions**: Set in Databricks Workspace UI (Admin/Editor/Viewer)
- **PII Tables**: Prefix with `confidential_` (e.g., `confidential_customers`)
- **Sensitive Columns**: Tag in `schema.yml` with `meta: { pii: true }`
