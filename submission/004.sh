#!/bin/bash
# Using descriptors, compute the taproot address at index 100 derived from this extended public key:
xpub="xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2"
index=100

descriptor="tr($xpub/$index)"
checksum=$(bitcoin-cli getdescriptorinfo "$descriptor" | jq -r '.checksum')
descriptor_with_checksum="$descriptor#$checksum"

address=$(bitcoin-cli deriveaddresses "$descriptor_with_checksum" | jq -r '.[0]')

echo $address
