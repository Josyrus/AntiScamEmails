#!/bin/bash

RESET='\033[0m'

BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
LCYAN='\033[0;96m'

BACK_RED='\033[41m'
BACK_LBLUE='\033[104m'

bold='\033[1m'
dim='\033[2m'
underline='\033[4m'

log_info() {
    echo
    echo -e "${BLUE}[INFO]${RESET} $1"
}

log_ok() {
    echo
    echo -e "${GREEN}[OK]${RESET} $1"
}

log_warn() {
    echo
    echo -e "${YELLOW}[WARN]${RESET} $1"
}

log_error() {
    echo
    echo -e "${RED}[ERROR]${RESET} $1"
}

log_json() {
    echo
    echo -e "${YELLOW}[JSON]${RESET} $1"
}
