#!/bin/bash
echo '================================='
echo '       System Information        '
echo '================================='
echo "Current user : $(whoami)"
echo "Current date : $(date)"
echo ""
echo '--- Disk Usage ---'
df -h
