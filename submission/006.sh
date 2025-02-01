#!/bin/bash
# Which tx in block 257,343 spends the coinbase output of block 256,128?

# Get the coinbase transaction ID from block 256,128
coinbase_txid=$(bitcoin-cli getblockhash 256128 | xargs bitcoin-cli getblock | jq -r '.tx[0]')

# Get the block hash for block 257,343
block_hash=$(bitcoin-cli getblockhash 257343)

# Get the transactions in block 257,343
transactions=$(bitcoin-cli getblock "$block_hash" | jq -r '.tx[]')

# Iterate over each transaction to find the one that spends the coinbase output
for txid in $transactions; do
  raw_tx=$(bitcoin-cli getrawtransaction "$txid" 1)
  vin_txids=$(echo "$raw_tx" | jq -r '.vin[].txid')
  for vin_txid in $vin_txids; do
    if [ "$vin_txid" == "$coinbase_txid" ]; then
      echo $txid
      exit 0
    fi
  done
done

echo "No matching transaction found in block 257,343."
