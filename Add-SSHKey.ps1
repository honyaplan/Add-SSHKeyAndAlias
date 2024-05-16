param (
    [string]$U,    # ユーザー名
    [string]$H,    # リモートホスト
    [string]$A     # エイリアス
)

function Show-Usage {
    Write-Host "Usage: .\Add-SSHKey.ps1 -U <username> -H <remote_host> -A <alias>"
}

if (-not $U -or -not $H -or -not $A) {
    Show-Usage
    exit 1
}

# 公開鍵のパス（必要に応じて変更してください）
$keyPath = "$env:USERPROFILE\.ssh\id_ed25519.pub"

# 公開鍵を読み込み
try {
    $key = Get-Content $keyPath -ErrorAction Stop
    Write-Host "SSH public key successfully read."
} catch {
    Write-Host "Error reading SSH public key: $($_.Exception.Message)"
    exit 1
}

# リモートサーバーに公開鍵を追加する関数
function Add-SSHKeyToRemote {
    param (
        [string]$username,
        [string]$hostname,
        [string]$publicKey
    )

    $command = @"
mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo '$publicKey' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
"@

    try {
        ssh -o StrictHostKeyChecking=ask $username@$hostname "echo 'SSH connection established.'"
        if ($LASTEXITCODE -ne 0) {
            throw "SSH connection failed."
        }

        ssh $username@$hostname $command
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to add SSH key to the remote server."
        }

        Write-Host "SSH key successfully added to the remote server."
    } catch {
        Write-Host "Error: $($_.Exception.Message)"
        exit 1
    }
}

# ローカルSSH configにエイリアスを追加する関数
function Add-AliasToSSHConfig {
    param (
        [string]$alias,
        [string]$hostname,
        [string]$username
    )

    $sshDir = "$env:USERPROFILE\.ssh"
    $configPath = Join-Path $sshDir "config"
    
    if (-not (Test-Path $sshDir)) {
        New-Item -Path $sshDir -ItemType Directory -Force
    }

    if (-not (Test-Path $configPath)) {
        New-Item -Path $configPath -ItemType File -Force
    }

    $configContent = @"
Host $alias
    HostName $hostname
    User $username
"@

    Add-Content -Path $configPath -Value $configContent
    Write-Host "Alias '$alias' added to SSH config."

    # 処理後に内容を出力
    try {
        $finalConfig = Get-Content -Path $configPath
        Write-Host "Current SSH config content:"
        Write-Output $finalConfig
    } catch {
        Write-Host "Failed to read SSH config file: $($_.Exception.Message)"
    }
}

# 実行部分
Add-SSHKeyToRemote -username $U -hostname $H -publicKey $key
Add-AliasToSSHConfig -alias $A -hostname $H -username $U
