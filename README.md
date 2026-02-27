# Mac Lab Admin Controller

A lightweight automation toolkit for managing multiple macOS lab machines using Fish shell and SSH.

This project provides centralized control for tasks such as system status checks, remote reboot/shutdown, software deployment, and lab-wide notifications.

Designed for educational labs, small fleets, and internal infrastructure environments.

---

## ✨ Features

* ⚡ Parallel remote execution across multiple machines
* 🔌 Mass reboot and shutdown orchestration
* 📦 Homebrew package deployment to all systems
* 🔔 Broadcast notifications to all Macs
* 🔊 Optional sound alerts for urgent announcements
* 🧩 Modular architecture with configurable environment
* 🚀 Minimal dependencies (SSH + Fish shell)

---

## 📁 Project Structure

```
mac-lab-admin/
│
├── fish/
│   ├── init.fish
│   └── modules/
│       ├── config.fish
│       ├── machines.fish
│       ├── power.fish
│       ├── brew.fish
│       └── notify.fish
│
└── README.md
```

---

## ⚙️ Requirements

* macOS or Linux admin machine
* Fish shell installed
* SSH access to target machines
* Target machines reachable via hostname or DNS
* macOS hosts required for notification features (osascript)

---

## 🔧 Configuration

Edit the configuration file:

```
fish/modules/config.fish
```

Example:

```fish
set -g LAB_USER "your-username"
set -g LAB_DOMAIN "local"
```

Edit machine inventory:

```
fish/modules/machines.fish
```

Example:

```fish
set -g MACHINES mac-001 mac-002 mac-003
```

---

## 🚀 Usage

Load the controller:

```fish
source fish/init.fish
```

### Single Machine

```fish
mac 23
mac 23 status
mac 23 reboot
mac 23 down
```

### All Machines

```fish
mac-all status
mac-all reboot
mac-all down
```

### Notifications

Silent notification:

```fish
mac-all-notify "Class starts in 5 minutes"
```

Notification with sound:

```fish
mac-all-alert "Save your work now"
```

---

## 🔔 How Notifications Work

Notifications are sent by executing AppleScript remotely via SSH:

```
ssh user@host osascript ...
```

The alert version additionally plays a system sound using:

```
afplay /System/Library/Sounds/
```

---

## 📦 Homebrew Deployment

Install a package on all machines:

```fish
mac-brew-all cask firefox
mac-brew-all formula git
```

---

## 🧠 Design Principles

* Configuration-driven environment
* No hardcoded credentials
* Parallel execution for speed
* Modular and extensible structure
* Minimal external dependencies

---

## 🔐 Security Notes

This project does **not** include:

* Password storage
* SSH keys
* Internal network information

Users must configure credentials locally.

---

## 📈 Potential Improvements

Future enhancements could include:

* Health monitoring dashboard
* Inventory export
* SSH connection pooling
* Ansible or Fabric backend integration
* Web UI controller
* Logging and reporting system

---

## 🎯 Use Cases

* Educational computer labs
* Small enterprise Mac fleets
* Dev/test environments
* Remote classroom management
* Internal infrastructure automation

---


## 👨‍💻 Author

Pownkumar (Founder Of Korelium)

---

## ⭐ Acknowledgment

Built as a practical infrastructure automation project to simplify multi-machine administration workflows using native tools.
