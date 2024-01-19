This file contains an explanation of the configuration files por the DNS servers in sistema.sol. We will include one master and one slave server. The following configurations will be applied to both of them.
### /etc/network/interfaces
Both servers need a fixed ip, here is an example of one of them:
```
auto enp0s8
iface enp0s8 inet static
address 192.168.57.103
netmask 255.255.255.0
gateway 192.168.57.1
```
### /etc/default/named
We will add the "-4" option as we will only use ipv4:
```
# run resolvconf?
RESOLVCONF=no

# startup options for the server
OPTIONS="-u bind -4"
```
### /etc/resolv.conf
This is the configuration for the default DNS:
```
domain sistema.sol
search sistema.sol
nameserver 192.168.57.103
nameserver 192.168.57.102
```
It is recommended to replace the line including our ip for the loopback ip.
### /etc/bind/named.conf.options
We have set an Access Control List to define the allowed source IP adresses. A forwarder has been set in case the DNS server receives a query for which it is not authorized. It is also important to set the port and interfaces to listen to, in case we have more interfaces. We have also allowed recursion so the DNS server can ask other DNS servers for info.  As we decided to only use ipv4, we can comment the v6 line. Finally, the dnssec-validation is set to yes so digital sign validation is used.
```
acl confiables {
        127.0.0.1;
        127.0.0.0/8;
        192.168.57.0/24;
};

options {
        directory "/var/cache/bind";
        forwarders { 208.67.222.222; };
        listen-on port 53 { 192.168.57.103; };
        recursion yes;
        allow-recursion { confiables; };
        dnssec-validation yes;
        //listen-on-v6 { any; };
};
```
(This is the configuration for the master, remember to replace the listen-on interface ip when configuring the slave)
### /etc/bind/named.conf.local
The following configuration will be included on the master server:
```
zone "sistema.sol" {
        type master;
        file "/var/lib/bind/tierra.sistema.sol";
        allow-transfer { 192.168.57.102; };
        notify yes;
};

zone "57.168.192.in-addr.arpa" {
        type master;
        file "/var/lib/bind/tierra.192.168.57";
};
```
We have decided to set the filenames to "tierra.X" as tierra is the master server so we know the files are located there. The transfer must be set so the slave can get the zone files from the master.

This is the configuration of the slave server:
```
zone "sistema.sol" {
        type slave;
        masters { 192.168.57.103; };
        file "/var/lib/bind/tierra.sistema.sol";
};

zone "57.168.192.in-addr.arpa" {
        type slave;
        masters { 192.168.57.103; };
        file "/var/lib/bind/tierra.192.168.57";
};
```
### /var/lib/bind/tierra.sistema.sol
The configuration of the direct zone, located in the master server.
```
;
; zone sistema.sol
;
$TTL     86400
@        IN      SOA     tierra.sistema.sol. user.sistema.sol. (
                                 1               ; Serial
                                 3600            ; Refresh
                                 1800            ; Retry
                                 604800          ; Expire
                                 7200 )          ; Negative Cache TTL
;
@                        IN      NS      tierra.sistema.sol.
@                        IN      NS      venus.sistema.sol.
tierra.sistema.sol.      IN      A       192.168.57.103
venus.sistema.sol.       IN      A       192.168.57.102
marte.sistema.sol.       IN      A       192.168.57.104
mercurio.sistema.sol.    IN      A       192.168.57.101
ns1.sistema.sol.         IN      CNAME   tierra.sistema.sol.
ns2.sistema.sol.         IN      CNAME   venus.sistema.sol.
@                        IN      MX 10   marte.sistema.sol.
mail.sistema.sol.        IN      CNAME   marte.sistema.sol.
```
We were asked to set the Negative Cache TTL to 2 hours, the other values are default ones. This file contains the NS records for both the DNS servers, the A records for every machine in "sistema.sol", the MX record for the mail server and the CNAME records for all the aliases.
### /var/lib/bind/tierra.192.168.57
The configuration of the reverse zone, located in the master server.

```
;
; zone sistema.sol
;
$TTL     86400
57.168.192.in-addr.arpa.         IN      SOA     tierra.sistema.sol. user.sistema.sol. (
                                 1               ; Serial
                                 3600            ; Refresh
                                 1800            ; Retry
                                 604800          ; Expire
                                 7200 )          ; Negative Cache TTL
;
57.168.192.in-addr.arpa.         IN      NS      tierra.sistema.sol.
57.168.192.in-addr.arpa.         IN      NS      venus.sistema.sol.
103.57.168.192.in-addr.arpa.     IN      PTR     tierra.sistema.sol.
102.57.168.192.in-addr.arpa.     IN      PTR     venus.sistema.sol.
104.57.168.192.in-addr.arpa.     IN      PTR     marte.sistema.sol.
101.57.168.192.in-addr.arpa.     IN      PTR     mercurio.sistema.sol.
```
We were asked to set the Negative Cache TTL to 2 hours, the other values are default ones. This file contains the NS records for both the DNS servers and the PTR records for every machine.