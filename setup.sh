#!/bin/sh

# setting an address for loopback
ifconfig lo 127.0.0.1
ifconfig

# adding a default route

route -n

update-alternatives --set iptables /usr/sbin/iptables-legacy

# iptables rules to route traffic to transparent proxy
iptables -A OUTPUT -t nat -p tcp --dport 1:65535 ! -d 127.0.0.1  -j DNAT --to-destination 127.0.0.1:1200
iptables -t nat -A POSTROUTING -o lo -s 0.0.0.0 -j SNAT --to-source 127.0.0.1
iptables -L -t nat

ip route add default src 127.0.0.1 dev lo

# generate identity key
/app/keygen --secret /app/id.sec --public /app/id.pub

# your custom setup goes here
which ollama

grep avx2 /proc/cpuinfo

ls tmp

ls app

# starting supervisord
/app/supervisord