const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (label,party,area) => {
  mem = {
    value: meta.position,
    qualifiers: {
      P2937: meta.term.id,
    },
    references: {
      P854: meta.source,
      P813: new Date().toISOString().split('T')[0],
      P1810: label,
    }
  }
  if(party) mem['qualifiers']['P4100'] = party
  if(area)  mem['qualifiers']['P768']  = area

  claims = {
    P31: { value: 'Q5' }, // human
    P106: { value: 'Q82955' }, // politician
    P39: mem,
  }

  return {
    type: 'item',
    labels: { en: label, pt: label },
    descriptions: { en: 'politician in Mozambique' },
    claims: claims,
  }
}
