"""Intentionally vulnerable: legacy auth module using broken hashes + weak RSA."""

import hashlib
import hmac
from cryptography.hazmat.primitives.asymmetric import rsa, ec
from cryptography.hazmat.primitives import serialization


# VULNERABLE: MD5 is cryptographically broken
def hash_password(password: str) -> str:
    return hashlib.md5(password.encode()).hexdigest()


# VULNERABLE: SHA-1 is deprecated for security uses
def session_token(user_id: str, secret: bytes) -> str:
    return hmac.new(secret, user_id.encode(), hashlib.sha1).hexdigest()


# VULNERABLE: RSA-1024 is below the 2048-bit minimum (CNSA 2.0 requires >= 3072)
def generate_signing_key():
    return rsa.generate_private_key(public_exponent=65537, key_size=1024)


# VULNERABLE: P-256 is below CNSA 2.0 requirement of P-384
def generate_ec_key():
    return ec.generate_private_key(ec.SECP256R1())


# VULNERABLE: classical RSA is quantum-vulnerable regardless of key size
def generate_strong_rsa():
    return rsa.generate_private_key(public_exponent=65537, key_size=4096)
