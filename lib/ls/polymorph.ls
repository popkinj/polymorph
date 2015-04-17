polymorph =
  version: '1.1'
polymorph.transpose = (from,to) ->
  # Insert temporary svg element to do our calculations
  svg = document.createElementNS 'http://www.w3.org/2000/svg','svg'
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

  transpose = (dists,shape) ->
    total = getLength shape
    line = document.createElementNS 'html://www.w3.org/2000/svg','path'
    line.id = 'test'
    line.setAttributeNS 'html://www.w3.org/2000/svg', 'd', shape
    line.setAttributeNS 'html://www.w3.org/2000/svg', 'style', 'display: none'
    svg.appendChild line
    debugger
    # console.log line
    # test = document.getElementById 'test'
    # console.log test
    # console.log test.getPointAtLength 14
    #
    #### This works but it's d3
    # line = d3.select 'svg'
    #   .append 'path'
    #   .attr 'd',shape
    #   .style 'display','none'
    # coords = []
    # for l in dists then coords.push line.node!getPointAtLength(l*total)
    coords.map -> "#{it.x},#{it.y}"

  measures = getMeasures from # Grab node distances from destination path
  newShape = transpose measures, to

  # Remove temporary svg element
  svg.parentNode.removeChild svg

  "M#{newShape.join 'L'}Z"
