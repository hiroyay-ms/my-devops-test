#!/bin/bash

ACCESS_TOKEN=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

OWNER=hiroyay-ms
REPO=my-devops-test
RUNNER_NAME=runner-1

REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/repos/${OWNER}/${REPO}/actions/runners/registration-token | jq .token --raw-output)

cd /home/runner/actions-runner

expect -c "
set timeout 10
spawn ./config.sh --url https://github.com/${OWNER}/${REPO} --token ${REG_TOKEN} 
expect \"Enter the name of the runner group to add this runner to:\"
send \"\n\"
expect \"Enter the name of runner:\"
send \"${RUNNER_NAME}\n\"
expect \"Enter any additional labels\"
send \"container\n\"
expect \"Enter name of work folder:\"
send \"\n\"
expect \"$\"
exit 0
"

cleanup() {
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!