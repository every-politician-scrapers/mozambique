#!/bin/bash

cd $(dirname $0)

# Original extracted from https://www.researchgate.net/profile/Elisabete-Azevedo-Harman/publication/308233910_De_Inimigos_a_Adversarios_Politicos_O_Parlamento_e_os_Parlamentares_em_Mocambique/links/57dee92008ae72d72eac1594/De-Inimigos-a-Adversarios-Politicos-O-Parlamento-e-os-Parlamentares-em-Mocambique.pdf
qsv select name,party raw.csv | qsv join --left party - partyLabel parties.csv | sed -e 's/$/,/' | qsv select "5,name,party[1],partyLabel" | qsv rename item,name,party,partyLabel > scraped.csv

wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | qsv sort -s name,startDate > wikidata.csv

bundle exec ruby diff.rb | tee diff.csv

cd ~-
