polymorph =
  version: '0.1'
polymorph.transpose = (from,to) ->
  # Insert temporary svg element to do our calculations
  svg = document.createElementNS 'http://www.w3.org/2000/svg','svg'
  # svg = document.createElement 'svg'
  svg.id = 'polymorph-temp-canvas'
  document.body.appendChild svg

  /*
   Get the total length of any svg string.
   @ param {string} A string representation of an SVG path.
  */
  getLength = ->
    line = document.createElementNS 'http://www.w3.org/2000/svg','path'
    line.setAttribute 'd',it
    svg.appendChild line
    l = line.getTotalLength!
    line.remove!
    l

  getMeasures = (path) ->
    # Create an array of points stripping off the M and Z
    pts = path.slice(1,-1).split /L/i

    total = getLength path # Get total for calculating percent

    lengths = [1e-6] # First node is always at zero... or pretty much there
    for pt in [2 to pts.length]
      tempPath = 'M'+pts.slice(0,pt).join('L') # Create the path string
      l = getLength tempPath # Get length
      lengths.push l/total # Stuff in array
    lengths

  measures = getMeasures to # Grab node distances from destination path
  "M#{measures.join 'L'}Z"
