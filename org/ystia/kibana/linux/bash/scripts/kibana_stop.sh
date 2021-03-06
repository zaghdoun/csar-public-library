#!/bin/bash

source ${utils_scripts}/utils.sh

log begin

ensure_home_var_is_set

# To set KIBANA_HOME
source ${YSTIA_DIR}/kibana_env.sh

log info "Stopping Kibana..."
sudo systemctl stop kibana.service

if [[ ! -z "${ELASTICSEARCH_HOME}" ]]
then
    sudo systemctl stop elasticsearch.service
fi

log end
