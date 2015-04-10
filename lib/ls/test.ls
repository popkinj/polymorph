#!/usr/bin/env lsc
#
require! <[ jsdom fs d3 topojson ]>

pathDir = "#__dirname/../paths"

# The simple circle
circle = fs.readFileSync "#pathDir/perfect_circle.svg", encoding: 'utf8'

# The cascadia boundary is in topojson
cTxt = fs.readFileSync "#pathDir/cascadia_bnd.json", encoding: 'utf8'
cJson = JSON.parse cTxt

# Converto to geojson
cGeoJson = topojson.feature cJson,cJson.objects.cascadia_bnd

pageWidth = 250
pageHeight = 250
proj = new d3.geo.mercator!
  .center [-125,56] #  // Center of BC
  .translate [(pageWidth/2),pageHeight/2] # Centre in window.
  .scale 1 .<<. 8  # Can see the whole province

path = d3.geo.path().projection(proj)
cascadia = path cGeoJson.features[0]
jsdom.env(
  html: "<svg id='shape'>#circle</svg>"
  src: [d3]
  done: (error,window) ->
    # console.log d3
    console.log error if error
    console.log d3.select('#shape')
)

# Create an array of points stripping off the M and Z
cascadia.slice(1,-1).split /L/i

# This will get used eventually... But require dom elements
# getPointAtLength
# getTotalLength
