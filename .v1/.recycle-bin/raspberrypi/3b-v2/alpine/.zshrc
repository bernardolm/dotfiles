pt_br='pt_BR.UTF-8'

export LANG="${pt_br}"
export LANGUAGE="${pt_br}"
export LC_ALL="${pt_br}"
export LC_COLLATE='C'
export TZ='America/Sao_Paulo'

echo "$(date +%A), $(date +%B)..."

# steps to do and automatize

# sudo install -Dm 0644 /usr/share/zoneinfo/America/Sao_Paulo /etc/zoneinfo/America/Sao_Paulo
# sudo setup-keymap br br-nodeadkeys
# sudo setup-keymap br br
