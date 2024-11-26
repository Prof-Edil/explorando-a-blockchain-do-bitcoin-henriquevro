#!/bin/bash
# How many new outputs were created by block 123,456?

block_hash=$(bitcoin-cli getblockhash 123456)
block=$(bitcoin-cli getblock "$block_hash")
txids=$(echo "$block" | jq -r '.tx[]')

new_outputs=0

for txid in $txids; do
  tx=$(bitcoin-cli getrawtransaction "$txid" 1)
  outputs=$(echo "$tx" | jq '.vout | length')
  new_outputs=$((new_outputs + outputs))
done

echo $new_outputs