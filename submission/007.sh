#!/bin/bash
# Only one single output remains unspent from block 123,321. What address was it sent to?

# Get the block hash for block 123,321
echo "Getting block hash for block 123,321..."
block_hash=$(bitcoin-cli getblockhash 123321)
echo "Block hash: $block_hash"

# Get the transactions in block 123,321
echo "Getting transactions in block 123,321..."
transactions=$(bitcoin-cli getblock "$block_hash" | jq -r '.tx[]')
echo "Transactions: $transactions"

# Iterate over each transaction to find unspent outputs
for txid in $transactions; do
    echo "Processing transaction ID: $txid"
    raw_tx=$(bitcoin-cli getrawtransaction "$txid" 1)
    echo "Raw transaction: $raw_tx"
    
    vouts=$(echo "$raw_tx" | jq -c '.vout')
    echo $vouts

    for vout in $(echo "$vouts" | jq -c '.[]'); do
        n=$(echo "$vout" | jq -r '.n')
        echo "Checking vout index: $n"
        unspent=$(bitcoin-cli gettxout "$txid" "$n")
        echo "Unspent: $unspent"
        if [ -n "$unspent" ]; then
            address=$(echo "$vout" | jq -r '.scriptPubKey.addresses[0]')
            if [ "$address" == "null" ]; then
                address=$(echo "$vout" | jq -r '.scriptPubKey.asm' | awk '{print $NF}')
            fi
            echo "Unspent output found in txid $txid, vout $n, address $address"
            echo $address
            exit 0
        else
            echo "Output $n in transaction $txid is spent."
        fi
    done
done

echo "No unspent output found in block 123,321."
