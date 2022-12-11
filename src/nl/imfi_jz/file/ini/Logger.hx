package nl.imfi_jz.file.ini;

class Logger {
    public static var OS_LINE_SEPARATOR(default, null) = getOsLineSeparator();

    public inline function new() {

    }

    private static function getOsLineSeparator():String {
        var nl:String = "\n";

        var l = new Logger();
        l.log("System name: " + Sys.systemName());

        if(Sys.systemName().substr(0, "Windows".length).toUpperCase() == "WINDOWS"){
            nl = "\r\n";
            l.log("OS line separator: \\r\\n");
        }
        else l.log("Line separator: \\n");

        return nl;
    }

    public inline function warn(warning) {
        #if warn
            Sys.println(OS_LINE_SEPARATOR + "Warning: " + warning);
        #end
        return this;
    }

    public inline function log(message) {
        #if (inifiction_log)
            Sys.println(OS_LINE_SEPARATOR + "Log: " + message);
        #end
        return this;
    }
}
