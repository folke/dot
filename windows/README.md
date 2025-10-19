Install scripts to quickly set up a Windows development environment.

## Bootstrap

Import `oem/oem.reg` to customize settings for your machine.

Run in a **non-elevated** PowerShell window:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
& ".\install.ps1"
```
