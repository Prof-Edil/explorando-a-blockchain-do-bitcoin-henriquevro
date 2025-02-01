import subprocess
import json

def get_transaction(txid):
    result = subprocess.run(['bitcoin-cli', 'getrawtransaction', txid, 'true'], capture_output=True, text=True)
    return json.loads(result.stdout)

def get_public_key_from_witness(tx, input_index):
    input_data = tx['vin'][input_index]
    txinwitness = input_data['txinwitness']
    witness_script = txinwitness[2]
    
    # Extract the public key from the witness script
    i = 0
    while i < len(witness_script):
        byte = witness_script[i:i+2]  # Each byte is represented by 2 hex characters
        i += 2
        
        if byte == "21":
            # Compressed public key (33 bytes = 66 hex characters)
            public_key = witness_script[i:i+66]
            return public_key
        elif byte == "41":
            # Uncompressed public key (65 bytes = 130 hex characters)
            public_key = witness_script[i:i+130]
            return public_key

    return None

txid = 'e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163'
tx = get_transaction(txid)
public_key = get_public_key_from_witness(tx, 0)

if public_key:
    print(public_key)