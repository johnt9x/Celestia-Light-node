# UPDATE NEW VERSION
```
sudo systemctl stop celestia-lightd 
cd $HOME 
rm -rf celestia-node 
git clone https://github.com/celestiaorg/celestia-node.git 
cd celestia-node/ 
git checkout tags/v0.8.0
make build
make install
systemctl restart celestia-lightd && journalctl -u celestia-lightd -o cat -f
```
