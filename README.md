# Add-SSHKeyAndAlias

This PowerShell script for Windows allows you to add an SSH public key to a specified remote host and create an alias in the local SSH config file (`~/.ssh/config`), similar to the `ssh-copy-id` utility in Unix-like systems.

## Prerequisites

- PowerShell 5.0 or higher
- SSH client installed
- SSH public key file (e.g., `id_ed25519.pub`)

## Usage

1. Clone or download the script.

```sh
git clone <your-repository-url>
cd Add-SSHKeyAndAlias
```

2. Open a PowerShell terminal and run:

```powershell
.\Add-SSHKey.ps1 -U <username> -H <remote_host> -A <alias>
```

- `<username>`: Username for the remote host
- `<remote_host>`: IP address or hostname of the remote host
- `<alias>`: Alias to add to the local SSH config

Example:

```powershell
.\Add-SSHKey.ps1 -U myuser -H example.com -A myalias
```

## Script Details

### Parameters

- `-U`: Username for the remote host
- `-H`: IP address or hostname of the remote host
- `-A`: Alias to add to the local SSH config

### Workflow

1. Validates the provided parameters.
2. Reads the SSH public key file (default: `~/.ssh/id_ed25519.pub`).
3. Adds the public key to the remote host.
4. Adds an alias to the local SSH config file (`~/.ssh/config`).

### Error Handling

The script checks for errors at each step and outputs error messages if any issues occur.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
