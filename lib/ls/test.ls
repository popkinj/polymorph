#!/usr/bin/env lsc
#


pageWidth = 250
pageHeight = 250
# This is what d3 uses to create a pixel based path from 
# a lat and long polygon.
proj = new d3.geo.mercator!
  .center [-125,56] #  // Center of BC
  .translate [(pageWidth/2),pageHeight/2] # Centre in window.
  .scale 1 .<<. 8  # Can see the whole province

path = d3.geo.path().projection(proj) # Path generating function



getCircle = (c) -> d3.text "perfect_circle.svg", (e,d) -> c null d
getCascadia = (c) -> d3.json "cascadia_bnd.json", (e,d) -> c null d

lengths = []
calc = (circle,cTopoJson) ->

  # Convert cascadia to geojson
  cGeoJson = topojson.feature cTopoJson,cTopoJson.objects.cascadia_bnd
  # Create path
  cascadia = path cGeoJson.features[0] # Create path
  console.log cascadia
# Create an array of points stripping off the M and Z
# pts = cascadia.slice(1,-1).split /L/i


async.parallel [
  -> getCircle it
  -> getCascadia it
], (err, results) ->
  circle = results[0]
  cascadia = results[1]
  calc circle, cascadia

# This will get used eventually... But require dom elements
# getPointAtLength
# getTotalLength
