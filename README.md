# Polymorph
Convert one svg path into another. Produce a new shape with the same amount of nodes in the first input yet shaped as the second input. This allows for sane transitions between the two shapes.

```javascript
var newShape = polymorph.transpose(firstShape,secondShape);
```
This makes the assumption that *firstShape* is of the format *M43 43 L 54 32 L 43 65Z"*. The *secondShape* can be any [SVG Path](http://www.w3schools.com/svg/svg_path.asp) format.

It makes most sense to transpose a more complex shape onto a simpler one. This way you don't lose any detail. But it works either way.
