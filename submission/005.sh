# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`

txid="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"

# Get the raw transaction details
raw_tx=$(bitcoin-cli getrawtransaction "$txid" 1)

# Extract public keys from the txinwitness fields
pubkeys=$(echo "$raw_tx" | jq -r '.vin[].txinwitness[1]')

# Format the public keys as a JSON array
pubkeys_json=$(echo "$pubkeys" | jq -R -s -c 'split("\n") | map(select(length > 0))')

# Create the multisig address
multisig=$(bitcoin-cli createmultisig 1 "$pubkeys_json")

# Extract the P2SH address
address=$(echo "$multisig" | jq -r '.address')

echo $address
