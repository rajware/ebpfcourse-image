#!/bin/sh -e

echo "Setting main hostname..."
setup-hostname bhringa

echo "Setting hosts file..."
sed -i -e 's/matsya/bhringa/g' /etc/hosts

echo "Setting /etc/network/interfaces..."
sed -i -e 's/matsya/bhringa/g' /etc/network/interfaces
