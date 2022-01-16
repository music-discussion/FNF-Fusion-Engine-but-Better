package;

import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flash.display.BitmapData;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end
#if sys
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import openfl.utils.ByteArray;
import lime.media.AudioBuffer;
import flash.media.Sound;
#end
using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	private var isPixel:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var modifiedByLua:Bool = false;
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteType:Int = 0;

	public var burning:Bool = false; //fire
	public var death:Bool = false;    //halo/death
	public var warning:Bool = false; //warning
	public var angel:Bool = false; //angel
	public var alt:Bool = false; //alt animation note
	public var bob:Bool = false; //bob arrow
	public var glitch:Bool = false; //glitch

	public var noteScore:Float = 1;

	public static var swagWidth:Float;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public var rating:String = "shit";
	public var modAngle:Float = 0; // The angle set by modcharts
	public var localAngle:Float = 0; // The angle to be edited inside Note.hx

	public var isParent:Bool = false;
	public var parent:Note = null;
	public var spotInLine:Int = 0;
	public var sustainActive:Bool = true;
	public var noteColors:Array<String> = ['purple', 'blue', 'green', 'red'];

	public var children:Array<Note> = [];

	public var rawNoteData:Int = 0; // for charting shit and thats it LOL

	public var noteYOff:Int = 0;

	var stepHeight = (0.45 * Conductor.stepCrochet * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? PlayState.SONG.speed : FlxG.save.data.scrollSpeed, 2));

	/////ek shit i copied
	public static var mania:Int = 0; 
	public static var noteScale:Float;
	public static var pixelnoteScale:Float;
	public static var tooMuch:Float = 30;

	public static var p1NoteScale:Float;
	public static var p2NoteScale:Float;
	public var defaultWidth:Float;

	public static var noteScales:Array<Float> = [0.7, 0.6, 0.5, 0.65, 0.58, 0.55, 0.7, 0.7, 0.7];
	public static var pixelNoteScales:Array<Float> = [1, 0.83, 0.7, 0.9, 0.8, 0.74, 1, 1, 1];
	public static var noteWidths:Array<Float> = [112, 84, 66.5, 91, 77, 70, 140, 126, 119];
	public static var sustainXOffsets:Array<Float> = [97, 84, 70, 91, 77, 78, 97, 97, 97];
	public static var posRest:Array<Int> = [0, 35, 70, 0, 50, 60, 0, 0, 0];

	public static var frameN:Array<Dynamic> = [
		['purple', 'blue', 'green', 'red'],
		['purple', 'green', 'red', 'yellow', 'blue', 'dark'],
		['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'darkred', 'dark'],
		['purple', 'blue', 'white', 'green', 'red'],
		['purple', 'green', 'red', 'white', 'yellow', 'blue', 'dark'],
		['purple', 'blue', 'green', 'red', 'yellow', 'violet', 'darkred', 'dark'],
		['white'],
		['purple', 'red'],
		['purple', 'white', 'red']
	];

	public static var noteTypeAssetPaths:Array<String> = [ //for noteTypes, just cleaning code a bit
		'noteassets/NOTE_assets', //not exactly needed but who cares
		'noteassets/notetypes/NOTE_types', //most note types are in a big spritesheet, if youre wondering why tf i did this
		'noteassets/notetypes/NOTE_types',
		'noteassets/notetypes/NOTE_types',
		'noteassets/notetypes/NOTE_types',
		'noteassets/NOTE_assets', //alt anim notes
		'noteassets/notetypes/NOTE_types',
		'noteassets/notetypes/NOTE_types',
		'noteassets/notetypes/poison',
		'noteassets/notetypes/drain'
	];
	public static var noteTypePrefixes:Array<String> = [
		"",
		"fire",
		"halo",
		"warning",
		"angel",
		"",
		"bob",
		"glitch",
		"poison",
		"poison" //forgot to change xml when copy pasting drain notes, if youre wondering why theres 2 poison
	];

	public static var keyAmmo:Array<Int> = [4, 6, 9, 5, 7, 8, 1, 2, 3];
	public static var ammoToMania:Array<Int> = [0, 6, 7, 8, 0, 3, 1, 4, 5, 2];
	public var curMania:Int = 0;
	public var scaleToUse:Float = 1;

	public static var P1MSwitchMap:Array<Dynamic> = [];
	public static var P2MSwitchMap:Array<Dynamic> = [];

	public var hitByOpponent:Bool = false;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?noteType:Int = 0, ?customImage:Null<BitmapData>, ?customXml:Null<String>, ?customEnds:Null<BitmapData>)
	{
		super();

		swagWidth = 160 * 0.7; //factor not the same as noteScale
		noteScale = 0.7;
		pixelnoteScale = 1;
		mania = 0;
		if (PlayState.SONG.mania != 0)
			{
				mania = PlayState.SONG.mania;
				swagWidth = noteWidths[mania];
				noteScale = noteScales[mania];
				pixelnoteScale = pixelNoteScales[mania];
				
			}
			p1NoteScale = noteScale;
			p2NoteScale = noteScale;

		if (prevNote == null)
			prevNote = this;
		this.noteType = noteType;
		this.prevNote = prevNote; 
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		if (Main.editor)
			this.strumTime = strumTime;
		else 
			this.strumTime = Math.round(strumTime);

		if (this.strumTime < 0)
			this.strumTime = 0;
		
		if (!mustPress)
			{
				/*if (strumTime >= PlayState.lastP2mChange)
					curMania = PlayState.curP2NoteMania;
				else
					curMania = PlayState.prevP2NoteMania;*/
	
				var highestStrumIdx:Int = 0;
				for (i in 0...P2MSwitchMap.length)
				{
					if (P2MSwitchMap[i][1] < this.strumTime)
						highestStrumIdx = i;
				}
				curMania = P2MSwitchMap[highestStrumIdx][0];
			}
			else
			{
				/*if (strumTime >= PlayState.lastP1mChange)
					curMania = PlayState.curP1NoteMania;
				else
					curMania = PlayState.prevP1NoteMania;*/
	
				var highestStrumIdx:Int = 0;
				for (i in 0...P1MSwitchMap.length)
				{
					if (P1MSwitchMap[i][1] < this.strumTime)
						highestStrumIdx = i;
				}
				curMania = P1MSwitchMap[highestStrumIdx][0];
			}
	
			scaleToUse = noteScales[curMania];
			if (PlayState.SONG.uiType.contains("pixel"))
				scaleToUse = pixelNoteScales[curMania];
	
			//this.noteData = noteData;
			this.noteData = noteData % 9;

		burning = noteType == 1;
		death = noteType == 2;
		warning = noteType == 3;
		angel = noteType == 4;
		alt = noteType == 5;
		bob = noteType == 6;
		glitch = noteType == 7;

		var daStage:String = PlayState.curStage;

		switch (PlayState.SONG.uiType)
		{
			case 'pixel':
				loadGraphic('assets/images/weeb/pixelUI/arrows-pixels.png', true, 17, 17);
				isPixel = true;
				/*animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				if (isSustainNote)
				{
					loadGraphic('assets/images/weeb/pixelUI/arrowEnds.png', true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();*/

				p1NoteScale = Note.pixelnoteScale;
				p2NoteScale = Note.pixelnoteScale;
				defaultWidth = width;
				setGraphicSize(Std.int(width * PlayState.daPixelZoom * scaleToUse));

				if(isSustainNote) {
					for (i in 0...9)
						{
							animation.add(frameN[2][i] + 'hold', [i]); // Holds
							animation.add(frameN[2][i] + 'holdend', [i + 9]); // Tails
						}
				} else {
					for (i in 0...9)
						{
							animation.add(frameN[2][i] + 'Scroll', [i + 9]); // Normal notes
						}
				}

				antialiasing = false;
			case 'normal':
				if (!FlxG.save.data.circleShit)
					frames = FlxAtlasFrames.fromSparrow('assets/images/NOTE_assets.png', 'assets/images/NOTE_assets.xml');
				else {
					frames = FlxAtlasFrames.fromSparrow('assets/images/noteassets/circle/NOTE_assets.png', 'assets/images/noteassets/circle/NOTE_assets.xml');
				}

				/*animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');*/
				for (i in 0...9)
					{
						animation.addByPrefix(frameN[2][i] + 'Scroll', frameN[2][i] + '0'); // Normal notes
						animation.addByPrefix(frameN[2][i] + 'hold', frameN[2][i] + ' hold piece'); // Hold
						animation.addByPrefix(frameN[2][i] + 'holdend', frameN[2][i] + ' hold end'); // Tails
					}

				if (burning)
					{
						frames = Paths.getSparrowAtlas('noteassets/firenotes/NOTE_assets');
						for (i in 0...9)
							{
								animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
								animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
								animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
							}
					}
				else if (death)
					{
						frames = Paths.getSparrowAtlas('noteassets/halo/NOTE_assets');
						for (i in 0...9)
							{
								animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
								animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
								animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
							}
					}
				else if (warning)
					{
						frames = Paths.getSparrowAtlas('noteassets/warning/NOTE_assets');
						for (i in 0...9)
							{
								animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
								animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
								animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
							}
					}
				else if (angel)
					{
						frames = Paths.getSparrowAtlas('noteassets/angel/NOTE_assets');
						for (i in 0...9)
							{
								animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
								animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
								animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
							}
					}
				else if (bob)
					{
						frames = Paths.getSparrowAtlas('noteassets/bob/NOTE_assets');
						for (i in 0...9)
							{
								animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
								animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
								animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
							}
					}
				else if (glitch)
					{
						frames = Paths.getSparrowAtlas('noteassets/glitch/NOTE_assets');
						for (i in 0...9)
							{
								animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
								animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
								animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
							}
					}
				//setGraphicSize(Std.int(width * noteScale));
				//updateHitbox();
				defaultWidth = width;
				setGraphicSize(Std.int(width * scaleToUse));
				updateHitbox();
				antialiasing = true;
			default:
				if (FileSystem.exists('assets/images/custom_ui/ui_packs/'+PlayState.SONG.uiType+"/NOTE_assets.xml") && FileSystem.exists('assets/images/custom_ui/ui_packs/'+PlayState.SONG.uiType+"/NOTE_assets.png")) {
					frames = FlxAtlasFrames.fromSparrow(customImage, customXml);
					animation.addByPrefix('greenScroll', 'green0');
	 				animation.addByPrefix('redScroll', 'red0');
	 				animation.addByPrefix('blueScroll', 'blue0');
	 				animation.addByPrefix('purpleScroll', 'purple0');

	 				animation.addByPrefix('purpleholdend', 'pruple end hold');
	 				animation.addByPrefix('greenholdend', 'green hold end');
	 				animation.addByPrefix('redholdend', 'red hold end');
	 				animation.addByPrefix('blueholdend', 'blue hold end');

	 				animation.addByPrefix('purplehold', 'purple hold piece');
	 				animation.addByPrefix('greenhold', 'green hold piece');
	 				animation.addByPrefix('redhold', 'red hold piece');
	 				animation.addByPrefix('bluehold', 'blue hold piece');

	 				if (burning)
						{
							frames = Paths.getSparrowAtlas('noteassets/firenotes/NOTE_assets');
							for (i in 0...9)
								{
									animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
									animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
									animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
								}
						}
					else if (death)
						{
							frames = Paths.getSparrowAtlas('noteassets/halo/NOTE_assets');
							for (i in 0...9)
								{
									animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
									animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
									animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
								}
						}
					else if (warning)
						{
							frames = Paths.getSparrowAtlas('noteassets/warning/NOTE_assets');
							for (i in 0...9)
								{
									animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
									animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
									animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
								}
						}
					else if (angel)
						{
							frames = Paths.getSparrowAtlas('noteassets/angel/NOTE_assets');
							for (i in 0...9)
								{
									animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
									animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
									animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
								}
						}
					else if (bob)
						{
							frames = Paths.getSparrowAtlas('noteassets/bob/NOTE_assets');
							for (i in 0...9)
								{
									animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
									animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
									animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
								}
						}
					else if (glitch)
						{
							frames = Paths.getSparrowAtlas('noteassets/glitch/NOTE_assets');
							for (i in 0...9)
								{
									animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
									animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
									animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
								}
						}
					setGraphicSize(Std.int(width * noteScale));
					updateHitbox();
					antialiasing = true;
					// when arrowsEnds != arrowEnds :laughing_crying:
				} else if (FileSystem.exists('assets/images/custom_ui/ui_packs/'+PlayState.SONG.uiType+"/arrows-pixels.png") && FileSystem.exists('assets/images/custom_ui/ui_packs/'+PlayState.SONG.uiType+"/arrowEnds.png")){
					loadGraphic(customImage, true, 17, 17);
					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);
					isPixel = true;
					if (isSustainNote)
					{
						var noteEndPic = BitmapData.fromFile('assets/images/custom_ui/ui_packs/'+PlayState.SONG.uiType+"/arrowEnds.png");
						loadGraphic(noteEndPic, true, 7, 6);

						animation.add('purpleholdend', [4]);
						animation.add('greenholdend', [6]);
						animation.add('redholdend', [7]);
						animation.add('blueholdend', [5]);

						animation.add('purplehold', [0]);
						animation.add('greenhold', [2]);
						animation.add('redhold', [3]);
						animation.add('bluehold', [1]);
					}

					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();
				} else {
					// no crashing today :)
					trace(PlayState.SONG.uiType);
					frames = FlxAtlasFrames.fromSparrow('assets/images/NOTE_assets.png', 'assets/images/NOTE_assets.xml');

					animation.addByPrefix('greenScroll', 'green0');
					animation.addByPrefix('redScroll', 'red0');
					animation.addByPrefix('blueScroll', 'blue0');
					animation.addByPrefix('purpleScroll', 'purple0');

					animation.addByPrefix('purpleholdend', 'pruple end hold');
					animation.addByPrefix('greenholdend', 'green hold end');
					animation.addByPrefix('redholdend', 'red hold end');
					animation.addByPrefix('blueholdend', 'blue hold end');

					animation.addByPrefix('purplehold', 'purple hold piece');
					animation.addByPrefix('greenhold', 'green hold piece');
					animation.addByPrefix('redhold', 'red hold piece');
					animation.addByPrefix('bluehold', 'blue hold piece');

					if (burning)
						{
							frames = Paths.getSparrowAtlas('noteassets/firenotes/NOTE_assets');
							for (i in 0...9)
								{
									animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
									animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
									animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
								}
						}
					else if (death)
						{
							frames = Paths.getSparrowAtlas('noteassets/halo/NOTE_assets');
							for (i in 0...9)
								{
									animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
									animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
									animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
								}
						}
					else if (warning)
						{
							frames = Paths.getSparrowAtlas('noteassets/warning/NOTE_assets');
							for (i in 0...9)
								{
									animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
									animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
									animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
								}
						}
					else if (angel)
						{
							frames = Paths.getSparrowAtlas('noteassets/angel/NOTE_assets');
							for (i in 0...9)
								{
									animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
									animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
									animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
								}
						}
					else if (bob)
						{
							frames = Paths.getSparrowAtlas('noteassets/bob/NOTE_assets');
							for (i in 0...9)
								{
									animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
									animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
									animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
								}
						}
					else if (glitch)
						{
							frames = Paths.getSparrowAtlas('noteassets/glitch/NOTE_assets');
							for (i in 0...9)
								{
									animation.addByPrefix(noteColors[i] + 'Scroll', noteColors[i] + '0'); // Normal notes
									animation.addByPrefix(noteColors[i] + 'hold', noteColors[i] + ' hold piece'); // Hold
									animation.addByPrefix(noteColors[i] + 'holdend', noteColors[i] + ' hold end'); // Tails
								}
						}
					setGraphicSize(Std.int(width * noteScale));
					updateHitbox();
					antialiasing = true;
				}
		}


		x += swagWidth * (noteData % keyAmmo[mania]);
			if(!isSustainNote) { //Doing this 'if' check to fix the warnings on Senpai songs
				var animToPlay:String = frameN[mania][noteData % keyAmmo[mania]];

				animation.play(animToPlay + 'Scroll');
			}

		// trace(prevNote);

		// we make sure its downscroll and its a SUSTAIN NOTE (aka a trail, not a note)
		// and flip it so it doesn't look weird.
		// THIS DOESN'T FUCKING FLIP THE NOTE, CONTRIBUTERS DON'T JUST COMMENT THIS OUT JESUS
		if (FlxG.save.data.downscroll && sustainNote) 
			flipY = true;

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;
			
			var animToPlay:String = frameN[mania][noteData % keyAmmo[mania]];

			animation.play(animToPlay + 'holdend');

			updateHitbox();

			x -= width / 2;

			if (isPixel)
				x += 30;

			if (prevNote.isSustainNote)
			{
				var animToPlay:String = frameN[mania][noteData % keyAmmo[mania]];

				animation.play(animToPlay + 'hold');

				
			//	prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.8 * FlxG.save.data.scrollSpeed;
				prevNote.updateHitbox();

				prevNote.scale.y *= (stepHeight + 1) / prevNote.height; // + 1 so that there's no odd gaps as the notes scroll
				prevNote.updateHitbox();
				prevNote.noteYOff = Math.round(-prevNote.offset.y);

				// prevNote.setGraphicSize();

				noteYOff = Math.round(-offset.y);

				// prevNote.setGraphicSize();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
