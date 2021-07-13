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
  echo "TUNNEL_NAME=$TUNNEL_NAME"
  echo "PRIVATE_KEY_FILE=$PRIVATE_KEY_FILE"
  echo "PEER_PUBLIC_KEY=$PEER_PUBLIC_KEY"
  echo "ENDPOINT=$ENDPOINT"
  echo "ALLOWED_IPS=$ALLOWED_IPS"
  echo "PEER_ADDR=$PEER_ADDR"
  echo "VPN_DNS=$VPN_DNS"
  echo "MTU=$MTU"
  echo ""
  echo ""

  sudo ip netns del $TUNNEL_NAME && echo "deleted old network namespace"

  sudo ip netns add $TUNNEL_NAME
  echo "(ok) ip netns add $TUNNEL_NAME"

  sudo ip link add wg0 type wireguard
  echo "(ok) ip link add wg0 type wireguard"

  sudo ip link set wg0 netns $TUNNEL_NAME
  echo "(ok) ip link set wg0 netns $TUNNEL_NAME"

  sudo ip netns exec $TUNNEL_NAME wg set wg0 \
    private-key $PRIVATE_KEY_FILE      \
    peer $PEER_PUBLIC_KEY              \
    endpoint $ENDPOINT                 \
    allowed-ips $ALLOWED_IPS

  echo "(ok) ip netns exec $TUNNEL_NAME wg set wg0 ..."

  sudo ip netns exec $TUNNEL_NAME ip addr add $PEER_ADDR dev wg0
  echo "(ok) ip netns exec $TUNNEL_NAME ip addr add $PEER_ADDR dev wg0"

  sudo ip netns exec $TUNNEL_NAME ip link set mtu $MTU up dev wg0
  echo "(ok) ip netns exec $TUNNEL_NAME ip link set mtu $MTU up dev wg0"

  sudo ip netns exec $TUNNEL_NAME ip route add default dev wg0
  echo "(ok) netns exec $TUNNEL_NAME ip route add default dev wg0"

  sudo mkdir -p /etc/netns/$TUNNEL_NAME || "created namespace directory"
  sudo echo -n $VPN_DNS > /etc/netns/$TUNNEL_NAME/resolv.conf
  echo "(ok) echo -n $VPN_DNS > /etc/netns/$TUNNEL_NAME/resolv.conf"

  echo ""
  echo ""
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

tscp() {
  TUNNEL_NAME=$WIREGUARD_TUNNEL_NAME
  SRC="$1"
  DEST="$2"
  current_user=$(whoami)
  sudo ip netns exec $TUNNEL_NAME sudo -u $current_user scp  $SRC $DEST
}
