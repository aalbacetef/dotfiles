#!/usr/bin/env bash

register-tunnel() {
  TUNNEL_NAME="$1"
  PRIVATE_KEY_FILE="$2"
  PEER_PUBLIC_KEY="$3"
  ENDPOINT="$4"
  ALLOWED_IPS="$5"
  PEER_ADDR="$6"
  VPN_DNS="$7"
  MTU="$8"

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
}

tun-exec() {
  sudo -E ip netns exec $TUNNEL_NAME $1
}

tssh() {
  TUNNEL_NAME=$WIREGUARD_TUNNEL_NAME
  HOSTNAME=$1
  current_user=$(whoami)
  sudo ip netns exec $TUNNEL_NAME sudo -u $current_user ssh -4 -C $HOSTNAME
}

tun-print(){
  TUNNEL_NAME=$WIREGUARD_TUNNEL_NAME
  echo "Use 'sudo -E -H ip netns exec $TUNNEL_NAME <command>' to run commands in this namespace"
  echo "Alternatively, you can run tun-exec or tssh <hostname>"
}
