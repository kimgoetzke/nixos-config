#!/usr/bin/env bash
# shellcheck disable=SC2128

f=$1
arg=$2
mysqlDatabaseName="test"
mysqlPassword="test"
mysqlUsername="test"

function drcv {
    echo "Action: $FUNCNAME - removes all unused Docker containers & volumes."
    docker container prune -f && docker volume prune -f
}

function drv {
    echo "Action: $FUNCNAME - removes all unused Docker volumes."
    docker volume prune -f
}

function dsrc {
    echo "Action: $FUNCNAME - stops and removes all Docker containers."
    docker stop "$(docker ps -a -q)" && docker container prune -f
}

function dsrcv {
    echo "Action: $FUNCNAME - stops and removes all Docker containers and removes all unused Docker volumes."
    docker stop "$(docker ps -a -q)" && docker container prune -f && docker volume prune -f
}

function nmc {
    echo "Action: $FUNCNAME - spins up new MySQL Docker container and copies env vars to clipboard."
    currentContainer=$(docker ps -f "name=local_mysql" --format "{{.ID}}")
    if [ -z "$currentContainer" ]; then
        echo "No MySQL container found. Spinning up new container..."
    else
        echo "MySQL container found. Removing container and then spinning up a new one..."
        docker stop "$currentContainer" && docker container prune -f
        sleep 2
    fi
    docker run --name=local_mysql --env=MYSQL_DATABASE="$mysqlDatabaseName" --env=MYSQL_PASSWORD="$mysqlPassword" --env=MYSQL_USER="$mysqlUsername" --env=MYSQL_ROOT_PASSWORD="$mysqlPassword" -p 3306:3306 -d mysql:8.0 --character-set-server=latin1 --collation-server=latin1_swedish_ci --log-bin-trust-function-creators=1
    sleep 1
    mysqlPort=$(docker port local_mysql | awk -F':' '{print $2}')
    echo "MySQL container accessible on port: $mysqlPort"
    testEnvVars="MYSQL_URL=jdbc:mysql://localhost:$mysqlPort/test;MYSQL_USERNAME=$mysqlUsername;MYSQL_PASSWORD=$mysqlPassword"
    echo "$testEnvVars" | xclip -selection clipboard
    echo "Copied to clipboard: $testEnvVars."
    echo "Open the run configuration for any test and paste as environment vars."
    echo "In case of errors above, clean up with: 'docker stop \$(docker ps -f \"name=local_mysql\") && docker container prune -f'."
}

function mp {
    echo "Action: $FUNCNAME - copies MySQL Docker container port number to clipboard."
    sqlDockerContainer=$(docker ps | grep "mysql:")
    if [ -z "$sqlDockerContainer" ]; then
        echo "Port number not found. Check if MySQL container is running."
    else
        portNumber=$(echo "$sqlDockerContainer" | grep -oPm1 '\d+(?=-)' | head -n 1)
        echo "$portNumber" | xclip -selection clipboard
        echo "MySQL port number ($portNumber) copied to clipboard."
    fi
}

function mid {
    echo "Action: $FUNCNAME - sets the MySQL Docker container id as a variable."
    sqlDockerContainer=$(docker ps | grep "mysql:")
    if [ -z "$sqlDockerContainer" ]; then
        echo "Container not found. Check if MySQL container is running."
    else
        containerId=$(echo "$sqlDockerContainer" | awk '{print $1}')
        echo "$containerId" | xclip -selection clipboard
        echo "MySQL container id ($containerId) copied to clipboard."
    fi
}

function mc {
    echo "Action: $FUNCNAME - executes a MySQL command in a Docker container e.g. container_name::SHOW DATABASES."
    IFS="::" read -ra parts <<< "$arg"
    if [ ${#parts[@]} -eq 1 ]; then
        command="${parts[0]}"
    elif [ ${#parts[@]} -eq 3 ]; then
        containerName="${parts[0]}"
        command="$(echo -e "${parts[2]}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
        echo "Command is: $command"
    fi
    if [ -z "$containerName" ] || [ -z "$command" ]; then
        echo "Warning: It seems you have not provided a container name. Trying to fetch it for you..."
        sqlDockerContainer=$(docker ps | grep "mysql:")
        containerName=$(echo "$sqlDockerContainer" | awk '{print $NF}')
    fi
    echo "Looking for container with name '$containerName' to execute command: $command."
    docker exec -it "$(docker ps -f "name=$containerName" --format "{{.ID}}")" bash -c "mysql -u $mysqlUsername -p$mysqlPassword -e \"$command;\""
}

function cn {
    echo "Action: $FUNCNAME - extracts the Docker container name based on a (partial) image name."
    dockerContainer=$(docker ps | grep "$arg")
    if [ -z "$dockerContainer" ]; then
        echo "Container not found. Check if a container with an image name containing '$arg' is running."
    else
        containerName=$(echo "$dockerContainer" | awk '{print $NF}')
        echo "$containerName" | xclip -selection clipboard
        echo "Container name '$containerName' has been copied to the clipboard."
    fi
}

function gp {
    echo "Action: $FUNCNAME - lists TCP connections (optional: using port number specified)."
    read -r -p "Enter port number: " port
    if [ -z "$port" ]; then
        netstat -nao
    else
        foundProcesses=$(netstat -nao | grep "PID :$port")
        echo "$foundProcesses"
        activePortPattern=":$port\s.+LISTENING\s+\d+$"
        pidNumberPattern="\d+$"

        if echo "$foundProcesses" | grep -qE "$activePortPattern"; then
            matched=$(echo "$foundProcesses" | grep -E "$activePortPattern")
            firstMatch=$(echo "$matched" | head -n 1)
            pidNumber=$(echo "$firstMatch" | grep -oE "$pidNumberPattern")
            ps -p "$pidNumber"
            read -r -p $'\nAction ([k] kill, [ENTER] none): ' action
            case $action in
                k|kill) kill -9 "$pidNumber" ;;
                *) echo "No action taken." ;;
            esac
        else
            echo "No matching process found."
        fi
    fi
}

function pi {
    echo "Action: $FUNCNAME - returns information about process for a given PID."
    read -r -p "Enter PID: " processId
    if [ -z "$processId" ]; then
        echo "No PID provided."
    else
        ps -p "$processId" -f
    fi
}

function uuid {
    echo "Action: $FUNCNAME - generates UUID."
    uuid=$(uuidgen)
    echo "$uuid" | xclip -selection clipboard
    echo "UUID ($uuid) copied to clipboard."
}

function ulid {
    echo "Action: $FUNCNAME - generates ULID."
    generatedUlid=$(uuidgen | tr 'a-f' 'A-F' | sed 's/-//g' | head -c 26)
    echo "$generatedUlid" | xclip -selection clipboard
    echo "ULID ($generatedUlid) copied to clipboard."
}

function display_menu {
    echo "Hi, $(whoami). Choose an action:"
    echo "1 - Stop & remove all Docker containers"
    echo "2 - Stop & remove all Docker containers and remove all unused volumes"
    echo "3 - Remove unused Docker volumes"
    echo "4 - Remove unused Docker containers and volumes"
    echo "5 - Spin up new MySQL Docker container and copy environment variables to clipboard"
    echo "6 - Get MySQL Docker container port number"
    echo "7 - Get MySQL Docker container id"
    echo "8 - Execute command in MySQL container (use container_name::command syntax)"
    echo "9 - Get port information (default: all listening TCP connections)"
    echo "10 - Extract the Docker container name based on a (partial) image name"
    echo "11 - Get process information"
    echo "12 - Generate UUID"
    echo "13 - Generate ULID"

    read -r -p "Select an option [1-12]: " choice
    case $choice in
        1) dsrc ;;
        2) dsrcv ;;
        3) drv ;;
        4) drcv ;;
        5) nmc ;;
        6) mp ;;
        7) mid ;;
        8) mc ;;
        9) cn ;;
        10) gp ;;
        11) pi ;;
        12) uuid ;;
        13) ulid ;;
        *) echo "Invalid choice." ;;
    esac
}

if [ "$f" == "help" ]; then
    display_menu
else
    $f
fi