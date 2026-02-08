# open-ports-scanner

This helm chart deploys the open ports scanner application as a Kubernetes CronJob with automated network open ports scanning and sends open ports reports/new open ports reports as Telegram notifications.

## Prerequisites

- Kubernetes 1.25+
- Helm 3.0+
- PersistentVolume provisioner support in the underlying infrastructure (if persistence is enabled)

## Install

To install the chart with the release name `my-scanner`:

```bash
helm install my-scanner ./deploy/helm/open-ports-scanner --namespace example --create-namespace
```

## Uninstall

To uninstall/delete the `my-scanner` deployment:

```bash
helm uninstall my-scanner --namespace example 
```

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter | Description | Default |
| ----------- | ----------- | ----------- |
| `image.repository` | Image repository | `vfabi/open-ports-scanner` |
| `image.tag` | Image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `cronjob.schedule` | Cron schedule | `0 */6 * * *` (every 6 hours) |
| `cronjob.concurrencyPolicy` | Concurrency policy | `Forbid` |
| `cronjob.successfulJobsHistoryLimit` | Successful jobs to retain | `3` |
| `cronjob.failedJobsHistoryLimit` | Failed jobs to retain | `1` |
| `config.nmapTargets` | Comma-separated IP addresses to scan | `100.100.100.1,10.11.12.13,22.22.22.22` |
| `config.nmapPorts` | Comma-separated ports to scan | `22,80,443` |
| `config.sendDiffReportTelegram` | Send differential (new open ports) report to Telegram | `true` |
| `config.sendReportTelegram` | Send full (all open ports) report to Telegram | `true` |
| `secrets.telegramBotToken` | Telegram bot token | `1234567890:AABBCc1234567890nVoluqEOZXCzxc` |
| `secrets.telegramChatId` | Telegram chat ID | `-1234567890` |
| `resources.requests.memory` | Memory request | `128Mi` |
| `resources.requests.cpu` | CPU request | `100m` |
| `resources.limits.memory` | Memory limit | `256Mi` |
| `resources.limits.cpu` | CPU limit | `500m` |
| `persistence.enabled` | Enable persistent storage | `true` |
| `persistence.storageClassName` | Storage class name | `""` (default) |
| `persistence.accessMode` | Access mode | `ReadWriteOnce` |
| `persistence.size` | Storage size | `1Gi` |
| `persistence.mountPath` | Mount path in container | `/app/data` |

## Custom values example

Create a `custom-values.yaml` file:

```yaml
cronjob:
  schedule: "0 */12 * * *"  # Run every 12 hours

config:
  nmapTargets: "192.168.1.1,192.168.1.10"
  nmapPorts: "22,80,443,8080"

secrets:
  telegramBotToken: "your-actual-telegram-bot-token"
  telegramChatId: "your-actual-telegram-chat-id"
```

Then install with:

```bash
helm install my-scanner ./deploy/helm/open-ports-scanner -f custom-values.yaml --namespace example --create-namespace
```

## Upgrade

To upgrade the release with new values:

```bash
helm upgrade my-scanner ./deploy/helm/open-ports-scanner -f custom-values.yaml --namespace example --create-namespace
```

## Testing

To test the chart rendering without installing:

```bash
helm template my-scanner ./deploy/helm/open-ports-scanner --debug
```

To validate the chart:

```bash
helm lint ./deploy/helm/open-ports-scanner
```
