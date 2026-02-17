# open-ports-scanner

This helm chart deploys the open ports scanner application as a Kubernetes CronJob with automated network open ports scanning and sends open ports reports/new open ports reports as Telegram notifications.

## Prerequisites

- Kubernetes 1.25+
- Helm 3.0+
- PersistentVolume provisioner support in the underlying infrastructure (if persistence is enabled)

## Values

The following table lists the configurable values of the chart and their defaults.

| Key | Description | Default |
| ----------- | ----------- | ----------- |
| `image.repository` | Image repository | `vfabi/open-ports-scanner` |
| `image.tag` | Image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `cronjob.schedule` | Cron schedule | `0 */6 * * *` (every 6 hours) |
| `cronjob.concurrencyPolicy` | Concurrency policy | `Forbid` |
| `cronjob.successfulJobsHistoryLimit` | Successful jobs to retain | `3` |
| `cronjob.failedJobsHistoryLimit` | Failed jobs to retain | `1` |
| `resources.requests.memory` | Memory request | `128Mi` |
| `resources.requests.cpu` | CPU request | `100m` |
| `resources.limits.memory` | Memory limit | `256Mi` |
| `resources.limits.cpu` | CPU limit | `500m` |
| `persistence.enabled` | Enable persistent storage | `true` |
| `persistence.storageClassName` | Storage class name | `""` (default) |
| `persistence.accessMode` | Access mode | `ReadWriteOnce` |
| `persistence.size` | Storage size | `1Gi` |
| `persistence.mountPath` | Mount path in container | `/app/data` |
| `config.nmapTargets` | Comma-separated Nmap targets (IP addresses or domains) to scan | `""` (required) |
| `config.nmapPorts` | Comma-separated Nmap ports to scan | `""` |
| `config.sendReportOpenPortsTelegram` | Send open ports report to Telegram | `""` |
| `config.sendReportNewOpenPortsTelegram` | Send new open ports (changes) report to Telegram | `""` |
| `secrets.telegramBotToken` | Telegram bot token | `""` |
| `secrets.telegramChatIdOpenPortsReport` | Telegram chat ID for open ports report | `""` |
| `secrets.telegramChatIdNewOpenPortsReport` | Telegram chat ID for new open ports report | `""` |

## Install

To install the chart with the release name `my-scanner` in the `example` namespace:

```bash
helm install my-scanner ./deploy/kubernetes/helm --namespace example --create-namespace
```

## Install (with custom values.yaml)

Create a `custom-values.yaml` file. For example:

```yaml
cronjob:
  schedule: "0 */12 * * *"  # Run every 12 hours

config:
  nmapTargets: "192.168.1.1,192.168.1.10"
  nmapPorts: "22,80,443,8080"
  sendReportOpenPortsTelegram: "true"
  sendReportNewOpenPortsTelegram: "true"

secrets:
  telegramBotToken: "1234567890:AABBCc1234567890nVoluqEOZXCzxc"
  telegramChatIdOpenPortsReport: "-1234567890"
  telegramChatIdNewOpenPortsReport: "-234567891"  
```

Then install with:

```bash
helm install my-scanner ./deploy/kubernetes/helm -f custom-values.yaml --namespace example --create-namespace
```

## Uninstall

```bash
helm uninstall my-scanner --namespace example 
```

## Upgrade

```bash
helm upgrade my-scanner ./deploy/kubernetes/helm -f custom-values.yaml --namespace example
```

## Testing

Template rendering:

```bash
helm template my-scanner ./deploy/kubernetes/helm --debug
```

Template rendering with custom values:

```bash
helm template my-scanner ./deploy/kubernetes/helm -f custom-values.yaml --debug
```

Linting:

```bash
helm lint ./deploy/kubernetes/helm
```

Test installation (without actual deployment):

```bash
helm install my-scanner ./deploy/kubernetes/helm --dry-run --debug
```
