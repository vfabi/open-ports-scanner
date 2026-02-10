# open-ports-scanner

![GitHub last commit](https://img.shields.io/github/last-commit/vfabi/open-ports-scanner)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

[![Generic badge](https://img.shields.io/badge/hub.docker.com-vfabi/open_ports_scanner-<>.svg)](https://hub.docker.com/repository/docker/vfabi/open-ports-scanner)
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/vfabi/open-ports-scanner)
![Docker Version](https://img.shields.io/docker/v/vfabi/open-ports-scanner)
![Docker Pulls](https://img.shields.io/docker/pulls/vfabi/open-ports-scanner)

Open ports scanner application based on Nmap.  
Designed for periodic scanning of open ports with notifications in Telegram: it provides a report on all found open ports or only on changes (newly opened ports).  

![Open ports report](.githubdata/1.png)

## Status

Production ready

## Features

- Scan specified ports using Nmap. Specified ports will be scanned as TCP and UDP.
- Configure the list of ports and targets for scanning through environment variables.
- Generate a report of open ports to standard output (stdout).
- Send report of open ports to Telegram.
- Detect changes in open ports (newly opened ports) and send a report to Telegram.

## Usage

### Environment variables

| Name | Type | Description | Mandatory | Default | Example |
| --- | --- | --- | --- | --- | --- |
| NMAP_TARGETS | str | Nmap targets (IP addresses or domains) to scan. | True | | `100.100.100.1,10.11.12.13,22.22.22.22` |
| NMAP_PORTS | str | Nmap ports to scan. Specified ports will be scanned as TCP and UDP. If not specified, it will scan top 1000 ports. | False | | `22,80,443` |
| SEND_REPORT_TELEGRAM | bool/str | Send open ports report to Telegram. | False | | `true` |
| SEND_DIFF_REPORT_TELEGRAM | bool/str | Send new open ports report to Telegram. | False | | `true` |
| TELEGRAM_BOT_TOKEN | str | Telegram bot token. Should be specified if `SEND_REPORT_TELEGRAM` or `SEND_DIFF_REPORT_TELEGRAM` is "true". | False | | `1234567890:AABBCc1234567890nVoluqEOZXCzxc` |
| TELEGRAM_CHAT_ID | str | Telegram chat ID. Should be specified if `SEND_REPORT_TELEGRAM` or `SEND_DIFF_REPORT_TELEGRAM` is "true". | False | | `-1234567890` |

### Docker environment

For a Docker environment, use the following commands:

```shell

# no ports specified
docker run --rm -it -v $(pwd)/data:/app/data -e NMAP_TARGETS="100.100.100.1,10.11.12.13,22.22.22.22" vfabi/open-ports-scanner:latest open-ports-scanner

# with ports specified
docker run --rm -it -v $(pwd)/data:/app/data -e NMAP_TARGETS="100.100.100.1,10.11.12.13,22.22.22.22" -e NMAP_PORTS="22,80,443" vfabi/open-ports-scanner:latest open-ports-scanner

# with telegram notifications, send only if there are open ports changes (newly opened ports)
docker run --rm -it -v $(pwd)/data:/app/data -e NMAP_TARGETS="100.100.100.1,10.11.12.13,22.22.22.22" -e NMAP_PORTS="22,80,443" -e SEND_DIFF_REPORT_TELEGRAM="true" -e TELEGRAM_BOT_TOKEN="1234567890:AABBCc1234567890nVoluqEOZXCzxc" -e TELEGRAM_CHAT_ID="-1234567890" vfabi/open-ports-scanner:latest open-ports-scanner

# with telegram notifications, send open ports report and open ports changes report
docker run --rm -it -v $(pwd)/data:/app/data -e NMAP_TARGETS="100.100.100.1,10.11.12.13,22.22.22.22" -e NMAP_PORTS="22,80,443" -e SEND_DIFF_REPORT_TELEGRAM="true" -e SEND_REPORT_TELEGRAM="true" -e TELEGRAM_BOT_TOKEN="1234567890:AABBCc1234567890nVoluqEOZXCzxc" -e TELEGRAM_CHAT_ID="-1234567890" vfabi/open-ports-scanner:latest open-ports-scanner
```

### Kubernetes environment

There are 2 options to deploy on Kubernetes:

1. Update and apply the yaml manifest at `deploy/kubernetes/yaml/main.yaml`
2. Update and apply the helm chart at `deploy/kubernetes/helm`

## Docker

[![Generic badge](https://img.shields.io/badge/hub.docker.com-vfabi/open_ports_scanner-<>.svg)](https://hub.docker.com/repository/docker/vfabi/open-ports-scanner)  

## Build

Update docker image repository in `build.sh` and run it:

```shell
./build.sh
```

## Contributing

Please refer to each project's style and contribution guidelines for submitting patches and additions. In general, we follow the "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

## License

Apache 2.0
