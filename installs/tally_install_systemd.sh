#!/bin/sh 

echo "[+] tally installing..."

echo "[+] building tally..."
cd ../tally
make
cd - > /dev/null

cp ../tally/release/tally /usr/local/bin/tally
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