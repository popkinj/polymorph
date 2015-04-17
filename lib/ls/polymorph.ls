/*
 # polymorph
 Convert one svg path into another. Produce a new shape with the same
 amount of nodes as the first input yet shaped like the second input.
 This allows for sane transitions between the two shapes.
*/
polymorph =
  version: '1.1'

/*
 ## transpose
 Duplicate node positioning from one shape onto another
 @param from {string} SVG shape containing the nodes to be copied
 @param to {string} Resulting SVG shape which will contain a 
 representation of the nodes from the first shape.
*/
polymorph.transpose = (from,to) ->
  # Insert temporary svg element to do our calculations
  svg = document.createElementNS 'http://www.w3.org/2000/svg','svg'
  svg.id = 'polymorph-temp-canvas'
  document.body.appendChild svg

  /*
   ### getLength
   Get the total length of any svg string.
   @param {string} A string representation of an SVG path.
   @return {number} A numerical distance
  */
  getLength = ->
    line = document.createElementNS 'http://www.w3.org/2000/svg','path'
    line.setAttribute 'd',it
    svg.appendChild line
    l = line.getTotalLength!
    line.remove!
    l

  /*
   ### getMeasures
   Rebuild the string node by node.
   Populating a length array as you go.
   @param path {string} SVG path
   @return {array} Array of lengths along a line
  */
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

  /*
   ### transpose
   Create an array of nodes positioned on the new shape.
   Their number and position are representative of the *dists* array
   @param dists {array} Array of distances along a line
   @param shape {string} Destination SVG path string
   @return {array} Array of distances along a line
  */
  transpose = (dists,shape) ->
    # Add a temporary destination path
    line = document.createElementNS 'http://www.w3.org/2000/svg','path'
    line.setAttribute 'd',shape
    svg.appendChild line

    total = getLength shape # Need to total length
    coords = [] # This will holde our points
    # Cycle through our ditsance array and grab point on our new path.
    for l in dists then coords.push line.getPointAtLength(l*total)
    coords.map -> "#{it.x},#{it.y}" # Only x and y please

  measures = getMeasures from # Grab node distances from destination path
  newShape = transpose measures, to # Calculate new shape

  svg.parentNode.removeChild svg # Remove temporary svg element

  "M#{newShape.join 'L'}Z"
