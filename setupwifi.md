## How to setup multiple WiFi networks


Edit /etc/wpa_supplicant/wpa_supplicant.conf and configure as many as you need!

``` sh
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
```

``` conf
# /etc/wpa_supplicant/wpa_supplicant.conf
# the priority value determines which network is preferred
# networks with higher priority will be connected to first
# if the network is not available, the next one will be tried
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1 

network={
        ssid="Tinker"
        psk="xxxxxxxx"
        priority=1
}

network={
        ssid="My starlink"
        psk="xxxxxxxxxx"
        priority=2
}

```

This gives priority to the "My starlink" network, so it will be connected first if available. If not, it will try to connect to "Tinker".

then reconfigure wpa_supplicant Without Reboot
``` sh
sudo wpa_cli -i wlan0 reconfigure
```
To check which WiFi network is currently selected or connected
``` sh
sudo wpa_cli -i wlan0 list_networks
```
The output will look something like this:

``` conf
network id / ssid / bssid / flags
0	My starlink	any	
1	Tinker	any	[CURRENT]
```
## Other commands and information

``` sh
sudo wpa_cli -i wlan0 status
```

This command will show you the current status of the WiFi connection, including the SSID of the connected network, ip address, and other details.
``` conf
bssid=90:09:d0:12:42:d4
freq=2432
ssid=Tinker
id=1
mode=station
pairwise_cipher=CCMP
group_cipher=CCMP
key_mgmt=WPA2-PSK
wpa_state=COMPLETED
ip_address=192.168.1.37
p2p_device_address=ba:27:eb:e7:0d:99
address=b8:27:eb:e7:0d:99
uuid=0be59b48-9315-5854-9f2a-ee8ffbe8edf9
```

Scan and list networks , the scan command initiates a scan  ?? and may change the network ?? , and scan_results show the results of the scan.

``` sh
sudo wpa_cli -i wlan0 scan
sudo wpa_cli -i wlan0 scan_results
```
The `scan` does the scan and  `scan_results` command will output a list of available WiFi networks, which typically includes the BSSID (MAC address of the access point), frequency, signal level, flags (encryption type), and SSID (network name). The output format generally looks like this:

``` sh
bssid / frequency / signal level / flags / ssid
90:09:d0:12:42:d4	2432	-57	[WPA2-PSK-CCMP][WPS][ESS]	Tinker
52:da:ef:3e:c0:f1	5240	-44	[WPA2-PSK-CCMP][ESS]	My starlink
90:09:d0:12:42:d6	5180	-67	[WPA2-PSK-CCMP][WPS][ESS]	Tinker
90:09:d0:12:42:d5	5745	-67	[WPA2-PSK-CCMP][WPS][ESS]	Tinker
a6:09:d0:12:42:d5	5745	-67	[WPA2-PSK-CCMP][WPS][ESS]	
52:da:ef:2e:c0:f1	2412	-27	[WPA2-PSK-CCMP][ESS]	My starlink
52:da:ef:6e:c0:f1	2412	-27	[WPA2-PSK-CCMP][ESS]	
52:da:ef:4e:c0:f1	2412	-29	[WPA2-PSK-CCMP][ESS]	
a6:09:d0:12:42:d4	2432	-58	[WPA2-PSK-CCMP][WPS][ESS]
```
