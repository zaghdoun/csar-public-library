#!/usr/bin/env bash

source ${utils_scripts}/utils.sh
log begin

# To set variables for the proxy
ensure_home_var_is_set

if isServiceInstalled; then
    log end "Elasticsearch component '${NODE}' already installed"
    exit 0
fi

ES_ZIP_NAME="elasticsearch-${ES_VERSION}.tar.gz"
ES_DOWNLOAD_PATH="${REPOSITORY}/${ES_ZIP_NAME}"

# Install dependencies
sudo yum -y install jq wget

# Elasticsearch installation
log debug "Elasticsearch installation from ${ES_DOWNLOAD_PATH}"
wget ${ES_DOWNLOAD_PATH} -O ${HOME}/${ES_ZIP_NAME} || error_exit "ERROR: Failed to install Elasticsearch (download problem) !!!"
tar xzf ${HOME}/${ES_ZIP_NAME} -C ${HOME} || error_exit "ERROR: Failed to install Elasticsearch (untar problem) !!!"
wget ${ES_DOWNLOAD_PATH}.sha1 -O ${HOME}/${ES_ZIP_NAME}.sha1
(cd ${HOME}; echo "$(cat ${ES_ZIP_NAME}.sha1) ${ES_ZIP_NAME}" | sha1sum -c) || error_exit "ERROR: Checksum validation failed for downloaded Elasticsearch binary"

# Curator installation
log debug "Curator installation : ${CURATOR_REPO_URL} ${CURATOR_REPO_KEY_URL}"
cat $scripts/files/elasticsearch-curator.repo |
sed "s,%CURATOR_REPO_URL%,$CURATOR_REPO_URL,g" |
sed "s,%CURATOR_REPO_KEY_URL%,$CURATOR_REPO_KEY_URL,g" >/tmp/elasticsearch-curator.repo
sudo cp /tmp/elasticsearch-curator.repo /etc/yum.repos.d
# Install the public signing key
sudo rpm --import $CURATOR_REPO_KEY_URL
sudo yum -y install elasticsearch-curator


setServiceInstalled
log end "Elasticsearch installed at ${HOME}"
