# Port knocker script for bash
A simple bash script for knocking on TCP and UDP ports. Accepts unlimited number of ports. Delay between knocks can be adjusted.<br>
Tested on Debian and CentOS, but should run on any OS with bash installed.<br>
<b>No dependencies!</b>

## Usage
Download the script, make it executable and run it.<br>
```
curl https://raw.githubusercontent.com/kolbasky/port-knocker/main/knocker.sh > knocker.sh
chmod +x knocker.sh
./knocker.sh --host(-h) sample.server.net --ports(-p) udp:111,tcp:222,... [--delay(-d) 0.1s]
```
Parameters are accepted in numerous forms.<br>
```
./knocker.sh -h server -p udp:111,tcp:222 -d 0.2s
./knocker.sh --host=server --ports=udp:111,tcp:222,udp:333
./knocker.sh host server -p udp:111 -p=tcp:222 --p udp:333 --delay=1s
```
So are the ports:<br>
`tcp:111` or `111:tcp` or `111tcp` or `111/tcp` or `TCP@111` etc<br>

Any way you want it :-)

## Parameters
- `[--]host|-h` hostname or IP address to knock. Mandatory argument.<br>
- `[--]ports|-p` comma-separated list of ports to knock, can be used multiple times. Mandatory argument. <br> Example: `-p tcp:123,udp:321,tcp:433` or `-p tcp:123 -p udp:321,tcp:433` etc <br>
- `[--]delay|-d` delay between knocks. Optional argument. Default: `0.1s`<br>
- `[--]help` show help message.<br>
