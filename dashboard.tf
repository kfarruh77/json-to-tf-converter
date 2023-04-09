resource "sumologic_dashboard" "dashboard"{
    title =  "${var.application} Dashboard Suite"
    description =  ""
    folder_id = "${sumologic_folder.folder.id}"
    theme = "Dark"
    refresh_interval = 120
    time_range {
        begin_bounded_time_range{
            from {
                relative_time_range{   
                    relative_time = "-15m"
                }
            }
        }
    }

    # Text Panels
    panel {
        text_panel {
            key = "panelPANE-5ECCC66EB8B1384E"
            visual_settings = "{\"general\":{\"mode\":\"TextPanel\",\"type\":\"text\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"text\":{\"format\":\"markdownV2\",\"verticalAlignment\":\"center\",\"horizontalAlignment\":\"center\",\"fontSize\":24,\"backgroundColor\":\"#232f3e\",\"textColor\":\"#ff9900\"},\"series\":{},\"legend\":{\"enabled\":false}}"
            keep_visual_settings_consistent_with_parent = true
            title = " "
            text = "API Gateway"
            }
    }

    panel {
        text_panel {
            key = "panelPANE-213A50E69E2E7B4F"
            visual_settings = "{\"general\":{\"mode\":\"TextPanel\",\"type\":\"text\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"text\":{\"format\":\"markdownV2\",\"verticalAlignment\":\"center\",\"horizontalAlignment\":\"center\",\"fontSize\":24,\"backgroundColor\":\"#232f3e\",\"textColor\":\"#ff9900\"},\"series\":{},\"legend\":{\"enabled\":false}}"
            keep_visual_settings_consistent_with_parent = true
            title = " "
            text = "Activity Map"
            }
    }

    # Metrics Panels
    panel {
        sumo_search_panel {
            key = "panelPANE-D8D8DB168C125B4F"
            title = "API Requests"
            description = ""
            visual_settings = "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"markerSize\":5,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":1},\"title\":{\"fontSize\":14},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12,\"logarithmic\":false,\"title\":\"\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"Categorical Default\"},\"series\":{},\"overrides\":[{\"series\":[],\"queries\":[\"A\"],\"properties\":{\"name\":\"{{ apiname }}\"}}]}"
            keep_visual_settings_consistent_with_parent = true 
            query {
                query_string =  "metric=Count account={{account}} namespace=aws/apigateway statistic=sum region=us-east-1 apiname={{apiname}} | sum by apiname, region, account, namespace"
                query_type = "Metrics"
                query_key = "A"
                metrics_query_mode = "Advanced"
            }
        }
    }

    panel {
        sumo_search_panel {
            key = "panelPANE-60F43ABF84A16B4B"
            title = "Average Latency (ms)"
            description = ""
            visual_settings = "{\"general\":{\"mode\":\"honeyComb\",\"type\":\"honeyComb\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"honeyComb\":{\"thresholds\":[{\"from\":0,\"to\":500,\"color\":\"#98ECA9\"},{\"from\":500,\"to\":1000,\"color\":\"#F2DA73\"},{\"from\":1000,\"to\":null,\"color\":\"#FFB5B5\"}],\"shape\":\"hexagon\",\"groupBy\":[],\"aggregationType\":\"avg\",\"noDataMessage\":\"\"},\"series\":{},\"legend\":{\"enabled\":false}}"
            keep_visual_settings_consistent_with_parent = true 
            query {
                query_string = "metric=latency account={{account}} namespace=aws/apigateway statistic=average region=us-east-1 apiname={{apiname}} | avg by apiname, region, account, namespace"
                query_type = "Metrics"
                query_key = "A"
                metrics_query_mode = "Advanced"
            }
        }
    }

    panel {
        sumo_search_panel {
            key = "panelE8D427E2B94E8B46"
            title = "4XX Errors"
            description = ""
            visual_settings = "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"line\",\"displayType\":\"default\",\"markerSize\":5,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":1,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12,\"logarithmic\":false,\"title\":\"\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"Categorical Default\"},\"series\":{},\"overrides\":[{\"series\":[],\"queries\":[\"A\"],\"properties\":{\"type\":\"line\",\"name\":\"{{apiname}}\"}}]}"
            keep_visual_settings_consistent_with_parent = true 
            query {
                query_string = "metric=4XXError namespace=aws/apigateway account={{account}} region=us-east-1 statistic=sum apiname={{apiname}} | sum by region, namespace, apiname, account"
                query_type = "Metrics"
                query_key = "A"
                metrics_query_mode = "Advanced"
            }
        }
    }

    panel {
        sumo_search_panel {
            key = "panelPANE-BF2D967C9330CA43"
            title = "5XX Errors"
            description = ""
            visual_settings = "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"line\",\"displayType\":\"default\",\"markerSize\":5,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":1,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12,\"logarithmic\":false,\"title\":\"\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"Categorical Default\"},\"series\":{},\"overrides\":[{\"series\":[],\"queries\":[\"A\"],\"properties\":{\"type\":\"line\",\"name\":\"{{apiname}}\"}}]}"
            keep_visual_settings_consistent_with_parent = true 
            query {
                query_string = "metric=5XXError namespace=aws/apigateway account={{account}} region=us-east-1 statistic=sum apiname={{apiname}} | sum by region, namespace, apiname, account"
                query_type = "Metrics"
                query_key = "A"
                metrics_query_mode = "Advanced"
            }
        }
    }

     panel {
        sumo_search_panel {
            key = "panelPANE-C60607E7B9ADB845"
            title = " "
            description = ""
            visual_settings = "{\"general\":{\"mode\":\"map\",\"type\":\"map\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"series\":{},\"legend\":{\"enabled\":false}}"
            keep_visual_settings_consistent_with_parent = true 
            query {
                query_string = "\"\\\"eventsource\\\"\" account={{account}} sourceIPAddress\n| json \"eventTime\", \"eventName\", \"eventSource\", \"awsRegion\", \"userAgent\", \"recipientAccountId\", \"userIdentity\", \"requestParameters\", \"responseElements\", \"errorCode\", \"errorMessage\",  \"requestID\", \"sourceIPAddress\" as eventTime, event_name, event_source, Region, user_agent, accountId1, userIdentity, requestParameters, responseElements, errorCode, errorMessage, requestID, src_ip nodrop\n| where event_source matches \"*amazonaws.com\" and !(src_ip matches \"*.amazonaws.com\")\n| count by src_ip\n| lookup latitude, longitude, country_code, country_name, region, city, postal_code from geo://location on ip = src_ip\n| where !isnull(latitude)"
                query_type = "Logs"
                query_key = "A"
            }
        }
    }

    # layout
    layout {
        grid {
            layout_structure{
                key = "panelPANE-5ECCC66EB8B1384E"
                structure = "{\"height\":2,\"width\":24,\"x\":0,\"y\":0}"
            }
            layout_structure{
                key = "panelPANE-D8D8DB168C125B4F"
                structure = "{\"height\":7,\"width\":12,\"x\":0,\"y\":2}"
            }
            layout_structure{
                key = "panelPANE-60F43ABF84A16B4B"
                structure = "{\"height\":7,\"width\":12,\"x\":12,\"y\":2}"
            }
            layout_structure{
                key = "panelPANE-BF2D967C9330CA43"
                structure = "{\"height\":6,\"width\":12,\"x\":12,\"y\":9}"
            }
            layout_structure{
                key = "panelPANE-C60607E7B9ADB845"
                structure = "{\"height\":10,\"width\":24,\"x\":0,\"y\":18}"
            }
            layout_structure{
                key = "panelPANE-213A50E69E2E7B4F"
                structure = "{\"height\":3,\"width\":24,\"x\":0,\"y\":15}"
            }
            layout_structure{
                key = "panelE8D427E2B94E8B46"
                structure = "{\"height\":6,\"width\":12,\"x\":0,\"y\":9}"
            }
        }
    }

    # variables

    variable {
        name = "account"
        display_name = "account"
        default_value = var.defaultAccount
        allow_multi_select = false
        include_all_option = false
        hide_from_ui = false
        source_definition {
            csv_variable_source_definition {
                values = var.accounts
            }
        }
    }

    variable {
        name = "apiname"
        display_name = "apiname"
        default_value = "*"
        allow_multi_select = false
        include_all_option = true
        hide_from_ui = false
        source_definition {
            metadata_variable_source_definition {
                filter = "account={{account}}"
                key = "apiname"
            }
        }
    }
}

output "dashboardId" {
    value = "${sumologic_dashboard.dashboard.id}"
}