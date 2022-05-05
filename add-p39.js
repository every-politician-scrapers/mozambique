const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (id, position, startdate, enddate) => {
  qualifier = {
    P580: meta.cabinet.start,
  }
  if(startdate) qualifier['P580']  = startdate
  if(enddate)   qualifier['P582']  = enddate

  reference = { }
  if(process.env.REF) {
    var wpref = /wikipedia.org/;
    if (wpref.test(process.env.REF)) {
      reference['P4656'] = process.env.REF
    } else {
      reference['P854'] = process.env.REF
    }
  }
  reference['P813'] = new Date().toISOString().split('T')[0]

  return {
    id,
    claims: {
      P39: {
        value: position,
        qualifiers: qualifier,
        references: reference,
      }
    }
  }
}
