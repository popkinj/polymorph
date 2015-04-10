#!/usr/bin/env lsc

pageWidth = window.innerWidth
pageHeight = window.innerHeight

# This is what d3 uses to create a pixel based path from 
# a lat and long polygon.
proj = new d3.geo.mercator!
  .center [-125,56] #  // Center of BC
  .translate [(pageWidth/2),pageHeight/2] # Centre in window.
  .scale 1 .<<. 9  # Can see the whole province

path = d3.geo.path().projection(proj) # Path generating function



getCircle = (c) -> d3.text "perfect_circle.svg", (e,d) -> c null d
getCascadia = (c) -> d3.json "cascadia_bnd.json", (e,d) -> c null d

getLength = (pt,pts) ->
  return 0 if pt is 1
  tempPath = 'M'+pts.slice(0,pt).join('L')
  line = d3.select 'svg'
    .append 'path'
    .attr 'id', 'cascadia'
    .attr 'd',tempPath

  l = line.node!.getTotalLength!
  line.remove!
  l



calc = (circle,cTopoJson) ->

  # Convert cascadia to geojson
  cGeoJson = topojson.feature cTopoJson,cTopoJson.objects.cascadia_bnd

  # Create path
  cascadia = path cGeoJson.features[0] # Create path

  # Create an array of points stripping off the M and Z
  pts = cascadia.slice(1,-1).split /L/i

  completeLine = d3.select 'svg'
    .append 'path'
    .attr 'id', 'cascadia'
    .attr 'd',cascadia
  total = completeLine.node!getTotalLength!
  completeLine.remove!

  lengths = []
  for pt in [1 to pts.length - 1]
    l = getLength pt, pts
    lengths.push l/total * 100

  console.log lengths


  # console.log polygon.getTotalLength!




async.parallel [
  -> getCircle it
  -> getCascadia it
], (err, results) ->
  calc results[0], results[1]

# This will get used eventually... But require dom elements
# getPointAtLength
# getTotalLength
