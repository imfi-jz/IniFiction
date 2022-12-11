package nl.imfi_jz.test.file.ini;

import nl.imfi_jz.file.ini.Key;
import nl.imfi_jz.file.ini.IniFile;

class BuildLog {
    public function new() {
    }

    public function exec() {
        var versionLog = new IniFile("build");
        versionLog.load();

        if(versionLog.keys.isEmpty()){
            versionLog.keys.add(new Key("iBuild", "0"));
        }
        var version = Std.parseInt(versionLog.keys.first().value) + 1;
        versionLog.keys.first().value = Std.string(version);
        versionLog.save();
    }
}
