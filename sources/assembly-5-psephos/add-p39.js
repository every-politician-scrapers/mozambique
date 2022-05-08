const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (id, label, party, area) => {
  qualifier = { }
  if(meta.term) qualifier['P2937'] = meta.term.id
  if(party)     qualifier['P4100'] = party
  if(area)      qualifier['P768']  = area

  reference = {
    P854: meta.source,
    P813: new Date().toISOString().split('T')[0],
    P1810: label,
  }

  return {
    id,
    claims: {
      P39: {
        value: meta.position,
        qualifiers: qualifier,
        references: reference,
      }
    }
  }
}
