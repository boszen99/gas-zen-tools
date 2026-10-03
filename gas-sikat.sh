#!/data/data/com.termux/files/usr/bin/bash
# GAS SIKAT - 3 TOOLS GACOR EDITION
# By Bos Zen - Upgrade dari 1 tool jadi 3 tools

RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
PURPLE='\033[1;35m'
NC='\033[0m'

clear
echo -e "${CYAN}"
echo "  ____    _    ____    ______  _____ _   _ "
echo " / ___|  / \  / ___|  |__  / | | ____| \ | |"
echo "| |  _  / _ \ \___ \    / /  | |  _| |  \| |"
echo "| |_| |/ ___ \ ___) |  / /_  | | |___| |\  |"
echo " \____/_/   \_\____/  /____| |_|_____|_| \_|"
echo -e "${NC}"
echo -e "${GREEN}    [ Tools Sikat By Bos Zen - 3 TOOLS GACOR ]${NC}"
echo ""
echo -e "${YELLOW}    Subfinder + Assetfinder + CRT.SH${NC}"
echo ""

read -p "mau sikat siapa hari ini Bos Zen? " target

if [ -z "$target" ]; then
  echo -e "${RED}Isi domain nya bos! contoh: xl.co.id${NC}"
  exit 1
fi

# Bersihin folder hasil
mkdir -p ~/hasil-gas
mkdir -p ~/hasil-san
rm -f /tmp/gas1.txt /tmp/gas2.txt /tmp/gas3.txt 2>/dev/null

echo ""
echo -e "${PURPLE}=== GASKEUN SIKAT $target BOS! ===${NC}"
echo ""

echo -e "${YELLOW}[1/3] Subfinder lagi nyikat...${NC}"
if command -v subfinder &>/dev/null; then
  subfinder -d $target -silent -o /tmp/gas1.txt 2>/dev/null
else
  echo "subfinder gak ada bos!"
  touch /tmp/gas1.txt
fi
c1=$(wc -l < /tmp/gas1.txt 2>/dev/null | tr -d ' ')
echo -e "${GREEN} -> Dapet $c1 subdomain${NC}"

echo -e "${YELLOW}[2/3] Assetfinder lagi nyikat...${NC}"
if command -v assetfinder &>/dev/null; then
  assetfinder --subs-only $target > /tmp/gas2.txt 2>/dev/null
else
  echo "assetfinder gak ada bos!"
  touch /tmp/gas2.txt
fi
c2=$(wc -l < /tmp/gas2.txt 2>/dev/null | tr -d ' ')
echo -e "${GREEN} -> Dapet $c2 subdomain${NC}"

echo -e "${YELLOW}[3/3] CRT.SH lagi nyikat...${NC}"
curl -s "https://crt.sh/?q=%25.$target&output=json" | grep -o '"name_value":"[^"]*"' | cut -d'"' -f4 | tr ' ' '\n' | sed 's/^\*.//g' | grep -E "\.$target$|^\$target$" | grep -v "^\*$" | sort -u > /tmp/gas3.txt 2>/dev/null
c3=$(wc -l < /tmp/gas3.txt 2>/dev/null | tr -d ' ')
echo -e "${GREEN} -> Dapet $c3 subdomain${NC}"

echo ""
echo -e "${CYAN}[+] Gabungin hasil 3 tools + hapus duplikat...${NC}"

# Gabungin semua
cat /tmp/gas1.txt /tmp/gas2.txt /tmp/gas3.txt 2>/dev/null | sort -u | grep -v "^\*$" | grep -v "^\s*$" | grep -v "^$" > ~/hasil-gas/subdomain.txt

# Buat file yang dibutuhin gas-san juga
cp ~/hasil-gas/subdomain.txt ~/hasil-san/subdomain.txt 2>/dev/null
cp ~/hasil-gas/subdomain.txt /tmp/subdomain.txt 2>/dev/null
cp ~/hasil-gas/subdomain.txt ~/daftar_subdomain.txt 2>/dev/null

total=$(wc -l < ~/hasil-gas/subdomain.txt 2>/dev/null | tr -d ' ')
echo ""
echo -e "${GREEN}==========================================${NC}"
echo -e "${GREEN}[✓] SELESAI BOS! TOTAL $total SUBDOMAIN GACOR!${NC}"
echo -e "${GREEN}==========================================${NC}"
echo -e "${CYAN}File kesimpen di:${NC}"
echo -e " - ~/hasil-gas/subdomain.txt"
echo -e " - ~/hasil-san/subdomain.txt"
echo -e " - ~/daftar_subdomain.txt"
echo ""
echo -e "${YELLOW}Mau lanjut sikat CF/Live? Ketik: gas san${NC}"
echo ""
cat ~/hasil-gas/subdomain.txt

rm /tmp/gas1.txt /tmp/gas2.txt /tmp/gas3.txt 2>/dev/null
