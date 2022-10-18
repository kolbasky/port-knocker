#!/usr/bin/env bash
shopt -s extglob
programname=$0

function usage {
    printf "Usage:\n"
    printf " ${programname} --host(-h) sample.server.net --ports(-p) 111:udp,222:tcp,... [--delay(-d) 0.1s]\n"
    printf " ${programname} --host(-h) sample.server.net --port(-p) 111:udp --port(-p) 222:tcp ... [--delay(-d) 0.1s]\n\n"
    printf "Parameters:\n"
    printf " [--]host|-h \t hostname or IP address to knock. Mandatory argument.\n"
    printf " [--]ports|-p \t comma-separated list of ports and protocols to knock, can be used multiple times.
\t\t e.g: -p tcp:123,udp:321,tcp:433 OR -p tcp:123 -p udp:321,tcp:433\n"
    printf " [--]delay|-d \t delay between knocks. Optional argument. Default: 0.1s\n"
    printf " [--]help \t show this help message\n\n"
    printf "Notes:\n"
    printf " ports can be specified almost in any form: TCP:111, 111/tcp, tCp111, 111tcp, tcp@111 etc\n"
    printf " '=' or ' ' can be used to specify parameters: --ports 123:tcp --ports=123:tcp\n"
}

if [ $# = 0 ]; then usage; exit 1; fi
# to support --parameter=value and --parameter value syntax.
set -- ${@//=/ }
# parse input arguments
while [ $# -gt 0 ]; do
    case "${1}" in
        *(-)help)
            usage
            exit 0
	    ;;
        *(-)host|*(-)h)
            host="${2}"
            shift
	    ;;
        *(-)port?(s)|*(-)p)
            ports+="${2} "
            shift
	    ;;
        *(-)delay|*(-)d|*(-)pause|*(-)sleep)
            delay="${2}"
            shift
	    ;;
        *)
            printf "Error: wrong argument \"${1}\"\n"
            usage
            exit 1
	    ;;
    esac
    shift
done

if [ -z "$host" ]
then
  printf "Error: missing mandatory argument \"--host|-h\"\n"
  usage
  exit 1
fi

if [ -z "$ports" ]
then
  printf "Error: missing mandatory argument \"--ports|-p\"\n"
  usage
  exit 1
fi

# parse --ports argument. we will support a lot of types of delimiters or their absence
# we will remove delimiters and use regex later to parse out port and proto
ports=${ports//,/ }
ports=${ports//[:\/\-\_@.~$\#\^\*]/}
delay=${delay:-"0.1s"}

for element in ${ports}
do
  proto=${element//[0-9]/}
  if [ "${proto,,}" != "tcp" ] && [ "${proto,,}" != "udp" ]
  then
    printf "Error: wrong protocol type \"${proto}\"\n"
    printf "Allowed protocols are: tcp, udp\n"
    usage
    exit 1
  fi
done

# knocking part
for element in ${ports}
do
  # removed all delimiters before. use regex-replace to parse port and proto.
  port=${element//[a-zA-Z]/}
  proto=${element//[0-9]/}
  printf "knocking: ${proto,,} ${port}\n"
  # printf to /dev/tcp/ will hang for some time, if port is not opened. 
  # timeout trick is needed.
  timeout ${delay} bash -c "printf '\n' > /dev/${proto,,}/${host}/${port}"
  sleep ${delay}
done

printf "Done!\n"
exit 0
