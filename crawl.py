#!/usr/bin/env python3
import os
import csv
import urllib.request

diff_file = open("./data/bills/diffstat.csv", "a")

sample = csv.reader(open('./data/bills/sample-1-diff.csv'), delimiter=';')
for item in sample:
    if not os.path.exists("./data/bills/"+item[1]+"/"):
        os.makedirs("./data/bills/"+item[1]+"/")
    print(item[1])

    page = urllib.request.urlopen(item[2])
    begut_htmlfile = open("./data/bills/"+item[1]+"/Begut.html", "w")
    begut_htmlfile.write(page.read().decode("utf-8"))
    begut_htmlfile.close()

    parse = 'html2text -b 0 --ignore-tables --single-line-break '+"./data/bills/"+item[1]+"/Begut.html"+" > ./data/bills/"+item[1]+"/Begut.txt"
    os.system(parse)

    print("saved begut "+item[1])

    page = urllib.request.urlopen(item[3])
    regv_htmlfile = open("./data/bills/"+item[1]+"/Regv.html", "w")
    regv_htmlfile.write(page.read().decode("utf-8"))
    regv_htmlfile.close()

    parse = 'html2text -b 0 --ignore-tables --single-line-break '+"./data/bills/"+item[1]+"/Regv.html"+" > ./data/bills/"+item[1]+"/Regv.txt"
    os.system(parse)

    print("saved regv "+item[1])

    diff = "diff -w -B ./data/bills/"+item[1]+"/Begut.txt ./data/bills/"+item[1]+"/Regv.txt > ./data/bills/test.diff"
    os.system(diff)
    diffstat = "diffstat -s ./data/bills/test.diff >> ./data/bills/diffstat.csv"
    os.system(diffstat)

diff_file.close()
