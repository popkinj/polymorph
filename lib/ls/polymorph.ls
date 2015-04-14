polymorph =
  version: '0.1'
polymorph.transpose = (from,to) ->
  console.log "from: #from"
  "blah"
  svg = document.createElement 'svg'
  svg.id = 'polymorph-temp-canvas'
  document.body.appendChild(svg);

  getLength = ->
    line = svg.appendChild 'path'
      .setAttribute 'd',it
    l = line.getTotalLength!
    line.remove!
    l
