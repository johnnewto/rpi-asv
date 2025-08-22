
# replace this with normal install, not the root install one given here'

ie 
https://bellergy.com/6-install-and-setup-mavlink-router/

# MAVLinkAnywhere  (replace this as in root install)

MAVLinkAnywhere is a general-purpose project that enables MAVLink data streaming to both local endpoints and remote locations over the internet. This project provides simplified scripts to install and configure `mavlink-router` on companion computers (Raspberry Pi, Jetson, etc.). `mavlink-router` is a powerful application that routes MAVLink packets between various endpoints, including UART, UDP, and TCP, making it ideal for MAVLink based UAV (PX4, Ardupilot, etc.) and drone communication systems.

[![MAVLinkAnywhere Tutorial](https://img.youtube.com/vi/_QEWpoy6HSo/0.jpg)](https://www.youtube.com/watch?v=_QEWpoy6HSo)

## Video Tutorial and Setup Guide
Watch our comprehensive setup guide that walks you through the entire process:
- [Complete Guide to Stream Pixhawk/ArduPilot/PX4 Telemetry Data Anywhere (2024)](https://www.youtube.com/watch?v=_QEWpoy6HSo)

### Video Contents
- 00:00 - Introduction
- 02:15 - Setting up the Raspberry Pi
- 04:30 - Local MAVLINK Streaming
- 08:30 - Smart WiFi manager setup
- 11:40 - Internet-based MAVLink Streaming
- 15:00 - Outro

### Required Hardware
- Raspberry Pi (any model)
- Pixhawk/ArduPilot/PX4 flight controller
- Basic UART connection cables

## Prerequisites

Before starting with MAVLinkAnywhere, ensure that:
- Your companion computer (Raspberry Pi, Jetson, etc.) is installed with Ubuntu or Raspbian OS
- You have properly wired your Pixhawk's TELEM ports to the companion computer's UART TTL pins
- MAVLink streaming is enabled on the TELEM port of your flight controller

## Remote Connectivity

### Internet Connection Options
- **5G/4G/LTE**: Use USB Cellular dongles for mobile connectivity
- **Ethernet**: Direct connection to your network interface
- **WiFi**: For WiFi connectivity, we recommend using our [Smart WiFi Manager](https://github.com/alireza787b/smart-wifi-manager) project to ensure robust and reliable connections to your predefined networks
- **Satellite Internet**: Compatible with various satellite internet solutions

### VPN Solutions
For internet-based telemetry, you have several VPN options:
1. [NetBird](https://netbird.io/) (Recommended, demonstrated in video tutorial)
2. [WireGuard](https://www.wireguard.com/)
3. [Tailscale](https://tailscale.com/)
4. [ZeroTier](https://www.zerotier.com/)


Alternatively, you can configure port forwarding on your router.

## Installation Script
Our installation script seamlessly installs `mavlink-router` on your companion computer, taking care of all necessary dependencies and configurations.

### Usage
1. **Clone the repository:**
   ```sh
   git clone https://github.com/alireza787b/mavlink-anywhere.git
   cd mavlink-anywhere
   ```
2. **Run the installation script:**
   ```sh
   chmod +x install_mavlink_router.sh
   sudo ./install_mavlink_router.sh
   ```

### What the Installation Script Does:
- Checks if `mavlink-router` is already installed
- Removes any existing `mavlink-router` directory
- Updates the system and installs required packages (`git`, `meson`, `ninja-build`, `pkg-config`, `gcc`, `g++`, `systemd`, `python3-venv`)
- Increases the swap space to ensure successful compilation on low-memory systems
- Clones the `mavlink-router` repository and initializes its submodules
- Creates and activates a Python virtual environment
- Installs the Meson build system in the virtual environment
- Builds and installs `mavlink-router` using Meson and Ninja
- Resets the swap space to its original size after installation

## Configuration Script
The configuration script generates and updates the `mavlink-router` configuration, sets up a systemd service, and enables routing with flexible endpoint settings.

### Usage
1. **Run the configuration script:**
   ```sh
   chmod +x configure_mavlink_router.sh
   sudo ./configure_mavlink_router.sh
   ```
2. **Follow the prompts to set up UART device, baud rate, and UDP endpoints:**
   - If an existing configuration is found, the script will use these values as defaults and show them to you
   - **UART Device**: Default is `/dev/ttyS0`. This is the default serial port on the Raspberry Pi
   - **Baud Rate**: Default is `57600`. This is the communication speed between the companion computer and connected devices
   - **UDP Endpoints**: Default is `0.0.0.0:14550`. You can enter multiple endpoints separated by spaces (e.g., `100.64.169.127:14550 100.64.238.129:14550 192.168.1.215:14550`), get these from the netbird pairs. 

### What the Configuration Script Does:
- Prompts the user to enable UART and disable the serial console using `raspi-config`
- Reads existing configuration values if available, and uses them as defaults
- Prompts for UART device, baud rate, and UDP endpoints
- Creates an environment file with the provided values
- Generates the `mavlink-router` configuration file
- Creates an interactive script for future updates if needed
- Stops any existing `mavlink-router` service
- Creates a systemd service file to manage the `mavlink-router` service
- Reloads systemd, enables, and starts the `mavlink-router` service

You can manually edit the configuration file if needed.
Final configuration file content will be something like :
```
   [General]
   TcpServerPort=5760
   ReportStats=false

   [UartEndpoint uart]
   Device=/dev/ttyS0
   Baud=57600
   [UdpEndpoint udp1]
   Mode=normal
   Address=100.64.169.127
   Port=14550
   [UdpEndpoint udp2]
   Mode=normal
   Address=100.64.238.129
   Port=14550
   [UdpEndpoint udp3]
   Mode=normal
   Address=192.168.1.215
   Port=14550
```
### Monitoring and Logs
- **Check the status of the service:**
  ```sh
  sudo systemctl status mavlink-router
  ```
- **View detailed logs:**
  ```sh
  sudo journalctl -u mavlink-router -f
  ```
```
pi@raspberrypi:~ $ sudo journalctl -u mavlink-router -f
-- Journal begins at Tue 2025-05-06 14:35:26 BST. --
Jun 14 23:48:09 raspberrypi systemd[1]: Stopping MAVLink Router Service...
Jun 14 23:48:09 raspberrypi systemd[1]: mavlink-router.service: Succeeded.
Jun 14 23:48:09 raspberrypi systemd[1]: Stopped MAVLink Router Service.
-- Boot 7381f1929a1e468b9cd0c27cede22d39 --
Jun 14 23:48:18 raspberrypi systemd[1]: Started MAVLink Router Service.
Jun 14 23:48:19 raspberrypi mavlink-routerd[446]: mavlink-router version v4-15-g51983a4
Jun 14 23:48:19 raspberrypi mavlink-routerd[446]: Opened UART [4]uart: /dev/ttyS0
Jun 14 23:48:19 raspberrypi mavlink-routerd[446]: UART [4]uart: speed = 57600
Jun 14 23:48:19 raspberrypi mavlink-routerd[446]: Opened UDP Client [5]udp2: 100.64.238.129:14550
Jun 14 23:48:19 raspberrypi mavlink-routerd[446]: Opened UDP Client [7]udp1: 100.64.169.127:14550
Jun 14 23:48:19 raspberrypi mavlink-routerd[446]: Opened TCP Server [9] [::]:5760
```


### Excessive Logging
example Mavlink Router which sends errors if a UDP endpoint is not reachable.
If you have a service that is logging excessively, you can limit its log size by editing its systemd service file. For example, for `mavlink-router`, you can edtit the service file:
``` sh
sudo systemctl edit mavlink-router
```
And add the following lines to limit the log size:
``` conf
[Service]
LogLevelMax=2
         
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
```

### Troubleshooting
- **Check mavlink router reports:**
  If you encounter issues, you can check the status of the `mavlink-router` service using:
  ```sh
  mavlink-routerd -r 
  ```
  You should see output similar to the following, indicating the status of your endpoints and any received messages form the flight controller:
```sh
pi@raspberrypi:~/mavlink-anywhere $ mavlink-routerd -r
mavlink-router version v4-15-g51983a4
Opened UART [4]uart: /dev/serial0
UART [4]uart: speed = 57600
Opened UDP Client [5]udp2: 100.64.238.129:14550
Opened UDP Client [7]udp1: 100.64.169.127:14550
TCP Server: Could not bind to tcp socket (Address already in use)
UART Endpoint [4]uart {
   Received messages {
      CRC error: 3 1% 0KB
      Sequence lost: 250 89%
      Handled: 25 0KB
      Total: 278
   }
   Transmitted messages {
      Total: 3 0KB
   }
}
UDP Endpoint [5]udp2 {
   Received messages {
      CRC error: 0 0% 0KB
      Sequence lost: 0 0%
      Handled: 0 0KB
      Total: 0
   }
   Transmitted messages {
      Total: 26 0KB
   }
}

```

### Connect to raspberry pi via SSH
If you are using a VPN solution like NetBird, you can connect to your Raspberry Pi via SSH using the assigned IP address. For example:
```sh
# ssh pi@<assigned-ip-address>
ssh pi@raspberrypi-1.netbird.cloud
```
if this does not work, you can try the following command:
```sh
ping raspberrypi-1.netbird.cloud
```

If there is a fightcontrooler connected to the Raspberry Pi, you can check the MAVLink connection using:
```sh
mavlink-router-cli status
```



### Connecting with QGroundControl
Use QGroundControl to connect to your companion computer's IP address on the configured UDP endpoints. For internet-based telemetry, make sure to follow the setup video to properly register your devices on your chosen VPN system or configure port forwarding on your router.

## Contact
For more information, visit the [GitHub Repo](https://github.com/alireza787b/mavlink-anywhere).




