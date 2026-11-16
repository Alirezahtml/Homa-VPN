#!/usr/bin/env python3
"""Kotlin's braces, parens and brackets balance, per source file.

The Android app compiles only on a tag (the release build), so a missing
brace once rode three green main-branch runs and broke the release. This
check runs on every push instead: it reads each Kotlin file with the
comments and the string literals stripped, and counts. A file that does
not balance fails the run before anything else builds on it.
"""
import pathlib
import sys

def strip(code: str) -> str:
    out = []
    i, n = 0, len(code)
    NORMAL, LINE, BLOCK, DQ, SQ = 0, 1, 2, 3, 4
    st = NORMAL
    while i < n:
        c = code[i]
        nxt = code[i + 1] if i + 1 < n else ''
        if st == NORMAL:
            if c == '/' and nxt == '/':
                st = LINE
                i += 2
                continue
            if c == '/' and nxt == '*':
                st = BLOCK
                i += 2
                continue
            if c == '"':
                st = DQ
                i += 1
                out.append(' ')
                continue
            if c == "'":
                st = SQ
                i += 1
                out.append(' ')
                continue
            out.append(c)
            i += 1
        elif st == LINE:
            if c == '\n':
                st = NORMAL
                out.append('\n')
            i += 1
        elif st == BLOCK:
            if c == '*' and nxt == '/':
                st = NORMAL
                i += 2
                out.append(' ')
                continue
            if c == '\n':
                out.append('\n')
            i += 1
        elif st == DQ:
            if c == '\\':
                i += 2
                continue
            if c == '"' or c == '\n':
                st = NORMAL
            i += 1
        elif st == SQ:
            if c == '\\':
                i += 2
                continue
            if c == "'" or c == '\n':
                st = NORMAL
            i += 1
    return ''.join(out)

def main(argv: list[str]) -> int:
    root = pathlib.Path(argv[1]) if len(argv) > 1 else pathlib.Path('app/android')
    bad = 0
    for f in sorted(root.rglob('*.kt')):
        code = strip(f.read_text(encoding='utf-8'))
        for op, cl in (('{', '}'), ('(', ')'), ('[', ']')):
            a, b = code.count(op), code.count(cl)
            if a != b:
                print(f'::error file={f}::Kotlin {op}{cl} unbalanced: {a} open, {b} close')
                bad += 1
    return 1 if bad else 0

if __name__ == '__main__':
    sys.exit(main(sys.argv))
