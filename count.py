#!/usr/bin/env python3
import os
import csv

sample = csv.reader(open('./data/bills/sample-1-diff.csv'), delimiter=';')
for item in sample:
    print(item[1])

    os.system("wc -l ./data/bills/"+item[1]+"/Begut.txt >> ./data/bills/fileleangth.txt")
    print("saved begut leangth "+item[1])

diff_file.close()
