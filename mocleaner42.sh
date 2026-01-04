#!/bin/bash

# Renkler
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Manual File Cleanup Starting ===${NC}"

# Get starting space
START_SPACE=$(df -m $HOME | awk 'NR==2 {print $4}')

# List of target directories to delete contents from
TARGETS=(
    "$HOME/.cache/*"
    "$HOME/.config/Code/Cache/*"
    "$HOME/.config/Code/CachedData/*"
    "$HOME/.config/Code/User/workspaceStorage/*"
    "$HOME/.config/google-chrome/Default/Cache/*"
    "$HOME/.var/app/com.visualstudio.code/cache/*"
    "$HOME/.var/app/com.visualstudio.code/config/Code/User/workspaceStorage/*"
    "$HOME/.var/app/com.visualstudio.code/config/Code/Service Worker/*"
    "$HOME/.vscode/extensions/tmp/*" # VS Code geçici eklenti dosyaları
)

for target in "${TARGETS[@]}"; do
    if ls $target >/dev/null 2>&1; then
        echo -e "${GREEN}Temizleniyor:${NC} $target"
        rm -rf $target 2>/dev/null
    else
        echo -e "Atlanıyor (Klasör boş veya yok): $target"
    fi
done

END_SPACE=$(df -m $HOME | awk 'NR==2 {print $4}')
FREED=$((END_SPACE - START_SPACE))

echo -e "\n${BLUE}=== İşlem Tamamlandı ===${NC}"
if [ $FREED -le 0 ]; then
    echo -e "${RED}Already clean! No extra space gained.${NC}"
else
    echo -e "${GREEN}✓ Cleaned space: ${FREED} MB${NC}"
fi
echo -e "${BLUE}Available space (your home directory): ${END_SPACE} MB ($(df -h $HOME | awk 'NR==2 {print $4}'))${NC}"
