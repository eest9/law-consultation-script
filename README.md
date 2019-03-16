# law-consultation-script

  - [get_begut.sh] is used to get the metadata for all consultation bills of the last legislative period.
  - [get_regv.sh] is used to get the metadata for all council bills of the last legislative period.
  - [crawl.py] is used to download each bill text, do the data comparison and the statistic analysis of the additions and the deletions.
  - [count.py] is used to count the overall number of fragments of each consultation bill.
  - [crawl-quali.py] is used to make diffs of a certain set of bills
  - rest is garbage

# requirements

  - coming soon

# usage
## [get_regv.sh]
This script requires 2 parameters. The first one is the start date and the seconde one the end date of the time frame you want to observe. Only ISO 8601 values are allowed.


[get_begut.sh]: https://github.com/eest9/law-consultation-script/blob/master/get_begut.sh
[get_regv.sh]: https://github.com/eest9/law-consultation-script/blob/master/get_regv.sh
[crawl.py]: https://github.com/eest9/law-consultation-script/blob/master/crawl.py
[count.py]: https://github.com/eest9/law-consultation-script/blob/master/count.py
[crawl-quali.py]: https://github.com/eest9/law-consultation-script/blob/master/crawl-quali.py
