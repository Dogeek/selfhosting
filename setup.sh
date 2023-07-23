#!/usr/bin/env bash

packagesNeeded='python3.10 python3.10-dev python3.10-venv python3-pip python3-setuptools python3-wheel pipx'

if [ -x "$(command -v apk)" ]; then
    sudo apk add --no-cache $packagesNeeded
elif [ -x "$(command -v apt-get)" ]; then
    sudo apt-get install $packagesNeeded
elif [ -x "$(command -v dnf)" ]; then
    sudo dnf install $packagesNeeded
elif [ -x "$(command -v pacman)" ]; then
    sudo pacman install $packagesNeeded
elif [ -x "$(command -v zypper)" ]; then
    sudo zypper install $packagesNeeded
elif [ -x "$(command -v pkg)" ]; then
    sudo pkg install $packagesNeeded
elif [ -x "$(command -v brew)" ]; then
    brew install $packagesNeeded
else
    echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $packagesNeeded">&2
fi

PIPX_BIN_DIR=$(pipx environment -v PIPX_BIN_DIR)
export PATH="$PIPX_BIN_DIR:$PATH"

pipx install poetry
poetry install

poetry run ansible-galaxy collection install -r requirements.yml
poetry run ansible-playbook -i inventory.yml playbook.yml
