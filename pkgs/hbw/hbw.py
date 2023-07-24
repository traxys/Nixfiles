#!/usr/bin/env python3

import sys
import subprocess
import json
import pyotp
import datetime

if len(sys.argv) < 2:
    print("Missing search term")
    sys.exit(1)

search = sys.argv[1]

process = subprocess.Popen(
    ["bw", "list", "items", "--search", search], stdout=subprocess.PIPE
)
process.wait()
data, _ = process.communicate()
if process.returncode != 0:
    sys.exit(1)

data = json.loads(data)

for item in data:
    if "login" in item:
        print(f"==== {item['name']} ====")
        if "username" in item["login"]:
            print(f"    {item['login']['username']}")
        if "password" in item["login"]:
            print(f"    {item['login']['password']}")
        if "totp" in item["login"] and item["login"]["totp"] is not None:
            if item["login"]["totp"].startswith("otpauth://"):
                totp = pyotp.parse_uri(item["login"]["totp"])
            else:
                totp = pyotp.TOTP(item["login"]["totp"])
            time_remaining = (
                totp.interval - datetime.datetime.now().timestamp() % totp.interval
            )
            print(f"    {totp.now()} ({int(time_remaining)})")
