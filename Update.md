# UPDATE NEW VERSION
Update go 1.20
```
ver="1.20" 
cd $HOME 
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" 
sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" 
rm "go$ver.linux-amd64.tar.gz"
```
Update git & restart lightnode
```
sudo systemctl stop celestia-lightd
cd celestia-node
git fetch 
git checkout v0.9.3
make build
sudo make install
celestia light config-update --p2p.network blockspacerace
sudo systemctl restart celestia-lightd && journalctl -u celestia-lightd -o cat -f
```
