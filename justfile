spot-name := "spot-1"
zone := "us-east5-b"

default:
    just -l

mk-spot:
    #!/usr/bin/env bash
    set -euo pipefail

    spotinfo="$(gcloud compute instances list --filter="name=('{{spot-name}}')" 2>/dev/null)"

    if ! echo $spotinfo | grep -q {{spot-name}}; then
        echo "Creating {{spot-name}}"
        gcloud compute instances create {{spot-name}} --project=astephe9-b8610af7fa5de6c7 --zone=us-east5-b --machine-type=e2-standard-2 --network-interface=address=34.162.230.23,network-tier=PREMIUM,subnet=default --no-restart-on-failure --maintenance-policy=TERMINATE --provisioning-model=SPOT --instance-termination-action=STOP --service-account=1016493563194-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20220920,mode=rw,size=50,type=projects/astephe9-b8610af7fa5de6c7/zones/us-east5-b/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any
        spotinfo="$(gcloud compute instances list --filter="name=('{{spot-name}}')" 2>/dev/null)"
    fi

    if ! echo $spotinfo | grep -q "RUNNING"; then
        echo "Starting {{spot-name}}"
        gcloud compute instances start {{spot-name}} --zone={{zone}}
    fi

stop-spot:
    #!/usr/bin/env bash
    set -euo pipefail
    spotinfo="$(gcloud compute instances list --filter="name=('{{spot-name}}')" 2>/dev/null)"

    if echo $spotinfo | grep -q "RUNNING"; then
        echo "Stopping {{spot-name}}"
        gcloud compute instances stop {{spot-name}} --zone={{zone}}
    fi

rm-spot:
    #!/usr/bin/env bash
    set -euo pipefail

    spotinfo="$(gcloud compute instances list --filter="name=('{{spot-name}}')" 2>/dev/null)"

    if echo $spotinfo | grep -q {{spot-name}}; then
        echo "Deleting {{spot-name}}"
        gcloud compute instances delete {{spot-name}} --project=astephe9-b8610af7fa5de6c7 --zone={{zone}} --delete-disks=all
    fi
