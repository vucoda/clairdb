#! /bin/sh

CONTAINER="${1:-clair}"

while true
do
    docker logs "$CONTAINER" | grep "update finished" > /dev/null 2>&1
    if [ $? = 0 ]; then
        break
    fi

    docker logs "$CONTAINER" | grep "an error occured" > /dev/null 2>&1
    if [ $? = 0 ]; then
        echo "Error happend" >&2
        docker logs "$CONTAINER"
        exit 1
    fi

    echo -n "."
    sleep 10
done
echo ""
