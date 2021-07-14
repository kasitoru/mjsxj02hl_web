#!/bin/sh

FILENAME="/tmp/image.jpg"
MESSAGE=$(mjsxj02hl --get-image $FILENAME)

if [ $? -eq 0 ]; then
    echo "Content-type: image/jpeg"
    echo ""
    cat $FILENAME
    rm $FILENAME
else
    echo "Content-type: text/html"
    echo ""
    echo "<h1>$MESSAGE</h1>"
fi

