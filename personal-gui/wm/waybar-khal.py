#!/usr/bin/env python
import json
import subprocess
from html import escape

data = {}

output = subprocess.check_output(
    'khal list now 7days --format "{start-end-time-style} {title}"', shell=True
).decode("utf-8")
lines = output.split("\n")

new_lines = []

for line in lines:
    line = escape(line)
    if len(line) and line[0].isalpha():
        line = "\n<b>" + line + "</b>"
    new_lines.append(line)

output = "\n".join(new_lines).strip()

if "Today" in output:
    next_meeting = output.split("\n")[1]
    if len(next_meeting) >= 30:
        next_meeting = next_meeting[0:27] + "..."
    data["text"] = " " + next_meeting
else:
    data["text"] = ""
data["tooltip"] = output

print(json.dumps(data))
