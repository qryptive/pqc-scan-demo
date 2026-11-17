#!/usr/bin/env bash
# Reproduces the recorded demo scan exactly, offline from GitHub: same source commit, same scanner
# image (by digest), same settings. Generated from github-action/action.yml by gen_reproduce.py.
#
#   source commit  : cb1ccbb4037401edac6f8176e0d9ff11e5c7a09e
#   scanner image  : ghcr.io/qryptive/pqc-scanner@sha256:3f78060af516743bdb36bbc0f78a7900bf9aa5a8e6956847894e2e1cbd440f89
#   action ref     : qryptive/pqc-scanner-action@f3ca1ae6901c16712c6ba3f8392b9bd02922eae2
#   recorded run   : https://github.com/qryptive/pqc-scan-demo/actions/runs/43951993622
#
# Needs docker and git. Run from the root of a clone of this repository:  ./reproduce.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

git clone --quiet "https://github.com/qryptive/pqc-scan-demo.git" "$WORK/ws"
git -C "$WORK/ws" checkout --quiet cb1ccbb4037401edac6f8176e0d9ff11e5c7a09e

docker run --rm --platform linux/amd64 \
  -v "$WORK/ws":/github/workspace --workdir /github/workspace \
  -e CI=true \
  -e GITHUB_ACTIONS=true \
  -e GITHUB_EVENT_NAME=workflow_dispatch \
  -e GITHUB_REPOSITORY=qryptive/pqc-scan-demo \
  -e GITHUB_SHA=cb1ccbb4037401edac6f8176e0d9ff11e5c7a09e \
  -e GITHUB_REF=refs/heads/main \
  -e GITHUB_REF_NAME=main \
  -e GITHUB_WORKSPACE=/github/workspace \
  -e INPUT_AUTO_FIX=false \
  -e INPUT_BASELINE_SCAN=true \
  -e INPUT_FAIL_ON_VULNERABLE=false \
  -e INPUT_FIX_RUN_ID= \
  -e INPUT_MIGRATION_MODE=pqc_only \
  -e 'INPUT_PATHS=**/*' \
  -e INPUT_REPORT_FORMAT=json \
  -e INPUT_SCAN_ID= \
  -e INPUT_SCAN_SCOPE=auto \
  -e INPUT_SEVERITY_THRESHOLD=medium \
  -e KEYPAIR_GRAPH_MAX_CANDIDATE_FILES=100 \
  -e KEYPAIR_GRAPH_MAX_FILES=2000 \
  -e PQC_PLATFORM_URL= \
  -e SCANNER_ASSET_DISCOVERY_ENABLED=true \
  -e SCANNER_CLOUD_KEY_REFERENCES_ENABLED=true \
  -e SCANNER_FINDING_GATE_ENABLED=true \
  -e SCANNER_IAC_EXTENDED_DETECTION_ENABLED=true \
  -e SCANNER_IAC_KEY_DEFINITIONS_ENABLED=true \
  -e SCANNER_KEYPAIR_ANCHOR_CLASS_ENABLED=true \
  -e SCANNER_KEYPAIR_CANDIDATES_ENABLED=true \
  -e SCANNER_KEYPAIR_GRAPH_ENABLED=true \
  -e SCANNER_KEY_DISTRIBUTION_ENABLED=true \
  -e SCANNER_MESH_OBSERVATIONS_ENABLED=true \
  -e SCANNER_PIN_DETECTION_ENABLED=true \
  -e SCANNER_PQ_CAPABILITY_ENABLED=true \
  -e SCANNER_TIER_GATE_ENABLED=true \
  -e SCANNER_TLS_SERVER_DETECTOR_ENABLED=true \
  ghcr.io/qryptive/pqc-scanner@sha256:3f78060af516743bdb36bbc0f78a7900bf9aa5a8e6956847894e2e1cbd440f89

python3 "$HERE/compare_report.py" "$HERE/expected/qryptive-scan-report.json" "$WORK/ws/qryptive-scan-report.json"
