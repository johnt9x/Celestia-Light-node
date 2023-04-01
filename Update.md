# UPDATE NEW VERSION
```
sudo systemctl stop celestia-lightd
cd $HOME
cd .celestia-light-blockspacerace-0
sudo rm -rf blocks index data transients
```
```
cd $HOME 
rm -rf celestia-node 
git clone https://github.com/celestiaorg/celestia-node.git 
cd celestia-node/ 
git checkout tags/v0.8.1
make build
make install
celestia light init --p2p.network blockspacerace
systemctl restart celestia-lightd && journalctl -u celestia-lightd -o cat -f
```
