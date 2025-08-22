

## log2ram 
If you plan to use log2ram, which will keep logs in RAM and occasionally sync them to disk, you should get the size of /var/log under 40MB. This size limit can be increased, but that’s not ideal, especially on something like a Pi Zero with limited RAM.

## First 

### Customize Log rotate:
**Edit logrotate configuration:** The primary tool for managing log files on Linux systems is logrotate. You can adjust its configuration for daemon.log in
 `/etc/logrotate.d/rsyslog` or `/etc/logrotate.conf`.

``` sh
sudo nano /etc/logrotate.d/rsyslog
```

- **Set size parameter:**  Force rotation when the log file reaches a specific size, e.g., size 1M to rotate when it reaches 1 megabytes.

- **Set rotate parameter:** Control the number of rotated log files to keep, e.g., rotate 1 to keep 1 rotated logs before old ones are removed.

        rotate 1
        size 1M

### Reduce maximum journald storage usage
To do that, edit /etc/systemd/journald.conf. Uncomment the SystemMaxUse=... line (if necessary), and set it to something around 20 MB:
``` sh
sudo nano /etc/systemd/journald.conf
```
``` conf
[Journal]
SystemMaxUse=20M
```

### Make no service is excessively logging, for example Mavlink Router which sends errors if a UDP endpoint is not reachable.
If you have a service that is logging excessively, you can limit its log size by editing its systemd service file. For example, for `mavlink-router`, you can edtit the service file:
``` sh
sudo systemctl edit mavlink-router
```
And add the following lines to limit the log size:
``` conf
         
```
This sets the maximum log level to 2, which is "critical" level. You can adjust the level as needed (0 for emergency, 1 for alert, 2 for critical, 3 for error, 4 for warning, 5 for notice, 6 for info, and 7 for debug).

Restart the service to apply the changes:
``` sh
sudo systemctl daemon-reload
sudo systemctl restart mavlink-router
```

Check the journal logs to see if the changes have taken effect:
``` sh
# To see the latest logs for mavlink-router:
sudo journalctl -u mavlink-router -e
# To follow the logs in real-time:
sudo journalctl -u mavlink-router -f

# or to see the last 10 lines:
sudo journalctl -u mavlink-router -n10
```df

### Check current log sizes:
You can check the current sizes of your log files to see how much space they are using.
``` sh
sudo du -hs /var/log/* | sort -rh | head -n 5
```
Sample output:
``` sh
25M	/var/log/journal
6.9M	/var/log/syslog
6.4M	/var/log/daemon.log
828K	/var/log/kern.log
760K	/var/log/netbird
```
### Clear existing logs:
``` sh
sudo truncate -s 0 /var/log/daemon.log
sudo truncate -s 0 /var/log/syslog
sudo journalctl --vacuum-size=1M
```
Recheck
``` sh
sudo du -hs /var/log/* | sort -rh | head -n 5
5.0M	/var/log/journal
828K	/var/log/kern.log
760K	/var/log/netbird
224K	/var/log/dpkg.log
168K	/var/log/apt

```

## Now Install log2ram:
``` sh
echo "deb [signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian/ $(bash -c '. /etc/os-release; echo ${VERSION_CODENAME}') main" | sudo tee /etc/apt/sources.list.d/azlux.list
sudo wget -O /usr/share/keyrings/azlux-archive-keyring.gpg  https://azlux.fr/repo.gpg
sudo apt update
sudo apt install log2ram
```

Reboot the Pi. Then verify it’s working, per the documentation. These commands will tell you whether log2ram is running and show its logs:
``` sh
sudo systemctl status log2ram
sudo journalctl -u log2ram -e
```

And these commands will allow you to see that the log2ram mount is setup correctly. Sample output from one of my Pis is included:
``` sh
df -h | grep log2ram
```
output will look like   
`log2ram          40M  532K   40M   2% /var/log`

``` sh
mount | grep log2ram
```
output will look like
`log2ram on /var/log type tmpfs (rw,nosuid,nodev,noexec,relatime,size=40960k,mode=755)`




### Disable Swap on Raspberry Pi OS
Disabling swap is a good practice to reduce write operations to the SD card
``` sh 
sudo dphys-swapfile swapoff
sudo dphys-swapfile uninstall
sudo update-rc.d dphys-swapfile remove
```







## If there is enough ram (pi 3B +) Enabling the Overlay File System:
Open a terminal on your Raspberry Pi.
Run the command: 
``` sh
sudo raspi-config
```
- Navigate to "4 Performance Options" 
- Select "P3 Overlay File System".

Follow the prompts to enable the overlay file system and 
- optionally, write-protect the boot partition.
Reboot the Raspberry Pi for the changes to take effect.

**Considerations:**

- **Lost Data**: Any changes made while the overlay is active will be lost upon reboot.
- **Updates**: To apply system updates, the overlay file system must be temporarily disabled, updates applied, and then the overlay re-enabled.
- **Performance**: The overlay file system may introduce a slight performance overhead due to the additional layer of abstraction.
- **Limited RAM**: The overlay consumes RAM, so the amount of available space for temporary changes is limited by the system's RAM capacity.

## Check the SD Card Usage
After setting up log2ram and disabling swap, you can check the SD card usage to see how much space is being used and how much is available. 
Note **log2ram:**

`log2ram          40M   15M   26M  38% /var/log` 

Use the following command: 
``` sh
pi@raspberrypi:~ $ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        15G  3.3G   11G  25% /
devtmpfs         85M     0   85M   0% /dev
tmpfs           214M     0  214M   0% /dev/shm
tmpfs            86M  684K   85M   1% /run
tmpfs           5.0M  4.0K  5.0M   1% /run/lock
tmpfs           214M     0  214M   0% /tmp
/dev/mmcblk0p1  255M   51M  205M  20% /boot
log2ram          40M   15M   26M  38% /var/log
tmpfs            43M     0   43M   0% /run/user/1000
pi@raspberrypi:~ $ 

```