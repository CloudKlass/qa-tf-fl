variable "backend_address_pool_name" {
    default = "labBackendPool"
}

variable "frontend_port_name" {
    default = "labFrontendPort"
}

variable "frontend_ip_configuration_name" {
    default = "labAGIPConfig"
}

variable "http_setting_name" {
    default = "labHTTPsetting"
}

variable "listener_name" {
    default = "labListener"
}

variable "request_routing_rule_name" {
    default = "labRoutingRule"
}

variable "redirect_configuration_name" {
    default = "labRedirectConfig"
}
