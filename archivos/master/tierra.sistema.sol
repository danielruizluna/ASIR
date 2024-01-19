;
; zone sistema.sol
;
$TTL	 86400
@	 IN	 SOA	 tierra.sistema.sol. user.sistema.sol. (
				 1		 ; Serial
				 3600		 ; Refresh	
				 1800		 ; Retry
				 604800		 ; Expire
				 7200 )		 ; Negative Cache TTL
;
@			 IN	 NS	 tierra.sistema.sol.
@			 IN	 NS	 venus.sistema.sol.
tierra.sistema.sol.	 IN	 A	 192.168.57.103
venus.sistema.sol.	 IN	 A	 192.168.57.102
marte.sistema.sol.	 IN	 A	 192.168.57.104
mercurio.sistema.sol.	 IN	 A	 192.168.57.101
ns1.sistema.sol.	 IN	 CNAME	 tierra.sistema.sol.
ns2.sistema.sol.	 IN	 CNAME	 venus.sistema.sol.
@			 IN	 MX 10	 marte.sistema.sol.
mail.sistema.sol.	 IN	 CNAME	 marte.sistema.sol.
