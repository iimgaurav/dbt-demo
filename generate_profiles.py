import yaml
import os

def clean(val):
    return val.replace('\r', '').replace('\n', '').strip()

# Common connection settings
host = clean(os.environ.get('DBT_DATABRICKS_HOST_NAME', ''))
http_path = clean(os.environ.get('DBT_DATABRICKS_HTTP_PATH', ''))
token = clean(os.environ.get('DBT_DATABRICKS_TOKEN', ''))

# Environment-specific catalog names
catalog_dev = clean(os.environ.get('DBT_DATABRICKS_CATALOG_DEV', 'dbt_tutorial_dev'))
catalog_uat = clean(os.environ.get('DBT_DATABRICKS_CATALOG_UAT', 'dbt_tutorial_uat'))
catalog_prod = clean(os.environ.get('DBT_DATABRICKS_CATALOG_PROD', 'dbt_tutorial_prod'))

# Get the active target from DBT_TARGET or default to dev
active_target = clean(os.environ.get('DBT_TARGET', 'dev'))

profile = {
    'dbt_proj_to': {
        'target': active_target,
        'outputs': {
            'dev': {
                'type': 'databricks',
                'host': host,
                'http_path': http_path,
                'token': token,
                'catalog': catalog_dev,
                'schema': 'default',
                'threads': 4
            },
            'uat': {
                'type': 'databricks',
                'host': host,
                'http_path': http_path,
                'token': token,
                'catalog': catalog_uat,
                'schema': 'default',
                'threads': 4
            },
            'prod': {
                'type': 'databricks',
                'host': host,
                'http_path': http_path,
                'token': token,
                'catalog': catalog_prod,
                'schema': 'default',
                'threads': 4
            }
        }
    }
}

with open('profiles.yml', 'w') as f:
    yaml.dump(profile, f, default_flow_style=False)

print(f"profiles.yml generated successfully with target: {active_target}")
print(f"  dev catalog:  {catalog_dev}")
print(f"  uat catalog:  {catalog_uat}")
print(f"  prod catalog: {catalog_prod}")
