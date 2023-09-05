variable sg_name {
    default = "my-app-sg"
}

variable "vpc_id" {
}

variable "ingress" {
   default = [{
        app_port = 443
        cidr_block = ["172.0.0.0/24"]
    },
    {
        app_port = 80
        cidr_block = ["172.0.0.0/24"]
    },
    {
        app_port = 22
        cidr_block = ["0.0.0.0/0"]
    }
   ]
}