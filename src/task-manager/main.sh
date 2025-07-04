#!/bin/bash

# Query or update tasks
# Expected args: [filter] <command> [mods]

# STATUS: ISSUE 1-3
# TESTS:  FAIL

set -euo pipefail

source "$ROOT/src/config-loader.sh"

# declarations
TASKRC=''
TASKDATA=''

main() {
  load_config
  dispatch $@
}

# for now, TASKDATA is entirely dependant on AUTODATA
load_config() {

  TASKRC="$(_get_file task.rc)"
  TASKDATA="$AUTODATA"

  if ! [[ -f "$TASKRC" ]]; then
    >&2 echo "ERROR: .taskrc file '$TASKRC' NOT FOUND, EXIT"
    exit 10
  fi

  if ! [[ -d "$TASKDATA" ]]; then
    >&2 echo "ERROR: \$AUTODATA NOT DEFINED, EXIT"
    exit 11
  else
    _set task.data "$TASKDATA"
  fi
}

dispatch() {
  set -x
  if [[ -z "$@" ]]; then
    special_cmd='null'
  else
    special_cmd="$1"
  fi

  case "$special_cmd" in
    help | --help | -h)   show_help ;;          # tested
    add | new)            insert_task "$@";;    # no issue assigned
    *) execute_task "$@" ;;                     # ISSUE ?
  esac
}

show_help() {
  help_txt=$(_get_file doc.help.task)
  if ! [[ -f "$help_txt" ]]; then
    >&2 echo 'help.txt file missing'
    exit 3
  else
    echo -e "$(cat $help_txt)" | less
    exit 0
  fi
}

insert_task() {
  set -x
  shift; # remove 'add keyword'
  if [[ -z "$@" ]]
    then task _columns
    else execute_task add $@
  fi
}

execute_task() {
  task $@
}

main $@
