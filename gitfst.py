#!/usr/bin/env python3
#
# Find the first commit of the current branch, which is defined as the descendant
# of the first ancestor belonging to a different branch. I.e if you have this
# history:
#
# 530b8557e branch b, HEAD
# d036ecec4
# a5cde18a2                   <- so this commit is the first of branch b
# d036ecec4 branch b' -> first ancestor belonging to different branch -^
#
# This command tries at most 256 ancestors.

import sys
import subprocess


def main() -> int:
    """ The main """
    current_branch = subprocess.run(["git", "branch", "--show-current"],
                                    stdout=subprocess.PIPE,
                                    universal_newlines=True,
                                    check=True).stdout.strip()
    prev = "HEAD"
    for i in range(1, 256):
        here = f"HEAD~{i}"
        cmd = ["git", "branch", "--contains", here]
        branches = subprocess.run(cmd,
                                  stdout=subprocess.PIPE,
                                  universal_newlines=True,
                                  check=True).stdout.split("\n")
        branches = [b.strip() for b in branches if b and b.strip()]
        for branch in branches:
            if branch.startswith("* "):
                branch = branch[2:]
            if branch != current_branch:
                if prev:
                    print(prev)
                    return 0
                print("Unexpected state", file=sys.stderr)
                return 1
        prev = here
    print("First commit not found 💥", file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main())
