# IT-Sicherheit – Projektarbeit

Praktische Projektarbeit im Bachelor Informatik an der Hochschule Niederrhein, Sommersemester 2026. Das Modul wurde laut Angabe des Autors bestanden; das Projekt ersetzte die Klausur.

## Inhalte

- Analyse eines Passwortschemas und eines gesalzenen MD5-Hashes
- Entschlüsselung einer didaktischen CBC-Übung
- Einsatz von OpenPGP, VeraCrypt, OpenVPN und SSH
- Prüfung und Anpassung von Linux-Dateirechten
- iptables-Firewall mit Testplan
- Netzplanung mit getrennten Subnetzen, Servernetz und DMZ

## Dateien

- [Dokumentation als PDF](projektarbeit.pdf)
- [Dokumentation als Markdown](projektarbeit.md)
- [Firewallskript](firewall/rapriv_fw.sh)
- [Skript zum Zurücksetzen der Regeln](firewall/resetfs.sh)

## Öffentliche Fassung

Diese Fassung wurde auf Grundlage der bedingten Veröffentlichungsfreigabe des betreuenden Professors bereinigt. Netzadressen und Kontonamen sind Beispieldaten. Zugangsdaten, geheime Nachrichten, Matrikelnummer und Unterschrift wurden entfernt. Terminal-Screenshots wurden durch Beschreibungen ersetzt, die Netzwerkgrafik durch eine Tabelle. Die ursprünglichen Schlüssel- und Signaturdateien sind nicht enthalten.

Die Ergebnisse beschreiben die damalige Prüfungsbearbeitung. Die bereinigten Skripte wurden statisch geprüft; die ursprüngliche Hochschulumgebung wurde nicht erneut angesprochen. Die Firewallskripte verändern lokale Regeln und sind für eine isolierte Testumgebung vorgesehen. Das Zurücksetzen setzt die Standardrichtlinien auf ACCEPT.

Nur die Dateien dieser bereinigten Fassung in ein neues Repository übernehmen. Unbereinigte Originale dürfen auch nicht in dessen Git-Historie stehen.
