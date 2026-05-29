import yaml
import os

def clean(val):
    return val.replace('\r', '').replace('\n', '').strip()

profile = {
    'dbt_proj_to': {
        'target': 'dev',
        'outputs': {
            'dev': {
                'type': 'databricks',
                'host': clean(os.environ['DBT_DATABRICKS_HOST_NAME']),
                'http_path': clean(os.environ['DBT_DATABRICKS_HTTP_PATH']),
                'token': clean(os.environ['DBT_DATABRICKS_TOKEN']),
                'catalog': clean(os.environ['DBT_DATABRICKS_CATALOG']),
                'schema': 'default',
                'threads': 4
            }
        }
    }
}

with open('profiles.yml', 'w') as f:
    yaml.dump(profile, f, default_flow_style=False)

print("profiles.yml generated successfully")
