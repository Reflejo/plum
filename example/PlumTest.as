package
{
    import com.atommica.plum.Plum;
    import com.atommica.plum.geom.ComplexPath;
    import com.atommica.plum.geom.CubicBezier;
    import com.atommica.plum.geom.Parametric;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    [SWF(width="760", height="700", frameRate="50", backgroundColor="#cccccc")]
    public class PlumTest extends Sprite
    {
        public function PlumTest()
        {
            var bez:CubicBezier = new CubicBezier(
                new Point(74, 113), new Point(179, 61), 
                new Point(389, 23), new Point(389, 93), 
                Parametric.ARC_LENGTH);
            
            var bez2:CubicBezier = new CubicBezier(
                new Point(389, 93), new Point(389, 163), 
                new Point(191, 245), new Point(191, 315), 
                Parametric.ARC_LENGTH);
            
            var bez3:CubicBezier = new CubicBezier(
                new Point(191, 315), new Point(190, 394), 
                new Point(622, 454), new Point(723, 481), 
                Parametric.ARC_LENGTH);
            
            var curveDebug:Sprite = new Sprite();
            this.addChild(curveDebug);
            
            this.bezier = new ComplexPath([bez, bez2, bez3]);
            bezier.draw(curveDebug.graphics);
            
            this.balls = [];
            for (var i:uint = 0; i < MAX_BALLS; i++)
            {
                // Create new ball object and keep animation/sprite instances
                var ball:Object = new Object();
                ball.sprite = new Sprite()
                
                // Fill with random color and set border
                ball.sprite.graphics.beginFill(Math.random() * 0xFFFFFF);
                ball.sprite.graphics.lineStyle(1, 0x000000)
                ball.sprite.graphics.drawCircle(0, 0, 10);
                
                // Draw a line in the middle to see how rotation works
                ball.sprite.graphics.moveTo(0, -10);
                ball.sprite.graphics.lineTo(0, 10);
                
                // Add Ball to screen
                this.addChild(ball.sprite);
                
                ball.animation = Plum.animate(ball.sprite, bezier, {
                    'speed': 50, 
                    'start': -ball.sprite.width * i,
                    'orientToPath': true, 
                    'fps': this.stage.frameRate
                });
                
                // Save ball into our balls array to pause/resume eventually.
                this.balls.push(ball);                
            }
            
            this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyPress);
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);
            
            // This sprite will be used to show how xAtY works.
            this.pointer = new Sprite();
            this.addChild(this.pointer);
        }
        
        /**
         * Capture the mouse movement to show how xAtY works
         */
        private function mouseMove(e:MouseEvent):void
        {
            this.pointer.graphics.clear();
            this.pointer.graphics.beginFill(0x0);
            
            for each (var point:Object in this.bezier.yAtX(e.stageX))
            {
                this.pointer.graphics.drawCircle(e.stageX, point.y , 5);
            }
        }
        
        private function keyPress(e:KeyboardEvent):void
        {
            for each (var ball:Object in this.balls)
            {
                switch (e.keyCode)
                {
                    case KEY_S: 
                        ball.animation.pause();
                        break;
                    
                    case KEY_R: 
                        ball.animation.resume();
                        break;
                    
                    case KEY_Q: 
                        ball.animation.reversed = !ball.animation.reversed;
                        break;
                    
                    case KEY_P: 
                        ball.animation.speed = 200;
                        break;
                }
            }
            
        }
        
        private const KEY_S:uint = 83;
        private const KEY_R:uint = 82;
        private const KEY_Q:uint = 81;
        private const KEY_P:uint = 80;

        private const MAX_BALLS:uint = 20;

        private var bezier:ComplexPath;
        private var balls:Array;
        private var pointer:Sprite = null;
    }
}
