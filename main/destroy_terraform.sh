#!/bin/bash

terraform init

terraform workspace select dev

terraform destroy