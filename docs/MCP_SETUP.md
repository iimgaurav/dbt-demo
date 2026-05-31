# dbt MCP Server Setup

## What is MCP?

Model Context Protocol (MCP) allows AI assistants like OpenCode to interact with your dbt project. It provides tools to:
- Run dbt commands (`dbt run`, `dbt build`, `dbt test`, `dbt compile`)
- Query lineage and metadata
- Generate code and documentation
- Search through models and sources

## Configuration

The MCP server is configured in `.opencode/mcp.json`:

```json
{
  "mcpServers": {
    "dbt": {
      "command": "C:\\Users\\Navneet\\AppData\\Local\\Programs\\Python\\Python312\\Scripts\\uv.exe",
      "args": ["tool", "run", "dbt-mcp"],
      "env": {
        "DBT_PROJECT_DIR": "C:\\Users\\Navneet\\Documents\\dbt_proj_to",
        "DBT_PATH": "C:\\Users\\Navneet\\.local\\bin\\dbt.exe",
        "DBT_MCP_LOG_LEVEL": "INFO"
      }
    }
  }
}
```

## Available Tools

### dbt CLI Commands
- `dbt run` - Execute models
- `dbt build` - Run models, tests, snapshots, seeds
- `dbt test` - Run tests
- `dbt compile` - Compile SQL
- `dbt docs` - Generate documentation
- `dbt show` - Execute SQL and return results

### Metadata Discovery
- Get model details, lineage, and health
- Get source freshness and test results
- Search across your dbt project

### Code Generation
- Generate model YAML
- Generate source definitions
- Generate staging models

## Usage

1. Restart OpenCode to load the MCP configuration
2. Ask OpenCode questions about your dbt project
3. Use commands like:
   - "What models are in my project?"
   - "Run dbt compile"
   - "Show me the lineage for gold_customer_ltv"
   - "Generate YAML for my new model"

## Troubleshooting

### MCP Server Not Starting
1. Check that `uv` is installed: `uv --version`
2. Check that `dbt` is installed: `dbt --version`
3. Verify the paths in `.opencode/mcp.json` are correct

### Commands Not Working
1. Ensure `DBT_PROJECT_DIR` points to the folder containing `dbt_project.yml`
2. Ensure `DBT_PATH` points to the dbt executable

### View Logs
Set `DBT_MCP_LOG_LEVEL=DEBUG` in the MCP configuration for verbose logging.

## Resources

- [dbt MCP Documentation](https://docs.getdbt.com/docs/dbt-ai/about-mcp)
- [Available Tools](https://docs.getdbt.com/docs/dbt-ai/mcp-available-tools)
- [dbt MCP GitHub](https://github.com/dbt-labs/dbt-mcp)
