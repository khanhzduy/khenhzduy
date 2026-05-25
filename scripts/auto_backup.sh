#!/bin/bash

# =========================
# KHAI BAO BIEN
# =========================
BASE_DIR=$(dirname "$(dirname "$(realpath "$0")")")
DATA_DIR="$BASE_DIR/data"
BACKUP_DIR="$BASE_DIR/backups"
LOG_DIR="$BASE_DIR/logs"
LOG_FILE="$LOG_DIR/backup.log"

# =========================
# TAO THU MUC NEU CHUA TON TAI
# =========================
mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"

# =========================
# MAU TERMINAL
# =========================
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# =========================
# KIEM TRA INTERNET
# =========================
check_internet() {
    ping -c 1 google.com &> /dev/null

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Internet: Connected${NC}"
    else
        echo -e "${RED}Internet: Disconnected${NC}"
    fi
}

# =========================
# BACKUP DU LIEU
# =========================
backup_data() {

    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

    BACKUP_FILE="backup_$TIMESTAMP.tar.gz"

    tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$DATA_DIR"

    echo "$(date): Backup success -> $BACKUP_FILE" >> "$LOG_FILE"

    echo -e "${GREEN}Backup thanh cong${NC}"

    cd "$BACKUP_DIR"

    # Chi giu 5 backup moi nhat
    ls -tp | grep '\.tar.gz$' | tail -n +6 | xargs -r rm --

    echo -e "${YELLOW}Da giu lai 5 backup moi nhat${NC}"

    # Tu dong push GitHub
    cd /root/student_backup_system

    git add .

    git commit -m "Auto backup $(date)"

    git push origin main

    echo -e "${BLUE}Da push len GitHub${NC}"
}

# =========================
# XEM DANH SACH BACKUP
# =========================
list_backups() {
    echo -e "${BLUE}Danh sach backup:${NC}"
    ls -lh "$BACKUP_DIR"
}

# =========================
# XEM LOG
# =========================
view_logs() {
    echo -e "${YELLOW}Noi dung backup.log:${NC}"
    cat "$LOG_FILE"
}

# =========================
# MENU
# =========================
while true
do
    clear

    echo -e "${BLUE}==============================${NC}"
    echo -e "${GREEN} STUDENT BACKUP SYSTEM ${NC}"
    echo -e "${BLUE}==============================${NC}"

    check_internet

    echo ""
    echo "1. Backup du lieu"
    echo "2. Xem danh sach backup"
    echo "3. Xem log"
    echo "4. Thoat"

    echo ""
    read -p "Chon chuc nang: " choice

    case $choice in
        1)
            backup_data
            ;;
        2)
            list_backups
            ;;
        3)
            view_logs
            ;;
        4)
            echo "Thoat chuong trinh..."
            exit 0
            ;;
        *)
            echo -e "${RED}Lua chon khong hop le!${NC}"
            ;;
    esac

    echo ""
    read -p "Nhan Enter de tiep tuc..."
done
