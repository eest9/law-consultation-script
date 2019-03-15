#!/usr/bin/env python3
import os
import csv
import urllib.request

diff_file = open("./data/bills/diffstat.csv", "a")

sample = csv.reader(open('./data/bills/sample-x.csv'), delimiter=';')
for item in sample:
    diff = "diff -w -B ./data/bills/"+item[0]+"/Begut.txt ./data/bills/"+item[0]+"/Regv.txt > ./data/bills/"+item[0]+"/test.diff"
    os.system(diff)

    print("done"+item[0])

diff_file.close()
