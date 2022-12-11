package nl.imfi_jz.file.ini;

import sys.FileSystem;
import haxe.io.Path;
import sys.io.File;

@:keep // Avoid dead code elimination
class IniFile extends Section {
    public static inline var EXTENTION = ".ini";
    
    public var path:Path;
    public var sections(default, null):List<Section> = new List<Section>();


    public function new(fileName:String, dir:String = null) {
        super(null, Logger.OS_LINE_SEPARATOR);
        if(dir == null){
            dir = new Path(Sys.programPath()).dir;
        }
        this.path = new Path(Path.join([dir, fileName + EXTENTION]));
        new Logger().log("Instantiated " + this.path.toString());
    }


    public function save():Bool {
        new Logger().log("Saving " + path.file + '.' + path.ext);

        var content = getTextContent();

        if(!FileSystem.exists(path.dir)){
            FileSystem.createDirectory(path.dir);
        }
        File.saveContent(path.toString(), content);

        return true;
    }

    public function load():Bool {
        var l = new Logger();
        if(!exists()){
            l.warn("Couldn't load " + path.toString());
            return false;
        }
        l.log("Loading " + path.file + '.' + path.ext);

        clear();

        var loadedLineSeparator = getFileLineSeparator();
        if(loadedLineSeparator != null){
            lineSeparator = loadedLineSeparator;
        }
        var content = File.getContent(path.toString()).split(lineSeparator);
        var lineNum = 0;

        for(line in content){
            lineNum++;
            if(StringTools.startsWith(line, "[") && StringTools.endsWith(line, "]")){ //righthand: line.substr((line.length - LINE_SEPARATOR.length) - 1) == "]"
                sections.add(new Section(line.substr(1, line.length - 2), lineSeparator));
                l.log("Added section: " + line);
            }

            else { // key expected
                var equalsPos = line.indexOf("=");
                var isComment = Key.isStrAComment(line);
                if(equalsPos > 0 || isComment){
                    // Add a key
                    var key:Key = null;
                    if(isComment){
                        key = new Comment(line);
                    }
                    else if(equalsPos > 0) {
                        key = new Key(
                            line.substring(0, equalsPos),
                            line.substring(equalsPos + 1)
                        );
                    }

                    if(sections.isEmpty()){
                        keys.add(key);
                        l.log("Added key: " + line);
                    }
                    else {
                        sections.last().keys.add(key);
                        l.log("Added key: " + line + " to section [" + sections.last().name + "]");
                    }
                }
                else {
                    l.warn("Ignored line " + lineNum + " of "
                        + path.file + '.' + path.ext + " \"" + line + "\"");
                }
            }
        }
        l.log("Loaded " + path)
        .log("Content: " + lineSeparator + getTextContent());

        return true;
    }

    public function delete():Bool {
        if(!exists()){
            return false;
        }

        new Logger().log("Deleting " + path.toString());
        sys.FileSystem.deleteFile(path.toString());

        return !exists();
    }

    public function exists():Bool {
        return path != null
            && sys.FileSystem.exists(path.toString())
            && !sys.FileSystem.isDirectory(path.toString());
    }

    public function clear(){
        sections.clear();
        keys.clear();
        lineSeparator = Logger.OS_LINE_SEPARATOR;
    }

    private function strContains(str:String, contains:String):Bool {
        return str.indexOf(contains) > -1;
    }

    public function getFileLineSeparator():Null<String> {
        var nl = null;

        var l = new Logger();
        var nlStr:String = null;

        var content = super.getTextContent();
        if(content.length > 0){
            if(content.indexOf('\r\n') >= 0 || content.indexOf('\n\r') >= 0){
                nl = "\r\n";
                nlStr = "CR LN";
            }
            else if(content.indexOf('\n') >= 0){
                nl = "\n";
                nlStr = "LN";
            }
            else if(content.indexOf('\r') >= 0){
                nl = '\r';
                nlStr = "CR";
            }
        }
        l.log('Found line separator $nlStr in file');

        return nl;
    }

    override public function getTextContent():String {
        var content = super.getTextContent();
        content = content.substring(content.indexOf(lineSeparator) + 1); // trim the first line (name of the section this file represents)

        for(section in sections){
            content += section.getTextContent();
        }

        return StringTools.trim(content);
    }

    override function get_name():String {
        return path.file;
    }
}
