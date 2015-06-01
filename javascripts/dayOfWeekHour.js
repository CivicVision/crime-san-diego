(function() {
  var cellSize, color, dayOfWeek, dayOfWeekScale, dayOfWeekTooltip, dayOfWeekTooltipHtml, end, height, hour, hoursAxis, start, sunday, time, timescale, weekday, weekdayText, width;

  width = 960;

  height = 20;

  cellSize = 17;

  hour = d3.time.format('%H');

  weekday = d3.time.format('%w');

  weekdayText = d3.time.format('%A');

  time = d3.time.format("%I %p");

  color = d3.scale.quantize().domain([-.05, .05]).range(d3.range(9).map(function(d) {
    return 'q' + d + '-9';
  }));

  sunday = new Date(2015, 4, 3);

  start = moment(sunday).startOf('day');

  end = moment(sunday).endOf('day');

  timescale = d3.time.scale().nice(d3.time.day).domain([start.toDate(), end.toDate()]).range([0, cellSize * 24]);

  hoursAxis = d3.svg.axis().scale(timescale).orient('top').ticks(d3.time.hour, 3).tickFormat(time);

  dayOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

  dayOfWeekScale = d3.scale.ordinal().domain([0, 1, 2, 3, 4, 5]).range(dayOfWeek);

  dayOfWeekTooltipHtml = d3.select("#day-of-week-popup").html();

  dayOfWeekTooltip = _.template(dayOfWeekTooltipHtml);

  d3.csv('data/day_of_week_hour.csv', function(data) {
    var hoursg, max, rect, svg;
    max = d3.max(data, function(d) {
      return d.count;
    });
    color.domain([0, max]);
    svg = d3.select('#day-of-week').selectAll('svg').data(d3.range(0, 7)).enter().append('svg').attr('width', width).attr('height', height).append('g').attr('transform', "translate(70,5)").attr('class', 'YlOrRd');
    svg.append('text').attr('class', 'day-of-week').attr('transform', 'translate(-70,10)').text(function(d) {
      return dayOfWeek[d];
    });
    rect = svg.selectAll('.hour').data(function(d) {
      return d3.time.hours(moment(sunday).add(d, 'days').startOf('day').toDate(), moment(sunday).add(d, 'days').endOf('day').toDate());
    }).enter().append('rect').attr('class', 'hour').attr('width', cellSize).attr('height', cellSize).attr('x', function(d) {
      return hour(d) * cellSize;
    }).attr('y', 0).attr('class', function(d) {
      var entry;
      entry = _.findWhere(data, {
        dow: weekday(d),
        hour: "" + (parseInt(hour(d)))
      });
      return color(parseInt(entry.count));
    }).on("mouseover", function(d) {
      var entry, templateData;
      entry = _.findWhere(data, {
        dow: weekday(d),
        hour: "" + (parseInt(hour(d)))
      });
      templateData = {
        dayOfWeek: weekdayText(d),
        hour: time(d),
        dataCount: entry.count
      };
      d3.select('#tooltip').html(dayOfWeekTooltip(templateData)).style("opacity", 1);
      return d3.select(this).classed("active", true);
    }).on("mouseout", function(d) {
      d3.select(this).classed("active", false);
      return d3.select('#tooltip').style("opacity", 0);
    }).on("mousemove", function(d) {
      return d3.select("#tooltip").style("left", (d3.event.pageX + 14) + "px").style("top", (d3.event.pageY - 32) + "px");
    });
    return hoursg = svg.append('g').classed('axis', true).classed('hours', true).classed('labeled', true).attr("transform", "translate(0,-10.5)").call(hoursAxis);
  });

}).call(this);
