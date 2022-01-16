package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import sys.io.File;
import sys.FileSystem;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;

import flash.media.Sound;

using StringTools;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	#if (haxe >= "4.0.0")
	public static var ignoreModFolders:Map<String, Bool> = new Map();
	public static var customImagesLoaded:Map<String, FlxGraphic> = new Map();
	public static var customSoundsLoaded:Map<String, Sound> = new Map();
	#else
	public static var ignoreModFolders:Map<String, Bool> = new Map<String, Bool>();
	public static var customImagesLoaded:Map<String, FlxGraphic> = new Map<String, FlxGraphic>();
	public static var customSoundsLoaded:Map<String, Sound> = new Map<String, Sound>();
	#end

	static var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	/*static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}*/

	inline static public function formatToSongPath(path:String) {
		return path.toLowerCase().replace(' ', '-');
	}

	static public var currentModDirectory:String = null;

//	static public function getLibraryPath(file:String, library = "preload")
//	{
//		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
//	}

//	inline static function getLibraryPathForce(file:String, library:String)
//	{
//		return '$library:assets/$library/$file';
//	}

	static function getPath(file:String, type:AssetType, library:Null<String>)
		{
			if (library != null)
				return getLibraryPath(file, library);
			if (currentLevel != null)
			{
				var levelPath = getLibraryPathForce(file, currentLevel);
				if (OpenFlAssets.exists(levelPath, type))
					return levelPath;
				levelPath = getLibraryPathForce(file, "shared");
				if (OpenFlAssets.exists(levelPath, type))
					return levelPath;
			}
	
			return getPreloadPath(file);
		}
	
		static public function getLibraryPath(file:String, library = "default")
		{
			return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
		}
	
		inline static function getLibraryPathForce(file:String, library:String)
		{
			return '$library:assets/$library/$file';
		}

	inline static public function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function lua(key:String,?library:String)
	{
		return getPath('data/$key.lua', TEXT, library);
	}

	inline static public function luaImage(key:String, ?library:String)
	{
		return getPath('data/$key.png', IMAGE, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String)
	{
		trace('assets/music/${song}_Voices.$SOUND_EXT');
		return 'assets/music/${song}_Voices.$SOUND_EXT';
	}

	inline static public function inst(song:String)
	{
		trace('assets/music/${song}_Inst.$SOUND_EXT');
		return 'assets/music/${song}_Inst.$SOUND_EXT';
	}

	inline static public function categoryMusic(song:String)
	{ //this wasnt soooooooo bad.
		trace('assets/categoryMusic/${song}');
		return 'assets/categoryMusic/${song}';
	}

	inline static public function image(key:String, ?library:String)
	{
		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}

	inline public static function getPsychPreloadPath(file:String = '')
	{
		return 'assets/$file'; //only used for psych engine states and thats it.
	}

	inline public static function getDataPsychPreloadPath(file:String = '') //custom made :)
		{
			return 'assets/data/$file'; //only used for psych engine states and thats it.
		}

	inline static public function mods(key:String = '') {
		return 'assets/images/' + key;
	}

//	static var currentLevel:String;
	static public function getModFolders()
	{
	//	#if MODS_ALLOWED
		ignoreModFolders.set('characters', true);
		ignoreModFolders.set('custom_events', true);
		ignoreModFolders.set('custom_notetypes', true);
		ignoreModFolders.set('data', true);
		ignoreModFolders.set('songs', true);
		ignoreModFolders.set('music', true);
		ignoreModFolders.set('sounds', true);
		ignoreModFolders.set('videos', true);
		ignoreModFolders.set('images', true);
		ignoreModFolders.set('stages', true);
		ignoreModFolders.set('weeks', true);
//		#end
	}

	static public function modFolders(key:String) {
		if(currentModDirectory != null && currentModDirectory.length > 0) {
			var fileToCheck:String = mods(currentModDirectory + '/' + key);
			if(FileSystem.exists(fileToCheck)) {
				return fileToCheck;
			}
		}
		return 'assets/images/' + key;
	}
}
