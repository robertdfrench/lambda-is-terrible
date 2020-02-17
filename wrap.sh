#!/bin/bash
function random_ip() {
	octet="$(( $RANDOM % 16 ))"
	echo "$octet.$octect.$octet.$octet"
}

num_requests=$1
for i in $(seq 1 ${num_requests}); do
	./cgi.py `random_ip`
done
