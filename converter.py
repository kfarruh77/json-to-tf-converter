import json
import textwrap
import re


def convert_queries(string):
    return string.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")


def indent_block(block, indent_level=1):
    return textwrap.indent(block, "\t" * indent_level)


def generate_terraform_from_json(json_data):
    terraform = 'resource "sumologic_dashboard" "dashboard" {\n'

    terraform += indent_block('title = "${var.application} Dashboard Suite"\n')
    terraform += indent_block(f'description = "{json_data["description"]}"\n')
    terraform += indent_block('folder_id = "${sumologic_folder.folder.id}"\n')
    terraform += indent_block(f'theme = "{json_data["theme"]}"\n')
    terraform += indent_block("refresh_interval = 120\n")

    time_range_block = "time_range {\n"
    time_range_block += indent_block("begin_bounded_time_range {\n")
    time_range_block += indent_block("from {\n", 2)
    time_range_block += indent_block("relative_time_range {\n", 3)
    time_range_block += indent_block('relative_time = "-15m"\n', 4)
    time_range_block += indent_block("}\n", 3)
    time_range_block += indent_block("}\n", 2)
    time_range_block += indent_block("}\n")
    time_range_block += "}\n"

    terraform += indent_block(time_range_block)

    for panel in json_data["panels"]:
        panel_block = "panel {\n"
        if panel["panelType"] == "TextPanel":
            text_panel_block = "text_panel {\n"
            text_panel_block += indent_block(f'key = "{panel["key"]}"\n')
            text_panel_block += indent_block(
                f'visual_settings = "{convert_queries(panel["visualSettings"])}"\n'
            )
            text_panel_block += indent_block(
                f'keep_visual_settings_consistent_with_parent = {str(panel["keepVisualSettingsConsistentWithParent"]).lower()}\n'
            )
            text_panel_block += indent_block(f'title = "{panel["title"]}"\n')
            text_panel_block += indent_block(f'text = "{panel["text"]}"\n')
            text_panel_block += "}\n"
            panel_block += indent_block(text_panel_block)

        elif panel["panelType"] == "SumoSearchPanel":
            sumo_search_panel_block = "sumo_search_panel {\n"
            sumo_search_panel_block += indent_block(f'key = "{panel["key"]}"\n')
            sumo_search_panel_block += indent_block(
                f'visual_settings = "{convert_queries(panel["visualSettings"])}"\n'
            )
            sumo_search_panel_block += indent_block(
                f'keep_visual_settings_consistent_with_parent = {str(panel["keepVisualSettingsConsistentWithParent"]).lower()}\n'
            )
            sumo_search_panel_block += indent_block(f'title = "{panel["title"]}"\n')
            for query in panel["queries"]:
                sumo_search_panel_block += indent_block("query {\n")
                sumo_search_panel_block += indent_block(
                    f'query_string = "{convert_queries(query["queryString"])}"\n', 3
                )
                sumo_search_panel_block += indent_block(
                    f'query_type = "{query["queryType"]}"\n', 3
                )
                sumo_search_panel_block += indent_block(
                    f'query_key = "{query["queryKey"]}"\n', 3
                )
                if query["queryType"] == "Metrics":
                    sumo_search_panel_block += indent_block(
                        f'metrics_query_mode  = "{query["metricsQueryMode"]}"\n', 3
                    )
                sumo_search_panel_block += indent_block("}\n")
            sumo_search_panel_block += "}\n"
            panel_block += indent_block(sumo_search_panel_block)

        panel_block += "}\n"

        terraform += indent_block(panel_block)

    layout_block = "layout {\n"
    layout_block += indent_block(f'{json_data["layout"]["layoutType"].lower()} {{\n')
    for structure in json_data["layout"]["layoutStructures"]:
        layout_block += indent_block("layout_structure {\n", 2)
        layout_block += indent_block(f'key = "{structure["key"]}"\n', 3)
        layout_block += indent_block(
            f'structure = "{convert_queries(structure["structure"])}"\n', 3
        )
        layout_block += indent_block("}\n", 2)
    layout_block += indent_block("}\n")
    layout_block += "}\n"
    terraform += indent_block(layout_block)

    for variable in json_data["variables"]:
        variable_block = "variable {\n"
        variable_block += indent_block(f'name = "{variable["name"]}"\n')
        variable_block += indent_block(f'display_name = "{variable["displayName"]}"\n')
        variable_block += indent_block(
            f'default_value = "{variable["defaultValue"]}"\n'
        )
        variable_block += indent_block(
            f'allow_multi_select = {str(variable["allowMultiSelect"]).lower()}\n'
        )
        variable_block += indent_block(
            f'include_all_option = {str(variable["includeAllOption"]).lower()}\n'
        )
        variable_block += indent_block(
            f'hide_from_ui = {str(variable["hideFromUI"]).lower()}\n'
        )
        variable_block += indent_block("source_definition {\n")
        source_defintion = variable["sourceDefinition"]
        temp = re.sub(
            r"(?<!^)(?=[A-Z])", "_", source_defintion["variableSourceType"]
        ).lower()
        variable_block += indent_block(f"{temp}{{\n", 2)
        for item in variable["sourceDefinition"].items():
            if item[0] != "variableSourceType":
                variable_block += indent_block(f'{item[0]} = "{item[1]}"\n', 3)
        variable_block += indent_block("}\n", 2)
        variable_block += indent_block("}\n")
        variable_block += "}\n"
        terraform += indent_block(variable_block)
    terraform += "}\n"

    terraform += 'output "dashboardId" {\n'
    terraform += indent_block('value = "${sumologic_dashboard.dashboard.id}"\n')
    terraform += "}"

    return terraform


def main():
    with open("Test-farrukh_Dashboard_Suite.json", "r", encoding="utf-8") as json_file:
        json_data = json.load(json_file)

    terraform_data = generate_terraform_from_json(json_data)

    with open("dashboard.tf", "w", encoding="utf-8") as terraform_file:
        terraform_file.write(terraform_data)


if __name__ == "__main__":
    main()
