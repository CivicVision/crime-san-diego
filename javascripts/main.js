(function() {
  if (!d3.select('.modal').empty()) {
    d3.select('.modal-close').on('click', function(d) {
      return d3.select("body").classed("modal-open", false);
    });
  }

}).call(this);
