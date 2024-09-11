# Setup nvm and install pre-req
if command -v node > /dev/null 2>&1; then
  echo "Node.js is already installed. Current version: $(node -v)"
else
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  nvm install --lts
fi
npm install

# Start the bitcoind
/bin/bash setup-bitcoin-node.sh

# Run the solution script
/bin/bash solution.sh

# Run the tests
npm run test