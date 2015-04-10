#!/usr/bin/env lsc
#

# The cascadia boundary is in topojson
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



# This will get used eventually... But require dom elements
# getPointAtLength
# getTotalLength
