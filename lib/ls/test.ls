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
console.log cGeoJson.features
