variable "backend_address_pool_name" {
    default = "qaBackendPool"
}

variable "frontend_port_name" {
    default = "qaFrontendPort"
}

variable "frontend_ip_configuration_name" {
    default = "qaAppGtwIPCfg"
}

variable "http_setting_name" {
    default = "qaHTTPsetting"
}

variable "listener_name" {
    default = "qaListener"
}

variable "request_routing_rule_name" {
    default = "qaRoutingRule"
}

variable "redirect_configuration_name" {
    default = "qaRedirectConfig"
}