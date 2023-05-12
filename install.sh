#!/bin/bash

# Ask for IP address
read -p "Enter your IP address: " ip_address

# Update system and install build tools
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y

# Install Go
ver="1.20.3" 
cd $HOME 
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" 
sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" 
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Check version
go version

# Setup Light Node
cd $HOME 
rm -rf celestia-node 
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/ 
git checkout v0.9.4
make build 
make install 
sudo mv $HOME/celestia-node/build/celestia /usr/local/bin/
make cel-key
sudo mv $HOME/celestia-node/cel-key /usr/local/bin/ 

# Setting init
celestia light init --p2p.network blockspacerace

# Create systemd service
sudo tee $HOME/celestia-lightd.service > /dev/null <<EOF
[Unit]
  Description=celestia-lightd
  After=network-online.target
[Service]
  User=$USER
  ExecStart=$(which celestia) light start --p2p.network blockspacerace --core.ip $ip_address --metrics.tls=false --metrics --metrics.endpoint otel.celestia.tools:4318 --keyring.accname my_celes_key --gateway --gateway.addr $ip_address --gateway.port 26659
  Restart=on-failure
  RestartSec=10
  LimitNOFILE=4096
[Install]
  WantedBy=multi-user.target
EOF

sudo mv $HOME/celestia-lightd.service /etc/systemd/system/
sudo systemctl enable celestia-lightd
sudo systemctl daemon-reload
sudo systemctl start celestia-lightd

echo '=============== PLEASE SAVE SEED PHRASE AFTER COMMAND BUILDING CEL-KEY==================='
echo '=============== SETUP FINISHED ==================='
echo -e 'To check logs: \e[1m\e[32mjournalctl -u celestia-lightd -o cat -f\e[0m'
echo -e "To check adress wallet: \e[1m\e[32mcel-key list --node.type light --keyring-backend test --p2p.network blockspacerace\e[0m"
