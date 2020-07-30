#colors
CONSOLE_COLOR_DEFAULT=$(echo -e '\033[39m')
CONSOLE_COLOR_RESET=$(echo -e '\033[0m')
CONSOLE_COLOR_RED=$(echo -e '\033[00;31m')
CONSOLE_COLOR_GREEN=$(echo -e '\033[00;32m')
CONSOLE_COLOR_YELLOW=$(echo -e '\033[00;33m')
CONSOLE_COLOR_BLUE=$(echo -e '\033[00;34m')
CONSOLE_COLOR_PURPLE=$(echo -e '\033[00;35m')
CONSOLE_COLOR_CYAN=$(echo -e '\033[00;36m')
CONSOLE_COLOR_WHITE=$(echo -e '\033[00;97m')
CONSOLE_COLOR_GRAY=$(echo -e '\033[00;90m')
CONSOLE_COLOR_BOLD=$(echo -e '\033[1m')
CONSOLE_COLOR_UNDERLINE=$(echo -e '\033[4m')

console.timestamp() {
  date +"[%d-%m-%y %H:%M:%S]"
}

console.multiline.info() {
  #if $1 is not null
  if [ ! -z ${1+x} ]; then
    message=$1

    echo -e "$message" | sed 's/^\(.*\)$/'"${CONSOLE_COLOR_WHITE}$(console.timestamp) INFO: "'\1'"${CONSOLE_COLOR_DEFAULT}"'/g'
  fi
}

console.error() {
  #if $1 is not null
  if [ ! -z ${1+x} ]; then
    message=$1
    echo -e "${CONSOLE_COLOR_RED}$(console.timestamp) ERROR: ${message}${CONSOLE_COLOR_DEFAULT}"
  fi
}

console.warn() {
  #if $1 is not null
  if [ ! -z ${1+x} ]; then
    message=$1
    echo -e "${CONSOLE_COLOR_YELLOW}$(console.timestamp) WARN: ${message}${CONSOLE_COLOR_DEFAULT}"
  fi
}

console.info() {
  #if $1 is not null
  if [ ! -z ${1+x} ]; then
    message=$1
    echo -e "${CONSOLE_COLOR_WHITE}$(console.timestamp) INFO: ${message}${CONSOLE_COLOR_DEFAULT}"
  fi
}

console.alert() {
  #if $1 is not null
  if [ ! -z ${1+x} ]; then
    message=$1
    echo -e "${CONSOLE_COLOR_BLUE}${CONSOLE_COLOR_BOLD}$(console.timestamp) INFO: ${message}${CONSOLE_COLOR_RESET}"
  fi
}

console.debug() {
  #if $1 is not null
  if [ ! -z ${1+x} ]; then
    message=$1
    echo -e "${CONSOLE_COLOR_GRAY}$(console.timestamp) DEBUG: ${message}${CONSOLE_COLOR_DEFAULT}"
  fi
}

console.error() {
  #if $1 is not null
  if [ ! -z ${1+x} ]; then
    message=$1
    printf "\r${CONSOLE_COLOR_RED}$(console.timestamp) ERROR: ${message}${CONSOLE_COLOR_DEFAULT}"
  fi
}

consolef.warn() {
  #if $1 is not null
  if [ ! -z ${1+x} ]; then
    message=$1
    printf "\r${CONSOLE_COLOR_YELLOW}$(console.timestamp) WARN: ${message}${CONSOLE_COLOR_DEFAULT}"
  fi
}

consolef.info() {
  #if $1 is not null
  if [ ! -z ${1+x} ]; then
    message=$1
    printf "\r${CONSOLE_COLOR_WHITE}$(console.timestamp) INFO: ${message}${CONSOLE_COLOR_DEFAULT}"
  fi
}

consolef.alert() {
  #if $1 is not null
  if [ ! -z ${1+x} ]; then
    message=$1
    printf "\r${CONSOLE_COLOR_BLUE}${CONSOLE_COLOR_BOLD}$(console.timestamp) INFO: ${message}${CONSOLE_COLOR_RESET}"
  fi
}

consolef.debug() {
  #if $1 is not null
  if [ ! -z ${1+x} ]; then
    message=$1
    printf "\r${CONSOLE_COLOR_GRAY}$(console.timestamp) DEBUG: ${message}${CONSOLE_COLOR_DEFAULT}"
  fi
}
