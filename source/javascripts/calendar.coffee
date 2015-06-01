width = d3.select('#calendar').node().getBoundingClientRect()['width']
height = 136
cellSize = 17
# cell size
day = d3.time.format('%w')
week = d3.time.format('%U')
percent = d3.format('.1%')
format = d3.time.format('%Y-%m-%d')
prettyDate = d3.time.format('%a, %b %e, %Y')
color = d3.scale.quantize().domain([ -.05, .05 ]).range(d3.range(9).map((d) -> 'q' + d + '-9'))

calendarTooltipHtml = d3.select("#calendar-popup").html()
calendarTooltip = _.template(calendarTooltipHtml)

svg = d3.select('#calendar').selectAll('svg').data(d3.range(2008, 2014)).enter().append('svg').attr('width', width).attr('height', height+20).attr('class', 'YlOrRd').append('g').attr('transform', "translate(#{(width - (cellSize * 53)) / 2},#{(height - (cellSize * 7) - 1)})")

monthPath = (t0) ->
  t1 = new Date(t0.getFullYear(), t0.getMonth() + 1, 0)
  d0 = +day(t0)
  w0 = +week(t0)
  d1 = +day(t1)
  w1 = +week(t1)
  'M' + (w0 + 1) * cellSize + ',' + d0 * cellSize + 'H' + w0 * cellSize + 'V' + 7 * cellSize + 'H' + w1 * cellSize + 'V' + (d1 + 1) * cellSize + 'H' + (w1 + 1) * cellSize + 'V' + 0 + 'H' + (w0 + 1) * cellSize + 'Z'

svg.append('text').attr('class', 'info').attr('transform', "translate(#{cellSize*26},#{cellSize * 8})").style('text-anchor', 'middle')
svg.append('text').attr('transform', 'translate(-6,' + cellSize * 3.5 + ')rotate(-90)').style('text-anchor', 'middle').text (d) ->
  d
rect = svg.selectAll('.day').data((d) ->
  d3.time.days new Date(d, 0, 1), new Date(d + 1, 0, 1)
).enter().append('rect').attr('class', 'day').attr('width', cellSize).attr('height', cellSize).attr('x', (d) ->
  week(d) * cellSize
).attr('y', (d) ->
  day(d) * cellSize
).datum(format)
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
  ).on("mouseover", (d) ->
    count = data[d]
    templateData  = { dataType: "all", date: prettyDate(format.parse(d)), dataCount: count}
    d3.select('#tooltip').html(calendarTooltip(templateData)).style("opacity", 1)
    d3.select(this).classed("active", true)
  ).on("mouseout", (d) ->
    d3.select(this).classed("active", false)
    d3.select('#tooltip').style("opacity", 0)
  ).on("mousemove", (d) ->
    d3.select("#tooltip").style("left", (d3.event.pageX + 14) + "px")
    .style("top", (d3.event.pageY - 32) + "px")
  )
  return
