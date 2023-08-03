import os
import re
from ethereum.utils import mk_contract_address, encode_hex, privtoaddr

# find the vanity address with "badc0de" in it
pattern = re.compile(r'badc0de')
iterations = 0

while True:
    # generate a random private key
    private_key = os.urandom(32)
    addr = privtoaddr(private_key)
    contract_addr = encode_hex(mk_contract_address(addr, 0))

    if pattern.search(contract_addr):
        print(f"Found address: with badc0de 0x{contract_addr}")
        print("The Private key is:")
        print(encode_hex(private_key))
        break

    iterations += 1

    # Print status every 1000 iterations
    if iterations % 1000 == 0:
        print(f"Iterations: {iterations}")


