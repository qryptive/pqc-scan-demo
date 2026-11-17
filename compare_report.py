#!/usr/bin/env python3
"""QP-617 T5: semantic comparison of two qryptive-scan-report.json files.

Usage: python3 compare_report.py EXPECTED.json ACTUAL.json

Two reports match when they have the same outcome and the same SET of
(repo-relative path, line, algorithm, severity). Timestamps, scanner build ids, summary counts
and absolute path prefixes are ignored. Exit 0 on a match, 1 on a mismatch (the difference is
printed), 2 when a file cannot be read as a v1 report.
"""
import json
import sys

PREFIXES = ("/github/workspace/", "/workspace/", "./")


def norm_path(p):
    p = str(p).replace("\\", "/")
    for pre in PREFIXES:
        while p.startswith(pre):
            p = p[len(pre):]
    return p


def load(path):
    with open(path, encoding="utf-8") as fh:
        d = json.load(fh)
    if not isinstance(d, dict) or d.get("schema_version") != 1:
        raise ValueError("not a schema v1 report: %s" % path)
    findings = d.get("findings")
    if not isinstance(findings, list):
        raise ValueError("no findings list: %s" % path)
    keys = set()
    for f in findings:
        keys.add((norm_path(f["path"]), f.get("line"), f.get("algorithm"), f.get("severity")))
    return d.get("outcome"), keys


def compare(expected, actual):
    """Return a list of difference lines (empty means the reports match)."""
    out = []
    if expected[0] != actual[0]:
        out.append("outcome: expected %s, got %s" % (expected[0], actual[0]))
    for k in sorted(expected[1] - actual[1], key=str):
        out.append("missing: %s:%s %s %s" % k)
    for k in sorted(actual[1] - expected[1], key=str):
        out.append("extra:   %s:%s %s %s" % k)
    return out


def main(argv):
    if len(argv) != 3:
        print(__doc__)
        return 2
    try:
        diff = compare(load(argv[1]), load(argv[2]))
    except (OSError, ValueError, KeyError, json.JSONDecodeError) as e:
        print("cannot read report: %s" % e)
        return 2
    if diff:
        print("MISMATCH")
        print("\n".join(diff))
        return 1
    print("MATCH")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
