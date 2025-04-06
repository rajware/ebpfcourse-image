#!/bin/sh -e

echo "Replacing login greeter background..."
sed -i \
    -e 's/\/backgrounds\/matsya\/matsya-background.jpeg/\/backgrounds\/rajware\/bhringa-background.jpeg/g' \
    /etc/lightdm/lightdm-gtk-greeter.conf
