import subprocess
import json

def get_transaction(txid):
    result = subprocess.run(['bitcoin-cli', 'getrawtransaction', txid, 'true'], capture_output=True, text=True)
    print(result.stdout)
    return json.loads(result.stdout)

def get_public_key_from_input(tx, input_index):
    input_data = tx['vin'][input_index]

txid = 'e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163'
tx = get_transaction(txid)
public_key = get_public_key_from_input(tx, 0)

print(public_key)