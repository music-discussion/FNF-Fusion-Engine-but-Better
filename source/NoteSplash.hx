package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

// TAKEN FROM EXTRA KEYS. THANNKS ZORO

using StringTools;

class NoteSplash extends FlxSprite
{

	public static var colors:Array<String> = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'darkblue'];

	var colorsThatDontChange:Array<String> = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'darkblue', 'orange', 'darkred'];

	public function new(nX:Float, nY:Float, color:Int)
	{
		x = nX;
		y = nY;
		super(x, y);
		if (PlayState.SONG.uiType.contains('pixel')) //if it includes pixel in the uiType Name, then switch splashes to pixel. Simple Enough. Maybe Custom Splash Skin soon?
			frames = Paths.getSparrowAtlas('noteassets/notesplash/Pixel_Splash');
		else
			frames = Paths.getSparrowAtlas('noteassets/notesplash/Splash');
		
		for (i in 0...colorsThatDontChange.length)
		{
			animation.addByPrefix(colorsThatDontChange[i] + ' splash', "splash " + colorsThatDontChange[i], 24, false);
		}
		//animation.play('splash');
		antialiasing = true;
		updateHitbox();
		makeSplash(nX, nY, color);
	}

	public function makeSplash(nX:Float, nY:Float, color:Int) 
	{
        setPosition(nX - 105, nY - 110);
		angle = FlxG.random.int(0, 360);
        alpha = 0.6;
        animation.play(colors[color] + ' splash', true);
		trace(animation.curAnim);
		animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
		//offset.set(500, 200);
        this.updateHitbox();   
    }

	override public function update(elapsed) 
	{
        if (animation.curAnim.finished)
		{
            kill();
        }
        super.update(elapsed);
    }
}