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
  public class Cubic implements IPoly
  {
    // properties
    private var __c0X:Number;
    private var __c1X:Number;
    private var __c2X:Number;
    private var __c3X:Number;
    private var __c0Y:Number;
    private var __c1Y:Number;
    private var __c2Y:Number;
    private var __c3Y:Number;
    private var __count:uint;

    public function Cubic()
    {
      reset();
    }
    
    public function get degree():uint { return 3; }

    public function reset():void
    {
      __c0X = 0;
      __c1X = 0;
      __c2X = 0;
      __c3X = 0;
      __c0Y = 0;
      __c1Y = 0;
      __c2Y = 0;
      __c3Y = 0;
      
      __count = 0;
    }
    
    public function addCoef( _cX:Number, _cY:Number ):void
    {
      if( __count < 4 && !isNaN(_cX) && !isNaN(_cY) )
      {
      	switch(__count)
      	{
      	  case 0:
      	    __c0X = _cX;
      	    __c0Y = _cY;
      	  break;
      	  
      	  case 1:
      	    __c1X = _cX;
      	    __c1Y = _cY;
      	  break;
      	  
      	  case 2:
      	    __c2X = _cX;
      	    __c2Y = _cY;
      	  break;
      	  
      	  case 3:
      	    __c3X = _cX;
      	    __c3Y = _cY;
      	  break;
      	}
      	__count++;
      }
    }
    
    public function getCoef( _indx:uint ):Object 
    { 
      if( _indx > -1 && _indx < 4 )
      {
      	var coef:Object = new Object();
      	switch(_indx)
      	{
      	  case 0:
      	    coef.X = __c0X;
      	    coef.Y = __c0Y;
      	  break;
      	  
      	  case 1:
      	    coef.X = __c1X;
      	    coef.Y = __c1Y;
      	  break;
      	  
      	  case 2:
      	    coef.X = __c2X;
      	    coef.Y = __c2Y;
      	  break;
      	  
      	  case 3:
      	    coef.X = __c3X;
      	    coef.Y = __c3Y;
      	  break;
      	}
      }
      return coef;
    }


    public function getX(_t:Number):Number
    {
      return (__c0X + _t*(__c1X + _t*(__c2X + _t*(__c3X))));
    }

    public function getY(_t:Number):Number
    {
      return (__c0Y + _t*(__c1Y + _t*(__c2Y + _t*(__c3Y))));
    }
    
    public function getXPrime(_t:Number):Number
    {
      return (__c1X + _t*(2.0*__c2X + _t*(3.0*__c3X)));
    }
    
    public function getYPrime(_t:Number):Number
    {
      return (__c1Y + _t*(2.0*__c2Y + _t*(3.0*__c3Y)));
    }
    
    public function getDeriv(_t:Number):Number
    {
      // use chain rule
      var dy:Number = getYPrime(_t);
      var dx:Number = getXPrime(_t);
      return dy/dx;
    }

    public function toString():String
    {
      var myStr:String = "coef[0] " + __c0X + "," + __c0Y;
      myStr           += " coef[1] " + __c1X + "," + __c1Y;
      myStr           += " coef[2] " + __c2X + "," + __c2Y;
      myStr           += " coef[3] " + __c3X + "," + __c3Y;
    
      return myStr;
    }
  }
}