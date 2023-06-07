# UPDATE NEW VERSION
Update go 1.20.3
```
ver="1.20.3" 
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
git checkout v0.10.4
make build
sudo make install
sudo systemctl restart celestia-lightd && journalctl -u celestia-lightd -o cat -f
```
