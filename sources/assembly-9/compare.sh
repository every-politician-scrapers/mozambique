#!/bin/bash

cd $(dirname $0)

# Original extracted from https://www.portaldogoverno.gov.mz/por/Imprensa/Noticias/Quem-sao-os-deputados-da-AR
qsv select name,party,constituency raw.csv | qsv join --left party - partyLabel parties.csv | qsv join --left constituency - provinceLabel provinces.csv | qsv select name,party\[1\],partyLabel,province,constituency | qsv rename name,party,partyLabel,area,areaLabel > scraped.csv

wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | qsv sort -s name,startDate > wikidata.csv

bundle exec ruby diff.rb | tee diff.csv

cd ~-
