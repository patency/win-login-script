# SSH Login Wrapper for Windows PowerShell

A simple **Linux-style SSH wrapper script** for Windows PowerShell.  
It allows quick login to servers defined in your `~/.ssh/config` file using numeric indexes or hostnames, set a default server, list available servers, and reset the default.


---

## Features

- Login to default server or first server if no default is set.
- List all configured servers (`-l` / `--list`).
- Login by index (`-i <n>` / `--index <n>`).
- Set default server (`-d <n>` / `--default <n>`).
- Reset default server (`-r` / `--reset`).
- Login by hostname (`login <hostname>`).
- Display help (`-h` / `--help`).

---

## Installation

1. Place the script in a folder, for example:

```powershell
C:\Users\<YourUser>\scripts\login.ps1
```

2. Add an alias in your PowerShell profile:
```powershell
C:\Users\<YourUser>\scripts\login.ps1
```

Add the line:
```powershell
Set-Alias login "C:\Users\<YourUser>\scripts\login.ps1"
```

3. Save and restart PowerShell.

---
## Usage

```powershell
login              # login default server (or first if none)
login -l           # list all servers
login -i 2         # login server at index 2
login -d 1         # set default server to index 1
login -r           # reset default server
login myserver     # login by hostname
login -h           # show help
```

---
## SSH Config Requirement
The script reads hosts from your SSH config file at:
```
C:\Users\<YourUser>\.ssh\config
```

Each host should be defined like:

```
Host myserver
    HostName 192.168.1.100
    User myuser
    Port 22

```
