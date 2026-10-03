#!/data/data/com.termux/files/usr/bin/bash
# INSTALL.SH GAS ZEN - 3 TOOLS GACOR
# By Bos Zen - Cianjur
# Cara pake: bash install.sh

RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

clear
echo -e "${CYAN}"
echo "  _____   _    ____   ____  _____ _   _ "
echo " / ____| / \  / ___| |__  /| ____| \ | |"
echo "| |  _  / _ \ \___ \   / / |  _| |  \| |"
echo "| |_| |/ ___ \ ___) | / /_ | |___| |\  |"
echo " \____/_/   \_\____/ /____||_____|_| \_|"
echo -e "${NC}"
echo -e "${GREEN}      [ Installer GAS ZEN 3 Tools By Bos Zen ]${NC}"
echo ""

mkdir -p ~/my-tools
mkdir -p ~/go/bin
mkdir -p ~/bin

echo -e "${YELLOW}[1/4] Install package...${NC}"
pkg install -y golang which curl git > /dev/null 2>&1

echo -e "${YELLOW}[2/4] Install subfinder + assetfinder...${NC}"
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest > /dev/null 2>&1
go install github.com/tomnomnom/assetfinder@latest > /dev/null 2>&1
# copy ke $PREFIX/bin biar kebaca
cp ~/go/bin/subfinder $PREFIX/bin/ 2>/dev/null; cp ~/go/bin/assetfinder $PREFIX/bin/ 2>/dev/null

echo -e "${YELLOW}[3/4] Pasang GAS ZEN...${NC}"

# GAS dispatcher
cat > ~/bin/gas << 'ENDGAS'
#!/data/data/com.termux/files/usr/bin/bash
if [ "$1" = "sun" ] || [ "$1" = "san" ]; then
  bash ~/my-tools/gas-sun.sh
else
  bash ~/my-tools/gas-sikat.sh
fi
ENDGAS
chmod +x ~/bin/gas
cp ~/bin/gas $PREFIX/bin/gas 2>/dev/null

# GAS SIKAT - TAMPILAN ORI 100% TAPI 3 TOOLS
cat > ~/my-tools/gas-sikat.sh << 'ENDSIKAT'
#!/bin/bash
spin() {
  sp='/-\|'
  while :; do
    for i in $(seq 0 3); do
      echo -ne "\r\033[1;33m$1 ${sp:$i:1} \033[0m"
      sleep 0.1
    done
  done
}
while true; do
  echo -e "\033[1;36m"
  echo "  _____   _    ____   ____  _____ _   _ "
  echo " / ____| / \  / ___| |__  /| ____| \ | |"
  echo "| |  _  / _ \ \___ \   / / |  _| |  \| |"
  echo "| |_| |/ ___ \ ___) | / /_ | |___| |\  |"
  echo " \____/_/   \_\____/ /____||_____|_| \_|"
  echo -e "\033[0m"
  echo -e "\033[0;32m      [ Tools Sikat By Bos Zen ]\033[0m"
  echo ""
  echo -n -e "\033[1;33mmau sikat siapa hari ini Bos Zen? \033[0m"
  read target
  if [ "$target" == "exit" ]; then
    echo -e "\033[1;31msiap Bos Zen, kabur dulu!\033[0m"
    break
  fi
  echo ""
  spin "Lagi nyari subdomain $target (3 tools)" &
  SPIN_PID=$!
  rm -f ~/gas1.txt ~/gas2.txt ~/gas3.txt 2>/dev/null
  subfinder -d $target -silent -o ~/gas1.txt > /dev/null 2>&1
  assetfinder --subs-only $target > ~/gas2.txt 2>/dev/null
  curl -s "https://crt.sh/?q=%25.$target&output=json" | grep -o '"name_value":"[^"]*"' | cut -d'"' -f4 | tr ' ' '\n' | sed 's/^\*.//g' | grep "$target" | sort -u > ~/gas3.txt 2>/dev/null
  cat ~/gas1.txt ~/gas2.txt ~/gas3.txt 2>/dev/null | sort -u | grep -v "^$" > $target.txt
  kill $SPIN_PID > /dev/null 2>&1
  c1=$(wc -l < ~/gas1.txt 2>/dev/null | tr -d ' '); c2=$(wc -l < ~/gas2.txt 2>/dev/null | tr -d ' '); c3=$(wc -l < ~/gas3.txt 2>/dev/null | tr -d ' '); total=$(wc -l < $target.txt 2>/dev/null | tr -d ' ')
  echo -ne "\r\033[0m                                                                  \r"
  echo -e "\033[1;32m[✓] subfinder   : $c1\033[0m"
  echo -e "\033[1;32m[✓] assetfinder : $c2\033[0m"
  echo -e "\033[1;32m[✓] crt.sh      : $c3\033[0m"
  echo -e "\033[1;32m[✓] TOTAL GABUNG : $total -> $target.txt\033[0m"
  echo -e "\033[1;33m[>] Gas sikat pake bugscanner...\033[0m"
  bugscanner-go scan direct -f $target.txt 2>/dev/null || echo "skip bugscanner (belum install)"
  echo ""
  echo -e "\033[1;32mmudah bos selesai, lo tinggal oprek aja sendiri tes satu-satu ya!\033[0m"
  echo -e "\033[1;33mmau lanjut gas lagi ketik target baru, mau kabur ketik exit\033[0m"
  echo ""
  rm -f ~/gas1.txt ~/gas2.txt ~/gas3.txt 2>/dev/null
done
ENDSIKAT
chmod +x ~/my-tools/gas-sikat.sh

echo -e "${YELLOW}[4/4] Setup PATH...${NC}"
grep -q "go/bin" ~/.bashrc 2>/dev/null || echo 'export PATH=$PATH:~/go/bin:~/bin:$PREFIX/bin' >> ~/.bashrc
export PATH=$PATH:~/go/bin:~/bin:$PREFIX/bin

echo ""
echo -e "${GREEN}==========================================${NC}"
echo -e "${GREEN}[✓] SELESAI BOS!${NC}"
echo -e "${GREEN}==========================================${NC}"
echo -e "Cara pake: ${YELLOW}source ~/.bashrc && gas${NC}"
echo ""
