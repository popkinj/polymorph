#!/usr/bin/env lsc
#
require! <[ jsdom fs ]>
circle = fs.readFileSync "#__dirname/../paths/perfect_circle.svg", encoding: 'utf8'
console.log circle
