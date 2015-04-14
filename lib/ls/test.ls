#!/usr/bin/env lsc

pageWidth = window.innerWidth
pageHeight = window.innerHeight

# This is what d3 uses to create a pixel based path from 
# a lat and long polygon.
proj = new d3.geo.mercator!
  .center [-125,51] #  // Center of BC
  .translate [(pageWidth/2),pageHeight/2] # Centre in window.
  .scale 1 .<<. 9  # Can see the whole province

path = d3.geo.path().projection(proj) # Path generating function



getCircle = (c) -> d3.text "perfect_circle.svg", (e,d) -> c null d
getCascadia = (c) -> d3.json "cascadia_bnd.json", (e,d) -> c null d
getCountries = (c) -> d3.json "countries.json", (e,d) -> c null d

getLength = ->
  line = d3.select 'svg'
    .append 'path'
    .attr 'd',it
  l = line.node!.getTotalLength!
  line.remove!
  l

getMeasures = (cascadia) ->
  # Create an array of points stripping off the M and Z
  pts = cascadia.slice(1,-1).split /L/i

  total = getLength cascadia # Get total for calculating percent

  lengths = [1e-6] # First node is always at zero... or pretty much there
  for pt in [2 to pts.length]
    tempPath = 'M'+pts.slice(0,pt).join('L') # Create the path string
    # console.log "#pt : #tempPath"
    l = getLength tempPath # Get length
    lengths.push l/total # Stuff in array
  lengths

transpose = (dists,shape) ->
  total = getLength shape
  line = d3.select 'svg'
    .append 'path'
    .attr 'd',shape
    .style 'display','none'
  coords = []
  for l in dists then coords.push line.node!getPointAtLength(l*total)
  coords.map -> "#{it.x},#{it.y}"


async.parallel [
  -> getCircle it
  -> getCascadia it
  -> getCountries it
], (err, results) ->
  cTopoJson = results[1] # Cascadia
  cstTopoJson = results[2] # Countries

  # Convert to geojson
  cGeoJson = topojson.feature cTopoJson,cTopoJson.objects.cascadia_bnd
  cstGeoJson = topojson.feature cstTopoJson,cstTopoJson.objects.countries

  # Create path
  cascadia = path cGeoJson.features[0] # Create path

  measures = getMeasures cascadia # Grab node distances from cascadia
  newNodes = transpose measures, results[0] # Convert to coords on new shape
  newPath = "M#{newNodes.join 'L'}Z"

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
    .style 'stroke','black'
    .transition!
    .duration 5000
    .attr 'd', cascadia
    .transition!
    .delay 10000
    .duration 5000
    .attr 'd', newPath

