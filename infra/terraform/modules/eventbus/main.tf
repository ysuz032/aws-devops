resource "aws_cloudwatch_event_bus" "custom_event_bus" {
  count = var.event_bus_name != "default" ? 1 : 0
  name  = var.event_bus_name
}