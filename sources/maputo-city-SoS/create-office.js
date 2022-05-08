module.exports = (label, jurisdiction) => {
  claims = {
    P31:   { value: 'Q294414' }, // instance of: public office
    P279:  { value: 'Q736559'  }, // subclas of: SoS
    P17:   { value: 'Q1029' }, // Mz
    P1001: { value: jurisdiction },
  }

  return {
    type: 'item',
    labels: {
      en: label,
    },
    descriptions: {
      en: `provincial position in Mozambique`,
    },
    claims: claims
  }
}
