# Qryptive scanner demo: a deliberately vulnerable repository

The code in `src/` uses weak and quantum-vulnerable cryptography on purpose (MD5, SHA-1, DES,
RSA, ECDSA, weak TLS and KMS settings in Python, Java, Go and Terraform). None of it does
anything real. It exists so you can see what the [Qryptive scanner](https://github.com/qryptive/pqc-scanner-action) reports.

**See a result:** open the latest run in the [Actions tab](../../actions), then its job summary.
The run also keeps the full report as the artifact `qryptive-scan-report`. The last recorded run
found 26 entries: 3 critical, 20 high and 3 informational.

**Run it yourself:** fork this repository and run the "PQC Demo Scan" workflow. That uses the
current scanner, so counts can change between releases.

**Reproduce the recorded result exactly:** run `./reproduce.sh`. It runs the scanner image pinned
by fingerprint, on the recorded source commit, with the recorded settings. It then compares the new
report with the saved one in `expected/` and prints MATCH or the differences. It needs Docker and git.

The scan runs in the GitHub runner and sends nothing to Qryptive: this workflow sets no Qryptive
key. What is sent, and when:
[qryptive.ai/privacy/scanner](https://qryptive.ai/privacy/scanner).

Add the same scan to your own repository: [qryptive.ai/scanner/install](https://qryptive.ai/scanner/install).

Scanner image used for the recorded run: `ghcr.io/qryptive/pqc-scanner@sha256:3f78060af516743bdb36bbc0f78a7900bf9aa5a8e6956847894e2e1cbd440f89`
