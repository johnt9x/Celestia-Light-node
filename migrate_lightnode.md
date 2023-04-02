# Stop service on old machine
# Save keys folder & seed phrase from old machine to local machine (your computer)
You can save in any way you know. This my way.
Open cmd from your computer
```
scp -r root@YourIP:/root/.celestia-light-blockspacerace-0/keys /Users
```
# Run a new full node on a new machine
To setup full node you can follow my guide [celestia light node setup for testnet](https://github.com/quynhgianggithub/Celestia-Light-node/blob/main/README.md)
# Wait for the new light node on the new machine to finish sync
# Stop service on new machine
```
sudo systemctl stop celestia-lightd
```
# Recover your wallet (your seed phrase from old machine) 
check your wallet address is the same as your old wallet
```
cel-key add my_celes_key --recover --keyring-backend test --node.type light --p2p.network blockspacerace
```
> y
> Enter your bip39 mnemonic
...
# Upload keys from locol machine (your computer)
scp -r /Users/keys root@YourIP:/root/.celestia-light-blockspacerace-0/
# Setting init
```
celestia light init --p2p.network blockspacerace
```
Restart node again
```
sudo systemctl enable celestia-lightd
sudo systemctl daemon-reload
sudo systemctl start celestia-lightd && journalctl -u celestia-lightd -o cat -f
```
check your ID, if it is correct with the old ID then you have migrated successfully
```
NODE_TYPE=light
AUTH_TOKEN=$(celestia $NODE_TYPE auth admin --p2p.network blockspacerace)

curl -X POST \
     -H "Authorization: Bearer $AUTH_TOKEN" \
     -H 'Content-Type: application/json' \
     -d '{"jsonrpc":"2.0","id":0,"method":"p2p.Info","params":[]}' \
     http://localhost:26658
```
