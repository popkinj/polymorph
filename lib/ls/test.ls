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
], (err, results) ->
  cTopoJson = results[1] # Cascadia

  # Convert cascadia to geojson
  cGeoJson = topojson.feature cTopoJson,cTopoJson.objects.cascadia_bnd

  # Create path
  cascadia = path cGeoJson.features[0] # Create path

  measures = getMeasures cascadia # Grab node distances from cascadia
  newNodes = transpose measures, results[0] # Convert to coords on new shape
  newPath = "M#{newNodes.join 'L'}Z"
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
    .duration 5000
    .attr 'd', newPath

# This will get used eventually... But require dom elements
# getPointAtLength
# getTotalLength
