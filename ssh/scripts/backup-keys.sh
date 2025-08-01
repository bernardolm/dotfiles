set -e

function cp_from_to() {
    echo -n "transfering from ${1}: "
    scp -o ConnectTimeout=1 -q "${USER}@${1}:${2}" \
        "${PWD}/${1}_id_ed25519.pub" && echo "OK" || echo "failed" && true
}

for ip in 192.168.0.{10..35}; do
    cp_from_to "${ip}" "/home/${USER}/.ssh/id_ed25519.pub"
done

cp_from_to "192.168.0.36" "C:/Users/Bernardo/.ssh/id_ed25519.pub"
