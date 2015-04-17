var polymorph;
polymorph = {
  version: '1.1'
};
polymorph.transpose = function(from, to){
  var svg, getLength, getMeasures, transpose, measures, newShape;
  svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  svg.id = 'polymorph-temp-canvas';
  document.body.appendChild(svg);
  /*
   Get the total length of any svg string.
   @ param {string} A string representation of an SVG path.
  */
  getLength = function(it){
    var line, l;
    line = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    line.setAttribute('d', it);
    svg.appendChild(line);
    l = line.getTotalLength();
    line.remove();
    return l;
  };
  getMeasures = function(path){
    var pts, total, lengths, i$, ref$, len$, pt, tempPath, l;
    pts = path.slice(1, -1).split(/L/i);
    total = getLength(path);
    lengths = [1e-6];
    for (i$ = 0, len$ = (ref$ = (fn$())).length; i$ < len$; ++i$) {
      pt = ref$[i$];
      tempPath = 'M' + pts.slice(0, pt).join('L');
      l = getLength(tempPath);
      lengths.push(l / total);
    }
    return lengths;
    function fn$(){
      var i$, to$, results$ = [];
      for (i$ = 2, to$ = pts.length; i$ <= to$; ++i$) {
        results$.push(i$);
      }
      return results$;
    }
  };
  transpose = function(dists, shape){
    var total, line, coords, i$, len$, l;
    total = getLength(shape);
    line = d3.select('svg').append('path').attr('d', shape).style('display', 'none');
    coords = [];
    for (i$ = 0, len$ = dists.length; i$ < len$; ++i$) {
      l = dists[i$];
      coords.push(line.node().getPointAtLength(l * total));
    }
    return coords.map(function(it){
      return it.x + "," + it.y;
    });
  };
  measures = getMeasures(from);
  newShape = transpose(measures, to);
  svg.parentNode.removeChild(svg);
  return "M" + newShape.join('L') + "Z";
};