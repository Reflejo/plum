/*
 * Copyright (c) 2011 Atommica: http://atommica.com
 * Created by Martín Conte Mac Donell (@Reflejo) <reflejo@gmail.com>
 *
 * Lot of maths ideas taken from Singularity (www.algorithmist.net)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
*/

package com.atommica.plum.geom
{
    import com.atommica.plum.math.SimpleRoot;
    
    import flash.geom.Point;

    public class CubicBezier extends Parametric
    {
        public function CubicBezier(anchor1:Point, control1:Point, control2:Point, 
                                    anchor2:Point, 
                                    parameterization:String=Parametric.UNIFORM)
        {
            this.parameterization = parameterization;

            this.root = new SimpleRoot();
            this.points = new <Point>[anchor1, control1, control2, anchor2];

            this.coef = new Cubic();
            this.invalidate = true;
        }
           
        /**
        * Remove control points and reset coeficient
        */
        public function reset():void
        {
            this.points = new Vector.<Point>();
            this.invalidate = true;
            
            this.coef.reset();
        }
        
        /**
        * Return point for a given t
        *
        * t:Number - parameter value in [0,1]
        */
        public override function getPoint(t:Number):Point
        {
            t = (t < 0) ? 0 : t;
            t = (t > 1) ? 1 : t;
        
            if (this.invalidate)
                this.computeCoef();
            
            var pt:Number = this.getParam(t);
            return new Point(this.coef.getX(pt), this.coef.getY(pt));
        }

    /**
    * Return the set of y-coordinates corresponding to the input x-coordinate
    *
    * @return Array set of (t,y)-coordinates at the input x-coordinate provided 
    * that the x-coordinate is inside the range covered by the quadratic Bezier 
    * in [0,1]; that is there must exist t in [0,1] such that Bx(t) = _x.  If 
    * the input x-coordinate is not inside the range covered by the Bezier curve, 
    * the returned array is empty.  Otherwise, the array contains either one 
    * or two y-coordinates.  There are issues with curves that are exactly or 
    * nearly (for numerical purposes) vertical in which there could 
    * theoretically be an infinite number of y-coordinates for a 
    * single x-coordinate. This method does not work in such cases, although 
    * compensation might be added in the future.
    *
    * Each array element is a reference to an <code>Object</code> whose 't' 
    * parameter represents the Bezier t parameter.  The <code>Object</code> 'y' 
    * property is the corresponding y-value.  The returned (t,y) coordinates may 
    * be used by the caller to determine which of two returned y-coordinates 
    * might be preferred over the other.
    */
  /*  public function yAtX(x:Number):Array
    {
        // the necessary y-coordinates are the intersection of the curve with 
        // the line x = _x.  The curve is generated in the form c0 + c1*t + 
        // c2*t^2 + c3*t^3, so the intersection satisfies the equation 
        // Bx(t) = _x or Bx(t) - _x = 0, or c0x-_x + c1x*t + c2x*t^2 + c3x*t^3 = 0.
        if (this.invalidate)
            this.computeCoef();
        
        // this is written out in individual steps for clarity
        var c0:Object  = this.coef.getCoef(0);
        var c1:Object  = this.coef.getCoef(1);
        var c2:Object  = this.coef.getCoef(2);
        var c3:Object  = this.coef.getCoef(3);
        var c0X:Number = c0.X;
        var c1X:Number = c1.X;
        var c2X:Number = c2.X;
        var c3X:Number = c3.X;
       
        // Find one root - any root - then factor out (t-r) to get a quadratic poly. for the remaining roots
        var f:Function = function(t:Number):Number { return t * (c1X + t * (c2X + t * c3X)) + c0X - _x; }
         
      // some curves that loop around on themselves may require bisection
      var _left:Number;
      var _right:Number;

      var bisect:Function = function bisect(fc:Function, left:Number, 
                                            right:Number, limit:Number):void
      {
          if (Math.abs(right - left) <= limit) return;
          
          var middle:Number = 0.5 * (left + right);
          if (fc(left) * fc(right) <= 0 )
          {
              _left  = _left;
              _right = _right;
          }
          else
          {
              this.bisect(fc, left, middle, limit);
              this.bisect(fc, middle, right, limit);
          }
      }

      bisect(f, 0, 1, 0.05);
        
      // experiment with tolerance - but not too tight :)  
      var t0:Number = this.root.findRoot(_left, _right, f, 50, 0.0000001);
      var eval:Number = Math.abs(f(t0));
      if( eval > 0.0000001 )
        return [];   // compensate in case method quits due to error (no event listener here)
      
      var result:Array = new Array();
      if( t0 <= 1 )
        result.push({t:t0, y:getPoint(t0).y});  
      
      // Factor theorem: t-r is a factor of the cubic polynomial if r is a root.  Use this to reduce to a quadratic poly.
      // using synthetic division
      var a:Number = c3.X;
      var b:Number = t0*a+c2.X;
      var c:Number = t0*b+c1.X;
      
      // process the quadratic for the remaining two possible roots
      var d:Number = b*b - 4*a*c;
      if( d < 0 )
      {
        return result;
      }
      
      d             = Math.sqrt(d);
      a             = 1/(a + a);
      var t1:Number = (d-b)*a;
      var t2:Number = (-b-d)*a;
      
      if( t1 >= 0 && t1 <=1 )
        result.push({t:t1, y:getPoint(t1).y});
        
      if( t2 >= 0 && t2 <=1 )
        result.push({t:t2, y:getPoint(t2).y});
        
      return result;
    }*/
    
        public override function computeCoef():void
        {
            this.coef.reset();
        
            this.coef.addCoef(this.points[0].x, this.points[0].y);
        
            var dX:Number = 3.0 * (this.points[1].x - this.points[0].x);
            var dY:Number = 3.0 * (this.points[1].y - this.points[0].y);
            this.coef.addCoef(dX, dY);
            
            var bX:Number = 3.0 * (this.points[2].x - this.points[1].x) - dX;
            var bY:Number = 3.0 * (this.points[2].y - this.points[1].y) - dY;
            this.coef.addCoef(bX, bY);
            
            this.coef.addCoef(this.points[3].x - this.points[0].x - dX - bX, 
                this.points[3].y - this.points[0].y - dY - bY);
            
            this._arcLength = -1;
            this.parameterize();
            this.invalidate = false;
        }
        
        private var root:SimpleRoot;
    }
}
