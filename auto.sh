#!/bin/bash

if [[ "$1" == 'debug' ]]; then shift ; set -x ; fi

VERSION='0.0.0'

# Entry point to my program. Loads config.yml then routes to the appropriate subprogram as instrcuted
# from the first argument.

# STATUS: OK
# TESTS:  partially passed

ROOT="$(dirname "$(readlink -f "$0")")"
ARGS=$@

set -o pipefail
set -u # example: /home/ahmad/bin/auto: line 23: ROOT: unbound variable, holy shit this is amazing
set -e # sideffects maybe

export ROOT # don't fail me, the config loader relies on you!
source "$ROOT/src/config-loader.sh"

main() {
  # set -x
  # check_dependencies_warn
  # load_config_user
  # load_config_internal
  dispatch $ARGS
}

dispatch() {
  [[ -z "$ARGS" ]] && show_help
  case "$1" in
    # standard
    -h | help | --help )     shift ; show_help    ;;
    -v | ver* | --version)   shift ; show_version ;;

    # special
    -t | task | todo ) shift ; execute_task "$@" ;;

    # not implemented
    list | ls ) echo -e "Vehicles:\n- Elantra\n- HR-V\n\nadd vin here and other relevant info" ;;
    info) gum choose elantra HR-V --header="Info about" ;;
    sel* | switch | -s) gum choose elantra HR-V --header="SELECT" ;;
    docs) echo "query documents status" ;;
    log) echo "auto log [km|fuel|serv|task|supp|jrnl]" ;;
    service | rep | maintenance) echo "maintenance records" ;;
    cal  | rem  | reminders) echo "reminders" ;;
    email) echo "email reminders to me" ;;
    fin | report) echo "generate financial report; sum of the cost of fuel, maintenance, supplies, docs, and the cost of the vehicle itself if financed " ;;
    
    # catch-all
    * ) echo "$1: unknown subcommand, do auto --help" ;;
    
  esac
}

show_help() {
  help_txt=$(_get_file doc.help.auto)
  if ! [[ -f "$help_txt" ]]; then
    >&2 echo 'help.txt file missing'
    exit 3
  else
    echo -e "$(cat $help_txt)" | less
    exit 0
  fi
}

show_version() { echo -e "AutoKnight $VERSION" ; }

execute_task() { bash "$(_get_file task.manager)" "$@" ; }

execute_list() { exit 77; }
execute_select() { exit 77; }
execute_docs() { exit 77; }
execute_log() { exit 77; }
execute_sendemail() { exit 77; }
execute_generate_report() { exit 77; }

main

# trap 'cleanup' EXIT