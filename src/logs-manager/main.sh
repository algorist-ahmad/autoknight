#!/bin/bash

ARGS="$@"

mileage_log_url='https://docs.google.com/spreadsheets/d/156JOMKEWYTwplv-CpO5qHW6ngFEdKflHdTtwJfQ1L4o/edit?usp=drivesdk'
fuel_log_url='https://docs.google.com/spreadsheets/d/1v5pyzDul_4alHlxygWA3xIrU4ShDOGtqchC8YG7-MO4/edit?usp=drivesdk'
service_log_file='/home/ahmad/collections/auto/fleet/3CZRZ2H52PM100370/service_log.csv'

main() {
    case "$1" in
        km | m) open_mileage_spreadsheet ;;
        fuel | f) open_fuel_log_spreadsheet ;;
        service | s) open_service_log_spreadsheet ;;
        *) >&2 echo -e "accepted values: k\e[1mm\e[0m, \e[1mf\e[0muel, \e[1ms\e[0mervice"
    esac
}

open_mileage_spreadsheet() { firefox "$mileage_log_url" ; }
open_fuel_log_spreadsheet() { firefox "$fuel_log_url" ; }
open_service_log_spreadsheet() { vd "$service_log_file" ; }

main $ARGS