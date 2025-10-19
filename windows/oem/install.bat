@echo off
net use D: \\host.lan\Data /persistent:yes 2>nul
reg import \\host.lan\Data\dot\windows\oem\oem.reg
