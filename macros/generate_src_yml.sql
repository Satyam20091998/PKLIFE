{% macro generate_src_yml(database_name, schema_name,table_name,model_name) %}

{% set sql %}
    with "columns" as (
        select '- name: ' || lower(column_name) || '\n            description: "'|| lower(COMMENT) ||'"'
            as column_statement,
            table_name,
            column_name
        from {{ database_name }}.information_schema.columns
        where table_schema = '{{ schema_name | upper }}' and table_name not in ('FIVETRAN_AUDIT', 'SCHEMA_MIGRATIONS') and table_name ilike '{{table_name}}'
            and lower(column_name) not in ('_fivetran_deleted', '_fivetran_synced')
    ),
    tables as (
        select table_name,
        listagg('\n          ' || column_statement || '\n') within group ( order by column_name ) as table_desc
        from "columns"
        group by table_name
    )

    select listagg(table_desc) within group ( order by table_name )
    from tables;
{% endset %}

{%- call statement('generator', fetch_result=True) -%}
{{ sql }}
{%- endcall -%}

{%- set states=load_result('generator') -%}
{%- set states_data=states['data'] -%}
{%- set states_status=states['response'] -%}

{% set sources_yaml=[] %}
{% do sources_yaml.append('version: 2') %}
{% do sources_yaml.append('') %}
{% do sources_yaml.append('models:') %}
{% do sources_yaml.append('  - name: ' ~ model_name | lower) %}

{% do sources_yaml.append('    columns:' ~ states_data[0][0] ) %}

{% if execute %}

{% set joined = sources_yaml | join ('\n') %}
{{ log(joined, info=True) }}
{% do return(joined) %}

{% endif %}

{% endmacro %}