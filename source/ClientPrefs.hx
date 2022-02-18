package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

class ClientPrefs {
	public static var downScroll:Bool = false;
	public static var healthDrain:Bool = false; //man I should have just ported this shit to kade, but too far onto now!
	public static var multiplayer:Bool = false; //does not save betwen launching the game.
	public static var shaking:Bool = false;
	public static var yourLoss:Bool = false;
	public static var middleScroll:Bool = false;
	public static var showFPS:Bool = true;
	public static var flashing:Bool = true;
	public static var globalAntialiasing:Bool = true;
	public static var noteSplashes:Bool = true;
	public static var lowQuality:Bool = false;
	public static var framerate:Int = 60;
	public static var cursing:Bool = true;
	public static var violence:Bool = true;
	public static var camZooms:Bool = true;
	public static var hideHud:Bool = false;
	public static var noteOffset:Int = 0;
	public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
	public static var imagesPersist:Bool = false;
	public static var ghostTapping:Bool = true;
	public static var timeBarType:String = 'Time Left';
	public static var scoreZoom:Bool = true;
	public static var noReset:Bool = false;
	public static var healthBarAlpha:Float = 1;
	
	public static var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'opponentplay' => false
	];

	public static var comboOffset:Array<Int> = [0, 0, 0, 0];
	public static var keSustains:Bool = false; //i was bored, okay?
	
	public static var ratingOffset:Int = 0;
	public static var sickWindow:Int = 45;
	public static var goodWindow:Int = 90;
	public static var badWindow:Int = 135;
	public static var safeFrames:Float = 10;

	//Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	
	public static var keyBinds:Map<String, Dynamic> = new Map<String, Dynamic>();
	public static var defaultKeys:Map<String, Dynamic>;

	public static function setControls() //sets ur controls for mania stuff.
	{
		trace('save controls attempt.');
		if (FlxG.save.data.p_InSet_reset == null) {
		keyBinds.set('note_left', [A, LEFT]);
		keyBinds.set('note_down', [S, DOWN]);
		keyBinds.set('note_up', [W, UP]);
		keyBinds.set('note_right', [D, RIGHT]);
		
		keyBinds.set('6k0', [S, W]);
		keyBinds.set('6k1', [D, E]);
		keyBinds.set('6k2', [F, R]);
		keyBinds.set('6k3', [SPACE, G]);
		keyBinds.set('6k4', [J, U]);
		keyBinds.set('6k5', [K, I]);
		keyBinds.set('6k6', [L, O]);

		keyBinds.set('9k0', [A, Q]);
		keyBinds.set('9k1', [S, W]);
		keyBinds.set('9k2', [D, E]);
		keyBinds.set('9k3', [F, R]);
		keyBinds.set('9k4', [SPACE, G]);
		keyBinds.set('9k5', [H, Y]);
		keyBinds.set('9k6', [J, U]);
		keyBinds.set('9k7', [K, I]);
		keyBinds.set('9k8', [L, O]);

		// Don't delete this
		defaultKeys = keyBinds.copy();
		FlxG.save.data.rcontrols = keyBinds.copy();
		FlxG.save.data.p_InSet_reset = true;
		trace('controls saved.');
		}
		else  {
			trace('coming back player detected. controls not reset.');
			defaultKeys = FlxG.save.data.rcontrols;
			keyBinds = defaultKeys.copy(); //so you don't have to continuously do this.
		}

		trace(defaultKeys);
	}

	public static function changeControls(number:Int, mania:Int) {
		//keyBinds = null; //there was a bug that had multiple keybinds and caused the game to crash.
		trace(mania + ' | ' + number);
		var keyOne:Array<Array<Dynamic>> = [	[A, D, J, Q, A], []]; //doing it this way makes it so when i finally add it so you can change ek binds, I can use the same function and save space.
		var keyTwo:Array<Dynamic> = [			[S, F, K, W, S], []];
		var keyThree:Array<Dynamic> = [			[W, J, I, O, K], []];
		var keyFour:Array<Dynamic> = [			[D, K, L, P, L], []];
		//this system takes ten times less space.
		keyBinds.set('note_left',  [keyOne[mania][number],   LEFT]); //im starting to see why shadowmario has so many functions over the littlest things.
		keyBinds.set('note_down',  [keyTwo[mania][number],   DOWN]); //im too lazy to copy and paste.
		keyBinds.set('note_up',	   [keyThree[mania][number], UP]);
		keyBinds.set('note_right', [keyFour[mania][number],  RIGHT]);
		//now 6k/7k. this should be simple.
		var keyOne:Array<Array<Dynamic>> = [[], 	[S, W], []]; 
		var keyTwo:Array<Dynamic> = [[], 			[D, E], []];
		var keyThree:Array<Dynamic> = [[], 			[F, R], []];
		var keyFour:Array<Dynamic> = [[], 			[SPACE, G], []];
		var keyFive:Array<Array<Dynamic>> = [[], 	[J, U], []]; 
		var keySix:Array<Dynamic> = [[],		    [K, I], []];
		var keySeven:Array<Dynamic> = [[], 			[L, O,], []];
		//don't mind me just converting save over to keybinds.
		keyBinds.set('6k0', [S, W]);
		keyBinds.set('6k1', [D, E]);
		keyBinds.set('6k2', [F, R]);
		keyBinds.set('6k3', [SPACE, G]);
		keyBinds.set('6k4', [J, U]);
		keyBinds.set('6k5', [K, I]);
		keyBinds.set('6k6', [L, O]);
		//now 9k. just the same thing over.
		var keyOne:Array<Array<Dynamic>> = [[], [],  [A, Q]]; 
		var keyTwo:Array<Dynamic> = [[], [], 		 [S, W]];
		var keyThree:Array<Dynamic> = [[], [],		 [D, E,]];
		var keyFour:Array<Dynamic> = [[], [],		 [F, R]];
		var keyFive:Array<Array<Dynamic>> = [[], [], [SPACE, G]]; 
		var keySix:Array<Dynamic> = [[], [], 		 [H, Y,]];
		var keySeven:Array<Dynamic> = [[], [], 		 [J, U]];
		var keyEight:Array<Dynamic> = [[], [],		 [K, I]];
		var keyNine:Array<Dynamic> = [[], [], 		 [L, O]];
		//don't mind me just converting save over to keybinds.
		keyBinds.set('9k0', [A, Q]);
		keyBinds.set('9k1', [S, W]);
		keyBinds.set('9k2', [D, E]);
		keyBinds.set('9k3', [F, R]);
		keyBinds.set('9k4', [SPACE, G]);
		keyBinds.set('9k5', [H, Y]);
		keyBinds.set('9k6', [J, U]);
		keyBinds.set('9k7', [K, I]);
		keyBinds.set('9k8', [L, O]);

		// Don't delete this styf.
		defaultKeys = keyBinds.copy();
		FlxG.save.data.rcontrols = defaultKeys.copy();
		trace(defaultKeys);
	}

	public static function loadDefaultKeys() {
		defaultKeys = keyBinds.copy();
		//trace(defaultKeys);
	}

	public static function saveSettings() {
		FlxG.save.data.downScroll = downScroll;
		FlxG.save.data.healthDarin = healthDrain;
		FlxG.save.data.shaking = shaking;
		FlxG.save.data.yourLoss = yourLoss;
		FlxG.save.data.middleScroll = middleScroll;
		FlxG.save.data.showFPS = showFPS;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.framerate = framerate;
		//FlxG.save.data.cursing = cursing;
		//FlxG.save.data.violence = violence;
		FlxG.save.data.camZooms = camZooms;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.hideHud = hideHud;
		FlxG.save.data.arrowHSV = arrowHSV;
		FlxG.save.data.imagesPersist = imagesPersist;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.timeBarType = timeBarType;
		FlxG.save.data.scoreZoom = scoreZoom;
		FlxG.save.data.noReset = noReset;
		FlxG.save.data.healthBarAlpha = healthBarAlpha;
		FlxG.save.data.comboOffset = comboOffset;
		FlxG.save.data.achievementsMap = Achievements.achievementsMap;
		FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;

		FlxG.save.data.ratingOffset = ratingOffset;
		FlxG.save.data.sickWindow = sickWindow;
		FlxG.save.data.goodWindow = goodWindow;
		FlxG.save.data.badWindow = badWindow;
		FlxG.save.data.safeFrames = safeFrames;
		FlxG.save.data.gameplaySettings = gameplaySettings;
	
		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'ninjamuffin99'); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = keyBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs() {
		if(FlxG.save.data.downScroll != null) {
			downScroll = FlxG.save.data.downScroll;
		}
		if(FlxG.save.data.healthDrain != null) {
			healthDrain = FlxG.save.data.healthDrain;
		}
		if(FlxG.save.data.shaking != null){
			shaking = FlxG.save.data.shaking;
		}
		if(FlxG.save.data.yourLoss != null){
			yourLoss = FlxG.save.data.yourLoss;
		}
		if(FlxG.save.data.middleScroll != null) {
			middleScroll = FlxG.save.data.middleScroll;
		}
		if(FlxG.save.data.flashing != null) {
			flashing = FlxG.save.data.flashing;
		}
		if(FlxG.save.data.globalAntialiasing != null) {
			globalAntialiasing = FlxG.save.data.globalAntialiasing;
		}
		if(FlxG.save.data.noteSplashes != null) {
			noteSplashes = FlxG.save.data.noteSplashes;
		}
		if(FlxG.save.data.lowQuality != null) {
			lowQuality = FlxG.save.data.lowQuality;
		}
		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}
		/*if(FlxG.save.data.cursing != null) {
			cursing = FlxG.save.data.cursing;
		}
		if(FlxG.save.data.violence != null) {
			violence = FlxG.save.data.violence;
		}*/
		if(FlxG.save.data.camZooms != null) {
			camZooms = FlxG.save.data.camZooms;
		}
		if(FlxG.save.data.noteOffset != null) {
			noteOffset = FlxG.save.data.noteOffset;
		}
		if(FlxG.save.data.arrowHSV != null) {
			arrowHSV = FlxG.save.data.arrowHSV;
		}
		if(FlxG.save.data.imagesPersist != null) {
			imagesPersist = FlxG.save.data.imagesPersist;
			FlxGraphic.defaultPersist = ClientPrefs.imagesPersist;
		}
		if(FlxG.save.data.ghostTapping != null) {
			ghostTapping = FlxG.save.data.ghostTapping;
		}
		if(FlxG.save.data.timeBarType != null) {
			timeBarType = FlxG.save.data.timeBarType;
		}
		if(FlxG.save.data.scoreZoom != null) {
			scoreZoom = FlxG.save.data.scoreZoom;
		}
		if(FlxG.save.data.noReset != null) {
			noReset = FlxG.save.data.noReset;
		}
		if(FlxG.save.data.healthBarAlpha != null) {
			healthBarAlpha = FlxG.save.data.healthBarAlpha;
		}
		if(FlxG.save.data.comboOffset != null) {
			comboOffset = FlxG.save.data.comboOffset;
		}
		
		if(FlxG.save.data.ratingOffset != null) {
			ratingOffset = FlxG.save.data.ratingOffset;
		}
		if(FlxG.save.data.sickWindow != null) {
			sickWindow = FlxG.save.data.sickWindow;
		}
		if(FlxG.save.data.goodWindow != null) {
			goodWindow = FlxG.save.data.goodWindow;
		}
		if(FlxG.save.data.badWindow != null) {
			badWindow = FlxG.save.data.badWindow;
		}
		if(FlxG.save.data.safeFrames != null) {
			safeFrames = FlxG.save.data.safeFrames;
		}
		if(FlxG.save.data.gameplaySettings != null)
		{
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
			{
				gameplaySettings.set(name, value);
			}
		}
		
		// flixel automatically saves your volume!
		if(FlxG.save.data.volume != null)
		{
			FlxG.sound.volume = FlxG.save.data.volume;
		}
		if (FlxG.save.data.mute != null)
		{
			FlxG.sound.muted = FlxG.save.data.mute;
		}

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'ninjamuffin99');
		if(save != null && save.data.customControls != null) {
			var loadedControls:Map<String, Array<FlxKey>> = save.data.customControls;
			for (control => keys in loadedControls) {
				keyBinds.set(control, keys);
			}
			reloadControls();
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic):Dynamic {
		return PlayState.isStoryMode ? defaultValue : (gameplaySettings.exists(name) ? gameplaySettings.get(name) : null);
	}

	public static function reloadControls() {
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

		TitleState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		TitleState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		TitleState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
	}

	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey> {
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len) {
			if(copiedArray[i] == NONE) {
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
}
