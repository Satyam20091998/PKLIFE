{{ codegen.generate_model_yaml(
    model_names=['child_customer'],
    upstream_descriptions=True
) }}




dbt run-operation generate_src_yml --args '{"database_name": "PL_DB", "schema_name": "SOURCE", "table_name": "RAW_ACCOUNT","model_name":"src_customer"}'

