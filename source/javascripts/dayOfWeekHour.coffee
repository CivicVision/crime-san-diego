width = 960
height = 20
cellSize = 17
hour = d3.time.format('%H')
weekday = d3.time.format('%w')
color = d3.scale.quantize().domain([ -.05, .05 ]).range(d3.range(9).map((d) -> 'q' + d + '-9'))
sunday = new Date(2015,5,3)
start = moment(sunday).startOf('day')
end = moment(sunday).endOf('day')
timescale = d3.time.scale()
.nice(d3.time.day)
.domain([start.toDate(), end.toDate()])
.range([0, cellSize*24])

hoursAxis = d3.svg.axis()
.scale(timescale)
.orient('top')
.ticks(d3.time.hour, 3)
.tickFormat(d3.time.format("%I %p"))

dayOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
dayOfWeekScale = d3.scale.ordinal().domain([0...6]).range(dayOfWeek)

d3.csv 'data/day_of_week_hour.csv', (data) ->
  max = d3.max(data, (d) -> d.count)
  color.domain([0, max])
  svg = d3.select('#day-of-week').selectAll('svg').data(d3.range(0,7)).enter().append('svg').attr('width', width).attr('height', height).append('g').attr('transform', "translate(70,5)").attr('class', 'YlOrRd')

  svg.append('text').attr('class', 'day-of-week').attr('transform', 'translate(-70,10)').text( (d) -> dayOfWeek[d] )
  rect = svg.selectAll('.hour').data((d) -> 
    d3.time.hours moment(sunday).add(d, 'days').startOf('day').toDate(), moment(sunday).add(d, 'days').endOf('day').toDate()
  ).enter().append('rect').attr('class', 'hour').attr('width', cellSize).attr('height', cellSize).attr('x', (d) ->
   hour(d)*cellSize 
  ).attr('y', 0)
  .attr('class', (d) ->
    entry = _.findWhere(data, { dow: weekday(d), hour: "#{parseInt(hour(d))}"})
    color(parseInt(entry.count))
  )
  hoursg = svg.append('g')
  .classed('axis', true)
  .classed('hours', true)
  .classed('labeled', true)
  .attr("transform", "translate(0,-10.5)")
  .call(hoursAxis)
