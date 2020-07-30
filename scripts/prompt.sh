# run a command with a progress indicator
prompt_clear_line() {
  printf "\033[2K\r"
}

prompt_clear_previous() {
  printf "\033[1A\033[2K"
}

prompt_progress() {
  #if $1 is not null
  if [ ! -z ${1+x} ]; then
    eval "${*}" &> /dev/null &
    local pid=$!
    local spin='-\|/'
    local i=0
    while kill -0 ${pid} 2>/dev/null
    do
      i=$(( (i+1) %4 ))
      printf "\r${CONSOLE_COLOR_YELLOW}${spin:$i:1}${CONSOLE_COLOR_DEFAULT}"
      sleep .1
    done
    prompt_clear_line
  fi
}

prompt_yN() {
  local question=$1

  read -r -n 1 -p "${CONSOLE_COLOR_GREEN}${question} [y/N] ${CONSOLE_COLOR_DEFAULT}" response
  prompt_clear_line
  if [[ "$response" =~ ^([yY])$ ]]; then
    return 0
  else
    return 1
  fi
}

prompt_Yn() {
  local question=$1

  read -r -n 1 -p "${CONSOLE_COLOR_GREEN}${question} [Y/n] ${CONSOLE_COLOR_DEFAULT}" response
  prompt_clear_line
  if [[ "${response}" =~ ^([nN])$ ]]; then
    return 1
  else
    return 0
  fi
}

prompt_input() {
  local question="${1}"
  local default="${2}"
  read -r -p "${CONSOLE_COLOR_GREEN}${question} [${default}] ${CONSOLE_COLOR_DEFAULT}" response
  if [[ "${response}" =~ ^[a-zA-Z0-9_]*$ ]]; then
    prompt_clear_previous

    if [[ "${response}" == "" ]]; then
      prompt_input_return="${default}"
    else
      prompt_input_return="${response}"
    fi
  else
    prompt_clear_previous
    printf "Invalid input!"
    sleep 1
    prompt_clear_line
    prompt_input "${question}" "${default}"
  fi
}
