package;

import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;

class OptionCatagory
{
	
	private var _options:Array<Option> = new Array<Option>();
	public final function getOptions():Array<Option>
	{
		return _options;
	}

	public final function addOption(opt:Option)
	{
		_options.push(opt);
	}

	
	public final function removeOption(opt:Option)
	{
		_options.remove(opt);
	}

	private var _name:String = "New Catagory";
	public final function getName() {
		return _name;
	}

	public function new (catName:String, options:Array<Option>)
	{
		_name = catName;
		_options = options;
	}
}

class Option
{
	public function new()
	{
		display = updateDisplay();
	}
	private var description:String = "";
	private var display:String;
	private var acceptValues:Bool = false;
	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}

	public final function getDescription():String
	{
		return description;
	}

	
	// Returns whether the label is to be updated.
	public function press():Bool { return throw "stub!"; }
	private function updateDisplay():String { return throw "stub!"; }
	public function left():Bool { return throw "stub!"; }
	public function right():Bool { return throw "stub!"; }
}

class OCinOC
{ // OptionCatagory in OptionCatagory
	private var _options:Array<Dynamic> = new Array<Dynamic>();
	public final function getOptions():Array<Dynamic>
	{
		return _options;
	}

	public final function addOption(opt:Dynamic)
	{
		_options.push(opt);
	}

	
	public final function removeOption(opt:Dynamic)
	{
		_options.remove(opt);
	}

	private var _name:String = "New Catagory";
	public final function getName() {
		return _name;
	}

	public function new (catName:String, options:Array<Dynamic>)
	{
		_name = catName;
		_options = options;
	}
}

class DFJKOption extends Option
{
	public static var rotation:Array<String> = ["ASWD","DFJK","JKIL","QWOP","ASKL"];
	public static var visualRotation:Array<String> = ["WASD","DFJK","IJKL","QWOP","ASKL"];
	private var controls:Controls;

	public function new(controls:Controls)
	{
		super();
		this.controls = controls;
		updateDisplay();
	}

	public override function press():Bool
	{
		FlxG.save.data.controls =(FlxG.save.data.controls+1)%rotation.length;
		

		controls.setKeyboardScheme(KeyboardScheme.Solo, true,rotation[FlxG.save.data.controls]);


		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  visualRotation[FlxG.save.data.controls];
	}
}

/*class DFJKOption extends Option //maybe one day
{
	private var controls:Controls;

	public function new(controls:Controls)
	{
		super();
		this.controls = controls;
	}

	public override function press():Bool
	{
		OptionsMenu.instance.openSubState(new KeyBindMenu());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Key Bindings for Four Key";
	}
}*/

class NewInputOption extends Option{

	public function new(desc:String){
		super();
		description = desc;
		updateDisplay();
	}
	private override function updateDisplay():String
		{
			return FlxG.save.data.newInput ? "New Input" : "Week 7ish Input";
		}
	
		public override function press():Bool
			{
				FlxG.save.data.newInput = !FlxG.save.data.newInput;
				display = updateDisplay();
				return true;
			}
}

class ResetKey extends Option{

	public function new(desc:String){
		super();
		description = desc;
		updateDisplay();
	}
	private override function updateDisplay():String
		{
			return "Reset Key "+ (FlxG.save.data.resetKey ? "Enabled" : "Disabled");
		}
	
		public override function press():Bool
			{
				FlxG.save.data.resetKey = !FlxG.save.data.resetKey;
				display = updateDisplay();
				return true;
			}
}
class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.downscroll ? "Downscroll" : "Upscroll";
	}
}

class AccuracyOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Accuracy " + (!FlxG.save.data.accuracyDisplay ? "off" : "on");
	}
}

class SongPositionOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Song Position " + (!FlxG.save.data.songPosition ? "off" : "on");
	}
}

class Judgement extends Option
{
	

	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}
	
	public override function press():Bool
	{
		return true;
	}

	private override function updateDisplay():String
	{
		return "Safe Frames";
	}

	override function left():Bool {

		if (Conductor.safeFrames == 1)
			return false;

		Conductor.safeFrames -= 1;
		FlxG.save.data.frames = Conductor.safeFrames;

		Conductor.recalculateTimings();

		OptionsMenu.versionShit.text = "Current Safe Frames: " + Conductor.safeFrames + " - Description - " + description + 
		" - SIK: " + OptionsMenu.truncateFloat(45 * Conductor.timeScale, 0) +
		"ms GD: " + OptionsMenu.truncateFloat(90 * Conductor.timeScale, 0) +
		"ms BD: " + OptionsMenu.truncateFloat(135 * Conductor.timeScale, 0) + 
		"ms SHT: " + OptionsMenu.truncateFloat(155 * Conductor.timeScale, 0) +
		"ms TOTAL: " + OptionsMenu.truncateFloat(Conductor.safeZoneOffset,0) + "ms";
		return true;
	}

	override function right():Bool {

		if (Conductor.safeFrames == 20)
			return false;

		Conductor.safeFrames += 1;
		FlxG.save.data.frames = Conductor.safeFrames;

		Conductor.recalculateTimings();

		OptionsMenu.versionShit.text = "Current Safe Frames: " + Conductor.safeFrames + " - Description - " + description + 
		" - SIK: " + OptionsMenu.truncateFloat(45 * Conductor.timeScale, 0) +
		"ms GD: " + OptionsMenu.truncateFloat(90 * Conductor.timeScale, 0) +
		"ms BD: " + OptionsMenu.truncateFloat(135 * Conductor.timeScale, 0) + 
		"ms SHT: " + OptionsMenu.truncateFloat(155 * Conductor.timeScale, 0) +
		"ms TOTAL: " + OptionsMenu.truncateFloat(Conductor.safeZoneOffset,0) + "ms";
		return true;
	}
}

class FPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.fps = !FlxG.save.data.fps;
	//	(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Counter " + (!FlxG.save.data.fps ? "off" : "on");
	}
}

class SplashOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.notesplash = !FlxG.save.data.notesplash;
	//	(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.notesplash);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Note Splashes " + (!FlxG.save.data.notesplash ? "Off" : "On");
	}
}

class CpuStrumsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.cpuStrums = !FlxG.save.data.cpuStrums;
	//	(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.notesplash);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "CPU Note Glows " + (!FlxG.save.data.cpuStrums ? "Off" : "On");
	}
}

class FreeplayInstOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.freeplayInst = !FlxG.save.data.freeplayInst;
	//	(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.notesplash);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Inst in Freeplay " + (!FlxG.save.data.freeplayInst ? "Off" : "On");
	}
}

class NoZoomOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.noZoom = !FlxG.save.data.noZoom;
	//	(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.notesplash);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "" + (!FlxG.save.data.noZoom ? "No Cam Zooming" : "Cam Zooming On");
	}
}

class SmallZoomOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.smallZoom = !FlxG.save.data.smallZoom;
	//	(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.notesplash);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Small Zoom" + (!FlxG.save.data.smallZoom ? "Off sad y tho" : "On");
	}
}

class BigZoomOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.bigZoom = !FlxG.save.data.bigZoom;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Big Zoom " + (!FlxG.save.data.bigZoom ? "off" : "on");
	}
}

class CircleOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.circleShit = !FlxG.save.data.circleShit;
	//	(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.notesplash);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Circle Arrows " + (!FlxG.save.data.circleShit ? "Off" : "On");
	}
}

class FPSCapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return "FPS Cap";
	}
	
	override function right():Bool {
		if (FlxG.save.data.fpsCap > 290)
			return false;
		FlxG.save.data.fpsCap = FlxG.save.data.fpsCap + 10;
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		OptionsMenu.versionShit.text = "Current FPS Cap: " + FlxG.save.data.fpsCap + " - Description - " + description;

		return true;
	}

	override function left():Bool {
		if (FlxG.save.data.fpsCap < 60)
			return false;
		FlxG.save.data.fpsCap = FlxG.save.data.fpsCap - 10;
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		OptionsMenu.versionShit.text = "Current FPS Cap: " + FlxG.save.data.fpsCap + " - Description - " + description;

		return true;
	}
}


class ScrollSpeedOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return "Scroll Speed";
	}

	override function right():Bool {
		FlxG.save.data.scrollSpeed += 0.1;

		if (FlxG.save.data.scrollSpeed < 1)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.scrollSpeed > 10)
			FlxG.save.data.scrollSpeed = 10;

		OptionsMenu.versionShit.text = "Current Scroll Speed: " + OptionsMenu.truncateFloat(FlxG.save.data.scrollSpeed,1) + " - Description - " + description;
		return true;
	}

	override function left():Bool {
		FlxG.save.data.scrollSpeed -= 0.1;

		if (FlxG.save.data.scrollSpeed < 1)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.scrollSpeed > 10)
			FlxG.save.data.scrollSpeed = 10;


		OptionsMenu.versionShit.text = "Current Scroll Speed: " + OptionsMenu.truncateFloat(FlxG.save.data.scrollSpeed,1) + " - Description - " + description;
		return true;
	}
}


class RainbowFPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.fpsRain = !FlxG.save.data.fpsRain;
		(cast (Lib.current.getChildAt(0), Main)).changeFPSColor(FlxColor.WHITE);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Rainbow " + (!FlxG.save.data.fpsRain ? "off" : "on");
	}
}

class NPSDisplayOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.npsDisplay = !FlxG.save.data.npsDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "NPS Display " + (!FlxG.save.data.npsDisplay ? "off" : "on");
	}
}

class ReplayOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	
	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new LoadReplayState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Load replays";
	}
}

class AccuracyDOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	
	public override function press():Bool
	{
		FlxG.save.data.accuracyMod +=1;
		FlxG.save.data.accuracyMod = FlxG.save.data.accuracyMod%3;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Accuracy Mode: " + (FlxG.save.data.accuracyMod == 0 ? "Accurate" : (FlxG.save.data.accuracyMod == 1 ? "Complex" : "Binary"));
	}
}

class CustomizeGameplay extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new GameplayCustomizeState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Customize Gameplay";
	}
}

class WatermarkOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		Main.watermarks = !Main.watermarks;
		FlxG.save.data.watermark = Main.watermarks;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Watermarks " + (Main.watermarks ? "on" : "off");
	}
}

class OffsetMenu extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");
		var poop:String = Highscore.formatSong("Tutorial", 1);

		PlayState.SONG = Song.loadFromJson(poop, "Tutorial");
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = 0;
		PlayState.storyWeek = 0;
		PlayState.offsetTesting = true;
		trace('CUR WEEK' + PlayState.storyWeek);
		LoadingState.loadAndSwitchState(new PlayState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Time your offset";
	}
}



