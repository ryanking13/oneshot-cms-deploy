#!/usr/bin/python3

import csv
import subprocess as sp

contest_exists = True
o = sp.check_output(["contest-list"])
if b"No Contests" in o:
    contest_exists = False

with open('user_list.csv') as f:
    reader = csv.reader(f, delimiter=",")
    headers = next(reader, None)
    
    print(headers)
    for row in reader:
        firstname = row[0]
        lastname = row[1]
        username = row[2]
        password = row[3]

        sp.call(["add-user", firstname, lastname, username, password])
        if contest_exists:
            sp.call(["add-participation", username, "1"])

