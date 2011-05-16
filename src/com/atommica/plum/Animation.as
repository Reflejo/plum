/*
* Copyright (c) 2011 Atommica: http://atommica.com
* Created by Martín Conte Mac Donell (@Reflejo) <reflejo@gmail.com>
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

package com.atommica.plum
{
    import com.atommica.plum.geom.Parametric;
    
    import flash.display.DisplayObject;
    import flash.events.EventDispatcher;
    import flash.geom.Point;

    public class Animation extends EventDispatcher
    {
        public function Animation(object:DisplayObject, path:Parametric, options:Object)
        {
            this.object = object;
            this.reversed = options.reversed;
            this.path = path;
            this.paused = options.paused;
            this.orientToBezier = options.orientToBezier;
            this.t = options.start / this.path.arcLength;
            this.speed = (options.speed / this.path.arcLength) / options.fps;
        }
        
        /**
         * Pause animation
         */
        public function pause():void
        {
            this.paused = true;
        }

        /**
         * Resume a paused animation
         */
        public function resume():void
        {
            this.paused = false;
        }
        
        /**
        * Calc distance in px from t
        */
        public function get distance():Number
        {
            return this.t * this.path.arcLength;
        }

        /**
         * Set distance (Actaully we are changing t step, based on some d in px)
         */
        public function set distance(d:Number):void
        {
            this.t = d / this.path.arcLength;
        }

        /**
         * Get next T from path, taking care the reverse flag and speed
         */
        final internal function nextT():Number
        {
            if (this.paused) return this.t;

            this.t += (this.reversed) ? -this.speed: this.speed;
            this.t = (this.t > 1) ? 1: this.t;

            return this.t;
        }
        
        /**
         * This method is called on every tic. Just move the object 
         */
        final internal function step(t:Number):void
        {
            if (this.paused) return;
            
            var point:Point = this.path.getPoint(t);
            if (this.orientToBezier)
            {
                var dx:Number = point.x - this.object.x;
                var dy:Number = point.y - this.object.y;
                var angle:Number = Math.atan2(dy, dx) * RAD2DEG;

                this.object.rotation = angle;
            }

            this.object.x = point.x;
            this.object.y = point.y;
        }

        /**
         * General cleanup. 
         */
        final internal function destroy() : void
        {
            path = null;
        }
       
        protected static const RAD2DEG:Number = 180 / Math.PI; //precalculate for speed

        internal var object:DisplayObject;
        
        private var orientToBezier:Boolean;
        private var path:Parametric;
        private var paused:Boolean;
        private var t:Number;
        
        public var speed:Number;
        public var reversed:Boolean;
    }
}
