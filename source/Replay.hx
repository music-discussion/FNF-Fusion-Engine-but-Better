#if sys
import sys.io.File;
#end
import Controls.Control;
import flixel.FlxG;
import openfl.events.IOErrorEvent;
import openfl.events.Event;
import openfl.net.FileReference;
import lime.utils.Assets;
import haxe.Json;
import flixel.input.keyboard.FlxKey;
import openfl.utils.Dictionary;

typedef KeyPress =
{
    public var time:Float;
    public var key:String;
}

typedef KeyRelease =
{
    public var time:Float;
    public var key:String;
}

class Ana
{
	public var hitTime:Float;
	public var nearestNote:Array<Dynamic>;
	public var hit:Bool;
	public var hitJudge:String;
	public var key:Int;

	public function new(_hitTime:Float,_nearestNote:Array<Dynamic>,_hit:Bool,_hitJudge:String, _key:Int) {
		hitTime = _hitTime;
		nearestNote = _nearestNote;
		hit = _hit;
		hitJudge = _hitJudge;
		key = _key;
	}
}

class Analysis
{
	public var anaArray:Array<Ana>;

	public function new() {
		anaArray = [];
	}
}

typedef ReplayJSON =
{
    public var replayGameVer:String;
    public var timestamp:Date;
    public var songName:String;
    public var songDiff:Int;
    public var keyPresses:Array<KeyPress>;
    public var keyReleases:Array<KeyRelease>;
	public var songNotes:Array<Dynamic>;
	public var songJudgements:Array<String>;
	public var noteSpeed:Float;
	public var isDownscroll:Bool;
	public var sf:Int;
	public var ana:Analysis;
}

class Replay
{
    public static var version:String = "1.4.2"; // replay file version

    public var path:String = "";
    public var replay:ReplayJSON;
    public function new(path:String)
    {
        this.path = path;
        replay = {
            songName: "No Song Found", 
			songDiff: 1,
			noteSpeed: 1.5,
			isDownscroll: false,
			songNotes: [],
			replayGameVer: version,
			timestamp: Date.now(),
			sf: Conductor.safeFrames,
			ana: new Analysis(),
			songJudgements: [],
            keyPresses: [],
            keyReleases: [],
        };
    }

    public static function LoadReplay(path:String):Replay
    {
        var rep:Replay = new Replay(path);

        rep.LoadFromJSON();

        trace('basic replay data:\nSong Name: ' + rep.replay.songName + '\nSong Diff: ' + rep.replay.songDiff + '\nKeys Length: ' + rep.replay.keyPresses.length);

        return rep;
    }

    public function SaveReplay(notearray:Array<Dynamic>, judge:Array<String>, ana:Analysis)
    {
        var json = {
            "songName": PlayState.SONG.song,
			"songDiff": PlayState.storyDifficulty,
			"noteSpeed": (FlxG.save.data.scrollSpeed > 1 ? FlxG.save.data.scrollSpeed : PlayState.SONG.speed),
			"isDownscroll": FlxG.save.data.downscroll,
			"songNotes": notearray,
			"songJudgements": judge,
			"timestamp": Date.now(),
			"replayGameVer": version,
			"sf": Conductor.safeFrames,
			"ana": ana,
            "keyPresses": replay.keyPresses,
            "keyReleases": replay.keyReleases
        };

        var data:String = Json.stringify(json);

        #if sys
        File.saveContent("assets/replays/replay-" + PlayState.SONG.song + "-time" + Date.now().getTime() + ".kadeReplay", data);
        #end
    }


    public function LoadFromJSON()
    {
        #if sys
        trace('loading ' + Sys.getCwd() + 'assets/replays/' + path + ' replay...');
        try
        {
            var repl:ReplayJSON = cast Json.parse(File.getContent(Sys.getCwd() + "assets/replays/" + path));
            replay = repl;
        }
        catch(e)
        {
            trace('failed!\n' + e.message);
        }
        #end
    }

}
