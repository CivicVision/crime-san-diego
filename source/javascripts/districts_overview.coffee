districtMapping = {
  'San001': '1'
  'San002': '2'
  'San003': '3'
  'San004': '4'
  'San005': '5'
  'San006': '6'
  'San007': '7'
  'San008': '8'
  'San009': '9'
}
d3.csv 'data/per_year_council.csv', (data) ->
  data_2012 = _.where(data, { year: "2012" })
  _.each(data_2012, (d) -> 
    d.per_houndredthousand = parseInt(d.per_houndredthousand)
    d.council = districtMapping[d.council]
  )
  yearCount = new Barchart(data_2012)
  yearCount.setValueKey('per_houndredthousand')
  yearCount.setGroupKey('council')
  yearCount.setXDomain(_.unique(_.map(data_2012, (d) -> d.council)))
  yearCount.setYDomain([0, d3.max(data_2012, (d) -> parseInt(d.per_houndredthousand))])
  yearCount.render('.per_district')
