@ECHO OFF
netsh interface ipv4 set address name="Ethernet" dhcp
netsh interface ipv4 set dns name="Ethernet" dhcp
