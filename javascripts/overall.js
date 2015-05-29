(function() {
  d3.csv('data/year_count.csv', function(data) {
    var width, yearCount;
    width = d3.select('.overall-per-year').node().getBoundingClientRect()['width'];
    data = _.reject(data, function(d) {
      return d.year === '2013';
    });
    yearCount = new Barchart(data, {
      width: width - 30
    });
    yearCount.setValueKey('count');
    yearCount.setGroupKey('year');
    yearCount.setXDomain([2007, 2008, 2009, 2010, 2011, 2012]);
    yearCount.setYDomain([
      0, d3.max(data, function(d) {
        return parseInt(d.count);
      })
    ]);
    return yearCount.render('.overall-per-year');
  });

}).call(this);
