#!/usr/bin/env bash

source ${utils_scripts}/utils.sh
source ${geoscripts}/utils.sh
source ${scripts}/logstash_utils.sh

ensure_home_var_is_set

log begin

# Get GEONAMES_HOME
source ${YSTIA_DIR}/${NODE}-service.env

log info "Update GeoNames index using file $FNAME"

get_geonames_from_repository $FNAME $REPOSITORY || error_exit "Cannot download $FNAME from $REPOSITORY"

# Change input with $FNAME
sed -i -e "s@data/.*txt@data/${FNAME}.txt@" ${LOGSTASH_HOME}/conf/geonames_parse.conf

send_sighup_ifneeded

log end