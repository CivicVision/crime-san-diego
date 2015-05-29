d3.csv 'data/year_count.csv', (data) ->
  width = d3.select('.overall-per-year').node().getBoundingClientRect()['width']
  data = _.reject(data, (d) -> d.year == '2013')
  yearCount = new Barchart(data, {width: width-30 })
  yearCount.setValueKey('count')
  yearCount.setGroupKey('year')
  yearCount.setXDomain([2007..2012])
  yearCount.setYDomain([0, d3.max(data, (d) -> parseInt(d.count))])
  yearCount.render('.overall-per-year')
