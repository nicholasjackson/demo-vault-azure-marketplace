#!/bin/bash

set -e

vault write pki/issue/marketplace \
    common_name=app.marketplace.demo