output "endpoint_service_url" {
  description = "URL to access the web UI"
  value = "http://${aws_instance.llama.public_ip}:7860"
}
