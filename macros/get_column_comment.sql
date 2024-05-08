{% macro get_column_comment(table_name, schema_name, database_name, column_name) %}

{% set comment = adapter.execute(
    "SELECT COMMENT FROM {}.INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '{}' AND TABLE_NAME = '{}' AND COLUMN_NAME = '{}'".format(database_name, schema_name, table_name, column_name)
) %}

{% if comment %}
    {{ comment[0]['COMMENT'] }}
{% else %}
    No comment available for {{ column_name }} in table {{ table_name }}.
{% endif %}

{% endmacro %}
