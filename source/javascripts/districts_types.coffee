unless d3.select('.types-per-district').empty()
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
  d3.csv 'data/most_crimes_per_district.csv', (data) ->
    table = d3.select('.types-per-district').append('table')
    header = table.append('thead').append('tr')
    header.selectAll('th').data(['District','crime type', 'no. of crimes']).enter().append('th').text((d) -> d)
    body = table.append('tbody')
    entries = body.selectAll('tr').data(data).enter().append('tr')
    entries.append('td').text( (d) -> districtMapping[d.council])
    entries.append('td').text( (d) -> d.type)
    entries.append('td').text( (d) -> d.count)


