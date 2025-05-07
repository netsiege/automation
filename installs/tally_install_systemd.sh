#!/bin/sh 

yn_prompt() {
    printf "%s [y/n]: " "$1"
    while :; do
        read ans
        case "$ans" in
            [Yy]) return 0 ;;
            [Nn]) return 1 ;;
            *) printf "Please answer y or n: " ;;
        esac
    done
}


echo "[+] tally installing..."

echo "[+] building tally..."
cd ../tally
make
cd - > /dev/null

if yn_prompt "Do you want to build tally?"; then
    cp ../tally/target/release/tally /usr/local/bin/tally
else 
    cp ../bins/tally /usr/local/bin/tally
fi
chmod +x /usr/local/bin/tally 

echo "[+] creating tally systemd service..."
cat <<EOF | sudo tee /etc/systemd/system/tally.service > /dev/null
[Unit]
Description=tally Scoring Service (netsiege)
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/tally 
Restart=on-failure
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now tally.service

echo "[+] tally service installed and started!"