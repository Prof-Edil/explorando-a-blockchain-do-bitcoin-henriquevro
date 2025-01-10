#!/bin/bash
# Exemplo de JSON de uma saída de transação (vout)
vout='{
  "n": 0,
  "scriptPubKey": {
    "asm": "048fa88c95a28485c3b493bf85e83b4558d971acf272881dc1867b7f79d30258f8c80030391682e48d5f58c2213bb84049718a136483ebc77462907ea03a801c5b OP_CHECKSIG",
    "desc": "pk(048fa88c95a28485c3b493bf85e83b4558d971acf272881dc1867b7f79d30258f8c80030391682e48d5f58c2213bb84049718a136483ebc77462907ea03a801c5b)#pxlyzqac",
    "hex": "41048fa88c95a28485c3b493bf85e83b4558d971acf272881dc1867b7f79d30258f8c80030391682e48d5f58c2213bb84049718a136483ebc77462907ea03a801c5bac",
    "type": "pubkey"
  },
  "value": 50.01
}'

# Extrair o índice da saída (n)
n=$(echo "$vout" | jq -r '.n')
echo "Checking vout index: $n"

# Simular o comando bitcoin-cli gettxout
# Substitua <txid> pelo ID da transação real e <n> pelo índice da saída
txid="255fb8ff561fc1668c79fbf902f394ffd1fbf29797d6d9266821ca4baef56906"
unspent=$(bitcoin-cli gettxout "$txid" "$n")
echo "Unspent: $unspent"

# Verificar se a saída não foi gasta
if [ -n "$unspent" ]; then
    address=$(echo "$vout" | jq -r '.scriptPubKey.addresses[0]')
    if [ "$address" == "null" ]; then
        address=$(echo "$vout" | jq -r '.scriptPubKey.asm' | awk '{print $NF}')
    fi
    echo "Unspent output found in txid $txid, vout $n, address $address"
else
    echo "Output $n in transaction $txid is spent."
fi