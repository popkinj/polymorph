#!/usr/bin/env lsc
#
require! <[ jsdom fs d3 topojson ]> # Modules


# Paths to resources
d3Min = "#__dirname/../../node_modules/d3/d3.min.js"
pathDir = "#__dirname/../paths"

# The simple circle in a file
circle = fs.readFileSync "#pathDir/perfect_circle.svg", encoding: 'utf8'
circleSvg = "<!DOCTYPE html><html><svg id='shape'>#circle</svg></html>"


# The cascadia boundary is in topojson
cTxt = fs.readFileSync "#pathDir/cascadia_bnd.json", encoding: 'utf8'
cJson = JSON.parse cTxt

# Conver to geojson
cGeoJson = topojson.feature cJson,cJson.objects.cascadia_bnd

pageWidth = 250
pageHeight = 250
# This is what d3 uses to create a pixel based path from 
# a lat and long polygon.
proj = new d3.geo.mercator!
  .center [-125,56] #  // Center of BC
  .translate [(pageWidth/2),pageHeight/2] # Centre in window.
  .scale 1 .<<. 8  # Can see the whole province

path = d3.geo.path().projection(proj) # Path generating function
cascadia = path cGeoJson.features[0] # Create path

# Create an array of points stripping off the M and Z
pts = cascadia.slice(1,-1).split /L/i
lengths = []
fillLengths = (e,w) ->
  console.log e if e
  # console.log w.d3.select('path').node!.getTotalLength!
  w.close!

dom = jsdom.env circleSvg, [d3Min], fillLengths
dom.implementation.addfeature(
  'http://www.w3.org/tr/svg11/feature#basicstructure', '1.1'
)
# jsdom.env(circlesvg, [d3min], filllengths)
#   .implementation.addfeature(
#       'http://www.w3.org/tr/svg11/feature#basicstructure', '1.1'
#   )


# This will get used eventually... But require dom elements
# getPointAtLength
# getTotalLength
