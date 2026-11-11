---
title:	|
	Hochschule Niederrhein

	Fachbereich Ingenieurwissenschaften und Informatik

	**Projektaufgabe IT-Security - SS2026**

	Bachelor Informatik

author:
	Metin Arslancan


date: 22.08.2026
output: pdf_document
---

\pagebreak


# Veröffentlichungshinweis

Diese Fassung wurde für das öffentliche Portfolio bereinigt. Netzadressen und Kontonamen wurden durch Beispieldaten ersetzt. Zugangsdaten, rekonstruierbare Geheimnachrichten, Matrikelnummer und Unterschrift wurden entfernt. Terminal-Abbildungen wurden durch Beschreibungen ersetzt; die Netzwerkgrafik wurde als Tabelle mit Beispieladressen neu dargestellt. Die bereinigte Fassung ist keine unveränderte Prüfungsabgabe.

# Einleitung

## Motivation

IT-Sicherheit ist ein wichtiger Bestandteil der Informatik, da Systeme und Daten vor unberechtigten Zugriffen, Manipulationen und Angriffen geschützt werden müssen. In dieser Projektarbeit möchte ich die in der Vorlesung behandelten Themen praktisch anwenden und dadurch mein Verständnis weiter vertiefen.

Dabei beschäftige ich mich unter anderem mit Passwörtern und Hashverfahren, Verschlüsselung, VPN-Verbindungen, Zugriffsrechten, Firewalls und der sicheren Planung von Netzwerken. Besonders interessant finde ich dabei, dass viele dieser Themen nicht nur im beruflichen Umfeld eine Rolle spielen, sondern auch im privaten Alltag wichtig sind. Durch die praktische Bearbeitung möchte ich deshalb nicht nur mein Wissen aus der Vorlesung festigen, sondern auch ein besseres Verständnis dafür entwickeln, wie IT-Systeme sinnvoll abgesichert werden können.

## Aufgabenstellung

Die Projektarbeit besteht aus vier Aufgabenbereichen, in denen verschiedene Themen der IT-Sicherheit praktisch angewendet werden.

In der ersten Aufgabe wird ein vorgegebenes Passwortschema untersucht. Dabei werden das verwendete Hashverfahren und das Salt bestimmt, das zugehörige Klartext-Passwort durch Ausprobieren ermittelt und das gefundene Passwortschema anschließend auf eine weitere Domain angewendet. Abschließend wird das verwendete Verfahren kritisch bewertet.

Die zweite Aufgabe beschäftigt sich mit angewandter Kryptografie. Hierbei wird zunächst eine verschlüsselte Nachricht mithilfe des CBC-Verfahrens entschlüsselt. Anschließend werden verschiedene Sicherheitsverfahren und Werkzeuge wie OpenPGP, VeraCrypt, OpenVPN und SSH eingesetzt. Zusätzlich werden Zugriffsrechte auf einem entfernten Linux-System überprüft und angepasst.

In der dritten Aufgabe wird mit `iptables` eine Firewall erstellt, die nur die in der Aufgabenstellung festgelegten Kommunikationsbeziehungen zulässt. Die Funktionsweise der Firewall wird anschließend mithilfe eines Testplans und verschiedener Kommandoausgaben überprüft.

Abschließend wird in der vierten Aufgabe eine sichere Netzwerktopologie für eine Werbeagentur geplant. Dabei werden verschiedene interne Bereiche und Server in getrennte Netze aufgeteilt und kontrolliert über eine zentrale Firewall miteinander verbunden.

Durch die Bearbeitung der Aufgaben werden verschiedene Inhalte aus der Vorlesung praktisch miteinander verknüpft und anhand konkreter Anwendungen umgesetzt.

--------------

\pagebreak

# Aufgabe Passwörter

## Analyse des gespeicherten Passwort-Eintrags

Gegeben ist der folgende Eintrag aus einer Konfigurationsdatei:

`1:123456:1bc8c1e945957c5f6d3522024bb6f316`

Der Eintrag besteht aus drei Teilen. Die erste Zahl gibt das verwendete
Hashverfahren an, der zweite Wert stellt das Salt dar und der letzte Wert
ist der gespeicherte Hashwert.

In der Vorlesung wird für Passwort-Hashes das Format

`$id$salt$hash`

verwendet. Dabei steht die ID 1 für das Hashverfahren MD5.
Daher wurde für den vorliegenden Eintrag MD5 verwendet.

Das verwendete Salt lautet:

`123456`

Der gespeicherte Hashwert lautet:

`1bc8c1e945957c5f6d3522024bb6f316`

Der vorliegende Hash besteht aus 32 Hex-Zeichen. Ein Hex-Zeichen besteht aus 4 Bit. Aufgrund dessen haben wir einen 128 Bit Hash, was ebenfalls zu einem MD5 passt, da MD5 einen 128-Bit-Hash erzeugt.

## Rekonstruktion des Passwortschemas

Nach dem in der Vorlesung vorgestellten Beispielalgorithmus wird ein
Passwort aus einem festen Passwortkern und der jeweiligen Domain erzeugt.
Hierzu werden die ersten sechs Zeichen der Second-Level-Domain verwendet.
Anschließend werden die Buchstaben der Domain mit ROT+1 verschoben und
der Passwortkern wird mittig zwischen die sechs Domainzeichen eingesetzt.

Für die Domain `amazon.example` lautet die Second-Level-Domain:

`amazon`

Durch ROT+1 werden die einzelnen Buchstaben wie folgt verändert:

`a -> b`

`m -> n`

`a -> b`

`z -> a`

`o -> p`

`n -> o`

Damit ergibt sich:

`bnbapo`

Da der Passwortkern mittig eingefügt wird, besitzt das gesuchte Passwort
die folgende Struktur:

`bnb+Passwortkern+apo`

Von dem sechsstelligen Passwortkern sind bereits die ersten fünf Ziffern
bekannt.Daher ergibt sich für das gesuchte Klartextpasswort zunächst die Form:

`bnb13579_apo`

Zur Bestimmung der letzten unbekannten Ziffer werden im nächsten Schritt
alle möglichen Werte von 0 bis 9 getestet.

Die möglichen Passwörter hatten damit die Form:

`bnb135790apo`, `bnb135791apo`, `...`, `bnb135799apo`

Für die einzelnen Kandidaten wurde jeweils ein MD5-Hash gebildet und
dieser mit dem vorgegebenen Hash `1bc8c1e945957c5f6d3522024bb6f316` verglichen.
Nachdem ich dies getan habe überstimmte keiner dieser Passwörter mit dem vorgegebenen Hash überein. Weshalb ich daraufhin die Positionen des Salts mit dem des Passworts getauscht habe.
Die zu hashende Zeichenfolge besitzt somit die Form:

`Salt + Passwort`

Beim Passwort `bnb135796apo` ergibt sich mit dem Salt die Zeichenfolge:

`123456bnb135796apo`

Der daraus berechnete MD5-Hash lautet:

`1bc8c1e945957c5f6d3522024bb6f316`

Dieser stimmt mit dem vorgegebenen Hashwert überein.

Damit wurden folgende Werte ermittelt:

**Klartext-Passwort für amazon.example:** `bnb135796apo`

**Vollständiger Passwortkern:** `135796`

**Salt-Anordnung:** `Salt + Passwort`


## Passwort für whatsapp.example

Für die Domain

`whatsapp.example`

lautet die Second-Level-Domain:

`whatsapp`

Für den Algorithmus werden die ersten sechs Zeichen verwendet:

`whatsa`

Anschließend wird erneut ROT+1 angewendet:

`w -> x`
`h -> i`
`a -> b`
`t -> u`
`s -> t`
`a -> b`

Damit ergibt sich:

`xibutb`

Der bereits ermittelte Passwortkern lautet:

`135796`

Der Passwortkern wird wieder zwischen die ersten drei und die letzten
drei Domainzeichen gesetzt:

`xib` + `135796` + `utb`

Daraus ergibt sich für `whatsapp.example`:

**Passwort:** `xib135796utb`

## Kritische Bewertung des Passwortschemas

Das Passwortschema ist nur eingeschränkt sicher. Der Passwortkern `135796` besteht nur aus sechs Ziffern und kann daher vergleichsweise leicht durchprobiert werden. Da in der Aufgabe bereits fünf Ziffern bekannt waren, musste ich nur zehn Möglichkeiten testen.

Zusätzlich ist der Aufbau vorhersehbar, da die Domain nur mit ROT+1 verändert und der Passwortkern immer an derselben Stelle eingesetzt wird. Kennt ein Angreifer das Verfahren, lassen sich dadurch auch Passwörter für andere Domains ableiten. Außerdem wird mit MD5 ein veraltetes Hashverfahren verwendet.

Das Salt bietet zwar zusätzlichen Schutz, gleicht die Schwächen des einfachen Passwortschemas jedoch nicht aus.

\pagebreak

#  Aufgabe Angewandte Kryptografie

## Entschlüsselung der Geheimnachricht

Die Entschlüsselung der Geheimnachricht basiert auf der Antonello-Übung und dem in der Vorlesung behandelten Cipher Block Chaining (CBC). Gegeben sind der Startblock `ca` und der Ciphertext `[Ciphertext für die Veröffentlichung entfernt]`. Zusätzlich ist bekannt, dass die ersten drei Zeichen des Klartextes `hac` lauten.

Beim CBC-Verfahren wird der aktuelle Cipherwert mit dem Schlüsselwert und dem vorherigen Cipherwert per XOR verknüpft. Für das erste Zeichen wird dafür der Startblock verwendet. Somit gilt:

`P_i = C_i XOR X_i XOR C_(i-1)`

Da die ersten drei Klartextzeichen bekannt sind, konnte ich daraus zunächst die ersten drei Schlüsselwerte bestimmen. Umgestellt nach dem Schlüsselwert ergibt sich:

`X_i = P_i XOR C_i XOR C_(i-1)`

Aus den bekannten Klartextzeichen `h`, `a` und `c` ergeben sich auf diesem Weg die Schlüsselwerte `X1`, `X2` und `X3`. Die konkreten Zahlenwerte wurden für diese Veröffentlichung entfernt.

Der Faktor `M` wird aus den ASCII-Werten der kleingeschriebenen Anfangsbuchstaben meines Vor- und Nachnamens gebildet. Für `m` und `a` gilt daher:

`M = (109 * 97) mod 256 = 77`

Die weiteren Schlüsselwerte werden mit der Rekursion

`X_(n+1) = (X_n * M + A) mod 256`

erzeugt. Mit `X1`, `X2` und `M = 77` konnte ich zunächst `A` bestimmen:

`X2 = (X1 * 77 + A) mod 256`

Daraus ergibt sich der Wert von `A` (für diese Veröffentlichung entfernt) und somit die endgültige Formel:

`X_(n+1) = (X_n * 77 + A) mod 256`

Mit dieser Formel habe ich die restlichen Schlüsselwerte berechnet. Die vollständige Schlüsselfolge ist ebenfalls nicht abgedruckt.

Anschließend habe ich den Ciphertext mit `P_i = C_i XOR X_i XOR C_(i-1)` entschlüsselt. Dabei erhielt ich in Hexadezimaldarstellung:

`[Hexadezimaldarstellung der Zugangsdaten entfernt]`

Die ermittelte Geheimnachricht wurde für diese Veröffentlichung entfernt:

`[GEHEIMNACHRICHT ENTFERNT]`

Zur Kontrolle habe ich zusätzlich die in der Aufgabenstellung angegebene Quersumme überprüft:

`[Prüfsumme der Zugangsdaten entfernt]`

Damit erfüllt die entschlüsselte Nachricht auch diese Bedingung.


## Antwortmail von Übungsdienst

Die entschlüsselte Nachricht `[GEHEIMNACHRICHT ENTFERNT]` habe ich anschließend als reine Text-E-Mail verschlüsselt und signiert an Übungsdienst geschickt. Die Signatur und der Inhalt wurden erfolgreich überprüft. Als Antwort erhielt ich folgende Nachricht:

Hello, I am Übungsdienst.

I received your message and decrypted it.

Your signature was verified.

I received your public key and added it to my key storage - feel free to chat with me without having to attach it again!

Here's a copy of your message:

> [GEHEIMNACHRICHT ENTFERNT]
>

I received your hackit credentials

Success! Your secrets have been successfuly checked -

Your VeraCrypt secret is: [CONTAINER-PASSWORT ENTFERNT]

- Sincerly yours,

        Übungsdienst



## OpenVPN-Client-Konfiguration

Den in der Aufgabenstellung angegebenen VeraCrypt-Container habe ich zunächst heruntergeladen. Das Passwort für den Sciebo-Ordner wurde durch ROT+1 aus `[AUSGANGSWERT ENTFERNT]` gebildet und lautet `[FREIGABE-PASSWORT ENTFERNT]`. Anschließend habe ich den Container mit dem von Übungsdienst erhaltenen Passwort `[CONTAINER-PASSWORT ENTFERNT]` eingebunden.

Im Container befanden sich meine persönlichen OpenVPN-Zugangsdaten:

`pki/ca.crt`, `pki/issued/Demo.User.crt` und `pki/private/Demo.User.key`.

Mit diesen Dateien habe ich folgende OpenVPN-Client-Konfiguration erstellt:

~~~{.text}
client
dev tun
proto tcp-client
remote 192.0.2.10 11194
ca pki/ca.crt
cert pki/issued/Demo.User.crt
key pki/private/Demo.User.key
~~~

Die Verbindung habe ich anschließend mit folgendem Befehl gestartet:

~~~{.bash}
sudo openvpn --config client.conf
~~~

Nach erfolgreichem Aufbau der VPN-Verbindung wurde auf meinem Rechner das Interface `tun0` mit der IP-Adresse `198.51.100.38` angezeigt. Anschließend konnte ich mich per SSH mit dem entfernten Rechner `198.51.100.20` verbinden:

~~~{.bash}
ssh demo-user@198.51.100.20
~~~

Als Passwort habe ich das zuvor entschlüsselte zweite Wort `[SSH-PASSWORT ENTFERNT]` verwendet.


## Zugriffsrechte

Nach der Anmeldung habe ich zunächst die Zugriffsrechte meines Homeverzeichnisses mit

~~~{.bash}
ls -ld ~
~~~

überprüft. Dabei wurden die Rechte `drwx------` angezeigt. Somit besitzt nur der Eigentümer Lese-, Schreib- und Ausführungsrechte auf das Homeverzeichnis.

Anschließend habe ich die Zugriffsrechte der Datei `[DATEINAME ENTFERNT]` überprüft:

~~~{.bash}
ls -l [DATEINAME ENTFERNT]
~~~

Die Datei besaß zunächst die Rechte:

`----------`

Damit waren für den Besitzer, die Gruppe und alle anderen Benutzer keine Lese-, Schreib- oder Ausführungsrechte gesetzt.

Laut Aufgabenstellung soll ausschließlich der Besitzer lesend auf die Datei zugreifen können. Deshalb habe ich die Rechte mit folgendem Befehl geändert:

~~~{.bash}
chmod 400 [DATEINAME ENTFERNT]
~~~

Nach der Änderung lauteten die Rechte:

`-r--------`

Damit besitzt ausschließlich der Eigentümer ein Leserecht. Schreib- oder Ausführungsrechte sind für niemanden gesetzt.


## Inhalt der im Homeverzeichnis abgelegten Datei

Nachdem ich die Zugriffsrechte angepasst hatte, habe ich die Datei mit

~~~{.bash}
cat [DATEINAME ENTFERNT]
~~~

ausgelesen. Der Inhalt lautet:

~~~{.text}
'THROUGH 20 YEARS OF EFFORT, WE'VE SUCCESSFULLY TRAINED EVERYONE TO USE PASSWORDS THAT
 ARE HARD FOR HUMANS TO REMEMBER, BUT EASY FOR COMPUTERS TO GUESS.'
~~~

#  Aufgabe Firewall

## Testplan

Um zu überprüfen, ob die Firewall nur die in der Aufgabenstellung vorgesehenen Verbindungen zulässt, habe ich einen Testplan mit zehn Testfällen erstellt. Dabei werden sowohl erlaubte als auch nicht erlaubte Kommunikationsbeziehungen überprüft.

| Nr. | Beschreibung | Kommando | Erwartetes Ergebnis |
|---:|---|---|---|
| 1 | Prüft, ob die OpenVPN-Verbindung zum vorgegebenen Server über Port 11194 möglich ist. | `sudo openvpn --config client.conf` | Die VPN-Verbindung zu `192.0.2.10:11194` wird erfolgreich aufgebaut. |
| 2 | Prüft, ob ICMP-Kommunikation mit dem erlaubten Rechner möglich ist. | `ping -c 3 192.0.2.10` | Alle Echo Requests werden beantwortet. |
| 3 | Prüft die erlaubte SSH-Verbindung zum Rechner `198.51.100.20`. | `ssh demo-user@` \newline `198.51.100.20` | Die SSH-Verbindung wird erfolgreich aufgebaut. |
| 4 | Prüft, ob eingehende Echo Requests und die dazugehörigen Echo Replies erlaubt sind. | Auf `198.51.100.20`: `ping -c 4 <aktuelle tun0-IP>` | Der Ping auf die eigene VPN-IP funktioniert. |
| 5 | Prüft ICMP zu einem nicht freigegebenen Ziel. | `ping -c 3 192.0.2.53` | Die Pakete werden blockiert, 100 % Paketverlust. |
| 6 | Prüft, ob ein nicht freigegebener OpenVPN-Port blockiert wird. | `nc -vz -w 3 192.0.2.10 11195` | Die Verbindung wird nicht aufgebaut. |
| 7 | Prüft einen nicht erlaubten SSH-Zugriff auf den VPN-Server. | `nc -vz -w 3 192.0.2.10 22` | Die Verbindung wird blockiert. |
| 8 | Prüft einen nicht erlaubten TCP-Port auf `198.51.100.20`. | `nc -vz -w 3 198.51.100.20 80` | Die Verbindung wird blockiert. |
| 9 | Prüft, ob DNS-Verkehr zu einem externen DNS-Server blockiert wird. | `nslookup example.com 192.0.2.53` | Die DNS-Anfrage schlägt fehl, da DNS nicht freigegeben ist. |
| 10 | Prüft eine nicht erlaubte HTTPS-Verbindung ins Internet. | `nc -vz -w 3 192.0.2.80 443` | Die Verbindung wird blockiert. |

## Firewallskript

Für die Umsetzung der Firewall habe ich das Skript `rapriv_fw.sh` erstellt. Zunächst werden vorhandene Firewallregeln gelöscht. Anschließend werden die Standardregeln für `INPUT`, `OUTPUT` und `FORWARD` auf `DROP` gesetzt, sodass zunächst sämtliche Verbindungen blockiert werden. Danach werden nur die in der Aufgabenstellung erlaubten Verbindungen freigegeben.

~~~{.bash}
#!/bin/bash

# Alte Regeln löschen
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# Standardmäßig alles blockieren
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

# Eingehende Echo Requests erlauben
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Ausgehende Echo Replies erlauben
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT
~~~

Durch die Default-Policy `DROP` werden alle anderen Kommunikationsbeziehungen blockiert. Explizit erlaubt werden lediglich die OpenVPN-Verbindung zum Server `192.0.2.10` auf Port `11194`, ICMP mit diesem Rechner, die SSH-Verbindung zu `198.51.100.20` sowie eingehende Echo Requests und die dazugehörigen ausgehenden Echo Replies.

Das Skript habe ich mit

~~~{.bash}
chmod +x rapriv_fw.sh
sudo ./rapriv_fw.sh
~~~

ausführbar gemacht und aktiviert. Anschließend habe ich die geladenen Regeln mit

~~~{.bash}
sudo iptables -L -n -v
~~~

kontrolliert. Die OpenVPN-Verbindung konnte auch bei aktiver Firewall erfolgreich aufgebaut werden.

## Kommandoausgabe

Zur Überprüfung der Firewall habe ich zunächst die vorgegebenen Kommandos auf meinem lokalen Rechner ausgeführt. Dabei war zu sehen, dass die Kommunikation mit `192.0.2.10` erlaubt wurde, während der Ping auf `198.51.100.20` blockiert wurde.

*Die ursprüngliche Terminal-Abbildung wurde entfernt. Laut Originaldokumentation war die Verbindung zum freigegebenen Ziel möglich; der nicht freigegebene Ping wurde blockiert.*

Anschließend habe ich mich per SSH mit dem Rechner `198.51.100.20` verbunden und dort die vorgegebenen Kommandos ausgeführt. Der Ping auf meine VPN-Adresse `198.51.100.54` war erfolgreich.

*Die ursprüngliche Terminal-Abbildung wurde entfernt. Laut Originaldokumentation war der Ping vom entfernten Rechner auf die VPN-Adresse erfolgreich.*

# Aufgabe Sichere Netzplanung

## Netzwerktopologie

Für die sichere Netzplanung habe ich die einzelnen Bereiche der Werbeagentur in voneinander getrennte Netze aufgeteilt. Der Kreativ-Bereich und die Verwaltung befinden sich jeweils in einem eigenen Subnetz. Zusätzlich habe ich für die Bilddatenbank ein geschütztes Servernetz und für den öffentlich erreichbaren Webserver eine separate DMZ vorgesehen. Dadurch sind die einzelnen Bereiche voneinander getrennt und die Kommunikation zwischen ihnen kann über die zentrale Linux-Firewall kontrolliert werden.

Die Linux-Firewall besitzt die öffentliche IP-Adresse `203.0.113.10` und stellt unter anderem SSH, NTP, DNS und OpenVPN bereit. Der Kreativ-Bereich verwendet das Netz `10.60.82.0/27` mit dem Gateway `10.60.82.1`, während die Verwaltung im Netz `10.60.82.32/27` mit dem Gateway `10.60.82.33` liegt.

Die Bilddatenbank mit der vorgegebenen IP-Adresse `10.60.82.115` befindet sich im geschützten Servernetz `10.60.82.96/27`. Der Zugriff auf die Datenbank ist intern sowie über eine OpenVPN-Verbindung aus dem Home-Office vorgesehen. Für die VPN-Verbindungen habe ich das separate Netz `10.60.83.0/24` vorgesehen.

Der Webserver mit der IP-Adresse `10.60.82.153` befindet sich in der DMZ `10.60.82.128/27`. Da der Webserver auch aus dem Internet erreichbar sein muss, wird er dadurch vom internen Mitarbeiter- und Servernetz getrennt.

\Needspace{7cm}

Die folgende Tabelle stellt die Netzaufteilung mit ersetzten Beispieladressen dar:

| Bereich | Beispielnetz / Adresse | Gateway / Zweck |
|---|---|---|
| Zentrale Linux-Firewall | 203.0.113.10 | SSH, NTP, DNS, OpenVPN |
| Kreativ-Bereich | 10.60.82.0/27 | 10.60.82.1 |
| Verwaltung | 10.60.82.32/27 | 10.60.82.33 |
| Geschütztes Servernetz | 10.60.82.96/27 | 10.60.82.97 |
| Bilddatenbank | 10.60.82.115 | Intern und über VPN |
| DMZ | 10.60.82.128/27 | 10.60.82.129 |
| Webserver | 10.60.82.153 | Öffentlich angebotener Webdienst |
| Home-Office-VPN | 10.60.83.0/24 | 10.60.83.1 |

\pagebreak

# Zusammenfassung

Zusammenfassend habe ich mich in dieser Projektarbeit mit mehreren wichtigen Bereichen der IT-Sicherheit beschäftigt und die Inhalte aus der Vorlesung praktisch angewendet. Dadurch konnte ich besser nachvollziehen, wie verschiedene Sicherheitsmaßnahmen funktionieren und warum sie in Kombination eingesetzt werden müssen.

Bei der Passwortaufgabe habe ich untersucht, wie sich ein Passwort aus einem festen Schema, einem Passwortkern, einem Salt und einem Hashwert zusammensetzt. Dabei wurde deutlich, dass ein vorhersehbares Passwortschema trotz unterschiedlicher Passwörter für verschiedene Domains ein Sicherheitsrisiko darstellen kann. Besonders der kurze numerische Passwortkern und die Verwendung des veralteten Hashverfahrens MD5 haben gezeigt, wie wichtig eine sichere Erzeugung und Speicherung von Passwörtern ist.

In der Aufgabe zur angewandten Kryptografie habe ich eine verschlüsselte Nachricht mithilfe des CBC-Verfahrens entschlüsselt und anschließend verschiedene Sicherheitswerkzeuge praktisch eingesetzt. Dazu gehörten unter anderem OpenPGP, VeraCrypt, OpenVPN und SSH. Außerdem habe ich Zugriffsrechte auf einem Linux-System überprüft und verändert. Dabei habe ich gelernt, dass nicht nur die eingesetzten Verschlüsselungsverfahren wichtig sind, sondern auch der sichere Umgang mit Schlüsseln, Zertifikaten und Berechtigungen.

Bei der Firewallaufgabe habe ich Regeln erstellt, mit denen nur bestimmte Kommunikationsverbindungen erlaubt und alle anderen blockiert werden. Mithilfe eines Testplans konnte ich anschließend überprüfen, ob die Firewall wie vorgesehen funktioniert. Dabei wurde für mich deutlich, dass eine Firewall nicht nur korrekt konfiguriert, sondern auch ausreichend getestet werden muss, da bereits kleine Fehler unerwünschte Verbindungen ermöglichen können.

Abschließend habe ich eine sichere Netzwerktopologie für eine Werbeagentur geplant. Dabei wurden verschiedene Bereiche in getrennte Netze aufgeteilt, der öffentlich erreichbare Webserver in einer DMZ platziert und die Bilddatenbank durch ein separates internes Netz geschützt. Der Zugriff aus dem Home-Office erfolgt über OpenVPN. Dadurch wurde deutlich, dass IT-Sicherheit bereits bei der Planung einer Netzwerkstruktur beginnt und eine sinnvolle Trennung verschiedener Bereiche einen wichtigen Beitrag zur Sicherheit leistet.

Insgesamt hat mir die Projektarbeit gezeigt, dass IT-Sicherheit nicht aus einer einzelnen Maßnahme besteht. Erst das Zusammenspiel aus sicheren Passwörtern, Verschlüsselung, Zugriffskontrollen, Firewalls, VPN-Verbindungen und einer durchdachten Netzwerkstruktur sorgt für einen wirksamen Schutz. Durch die praktische Bearbeitung konnte ich die Inhalte aus der Vorlesung besser verstehen und gleichzeitig erkennen, wie schnell kleine Fehler zu Sicherheitsproblemen führen können.

-----------

\pagebreak

#  Quellen- und Literaturverzeichnis


- Cone, Matt (o. J.): *Markdown Guide – Basic Syntax*. Markdown Guide. Zugriff am 31.08.2026.

- Cone, Matt (o. J.): *Markdown Guide – Markdown Cheat Sheet*. Markdown Guide. Zugriff am 31.08.2026.

- Quade, Jürgen; Grothe, Martin (2026): *IT-Sicherheit – Vorlesungs- und Übungsunterlagen*. Hochschule Niederrhein, Sommersemester 2026.

- OpenAI (2026): *ChatGPT – GPT-5.6 Sol*. Zugriff am 31.08.2026.
