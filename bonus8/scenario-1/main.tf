provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "example" {
  ami                                  = "ami-05d62b9bc5a6ca605"
  availability_zone                    = "eu-north-1b"
  disable_api_stop                     = false
  disable_api_termination              = false
  ebs_optimized                        = true
  get_password_data                    = false
  hibernation                          = false
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t3.micro"
  key_name                             = "europe-stockholm"
  monitoring                           = false
  placement_partition_number           = 0
  secondary_private_ips                = []
  source_dest_check                    = true
  
  tags = {
    Name = "test"
  }

  tags_all = {
    Name = "test"
  }

  tenancy                     = "default"
  user_data                   = null
  user_data_replace_on_change = null
  vpc_security_group_ids      = ["sg-06d5357cd83631c48"]

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = 1
    threads_per_core = 2
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  enclave_options {
    enabled = false
  }

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  private_dns_name_options {
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    iops                  = 3000
    throughput            = 125
    volume_size           = 8
    volume_type           = "gp3"
  }
}