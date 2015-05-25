# Plum

Plum is a library that helps you in the creation of curves and object animation through these ones. See [demo here](http://reflejo.github.com/plum/).

## Basic syntax:

```javascript
var animation:Animation = Plum.animate(<display object>, <path>, <options>);
```

#### Parameters:

 * **display object**: The DisplayObject instance that you want to move through the bezier.
 * **path**: Any Parametric instance. This will be bezier itself (See "Paths" below)
 * **options**: Hash array with options. All options are optional and not present variables will take default values. These are the valid options:
 * **speed (uint)**: This is the speed that your displayobject will move. You MUST send your stage fps to make this precise (pixels per second) *(Default: 100)*
 * **fps (uint)**: Stage FPS, it is used to calculate speed. *(Default: 24)*
 * **start (uint)**: Start distance in px. (Could be negative) *(Default: 0)*
 * **paused (Boolean)**: Flag to start paused *(Default: false)*
 * **reversed (Boolean)**: Flag to start the animation backwards. *(Default: false)*
 * **orientToPath (Boolean)**: A common effect that designers/developers want is for a MovieClip/Sprite to orient itself in the direction of a Bezier path (alter its rotation). orientToBezier makes it easy.

## Paths (aka "Parametric"):

Paths are parametric ecuations. At this moment, the ones implemented are: CubicBezier & ComplexPath

### CubicBezier:	

```javascript
var bezier:CubicBezier = new CubicBezier(<point1>, <control1>, <control2>, <point2>, <parameterization>);
```

#### Parameters:

 * **point1, control1, control2, point2 (Point)**: Anchors and control points that defines bezier ecuations.
 * **parameterization (Boolean)**: Parameterization method *(Default: Parametric.UNIFORM)* Options are:
   * **Parametric.UNIFORM**: Spreads the global 't' values out uniformly based on the number of knots
   * **Parametric.ARC_LENGTH**: The global t-distribution is based on the fraction of arclength of each line segment between knots to the total arc length.

### ComplexPath:

Craft comples paths with more than one Parametric.

```javascript
var bezier:ComplexPath = new ComplexPath(<paths>);
```

#### Parameters:

 * **paths (Array)**: Array of any Parametric instance.

## Parametric methods:

 * **draw(graphics:Graphics, thickness:uint=1, color:uint=0xff0000, precision:Number=0.01, dotted:Boolean=false)**: Draw the path inside the given graphics.
 * **getPoint(t:Number):Point**: Get the point at given t (This will depend on parameterization).
 * **yAtX(x:Number):Array**: Get curve y located at given x (Could be more than one). Returns an Array of Objects {t: Number, y: Number}.
 * **arcLength**: Property that has the total curve length

## Animation Object

### Methods

 * **pause()**: Pause the animation at actual t.
 * **resume()**: Resume last t animation
 * **distance (Number)**: set/get the total distance of this object in the curve (It should be used to move objects)
 * **speed (uint)**: Set the speed of the display object, defined as px/s.
 * **reversed (Boolean)**: If true, Sets animation orientation to backawards (Could be changed at any time)

# Demo

See [demo here](http://reflejo.github.com/plum/).
 
## Author
 
Martín Conte Mac Donell <Reflejo@gmail.com> - [@fz](https://twitter.com/fz)
