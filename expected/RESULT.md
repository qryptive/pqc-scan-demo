# Recorded scan result

This is the result of the [recorded run](https://github.com/qryptive/pqc-scan-demo/actions/runs/44923157930), written out so you can read it without
signing in to GitHub. GitHub shows a run's job summary only to signed-in users, and downloading
its report artifact needs a sign-in too.
The full report is [`qryptive-scan-report.json`](qryptive-scan-report.json) in this folder.

Outcome: **COMPLETE**. 4 of 4 files examined. 26 entries: 3 critical, 20 high, 3 informational.

| Severity | File | Line | Algorithm |
|---|---|---|---|
| critical | `src/go/crypto_legacy.go` | 27 | DES |
| critical | `src/java/LegacyCryptoService.java` | 43 | DES |
| critical | `src/terraform/kms_weak.tf` | 34 | RSA |
| high | `src/go/crypto_legacy.go` | 17 | MD5 |
| high | `src/go/crypto_legacy.go` | 22 | SHA-1 |
| high | `src/go/crypto_legacy.go` | 38 | RSA |
| high | `src/go/crypto_legacy.go` | 43 | RSA |
| high | `src/java/LegacyCryptoService.java` | 26 | MD5 |
| high | `src/java/LegacyCryptoService.java` | 32 | SHA-1 |
| high | `src/java/LegacyCryptoService.java` | 38 | RSA |
| high | `src/java/LegacyCryptoService.java` | 48 | RSA |
| high | `src/python/legacy_auth.py` | 11 | MD5 |
| high | `src/python/legacy_auth.py` | 16 | SHA-1 |
| high | `src/python/legacy_auth.py` | 21 | RSA |
| high | `src/python/legacy_auth.py` | 26 | ECC |
| high | `src/python/legacy_auth.py` | 31 | RSA |
| high | `src/terraform/kms_weak.tf` | 3 | RSA |
| high | `src/terraform/kms_weak.tf` | 9 | RSA |
| high | `src/terraform/kms_weak.tf` | 15 | RSA |
| high | `src/terraform/kms_weak.tf` | 20 | ECC |
| high | `src/terraform/kms_weak.tf` | 26 | TLS |
| high | `src/terraform/kms_weak.tf` | 41 | TLS |
| high | `src/terraform/kms_weak.tf` | 48 | TLS |
| informational | `src/go/crypto_legacy.go` | 48 | HMAC |
| informational | `src/java/LegacyCryptoService.java` | 57 | HMAC |
| informational | `src/java/LegacyCryptoService.java` | 63 | SHA-256 |

Each entry's one-line recommendation is in the JSON report. Run `../reproduce.sh` to check this result against the pinned scanner yourself.
