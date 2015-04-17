# test.ls
# Testing out polymorph
# Pulling in three datasets then converting to paths with 
# d3. Then pluggin into polymorph to calculate the transpose.
# Finally animating back and fourth with d3.

pageWidth = window.innerWidth
pageHeight = window.innerHeight

# This is what d3 uses to create a pixel based path from 
# a lat and long polygon.
proj = new d3.geo.mercator!
  .center [-125,51] #  // Center of BC
  .translate [(pageWidth/2),pageHeight/2] # Centre in window.
  .scale 1 .<<. 9  # Can see the whole province

path = d3.geo.path().projection(proj) # Path generating function

# Fetch our test data
getCircle = (c) -> d3.text "perfect_circle.svg", (e,d) -> c null d
getCascadia = (c) -> d3.json "cascadia_bnd.json", (e,d) -> c null d
getCountries = (c) -> d3.json "countries.json", (e,d) -> c null d

async.parallel [
  -> getCircle it
  -> getCascadia it
  -> getCountries it
], (err, results) ->
  circle = results[0] # Simple circle
  cTopoJson = results[1] # Cascadia
  cstTopoJson = results[2] # Countries

  # Convert to geojson
  cGeoJson = topojson.feature cTopoJson,cTopoJson.objects.cascadia_bnd
  cstGeoJson = topojson.feature cstTopoJson,cstTopoJson.objects.countries

  # Create path
  cascadia = path cGeoJson.features[0] # Create path

  /*
    Here's the new path
    We're basically taking a more complex shape
    and transposing all the nodes onto a simple one (the circle)
    This seeds the circle with the same # of nodes as the complex 
    shape. Thus allowing for a seamless transition between shapes.
  */
  newPath = polymorph.transpose cascadia, circle

  d3.select 'svg'
    .selectAll 'path.country'
    .data cstGeoJson.features.filter ->
      # Just North America please
      it.properties.name.match /(Canada|Mexico|United States)/
    .enter!
    .append 'path'
    .attr 'class','country'
    .attr 'd', path
    .style 'fill','none'
    .style 'opacity',1e-6
    .style 'fill','#E4E4E4'
    .style 'stroke-linejoin','round'
    .transition!
    .delay 5000
    .duration 500
    .style 'opacity',1
    .transition!
    .delay 10000
    .duration 500
    .style 'opacity',1e-6

  d3.select 'svg'
    .append 'path'
    .attr 'id', 'cascadia'
    .attr 'd',newPath
    .style 'fill','none'
    .style 'stroke-width','2px'
    .style 'stroke','#545454'
    .transition!
    .duration 5000
    .attr 'd', cascadia
    .transition!
    .delay 10000
    .duration 5000
    .attr 'd', newPath
