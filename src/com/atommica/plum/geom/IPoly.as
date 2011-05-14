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
  public interface IPoly
  {
  	// access the degree of this polynomial
  	function get degree():uint;
  	
  	// access and add coefficients
    function addCoef( _cX:Number, _cY:Number):void;
    function getCoef( _indx:uint ):Object;
    
  	// clear coefficient values
    function reset():void

    // evaluate polynomial x-coordinate at a given t
    function getX(_t:Number):Number
    
    // evaluate polynomial y-coordinate at a given t
    function getY(_t:Number):Number

    // evaluate x-coordinate of derivative at a given t
    function getXPrime(_t:Number):Number
    
    // evaluate y-coordinate of derivative at a given t
    function getYPrime(_t:Number):Number

    // evaluate dy/dx at a given t
    function getDeriv(_t:Number):Number

    function toString():String
  }
}