echo "Installing Bitcoin Core .... "
mkdir install
cd install
wget https://bitcoincore.org/bin/bitcoin-core-27.1/bitcoin-27.1-x86_64-linux-gnu.tar.gz > /dev/null 2>&1
tar --extract -f bitcoin-27.1-x86_64-linux-gnu.tar.gz
cp -r bitcoin-27.1/bin/* /usr/local/bin/
mkdir -p ~/.bitcoin
echo "regtest=1
fallbackfee=0.0001
server=1
rest=1
txindex=1
rpcauth=alice:88cae77e34048eff8b9f0be35527dd91\$d5c4e7ff4dfe771808e9c00a1393b90d498f54dcab0ee74a2d77bd01230cd4cc">> ~/.bitcoin/bitcoin.conf
cd ..
bitcoind -daemon
sleep 5