const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = function () {
    return `SELECT DISTINCT ?item ?itemLabel ?position ?positionLabel ?start ?end
               (STRAFTER(STR(?held), '/statement/') AS ?psid)
      WHERE {
          # Positions ever in the cabinet
          ?position p:P361 ?ps .
          ?ps ps:P361 wd:${meta.cabinet.parent} .

          # Who has held those positions since 2000?
          ?item wdt:P31 wd:Q5 ; p:P39 ?held .
          ?held ps:P39 ?position ; pq:P580 ?start .
          OPTIONAL { ?held pq:P582 ?end }

          FILTER NOT EXISTS { ?held wikibase:rank wikibase:DeprecatedRank }
          FILTER (!BOUND(?end) || ?end > "2000-01-01"^^xsd:dateTime)
          FILTER (?start < "2020-01-01"^^xsd:dateTime)

          SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
      }
      ORDER BY ?item ?position ?start ?psid`
}
