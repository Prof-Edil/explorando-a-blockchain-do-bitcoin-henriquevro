import subprocess
import json

def get_block_hash(block_height):
    result = subprocess.run(['bitcoin-cli', 'getblockhash', str(block_height)], capture_output=True, text=True)
    return result.stdout.strip()

def get_block(block_hash):
    result = subprocess.run(['bitcoin-cli', 'getblock', block_hash, '2'], capture_output=True, text=True)
    return json.loads(result.stdout)

def is_unspent(txid, vout_index):
    result = subprocess.run(['bitcoin-cli', 'gettxout', txid, str(vout_index)], capture_output=True, text=True)
    return result.stdout.strip() != ''

def find_unspent_output(block):
    for tx in block['tx']:
        for vout in tx['vout']:
            if is_unspent(tx['txid'], vout['n']):
                return vout['scriptPubKey'].get('address')
    return None

block_height = 123321
block_hash = get_block_hash(block_height)
block = get_block(block_hash)
address = find_unspent_output(block)

if address:
    print(address)