package nl.imfi_jz.file.ini;

class Section implements TextContent {
    public var name(get, set):String;
    private var nameVar:String;
    public var keys(default, null):List<Key> = new List<Key>();
    public var lineSeparator(default, null):String;


    public function new(name:String, lineSeparator:String = '\r\n') {
        this.name = name;
        this.lineSeparator = lineSeparator;
    }


    public function getTextContent():String {
        var content = "";
        if(name != null && name.length > 0){
            content += '[' + name + ']' + lineSeparator;
        }

        for(key in keys){
            content += key.getTextContent() + lineSeparator;
        }

        content += lineSeparator;

        return content;
    }

    function get_name():String {
        return nameVar;
    }

    function set_name(value:String):String {
        return this.nameVar = value;
    }
}
