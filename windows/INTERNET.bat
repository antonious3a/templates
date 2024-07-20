@ECHO OFF
netsh interface ipv4 set address name="Ethernet" static 172.16.1.10 255.255.255.0 172.16.1.1
netsh interface ipv4 set dns name="Ethernet" static 172.16.1.50 primary
netsh interface ipv4 add dns name="Ethernet" 1.1.1.1 index=2
