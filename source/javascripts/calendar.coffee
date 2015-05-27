width = 960
height = 136
cellSize = 17
# cell size
day = d3.time.format('%w')
week = d3.time.format('%U')
percent = d3.format('.1%')
format = d3.time.format('%Y-%m-%d')
color = d3.scale.quantize().domain([ -.05, .05 ]).range(d3.range(9).map((d) -> 'q' + d + '-9'))
svg = d3.select('#calendar').selectAll('svg').data(d3.range(2008, 2014)).enter().append('svg').attr('width', width).attr('height', height).attr('class', 'YlOrRd').append('g').attr('transform', "translate(#{(width - (cellSize * 53)) / 2},#{(height - (cellSize * 7) - 1)})")

monthPath = (t0) ->
  t1 = new Date(t0.getFullYear(), t0.getMonth() + 1, 0)
  d0 = +day(t0)
  w0 = +week(t0)
  d1 = +day(t1)
  w1 = +week(t1)
  'M' + (w0 + 1) * cellSize + ',' + d0 * cellSize + 'H' + w0 * cellSize + 'V' + 7 * cellSize + 'H' + w1 * cellSize + 'V' + (d1 + 1) * cellSize + 'H' + (w1 + 1) * cellSize + 'V' + 0 + 'H' + (w0 + 1) * cellSize + 'Z'

svg.append('text').attr('transform', 'translate(-6,' + cellSize * 3.5 + ')rotate(-90)').style('text-anchor', 'middle').text (d) ->
  d
rect = svg.selectAll('.day').data((d) ->
  d3.time.days new Date(d, 0, 1), new Date(d + 1, 0, 1)
).enter().append('rect').attr('class', 'day').attr('width', cellSize).attr('height', cellSize).attr('x', (d) ->
  week(d) * cellSize
).attr('y', (d) ->
  day(d) * cellSize
).datum(format)
rect.append('title').text (d) ->
  d
svg.selectAll('.month').data((d) ->
  d3.time.months new Date(d, 0, 1), new Date(d + 1, 0, 1)
).enter().append('path').attr('class', 'month').attr 'd', monthPath
d3.csv 'data/day_count.csv', (error, csv) ->
  data = d3.nest().key((d) ->
    d.date
  ).rollup((d) ->
    (d[0].count)
  ).map(csv)
  color.domain(d3.extent(csv, (d) -> d.count))
  rect.filter((d) ->
    d of data
  ).attr('class', (d) ->
    'day ' + color(data[d])
  ).select('title').text (d) ->
    d + ': ' + (data[d])
  return
