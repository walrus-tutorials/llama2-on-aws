resource "aws_instance" "llama" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.vpc_name != "" ? data.aws_subnets.selected.0.ids.0 : null
  vpc_security_group_ids = var.security_group_name != "" ? [data.aws_security_group.selected.0.id] : null
  key_name      = var.key_name
  user_data     = <<-EOF
                  #!/bin/bash
                  set -ex;

                  # install docker
                  curl -fsSL https://get.docker.com | bash

                  # get text-generation-webui
                  mkdir -p /opt/llama/models && cd /opt/llama
                  git clone https://github.com/oobabooga/text-generation-webui
                  cd text-generation-webui
                  # pin the version
                  git checkout 991bb57e439ccfbcd5a0f154957c98d2e3d66c35
                  ln -s docker/{Dockerfile,docker-compose.yml,.dockerignore} .
                  cp docker/.env.example .env
                  sed -i '/^CLI_ARGS=/s/.*/CLI_ARGS=--model llama-2-7b-chat.ggmlv3.q4_K_M.bin --wbits 4 --listen --auto-devices --chat/' .env
                  sed -i '/^\s*deploy:/,$d' docker/docker-compose.yml

                  # get llama-2
                  curl -L https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGML/resolve/main/llama-2-7b-chat.ggmlv3.q4_K_M.bin --output ./models/llama-2-7b-chat.ggmlv3.q4_K_M.bin

                  # run
                  docker compose up
                  EOF

  tags = {
    "Name" = var.instance_name
  }

  root_block_device {
    volume_size = var.disk_size
  }
}


resource "null_resource" "health_check" {
  depends_on = [
    aws_instance.llama,
  ]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command     = "for i in `seq 1 60`; do if `command -v wget > /dev/null`; then wget --no-check-certificate -O - -q $ENDPOINT >/dev/null && exit 0 || true; else curl -k -s $ENDPOINT >/dev/null && exit 0 || true;fi; sleep 5; done; echo TIMEOUT && exit 1"
    interpreter = ["/bin/sh", "-c"]
    environment = {
      ENDPOINT = "http://${aws_instance.llama.public_ip}:7860"
    }
  }
}