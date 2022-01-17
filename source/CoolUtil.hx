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
using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];

	public static function difficultyString():String
	{
		return difficultyArray[PlayState.storyDifficulty];
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
	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
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

	//because controls.hx sucks. we result to CoolUtil. the one place with all the goodies.
	
	public static function bindCheck(mania:Int)
		{
			var keysMap = ClientPrefs.keyBinds;
	
			var binds:Array<Int> = [keysMap.get('note_left')[0],keysMap.get('note_down')[0], keysMap.get('note_up')[0], keysMap.get('note_right')[0]];
			switch(mania)
			{
				case 0: 
					binds = [keysMap.get('note_left')[0],keysMap.get('note_down')[0], keysMap.get('note_up')[0], keysMap.get('note_right')[0]];
				case 1: 
					binds = [keysMap.get('6k0')[0], keysMap.get('6k1')[0], keysMap.get('6k2')[0], keysMap.get('6k4')[0], keysMap.get('6k5')[0], keysMap.get('6k6')[0]];
				case 2: 
					if (PlayState.maniaToChange	!= 2)
					{
						switch (PlayState.maniaToChange)
						{
							case 0: 
								binds = [keysMap.get('note_left')[0],keysMap.get('note_down')[0], keysMap.get('note_up')[0], keysMap.get('note_right')[0], -1, -1, -1, -1, -1];
							case 1: 
								binds = [keysMap.get('6k0')[0], keysMap.get('6k5')[0], keysMap.get('6k1')[0], keysMap.get('6k2')[0],-1, keysMap.get('6k4')[0],-1, -1,keysMap.get('6k6')[0]];
							case 3: 
								binds = [keysMap.get('note_left')[0],keysMap.get('note_down')[0], keysMap.get('note_up')[0], keysMap.get('note_right')[0], keysMap.get('6k3')[0], -1, -1, -1, -1];
							case 4: 
								binds = [keysMap.get('6k0')[0], keysMap.get('6k5')[0], keysMap.get('6k1')[0], keysMap.get('6k2')[0],keysMap.get('6k3')[0], keysMap.get('6k4')[0],-1, -1,keysMap.get('6k6')[0]];
							case 5: 
								binds = [keysMap.get('9k0')[0], keysMap.get('9k1')[0], keysMap.get('9k2')[0], keysMap.get('9k3')[0], -1, keysMap.get('9k5')[0], keysMap.get('9k6')[0], keysMap.get('9k7')[0], keysMap.get('9k8')[0]];
							case 6: 
								binds = [-1,-1,-1,-1,keysMap.get('6k3')[0],-1,-1,-1,-1];
							case 7:
								binds = [keysMap.get('note_left')[0],-1,-1, keysMap.get('note_right')[0],-1,-1,-1,-1,-1];
							case 8: 
								binds = [keysMap.get('note_left')[0],-1,-1, keysMap.get('note_right')[0],keysMap.get('6k3')[0],-1,-1,-1,-1];
						}
					}
					else
						binds = [keysMap.get('9k0')[0], keysMap.get('9k1')[0], keysMap.get('9k2')[0], keysMap.get('9k3')[0], keysMap.get('9k4')[0], keysMap.get('9k5')[0], keysMap.get('9k6')[0], keysMap.get('9k7')[0], keysMap.get('9k8')[0]];
				case 3: 
					binds = [keysMap.get('note_left')[0],keysMap.get('note_down')[0], keysMap.get('6k3')[0], keysMap.get('note_up')[0], keysMap.get('note_right')[0]];
				case 4: 
					binds = [keysMap.get('6k0')[0], keysMap.get('6k1')[0], keysMap.get('6k2')[0], keysMap.get('6k3')[0], keysMap.get('6k4')[0], keysMap.get('6k5')[0], keysMap.get('6k6')[0]];
				case 5: 
					binds = [keysMap.get('9k0')[0], keysMap.get('9k1')[0], keysMap.get('9k2')[0], keysMap.get('9k3')[0], keysMap.get('9k5')[0], keysMap.get('9k6')[0], keysMap.get('9k7')[0], keysMap.get('9k8')[0]];
				case 6: 
					binds = [keysMap.get('6k3')[0]];
				case 7:
					binds = [keysMap.get('note_left')[0], keysMap.get('note_right')[0]];
				case 8: 
					binds = [keysMap.get('note_left')[0], keysMap.get('6k3')[0], keysMap.get('note_right')[0]];
			}
			return binds;
		}
		public static function altbindCheck(mania:Int)
			{
				var keysMap = ClientPrefs.keyBinds;
		
				var binds:Array<Int> = [keysMap.get('note_left')[1],keysMap.get('note_down')[1], keysMap.get('note_up')[1], keysMap.get('note_right')[1]];
				switch(mania)
				{
					case 0: 
						binds = [keysMap.get('note_left')[1],keysMap.get('note_down')[1], keysMap.get('note_up')[1], keysMap.get('note_right')[1]];
					case 1: 
						binds = [keysMap.get('6k0')[1], keysMap.get('6k1')[1], keysMap.get('6k2')[1], keysMap.get('6k4')[1], keysMap.get('6k5')[1], keysMap.get('6k6')[1]];
					case 2: 
						if (PlayState.maniaToChange != 2)
						{
							switch (PlayState.maniaToChange)
							{
								case 0: 
									binds = [keysMap.get('note_left')[1],keysMap.get('note_down')[1], keysMap.get('note_up')[1], keysMap.get('note_right')[1], -1, -1, -1, -1, -1];
								case 1: 
									binds = [keysMap.get('6k0')[1], keysMap.get('6k5')[1], keysMap.get('6k1')[1], keysMap.get('6k2')[1],-1, keysMap.get('6k4')[1],-1, -1,keysMap.get('6k6')[0]];
								case 3: 
									binds = [keysMap.get('note_left')[1],keysMap.get('note_down')[1], keysMap.get('note_up')[1], keysMap.get('note_right')[1], keysMap.get('6k3')[1], -1, -1, -1, -1];
								case 4: 
									binds = [keysMap.get('6k0')[1], keysMap.get('6k5')[1], keysMap.get('6k1')[1], keysMap.get('6k2')[1],keysMap.get('6k3')[1], keysMap.get('6k4')[1],-1, -1,keysMap.get('6k6')[1]];
								case 5: 
									binds = [keysMap.get('9k0')[1], keysMap.get('9k1')[1], keysMap.get('9k2')[1], keysMap.get('9k3')[1], -1, keysMap.get('9k5')[1], keysMap.get('9k6')[1], keysMap.get('9k7')[1], keysMap.get('9k8')[1]];
								case 6: 
									binds = [-1,-1,-1,-1,keysMap.get('6k3')[1],-1,-1,-1,-1];
								case 7:
									binds = [keysMap.get('note_left')[1],-1,-1, keysMap.get('note_right')[1],-1,-1,-1,-1,-1];
								case 8: 
									binds = [keysMap.get('note_left')[1],-1,-1, keysMap.get('note_right')[1],keysMap.get('6k3')[1],-1,-1,-1,-1];
							}
						}
						else
							binds = [keysMap.get('9k0')[1], keysMap.get('9k1')[1], keysMap.get('9k2')[1], keysMap.get('9k3')[1], keysMap.get('9k4')[1], keysMap.get('9k5')[1], keysMap.get('9k6')[1], keysMap.get('9k7')[1], keysMap.get('9k8')[1]];
					case 3: 
						binds = [keysMap.get('note_left')[1],keysMap.get('note_down')[1], keysMap.get('6k3')[1], keysMap.get('note_up')[1], keysMap.get('note_right')[1]];
					case 4: 
						binds = [keysMap.get('6k0')[1], keysMap.get('6k1')[1], keysMap.get('6k2')[1], keysMap.get('6k3')[1], keysMap.get('6k4')[1], keysMap.get('6k5')[1], keysMap.get('6k6')[1]];
					case 5: 
						binds = [keysMap.get('9k0')[1], keysMap.get('9k1')[1], keysMap.get('9k2')[1], keysMap.get('9k3')[1], keysMap.get('9k5')[1], keysMap.get('9k6')[1], keysMap.get('9k7')[1], keysMap.get('9k8')[1]];
					case 6: 
						binds = [keysMap.get('6k3')[1]];
					case 7:
						binds = [keysMap.get('note_left')[1], keysMap.get('note_right')[1]];
					case 8: 
						binds = [keysMap.get('note_left')[1], keysMap.get('6k3')[1], keysMap.get('note_right')[1]];
				}
				return binds;
			}
}
