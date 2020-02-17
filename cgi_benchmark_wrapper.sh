#!/bin/bash
# Generate bogus CGI load without involving a web server.
#
# This wrapper expects a single argument, which is the number of times to invoke the cgi
# script. Each invocation is provided with a random IP address, as though we were being
# invoked by several different clients.

function random_ip() {
	# Generate an IP address that looks like N.N.N.N
	octet="$(( $RANDOM % 16 ))"
	echo "$octet.$octect.$octet.$octet"
}

num_requests=$1
for i in $(seq 1 ${num_requests}); do
	REMOTE_ADDR=`random_ip` ./cgi.py
done
