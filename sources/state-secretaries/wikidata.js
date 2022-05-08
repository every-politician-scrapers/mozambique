const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = function (...positions) {
  positions = positions.map(value => `wd:${value}`).join(' ')

  return `SELECT DISTINCT ?item ?name ?position ?positionLabel
                 ?startDate ?endDate (STRAFTER(STR(?ps), STR(wds:)) AS ?psid)
    WITH {
      SELECT DISTINCT ?item ?position ?startNode ?endNode ?ps
      WHERE {
          VALUES ?position { ${positions} }
          ?item wdt:P31 wd:Q5 ; p:P39 ?ps .
          ?ps ps:P39 ?position .
          FILTER NOT EXISTS { ?ps wikibase:rank wikibase:DeprecatedRank }

          ?ps pqv:P580 ?startNode
          MINUS { ?ps pq:P582 [] }
      }
    } AS %statements
    WHERE {
      INCLUDE %statements .
      ?startNode wikibase:timeValue ?startV ; wikibase:timePrecision ?startP .

      BIND (
        COALESCE(
          IF(?startP = 11, SUBSTR(STR(?startV), 1, 10), 1/0),
          IF(?startP = 10, SUBSTR(STR(?startV), 1, 7), 1/0),
          IF(?startP = 9,  SUBSTR(STR(?startV), 1, 4), 1/0),
          IF(?startP = 8,  CONCAT(SUBSTR(STR(?startV), 1, 4), "s"), 1/0),
          ""
        ) AS ?startDate
      )

      OPTIONAL {
        ?ps prov:wasDerivedFrom ?ref .
        ?ref pr:P854 ?source FILTER CONTAINS(STR(?source), '${meta.source.url}') .
        OPTIONAL { ?ref pr:P1810 ?sourceName }
        OPTIONAL { ?ref pr:P1932 ?statedName }
        OPTIONAL { ?ref pr:P813  ?sourceDate }
      }
      OPTIONAL { ?item rdfs:label ?labelName FILTER(LANG(?labelName) = "en") }
      BIND(COALESCE(?sourceName, ?labelName) AS ?name)

      OPTIONAL { ?position rdfs:label ?positionEN FILTER(LANG(?positionEN) = "en") }
      BIND(COALESCE(?statedName, ?positionEN) AS ?positionLabel)
    }
    # ${new Date().toISOString()}
    ORDER BY ?sourceDate ?item ?psid`
}
