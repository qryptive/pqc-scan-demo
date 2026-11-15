// Intentionally vulnerable: legacy Go crypto using stdlib + JWT.

package legacy

import (
	"crypto/des"
	"crypto/rsa"
	"crypto/rand"
	"crypto/md5"
	"crypto/sha1"

	"github.com/golang-jwt/jwt/v4"
)

// VULNERABLE: MD5
func MD5Hash(data []byte) [16]byte {
	return md5.Sum(data)
}

// VULNERABLE: SHA-1
func SHA1Hash(data []byte) [20]byte {
	return sha1.Sum(data)
}

// VULNERABLE: DES (and ECB-like single-block usage)
func DesCipher(key []byte) ([]byte, error) {
	block, err := des.NewCipher(key)
	if err != nil {
		return nil, err
	}
	out := make([]byte, des.BlockSize)
	block.Encrypt(out, make([]byte, des.BlockSize))
	return out, nil
}

// VULNERABLE: RSA-1024 keygen
func GenerateWeakRSA() (*rsa.PrivateKey, error) {
	return rsa.GenerateKey(rand.Reader, 1024)
}

// VULNERABLE: classical RSA (quantum-vulnerable regardless of key size)
func GenerateRSA4096() (*rsa.PrivateKey, error) {
	return rsa.GenerateKey(rand.Reader, 4096)
}

// JWT with HS256 — classified as protocol finding.
func SignJWT(subject string, secret []byte) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"sub": subject,
	})
	return token.SignedString(secret)
}
