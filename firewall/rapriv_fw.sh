#!/bin/bash

# Bereinigte Prüfungsfassung mit Beispieladressen.
# Nur in einer isolierten Testumgebung verwenden.
# Das Skript verändert die lokalen iptables-Regeln.

# Alte Regeln löschen
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# Standardmäßig alles verbieten
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# OpenVPN zu 192.0.2.10 über TCP Port 11194
iptables -A OUTPUT -p tcp -d 192.0.2.10 --dport 11194 -j ACCEPT
iptables -A INPUT -p tcp -s 192.0.2.10 --sport 11194 -m state --state ESTABLISHED -j ACCEPT

# ICMP mit 192.0.2.10
iptables -A OUTPUT -p icmp -d 192.0.2.10 --icmp-type echo-request -j ACCEPT
iptables -A INPUT -p icmp -s 192.0.2.10 --icmp-type echo-reply -j ACCEPT

# SSH-Client zu 198.51.100.20
iptables -A OUTPUT -p tcp -d 198.51.100.20 --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -s 198.51.100.20 --sport 22 -m state --state ESTABLISHED -j ACCEPT

# Eingehende Ping-Anfragen erlauben
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Antworten auf eingehende Ping-Anfragen erlauben
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT
