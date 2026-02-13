# network

to be able to connect by ssh over wifi on alpine, this order in _/etc/interfaces_ is important!
ref.: <https://forums.raspberrypi.com/viewtopic.php?t=40426#p1091115>

```bash
auto lo
iface lo inet loopback

auto wlan0
allow-hotplug wlan0
iface wlan0 inet static
    address 192.168.0.x
    netmask 255.255.255.0
    gateway 192.168.0.1
    wpa-ssid "***"
    wpa-psk "***"

auto eth0
allow-hotplug eth0
iface eth0 inet dhcp
```
