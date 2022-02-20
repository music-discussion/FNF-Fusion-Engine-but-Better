package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import lime.system.System;
import lime.utils.Assets;
#if sys
import sys.io.File;
import haxe.io.Path;
import sys.FileSystem;
import openfl.utils.ByteArray;
import flash.display.BitmapData;
#end
import haxe.Json;
import haxe.format.JsonParser;
import tjson.TJSON;

typedef MenuCharacterFile = {
	var image:String;
	var scale:Float;
	var position:Array<Int>;
	var idle_anim:String;
	var confirm_anim:String;
}

class MenuCharacter extends FlxSprite
{
	public var character:String;
	public var like:String;
	var dontPlayAnim:Bool = false;
//	var visible:Bool = true;
	private static var DEFAULT_CHARACTER:String = 'bf';

	public function new(x:Float, character:String = 'bf')
	{
		super(x);

		this.character = character;
		// use assets it is less laggy
		var parsedCharJson:Dynamic = CoolUtil.parseJson(File.getContent("assets/images/campaign-ui-char/custom_ui_chars.json"));
		if (!!Reflect.field(parsedCharJson,character).defaultGraphics) {
			// use assets, it is less laggy
			var tex = FlxAtlasFrames.fromSparrow('assets/images/campaign_menu_UI_characters.png', 'assets/images/campaign_menu_UI_characters.xml');
			frames = tex;
		} else {
			var rawPic:BitmapData = BitmapData.fromFile('assets/images/campaign-ui-char/'+character+".png");
			var rawXml:String = File.getContent('assets/images/campaign-ui-char/'+character+".xml");
			var tex = FlxAtlasFrames.fromSparrow(rawPic, rawXml);
			frames = tex;
		}

		// don't use assets because you can use custom like folders
		var animJson = CoolUtil.parseJson(File.getContent("assets/images/campaign-ui-char/"+Reflect.field(parsedCharJson,character).like+".json"));
		for (field in Reflect.fields(animJson)) {
			animation.addByPrefix(field, Reflect.field(animJson, field), 24, (field == "idle"));
		}
		this.like = Reflect.field(parsedCharJson,character).like;
		if (!dontPlayAnim)
			animation.play('idle');
		updateHitbox();
	//	if (visible)
	//		character.visible = true;
	//	else {
	//		character.visible = false;
	//	}
	}

	public function changeCharacter(?character:String = 'bf') {
		if(character == null) character = '';
		if(character == this.character) return;

		this.character = character;
		antialiasing = ClientPrefs.globalAntialiasing;
		visible = true;

		var dontPlayAnim:Bool = false;
		scale.set(1, 1);
		updateHitbox();

		switch(character) {
			case '':
				visible = false;
				dontPlayAnim = true;
			default:
				var characterPath:String = 'assets/images/campaign-ui-char/' + character + '.json';
				var rawJson = null;

				var path:String = Paths.modFolders(characterPath);
				if (!FileSystem.exists(path)) {
					path = Paths.getPsychPreloadPath(characterPath);
				}

				if(!FileSystem.exists(path)) {
					path = Paths.getPsychPreloadPath('images/campaign-ui-char/' + DEFAULT_CHARACTER + '.json');
				}
				rawJson = File.getContent(path);
				
				var charFile:MenuCharacterFile = cast Json.parse(rawJson);
				frames = Paths.getSparrowAtlas('campaign-ui-char/' + charFile.image);
				animation.addByPrefix('idle', charFile.idle_anim, 24);
				animation.addByPrefix('confirm', charFile.confirm_anim, 24, false);

				if(charFile.scale != 1) {
					scale.set(charFile.scale, charFile.scale);
					updateHitbox();
				}
				offset.set(charFile.position[0], charFile.position[1]);
				animation.play('idle');
		}
	}
}
