#!/usr/bin/env bash

set -o errexit #(set -e)
# set -o nounset #(set -u) #fail on unset vars
set -o pipefail
# set -o xtrace #(set -x)
# set -o errtrace #(set -E) # inherit the ERR trap in subshell and functions

WORK_DIR=$(dirname "$(readlink --canonicalize-existing "${0}" 2> /dev/null)")
readonly WORK_DIR


config_name=$1
readonly config_name
control_path_dir=$2
readonly control_path_dir
generate_config_path=$3
readonly generate_config_path

readonly SYMLINK_INCLUDES_DIR_NAME=symlink_includes

test -z $config_name && echo 'config_name var is empty, exiting …' && exit
test -z $control_path_dir && echo 'config_name var is empty, exiting …' && exit

cat <<EOF > ~/.ssh/"${config_name}"

include ${SYMLINK_INCLUDES_DIR_NAME}/include_${config_name}

### extended defaults #####################################################

Host *
    # for local file editing with sublime
    RemoteForward 52698 127.0.0.1:55555
    # for copying rmate from local comp
    ForwardAgent yes
    # for scp from remote to local
    RemoteForward 22227 127.0.0.1:22
EOF

mkdir \
    -p ~/.ssh/"${SYMLINK_INCLUDES_DIR_NAME}" \
    -p "${control_path_dir}/${config_name}"

[ ! -e ~/.ssh/"${SYMLINK_INCLUDES_DIR_NAME}/include_${config_name}" ] && ln -sf "${generate_config_path}" ~/.ssh/"${SYMLINK_INCLUDES_DIR_NAME}/include_${config_name}"
