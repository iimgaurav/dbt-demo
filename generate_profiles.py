import yaml
import os

profile = {
    'dbt_proj_to': {
        'target': 'dev',
        'outputs': {
            'dev': {
                'type': 'databricks',
                'host': os.environ['DBT_DATABRICKS_HOST_NAME'].strip(),
                'http_path': os.environ['DBT_DATABRICKS_HTTP_PATH'].strip(),
                'token': os.environ['DBT_DATABRICKS_TOKEN'].strip(),
                'catalog': os.environ['DBT_DATABRICKS_CATALOG'].strip(),
                'schema': 'default',
                'threads': 4
            }
        }
    }
}

with open('profiles.yml', 'w') as f:
    yaml.dump(profile, f, default_flow_style=False)

print("profiles.yml generated successfully")
