package nl.imfi_jz.file.ini;

class Key implements TextContent {
    public var key:String;
    public var value:String;


    public function new(key:String, value:String = null) {
        this.key = key;
        this.value = value;
    }


    public function getTextContent():String {
        var keyContent = key;
        var valContent = value;

        if(keyContent == null){
            keyContent = "";
        }
        
        if(valContent == null){
            return keyContent;
        }
        else if(keyContent.length > 0){
            return keyContent + "=" + valContent;
        }
        else return valContent;
    }

    public function hasValue():Bool {
        if(value == null || value == ""){
            return false;
        } else for(char in value.split("")){
            if(!StringTools.isSpace(char, 0) && char != ""){
                return true;
            }
        }
        return false;
    }

    public function isComment():Bool {
        if(value == null){
            return isStrAComment(key);
        }
        else if(key == null || key.length <= 0){
            return isStrAComment(value);
        }
        else return false;
    }

    public static inline function isStrAComment(str:String):Bool {
        return StringTools.startsWith(StringTools.ltrim(str), Comment.COMMENT_CHARACTER);
    }
}
