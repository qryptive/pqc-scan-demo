// Intentionally vulnerable: legacy Java crypto using JCA + JWT + BouncyCastle.

package com.example.legacy;

import java.security.MessageDigest;
import java.security.KeyPairGenerator;
import java.security.Security;
import java.security.NoSuchAlgorithmException;
import javax.crypto.Cipher;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

public class LegacyCryptoService {

    static {
        // Provider registration — classified as dependency, not algorithm finding
        Security.addProvider(new BouncyCastleProvider());
    }

    // VULNERABLE: MD5
    public byte[] fingerprint(byte[] data) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("MD5");
        return md.digest(data);
    }

    // VULNERABLE: SHA-1
    public byte[] legacyDigest(byte[] data) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-1");
        return md.digest(data);
    }

    // VULNERABLE: RSA + PKCS#1 v1.5 padding (Bleichenbacher attack surface, and quantum-vulnerable)
    public Cipher rsaCipher() throws Exception {
        return Cipher.getInstance("RSA/ECB/PKCS1Padding");
    }

    // VULNERABLE: DES
    public Cipher desCipher() throws Exception {
        return Cipher.getInstance("DES/ECB/PKCS5Padding");
    }

    // VULNERABLE: RSA-1024 keygen
    public void generateWeakRsaKey() throws NoSuchAlgorithmException {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("RSA");
        kpg.initialize(1024);
        kpg.generateKeyPair();
    }

    // JWT with HS256 — classified as protocol finding (JWT), not as raw HS256 algorithm.
    public String signJwt(String subject, String secret) {
        return Jwts.builder()
            .setSubject(subject)
            .signWith(SignatureAlgorithm.HS256, secret.getBytes())
            .compact();
    }

    // HMAC-SHA256 used outside of a JWT context — different classification.
    public Mac hmacSha256(byte[] key) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(key, "HmacSHA256"));
        return mac;
    }
}
