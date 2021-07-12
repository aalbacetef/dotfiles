#!/usr/bin/env bash

TUNNEL_NAME=
PRIVATE_KEY_FILE=
PEER_PUBLIC_KEY=
ENDPOINT=
ALLOWED_IPS=
PEER_ADDR=
VPN_DNS=
MTU=

sudo ip netns add $TUNNEL_NAME
sudo ip link add wg0 type wireguard
sudo ip link set wg0 netns $TUNNEL_NAME
sudo ip netns exec $TUNNEL_NAME wg set wg0 \
  private-key $PRIVATE_KEY_FILE      \
  peer $PEER_PUBLIC_KEY              \
  endpoint $ENDPOINT                 \
  allowed-ips $ALLOWED_IPS

sudo ip netns exec $TUNNEL_NAME ip addr add $PEER_ADDR dev wg0
sudo ip netns exec $TUNNEL_NAME ip link set mtu $MTU up dev wg0
sudo ip netns exec $TUNNEL_NAME ip route add default dev wg0

sudo mkdir -p /etc/netns/$TUNNEL_NAME
sudo echo -n $VPN_DNS > /etc/netns/$TUNNEL_NAME/resolv.conf

echo Use 'sudo -E ip netns exec $TUNNEL_NAME <command>' to run commands in this namespace

