# Qryptive — Example Vulnerable Application

A reference repo for evaluating the [Qryptive PQC Scanner](https://github.com/qryptive/pqc-scanner-action).

Every file in `src/` contains **intentionally vulnerable cryptography** so you can see exactly what the scanner detects. Safe to fork — none of this code does anything real.

---

## What's in here

| Language | File | Vulnerabilities |
|---|---|---|
| Python | [`src/python/legacy_auth.py`](src/python/legacy_auth.py) | MD5, SHA-1, RSA-1024, ECDSA P-256, classical RSA |
| Java | [`src/java/LegacyCryptoService.java`](src/java/LegacyCryptoService.java) | MD5, SHA-1, DES, RSA-1024, BouncyCastle (dependency), JWT (protocol) |
| Go | [`src/go/crypto_legacy.go`](src/go/crypto_legacy.go) | MD5, SHA-1, DES, RSA-1024, classical RSA, JWT |
| Terraform | [`src/terraform/kms_weak.tf`](src/terraform/kms_weak.tf) | RSA-2048 KMS keys, ECDSA P-256, deprecated TLS policies, TLS 1.1 |

---

## How the evaluation works

1. **Look at the workflow file**: [`.github/workflows/pqc-scan.yml`](.github/workflows/pqc-scan.yml) — this is exactly what you'd add to your own repo (~25 lines).
2. **Look at recent runs**: Actions tab → "PQC Evaluation Scan". The scanner runs on push, on PR, weekly via cron, and on demand.
3. **Look at findings**: Security tab → Code scanning alerts. Or the latest run's job summary.
4. **Try it on your own code**: copy `.github/workflows/pqc-scan.yml` into one of your repos.

The scanner runs entirely in the GitHub Actions runner. **No source code is sent to Qryptive.** See [`docs/ENTERPRISE_PRIVACY.md`](https://github.com/qryptive/.github/blob/main/docs/ENTERPRISE_PRIVACY.md) for the data-handling document.

---

## What you'll see in the Security tab

Each finding includes:
- File path and line number
- Algorithm name (RSA, MD5, DES, etc.)
- Severity (CRITICAL / HIGH / MEDIUM / LOW)
- Remediation: "Migrate to ML-KEM-768 (key exchange) or ML-DSA-65 (signatures) per NIST FIPS 203/204"
- Compliance tag where applicable (CNSA 2.0, NIST SP 800-131A, PCI-DSS 4.0)

Expected: **~30+ findings across the four files in this repo.**

---

## Next steps

- **Free tier**: keep using the workflow above — local scan, findings in Security tab, no Qryptive account needed.
- **AI disambiguation + dashboard**: sign up at [qryptive.ai](https://qryptive.ai), add `pqc_api_key: ${{ secrets.PQC_API_KEY }}` to the workflow.
- **Auto-fix PRs**: also add `github_token: ${{ secrets.GITHUB_TOKEN }}` — vulnerable files get rewritten to PQC equivalents and opened as a PR back to your repo.

---

*Questions? Contact us at [qryptive.ai](https://qryptive.ai).*
