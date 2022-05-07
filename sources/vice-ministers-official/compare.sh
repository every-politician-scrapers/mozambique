#!/bin/bash

cd $(dirname $0)

bundle exec ruby scraper.rb | qsv select position,name | qsv rename name,position > scraped.csv
qsv cat rows ../../wikidata/*.csv | qsv search -i "Deputy Minister" | qsv select position | qsv behead | xargs wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid > wikidata.csv
bundle exec ruby diff.rb | tee diff.csv

cd ~-
