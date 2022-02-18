package;

import flash.display.BitmapData;
import haxe.Json;
import lime.utils.Assets;
import tjson.TJSON;
import lime.app.Application;
import openfl.display.BitmapData;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

import openfl.utils.Assets;
import lime.utils.Assets;
import flixel.FlxG;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['Easy', "Normal", "Hard"];
	public static var CurSongDiffs:Array<String> = ['EASY', 'NORMAL', 'HARD'];

	public static function difficultyFromInt(difficulty:Int):String
	{
		return difficultyArray[difficulty];
	}

	public static function difficultyString():String
		{
			return CurSongDiffs[PlayState.storyDifficulty];
		}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	
	public static function coolStringFile(path:String):Array<String>
		{
			var daList:Array<String> = path.trim().split('\n');
	
			for (i in 0...daList.length)
			{
				daList[i] = daList[i].trim();
			}
	
			return daList;
		}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	public static function getSongFromJsons(song:String, diff:Int, customChart:Bool = false)
		{
			var path = "assets/data/charts/" + song;
			if (customChart)
				path = "assets/data/freeplayCharts/" + song;
	
			if (PlayState.isStoryMode) //idk why its flagged as incorrect, game still compiles??????
				return song + PlayState.storySuffix;
	
			#if sys
			if (FileSystem.exists(path))
			{
				var diffs:Array<String> = [];
				var sortedDiffs:Array<String> = [];
				diffs = FileSystem.readDirectory(path);
	
				var easy:String = "";
				var normal:String = "";
				var hard:String = "";
				var extra:Array<String> = [];
				var extraCount = 0;
				
				for (file in diffs)
				{
					if (!file.contains(".hscript") && file.endsWith(".json")) //fuck you
					{
						if (!file.endsWith(".json")) //get rid of non json files
							diffs.remove(file);
						else if (file.endsWith("-easy.json")) //add easy first
						{
							easy = file;
						}
						else if (file.endsWith(song + ".json")) //add normal
						{
							normal = file;
						}
						else if (file.endsWith("-hard.json")) //add hard
						{
							hard = file;
						}
						else
						{
							extra.push(file);
							extraCount++;
						}
					}
	
					
				}
				var textDiffs:Array<String> = [];
				if (easy != "")
				{
					sortedDiffs.push(easy); //pushes them in correct order
					textDiffs.push("Easy");
				}
				if (normal != "")
				{
					sortedDiffs.push(normal);
					textDiffs.push("Normal");
				}
				if (hard != "")
				{
					sortedDiffs.push(hard);
					textDiffs.push("Hard");
				}
				if (extraCount != 0)
					for (i in extra)
					{
						sortedDiffs.push(i);
					}
						
	
	
				var outputDiffs:Array<String> = [];
				for (file in sortedDiffs)
				{
					var noJson = StringTools.replace(file,".json", "");
					var noSongName = StringTools.replace(noJson,song.toLowerCase(), "");
					outputDiffs.push(noSongName); //gets just the difficulty on the end of the file
				}
				
				if (extraCount != 0)
					for (file in extra)
					{
						var noJson = StringTools.replace(file,".json", "");
						var noSongName = StringTools.replace(noJson,song.toLowerCase(), "");
						var fixedShit = StringTools.replace(noSongName,"-", "");
						textDiffs.push(fixedShit.toUpperCase()); //upper cases the difficulty to use them in the array
					}
				CurSongDiffs = textDiffs;
				if (diff > outputDiffs.length)
					diff = outputDiffs.length;
				return song + outputDiffs[diff];
			}
			else 
				return "tutorial"; //in case it dont work lol
			#else
				//do nothing lol
			#end
		}

		public static function songCompatCheck(noteType:Int)
		{
				switch (PlayState.SONG.song.toLowerCase())
				{
					case "ectospasm" | "spectral":
						if (noteType == 1)
							noteType = 8;
						else if (noteType == 2)
							noteType = 4;
					case "godspeed" | "where-are-you": //for his mod lmao
						if (noteType <= 4)
							noteType = 0;
						else if (noteType == 5)
							noteType = 1;
						else if (noteType == 6)
							noteType = 2;
						else if (noteType == 7)
							noteType = 3;
						else if (noteType == 8)
							noteType = 6;
						else if (noteType == 9)
							noteType = 7;
					default: 
						//nada
				}
		
		
				return noteType;
		}

	public static function getString(dyn:Dynamic,key:String,jsonName:String,?d:String):String{
		if(Reflect.hasField(dyn,key)){
			return Reflect.field(dyn,key);
		}
		if(d!=null){
			trace("asdqwe6b");
			return d;
		}
		Application.current.window.alert('oopsy doopsy looks like you are missing "'+key+'" SOMEWHERE inside of your json at location '+jsonName);
		return "";
	}	public static function getInt(dyn:Dynamic,key:String,jsonName:String,?d:Int):Int{
		if(Reflect.hasField(dyn,key)){
			return Reflect.field(dyn,key);
		}
		if(d!=null){

			return d;
		}
		Application.current.window.alert('oopsy doopsy looks like you are missing "'+key+'" SOMEWHERE inside of your json at location '+jsonName);
		return 0;
	}public static function getDynamic(dyn:Dynamic,key:String,jsonName:String,crash:Bool):Dynamic{
		if(Reflect.hasField(dyn,key)){
			return Reflect.field(dyn,key);
		}
		if(crash){
			Application.current.window.alert('oopsy doopsy looks like you are missing "'+key+'" SOMEWHERE inside of your json at location '+jsonName);
		}
		return null;
	}
	public static function getFloat(dyn:Dynamic,key:String,jsonName:String,?d:Float):Float{
		if(Reflect.hasField(dyn,key)){
			return Reflect.field(dyn,key);
		}
		if(d!=null){

			return d;
		}
		Application.current.window.alert('oopsy doopsy looks like you are missing "'+key+'" SOMEWHERE inside of your json at location '+jsonName);
		return 0;
	}	public static function getBool(dyn:Dynamic,key:String,jsonName:String,?d:Bool):Bool{
		if(Reflect.hasField(dyn,key)){
			return Reflect.field(dyn,key);
		}
		if(d!=null){

			return d;
		}
		Application.current.window.alert('oopsy doopsy looks like you are missing "'+key+'" SOMEWHERE inside of your json at location '+jsonName);
		return false;
	}
	public static function getBitmap(file:String):BitmapData{
		if(!FileSystem.exists(file)){
			Application.current.window.alert('oopsy doopsy looks like you are missing "'+file+'"');
		}
		return BitmapData.fromFile(file);
	}
	public static function getContent(file:String):String{
		if(!FileSystem.exists(file)){
			Application.current.window.alert('oopsy doopsy looks like you are missing "'+file+'"');
		}
		return File.getContent(file);
	}

	public static function boundTo(value:Float, min:Float, max:Float):Float {
		var newValue:Float = value;
		if(newValue < min) newValue = min;
		else if(newValue > max) newValue = max;
		return newValue;
	}
	
	public static function parseJson(json:String):Dynamic {
		// the reason we do this is to make it easy to swap out json parsers

		return TJSON.parse(json);
	}

	public static function dominantColor(sprite:flixel.FlxSprite):Int{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth){
			for(row in 0...sprite.frameHeight){
			  var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
			  if(colorOfThisPixel != 0){
				  if(countByColor.exists(colorOfThisPixel)){
				    countByColor[colorOfThisPixel] =  countByColor[colorOfThisPixel] + 1;
				  }else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687)){
					 countByColor[colorOfThisPixel] = 1;
				  }
			  }
			}
		 }
		var maxCount = 0;
		var maxKey:Int = 0;//after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
			for(key in countByColor.keys()){
			if(countByColor[key] >= maxCount){
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}
		public static function stringifyJson(json:Dynamic, ?fancy:Bool = true):String {
			// use tjson to prettify it
			var style:String = if (fancy) 'fancy' else null;
			return TJSON.encode(json,style);
		}
		public static function coolDynamicTextFile(path:String):Array<String>
			{
				var daList:Array<String> = File.getContent(path).trim().split('\n');
		
				for (i in 0...daList.length)
				{
					daList[i] = daList[i].trim();
				}
		
				return daList;
			}
}
