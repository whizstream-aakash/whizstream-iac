#!/bin/bash

set -x

terraform init

terraform workspace select dev

terraform destroy -auto-approve