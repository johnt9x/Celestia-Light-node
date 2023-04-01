# Celestia-Light-node
Guide celestia light node
https://docs.celestia.org/nodes/light-node/

# Celestia-Light-Node
# Update system and install build tools
```
sudo apt update && sudo apt upgrade -y
```
# Additional package:
```
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y
```
# Install Go
```
ver="1.19.1" 
cd $HOME 
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" 
sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" 
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
Check verion
```
go version
```
# Setup Light Node:
```
cd $HOME 
rm -rf celestia-node 
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/ 
git checkout tags/v0.8.1
make build 
make install 
sudo mv $HOME/celestia-node/build/celestia /usr/local/bin/
```
```
make cel-key
sudo mv $HOME/celestia-node/cel-key /usr/local/bin/ 
```
# Setting init:
```
celestia light init --p2p.network blockspacerace
```
# Run node with port 26659, change ip-addr = address VPS (Update in systemd service)
```
light start --p2p.network blockspacerace --core.ip (Your IP) --gateway --gateway.addr (Your IP) --gateway.port 26659
```
# Run node with RPC, use port 26657. change ip-addr = address VPS (Update in systemd service)
```
light start --core.ip https://rpc-blockspacerace.pops.one/ --gateway --gateway.addr (Your IP) --gateway.port 26657 --p2p.network blockspacerace
```
# Creat new wallet:
```
cel-key add wallet --keyring-backend test --node.type light --p2p.network blockspacerace
```
# Recover wallet:
```
cel-key add wallet --recover --keyring-backend test --node.type light --p2p.network blockspacerace
```
# Check wallet 
```
cel-key list --node.type light --keyring-backend test --p2p.network blockspacerace
```
# delete wallet
```
cel-key delete yournamewallet --node.type light --keyring-backend test --p2p.network blockspacerace
```
# Creat systemD (Change yourname wallet, your IP)
```
sudo tee $HOME/celestia-lightd.service > /dev/null <<EOF
[Unit]
  Description=celestia-lightd
  After=network-online.target
[Service]
  User=$USER
  ExecStart=$(which celestia) light start --p2p.network blockspacerace --core.ip (Your IP) --metrics.tls=false --metrics --metrics.endpoint otel.celestia.tools:4318 --keyring.accname yournamewallet --gateway --gateway.addr (Your IP) --gateway.port 26659
  Restart=on-failure
  RestartSec=10
  LimitNOFILE=4096
[Install]
  WantedBy=multi-user.target
EOF
```
```
sudo mv $HOME/celestia-lightd.service /etc/systemd/system/
```
```
sudo systemctl enable celestia-lightd
sudo systemctl daemon-reload
sudo systemctl start celestia-lightd && journalctl -u celestia-lightd -o cat -f
```
# Remove node
```
sudo systemctl stop celestia-lightd
sudo systemctl disable celestia-lightd
rm /etc/systemd/system/celestia-lightd.service
sudo systemctl daemon-reload
cd $HOME
rm -rf .celestia-lightd celestia-node
```
