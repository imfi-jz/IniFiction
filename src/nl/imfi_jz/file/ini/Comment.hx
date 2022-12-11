package nl.imfi_jz.file.ini;

class Comment extends Key {
    public static inline final COMMENT_CHARACTER = ';';

    public function new(comment:String) {
        super(comment);
        if(!Key.isStrAComment(comment)){
            key = '$COMMENT_CHARACTER ' + comment;
        }
    }
}