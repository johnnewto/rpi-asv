# Autonomous Starlink-Powered R/C Boat

Control your R/C boat from anywhere using Starlink Mini and MAVLink! This project leverages a Raspberry Pi or Ubuntu system with `mavlink-router` and Netbird for seamless, global connectivity to your autonomous boat.

## Overview

The **Starlink Mini** revolutionizes the R/C hobby by enabling low-latency, high-bandwidth control over long distances. This repository, `mavlink-anywhere`, provides a setup to route MAVLink packets over a Starlink connection using `mavlink-router` and Netbird for secure networking.

## Prerequisites

- Raspberry Pi or Ubuntu system
- Starlink Mini with active connection
- Netbird account for VPN setup
- QGroundControl (QGC) installed on your control device (laptop or Android)
- Git installed (`sudo apt-get install git`)

## Installation

### 1. Clone the Repository
```bash
git clone https://github.com/mavlink-anywhere.git
cd ~/repos/mavlink-anywhere
```

### 2. Install MAVLink Router
Install dependencies and set up `mavlink-router`:
```bash
sudo apt-get install git
chmod +x configure_mavlink_router.sh
./configure_mavlink_router.sh
```

### 3. Netbird Setup
Netbird provides secure peer-to-peer networking for remote control.

#### Install Netbird
Run the following command on your Raspberry Pi or Ubuntu system:
```bash
netbird up --setup-key 49428D8A-8D99-4CF9-92BF-219F291705BC
```

#### Install Netbird as a Service
To ensure Netbird runs on boot:
```bash
sudo netbird service install --setup-key 49428D8A-8D99-4CF9-92BF-219F291705BC
sudo systemctl enable netbird
sudo systemctl start netbird
```

#### Check Netbird Status
```bash
sudo systemctl status netbird
```

#### Run Netbird on Control Device
Install and run Netbird on your laptop or Android device with the same setup key:
```bash
netbird up --setup-key 49428D8A-8D99-4CF9-92BF-219F291705BC
```

**Note**: The current setup key is `49428D8A-8D99-4CF9-92BF-219F291705BC`. An alternative key is `E2797038-1191-4CE5-981F-3D133D204EEB`.

### 4. Configure QGroundControl (QGC)
Connect QGC to the boat using the Netbird-provided hostname and port:
- **Connection URL**: `raspberrypi.netbird.cloud:14550`

Alternatively, use one of the following IP addresses and port based on your network configuration:
- Local network (laptop): `192.168.1.188:14550`
- Android device: `100.64.238.129:14550`
- Other endpoints: `100.64.253.183:14550`, `169.254.58.244:14550`

### 5. Monitor MAVLink Router
Check the status of `mavlink-router`:
```bash
sudo systemctl status mavlink-router
```

View real-time logs:
```bash
sudo journalctl -u mavlink-router -f
```

## Usage

1. Ensure the Starlink Mini is powered and connected.
2. Start the Netbird service on both the Raspberry Pi and your control device.
3. Launch QGC and connect to `raspberrypi.netbird.cloud:14550`.
4. Control your R/C boat from anywhere with an internet connection!

## Managing Peers
Monitor and manage connected devices via the Netbird dashboard:
- [Netbird Peers](https://app.netbird.io/peers)

## Troubleshooting

- **Connection Issues**: Verify Netbird is running (`sudo systemctl status netbird`) and the setup key matches on all devices.
- **MAVLink Router Errors**: Check logs with `sudo journalctl -u mavlink-router -f`.
- **QGC Fails to Connect**: Ensure the correct IP/hostname and port are used, and check firewall settings.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue on the [GitHub repository](https://github.com/mavlink-anywhere).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.