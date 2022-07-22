module.exports = (label) => {
  return {
    type: 'item',
    labels: {
      en: label,
      pt: label,
    },
    descriptions: {
      en: `diplomat from Mozambique`,
    },
    claims: {
      P31: { value: 'Q5' }, // human
      P106: { value: 'Q193391' }, // diplomat
    }
  }
}
