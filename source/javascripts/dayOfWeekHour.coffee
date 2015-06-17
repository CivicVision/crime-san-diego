@dayofWeekChart = ->
  width = 700
  height = 20
  cellSize = 17
  xTicks = 3
  defaultEmpty = 0
  paddingDays = 5
  weekDayPadding = 70
  weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
  hour = d3.time.format('%H')
  weekday = d3.time.format('%w')
  weekdayText = d3.time.format('%A')
  time = d3.time.format("%I %p")

  dayOfWeekTooltipHtml = d3.select("#day-of-week-popup").html()
  dayOfWeekTooltip = _.template(dayOfWeekTooltipHtml)

  dayOfWeekScale = d3.scale.ordinal().domain([0...6]).range(weekDays)
  startDate = new Date(2015,4,3)
  color = d3.scale.quantize().domain([ -.05, .05 ]).range(d3.range(9).map((d) -> 'q' + d + '-9'))
  start = moment(startDate).startOf('day')
  end = moment(startDate).endOf('day')

  timescale = d3.time.scale()
  .nice(d3.time.day)
  .domain([start.toDate(), end.toDate()])
  .range([0, cellSize*24])


  chart = (selection) ->
    selection.each (data,i) =>
      start = moment(startDate).startOf('day')
      end = moment(startDate).endOf('day')

      timescale
        .domain([start.toDate(), end.toDate()])
        .range([0, cellSize*24])
      svg = this.selectAll('svg').data(d3.range(0,7))

      gEnter = svg.enter().append('svg').append('g')

      svg.attr('width', width).attr('height', height)
      g = svg.select("g").attr('transform', "translate(#{weekDayPadding}, #{paddingDays})").attr('class', 'YlOrRd')
      g.append('text').attr('class', 'day-of-week').attr('transform', "translate(-#{weekDayPadding}, #{paddingDays*2})").text( (d) -> weekDays[d] )
      rect = g.selectAll('.hour').data((d) ->
        d3.time.hours moment(startDate).add(d, 'days').startOf('day').toDate(), moment(startDate).add(d, 'days').endOf('day').toDate()
      )
      rect.enter().append('rect').attr('width', cellSize).attr('height', cellSize).attr('x', (d) ->
        hour(d)*cellSize
      ).attr('y', 0)
      .on("mouseout", (d) ->
        d3.select(this).classed("active", false)
        d3.select('#tooltip').style("opacity", 0)
      ).on("mousemove", (d) ->
        d3.select("#tooltip").style("left", (d3.event.pageX + 14) + "px")
        .style("top", (d3.event.pageY - 32) + "px")
      )
      rect.attr('class', (d) ->
        entry = _.findWhere(data, { dow: weekday(d), hour: "#{parseInt(hour(d))}"})
        if entry
          count = entry.count
        else
          count = defaultEmpty
        "hour #{color(parseInt(count))}"
      )
      .on("mouseover", (d) ->
        entry = _.findWhere(data, { dow: weekday(d), hour: "#{parseInt(hour(d))}"})
        if entry
          count = entry.count
        else
          count = defaultEmpty
        templateData  = { dayOfWeek: weekdayText(d), hour: time(d), dataCount: count }
        d3.select('#tooltip').html(dayOfWeekTooltip(templateData)).style("opacity", 1)
        d3.select(this).classed("active", true)
      )
      hoursAxis = d3.svg.axis()
      .scale(timescale)
      .orient('top')
      .ticks(d3.time.hour, xTicks)
      .tickFormat(time)

      hoursg = g.append('g')
      .classed('axis', true)
      .classed('hours', true)
      .classed('labeled', true)
      .attr("transform", "translate(0,-10.5)")
      .call(hoursAxis)
  chart.cellSize = (value) ->
    unless arguments.length
      return cellSize
    cellSize = value
    chart
  chart.height = (value) ->
    unless arguments.length
      return height
    height = value
    chart
  chart.width = (value) ->
    unless arguments.length
      return width
    width = value
    chart
  chart.color = (value) ->
    unless arguments.length
      return color
    color = value
    chart
  chart.weekDays = (value) ->
    unless arguments.length
      return weekDays
    weekDays = value
    chart
  chart.xTicks = (value) ->
    unless arguments.length
      return xTicks
    xTicks = value
    chart
  chart.weekDayPadding = (value) ->
    unless arguments.length
      return weekDayPadding
    weekDayPadding = value
    chart
  chart

unless d3.select('#day-of-week').empty()

  d3.csv 'data/day_of_week_hour.csv', (data) ->
    max = d3.max(data, (d) -> d.count)
    color = d3.scale.quantize().domain([0, max]).range(d3.range(9).map((d) -> 'q' + d + '-9'))
    width = d3.select('#day-of-week').node().getBoundingClientRect()['width']
    chart = dayofWeekChart().color(color).width(width).cellSize(20)
    d3.select('#day-of-week').datum(data).call(chart)

