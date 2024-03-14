#!/bin/sh

reboot
RETURN_CODE=$?

echo "Content-type: text/html"
echo ""
echo "<h1>OK ($RETURN_CODE)</h1>"

