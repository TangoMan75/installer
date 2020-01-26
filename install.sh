#!/bin/bash

#/**
# * TangoMan Universal Installer
# * TangoMan Universal Installer is a ultra fast way 
# * to deploy git repositories on your local machine.
# *
# * @version 0.1.0
# * @licence MIT
# * @author  "Matthias Morin" <mat@tangoman.io>
# */

function echo_title() {     echo -ne "\033[0;1;41m${*}\033[0m\n"; }
function echo_caption() {   echo -ne "\033[0;1;44m${*}\033[0m\n"; }
function echo_bold() {      echo -ne "\033[0;1;34m${*}\033[0m\n"; }
function echo_danger() {    echo -ne "\033[0;31m${*}\033[0m\n"; }
function echo_success() {   echo -ne "\033[0;32m${*}\033[0m\n"; }
function echo_warning() {   echo -ne "\033[0;33m${*}\033[0m\n"; }
function echo_secondary() { echo -ne "\033[0;34m${*}\033[0m\n"; }
function echo_info() {      echo -ne "\033[0;35m${*}\033[0m\n"; }
function echo_primary() {   echo -ne "\033[0;36m${*}\033[0m\n"; }
function echo_error() {     echo -ne "\033[0;1;31merror:\033[0;31m\t${*}\033[0m\n"; }
function echo_label() {     echo -ne "\033[0;1;32m${*}:\033[0m\t"; }
function echo_prompt() {    echo -ne "\033[0;36m${*}\033[0m "; }

## Check app installed
function is_installed() {
    if [ ! -x "$(command -v ${1})" ]; then
        if [ -z "$(dpkg -s ${1} 2>/dev/null | grep 'install ok installed')" ]; then
            echo 'false'
            return 0
        fi
    fi
    echo 'true'
}

## Prompt user for parameter
prompt_user() {
    local ARGUMENTS=()
    local PARAMETER

    local OPTARG
    local OPTION
    while [ $# -gt 0 ]; do
        OPTIND=0
        while getopts :d:h OPTION; do
            case "${OPTION}" in
                d) DEFAULT_VALUE="${OPTARG}";;
                h) echo_label 'description'; echo_primary 'Prompt user for parameter value'
                    echo_label 'usage'; echo_primary 'promt_user [parameter] -d [default_value] -h (help)'
                    return 0;;
                :) echo_error "\"${OPTARG}\" requires value"
                    return 1;;
                \?) echo_error "invalid option \"${OPTARG}\""
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            ARGUMENTS+=("${1}")
            shift
        fi
    done

    if [ "${#ARGUMENTS[@]}" -eq 0 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 'usage'; echo_primary 'promt_user [parameter] -d [default_value] -h (help)'
        return 1
    fi

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 'usage'; echo_primary 'promt_user [parameter] -d [default_value] -h (help)'
        return 1
    fi

    PARAMETER="${ARGUMENTS[0]}"

    if [ -n "${DEFAULT_VALUE}" ]; then
        read -p "${PARAMETER} [${DEFAULT_VALUE}]: " NEW_VALUE
        if [ -n "${NEW_VALUE}" ]; then
            echo "${NEW_VALUE}"
        else
            echo "${DEFAULT_VALUE}"
        fi
    else
        read -p "${PARAMETER}: " NEW_VALUE
        echo "${NEW_VALUE}"
    fi
}

echo_title ' ################################ '
echo_title ' # TangoMan Universal Installer # '
echo_title ' ################################ '
echo

# Update packages
case "${OSTYPE}" in
    'cygwin')
        echo_caption "You're using Windows"
        echo_primary 'Have you tried Ubuntu ?'
        echo_error "ostype: \"${OSTYPE}\" is not handled";
        exit 1
    ;;
    'msys')
        echo_caption "You're using Windows"
        echo_primary 'Have you tried Ubuntu ?'
    ;;
    'darwin'*)
        echo_caption "You're using MAC"
        echo_primary 'Have you tried not selling a kidney to buy new hardware ?'
        echo_error "ostype: \"${OSTYPE}\" is not handled";
        exit 1
    ;;
    'linux-gnu')
        echo_caption "You're using Linux, congratulations !"
    ;;
    'linux-androideabi')
        echo_caption "You're using android"
    ;;
    'linux-gnueabihf')
        echo_caption "You're using net hunter... Don't hack me ;-)"
    ;;
    *)
        echo_error "ostype: \"${OSTYPE}\" is not handled";
        exit 1
    ;;
esac

# check git installed
if [ `is_installed 'git'` == 'false' ]; then
    echo_primary 'Please wait while your system is being updated'

    echo_info 'sudo apt-get update -y'
    sudo apt-get update -y

    echo_info 'sudo apt-get install -y git'
    sudo apt-get install -y git
fi

# optional: place here default values
DEFAULT_GIT_SERVER='github.com'
DEFAULT_GIT_USERNAME='TangoMan75'
DEFAULT_GIT_REPOSITORY='bash_aliases'
DEFAULT_COMMAND='make install'

GIT_SSH='false'

ARGUMENTS=()
OPTARG=''
OPTION=''
while [ $# -gt 0 ]; do
    OPTIND=0
    while getopts :c:s:u:bgHlSh OPTION; do
        case "${OPTION}" in
            c) COMMAND="${OPTARG}"; DEFAULT_COMMAND='';;
            s) GIT_SERVER="${OPTARG}"; DEFAULT_GIT_SERVER='';;
            u) GIT_USERNAME="${OPTARG}"; DEFAULT_GIT_USERNAME='';;
            b) GIT_SERVER='bitbucket.org'; DEFAULT_GIT_SERVER='';;
            g) GIT_SERVER='github.com'; DEFAULT_GIT_SERVER='';;
            l) GIT_SERVER='gitlab.com'; DEFAULT_GIT_SERVER='';;
            H) GIT_SSH='false';;
            S) GIT_SSH='true';;
            h) echo_label 'description:'; echo_primary 'TangoMan Universal Installer'
                echo_label 'usage'; echo_info "bash ${0} (repository) [-s server] [-u username] [-c command] -b (bitbucket) -g (github) -l (gitlab) -S (ssh) -H (https) -p (prompt) -h (help)"
                exit 0;;
            :) echo_error "\"${OPTARG}\" requires value"
                exit 1;;
            \?) echo_error "invalid option \"${OPTARG}\""
                exit 1;;
        esac
    done
    if [ "${OPTIND}" -gt 1 ]; then
        shift $(( OPTIND-1 ))
    fi
    if [ "${OPTIND}" -eq 1 ]; then
        ARGUMENTS+=($1)
        shift
    fi
done

if [ ${#ARGUMENTS[@]} -gt 1 ]; then
    echo_error "too many arguments (${#ARGUMENTS[@]})"
    echo_label 'usage'; echo_info "bash ${0} (repository) [-s server] [-u username] [-c command] -b (bitbucket) -g (github) -l (gitlab) -S (ssh) -H (https) -p (prompt) -h (help)"
    exit 1
fi

## set argument as repository
if [ -n "${ARGUMENTS[0]}" ]; then
    GIT_REPOSITORY="${ARGUMENTS[0]}"
    DEFAULT_GIT_REPOSITORY=''
fi

if [ -n "${DEFAULT_GIT_SERVER}" ]; then
    GIT_SERVER=$(prompt_user 'Please enter git server name' -d "${DEFAULT_GIT_SERVER}")
fi

if [ -n "${DEFAULT_GIT_USERNAME}" ]; then
    GIT_USERNAME=$(prompt_user 'Please enter git username' -d "${DEFAULT_GIT_USERNAME}")
fi

if [ -n "${DEFAULT_GIT_REPOSITORY}" ]; then
    GIT_REPOSITORY=$(prompt_user 'Please enter git repository name' -d "${DEFAULT_GIT_REPOSITORY}")
fi

if [ -n "${DEFAULT_COMMAND}" ]; then
    COMMAND=$(prompt_user 'Please enter install command' -d "${DEFAULT_COMMAND}")
fi

echo_success "Installing \"${GIT_USERNAME}/${GIT_REPOSITORY}\" from \"${GIT_SERVER}\""

# check command contains `make`
if [ -n "$(echo "${COMMAND}" | grep 'make')" ]; then
    # check make installed
    echo_primary 'Please wait while your system is being updated'

    echo_info 'sudo apt-get update -y'
    sudo apt-get update -y

    echo_info 'sudo apt-get install -y make'
    sudo apt-get install -y make
fi

if [ "${GIT_SSH}" = 'true' ]; then
    {
        # try clone over ssh
        echo_info "git clone git@${GIT_SERVER}:${GIT_USERNAME}/${GIT_REPOSITORY}.git --depth=1"
        git clone git@${GIT_SERVER}:${GIT_USERNAME}/${GIT_REPOSITORY}.git --depth=1
    } || {
        # try clone over https
        echo_info "git clone https://${GIT_SERVER}/${GIT_USERNAME}/${GIT_REPOSITORY} --depth=1"
        git clone https://${GIT_SERVER}/${GIT_USERNAME}/${GIT_REPOSITORY} --depth=1
    } || {
        echo_error "could not clone ${GIT_USERNAME}/${GIT_REPOSITORY} from ${GIT_SERVER} for some reason"
        exit 1
    }
else
    echo_info "git clone https://${GIT_SERVER}/${GIT_USERNAME}/${GIT_REPOSITORY}.git --depth=1"
    git clone https://${GIT_SERVER}/${GIT_USERNAME}/${GIT_REPOSITORY}.git --depth=1
fi

# Execute command if exist
if [ -n "${COMMAND}" ]; then
    echo_info "(cd ./${GIT_REPOSITORY} && ${COMMAND})"
    (cd ./${GIT_REPOSITORY} && ${COMMAND})

    if [ $? -ne 0 ]; then
        echo_error "could not install ${GIT_REPOSITORY}, command \"${COMMAND}\" exited with error"
        exit 1
    fi
fi

echo_success "${GIT_SERVER} ${GIT_USERNAME}/${GIT_REPOSITORY} successfully installed"
