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
	public static var noteScale:Float;
	public static var pixelnoteScale:Float;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	public static var tooMuch:Float = 30;

	public var rating:String = "shit";
	public var modAngle:Float = 0; // The angle set by modcharts
	public var localAngle:Float = 0; // The angle to be edited inside Note.hx

	public var isParent:Bool = false;
	public var parent:Note = null;
	public var spotInLine:Int = 0;
	public var sustainActive:Bool = true;
	public var noteColors:Array<String> = ['purple', 'blue', 'green', 'red'];

	public var children:Array<Note> = [];

	public static var mania:Int = 0; //used for absoulutely shit.

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?noteType:Int = 0, ?customImage:Null<BitmapData>, ?customXml:Null<String>, ?customEnds:Null<BitmapData>)
	{
		super();

		swagWidth = 160 * 0.7; //factor not the same as noteScale
		noteScale = 0.7;
		pixelnoteScale = 1;
		mania = 0;

		if (prevNote == null)
			prevNote = this;
		this.noteType = noteType;
		this.prevNote = prevNote; 
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		if (this.strumTime < 0 )
			this.strumTime = 0;

		this.noteData = noteData;

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
				animation.add('greenScroll', [6]);
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
				updateHitbox();
			case 'normal':
				if (!FlxG.save.data.circleShit)
					frames = FlxAtlasFrames.fromSparrow('assets/images/NOTE_assets.png', 'assets/images/NOTE_assets.xml');
				else {
					frames = FlxAtlasFrames.fromSparrow('assets/images/noteassets/circle/NOTE_assets.png', 'assets/images/noteassets/circle/NOTE_assets.xml');
				}

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


		switch (noteData)
		{
			case 0:
				x += swagWidth * 0;
				animation.play('purpleScroll');
			case 1:
				x += swagWidth * 1;
				animation.play('blueScroll');
			case 2:
				x += swagWidth * 2;
				animation.play('greenScroll');
			case 3:
				x += swagWidth * 3;
				animation.play('redScroll');
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

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			updateHitbox();

			x -= width / 2;

			if (isPixel)
				x += 30;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				
				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.8 * FlxG.save.data.scrollSpeed;
				prevNote.updateHitbox();
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
