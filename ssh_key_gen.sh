#!/usr/bin/env bash

set -e

CONFIG_SSH_RSA_DIR=${PWD}/.ssh
CONFIG_SSH_RSA_FILE=id_rsa
CONFIG_OBJ_PREFIX=VMW

# source scripts
source scripts/console.sh
source scripts/prompt.sh

update_ssh_config() {
  local rsa_dir=${1}
  local prefix=${2}

  mkdir -p ${HOME}/.ssh
  cp -a "${rsa_dir}/id_rsa" "${HOME}/.ssh/${prefix}_id_rsa"
  cp -a "${rsa_dir}/id_rsa.pub" "${HOME}/.ssh/${prefix}_id_rsa.pub"

  if prompt_yN "Append identity to ${HOME}/.ssh/config?"; then
    # if config is not present initialize
    if [ ! -f "${HOME}/.ssh/config" ]; then
      touch ${HOME}/.ssh/config

      # if rsa key already present, add it to the top
      if [ -f "${HOME}/.ssh/id_rsa" ]; then
        echo "IdentityFile ~/.ssh/id_rsa" >> "${HOME}/.ssh/config"
      fi
    fi

    # append new ssh identity
    echo "IdentityFile ~/.ssh/${prefix}_id_rsa" >> "${HOME}/.ssh/config"
  fi
}

generate_ssh_key() {
  local rsa_dir=${1}
  local prefix=${2}

  console.info "Generating new ssh rsa key at \"${rsa_dir}\"..."
  mkdir -p "${rsa_dir}"
  pushd "${rsa_dir}" &> /dev/null
  ssh-keygen -t rsa -N "" -q -f id_rsa
  popd &> /dev/null

  if prompt_yN "Copy generated SSH keys to ${HOME}/.ssh directory?"; then
    update_ssh_config "${rsa_dir}" "${prefix}"
  fi
}

# if ssh dir exists
if [ -d ${CONFIG_SSH_RSA_DIR} ]; then
  console.info "SSH Key pair found at \"${CONFIG_SSH_RSA_DIR}\""

  if prompt_yN "Regenerage SSH keys?"; then
    rm -rf "${CONFIG_SSH_RSA_DIR}"
    generate_ssh_key "${CONFIG_SSH_RSA_DIR}" "${CONFIG_OBJ_PREFIX}"
  elif prompt_yN "Copy generated SSH keys to ${HOME}/.ssh directory?"; then
    update_ssh_config "${CONFIG_SSH_RSA_DIR}" "${CONFIG_OBJ_PREFIX}"
  fi
else
  generate_ssh_key "${CONFIG_SSH_RSA_DIR}" "${CONFIG_OBJ_PREFIX}"
fi

console.info "SSH Key pair located at \"${CONFIG_SSH_RSA_DIR}\""
