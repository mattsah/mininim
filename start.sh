#!/bin/sh

SCRIPT_DIR=$(dirname "$0")

cd $SCRIPT_DIR
trap 'kill -- -$$' INT
bin/app serve &
caddy run --config config/caddyfile --adapter caddyfile &
wait
