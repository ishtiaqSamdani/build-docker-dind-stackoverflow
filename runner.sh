#!/bin/bash
echo "Starting runner"
cd /actions-runner || exit 1

registration_url="https://api.github.com/orgs/${GITHUB_OWNER}/actions/runners/registration-token"
echo "Requesting registration URL at '${registration_url}'"

echo "Starting runner"
payload=$(curl -sX POST -H "Authorization: token ${GITHUB_PERSONAL_TOKEN}" ${registration_url})
export RUNNER_TOKEN=$(echo $payload | jq .token --raw-output)

RUNNER_CPU="2"
RUNNER_MEMORY="4GB"
RUNNER_NAME_ARGUMENT_PASSED=$RUNNER_NAME
RUNNER_NAME="quicksilver-${RUNNER_CPU}cpu-${RUNNER_MEMORY}"

if [ -n "$RUNNER_NAME_ARGUMENT_PASSED" ]; then
    RUNNER_NAME=$RUNNER_NAME_ARGUMENT_PASSED
fi

echo "RUNNER_NAME: ${RUNNER_NAME}"

random_string() {
    cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 10 | head -n 1
}

RUNNER_ALLOW_RUNASROOT=1
export RUNNER_ALLOW_RUNASROOT=1

./config.sh \
    --name "${RUNNER_NAME}-$(random_string)" \
    --token ${RUNNER_TOKEN} \
    --labels ${RUNNER_NAME} \
    --url https://github.com/${GITHUB_OWNER} \
    --work "/work" \
    --unattended \
    --replace \
    --ephemeral

remove() {
    ./config.sh remove --token "${RUNNER_TOKEN}"
}

trap 'remove; exit 130' INT
trap 'remove; exit 143' TERM

./run.sh "$*" &

wait $!

remove
echo "Runner stopped."