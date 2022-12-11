package nl.imfi_jz.test.file.ini;

import utest.Assert;
import nl.imfi_jz.file.ini.Logger;
import nl.imfi_jz.file.ini.IniFile;
import haxe.io.Path;
import nl.imfi_jz.file.ini.Key;
import nl.imfi_jz.file.ini.Section;

class IniFileTests extends utest.Test {

    public function testInitialisation() {
        var ini = new IniFile("testfile");

        var dir = new Path(Sys.programPath()).dir;

        Assert.isFalse(ini == null);
        Assert.equals(Path.join([dir, "testfile" + IniFile.EXTENTION]), ini.path.toString());
        Assert.equals("testfile", ini.name);
        Assert.equals(0, ini.keys.length);
        Assert.equals(0, ini.sections.length);
    }

    public function testClear() {
        var ini = getTestFile();

        ini.keys.add(new Key("Main", "123"));

        Assert.equals(2, ini.sections.length);
        Assert.equals(2, ini.keys.length);

        ini.clear();

        Assert.equals(0, ini.keys.length);
        Assert.equals(0, ini.sections.length);
    }

    public function testSave() {
        var ini = new IniFile("Test IniFile");

        Assert.isTrue(ini.save());

        ini = getTestFile();

        Assert.isTrue(ini.save());

        ini.sections.first().keys.remove(ini.sections.first().keys.last());

        Assert.isTrue(ini.save());

        ini.sections.first().keys.remove(ini.sections.first().keys.first());

        Assert.isTrue(ini.save());
    }

    public function testLoad() {
        var l = new Logger().log("Starting load test");
        var ini = new IniFile("Test IniFile");
        ini.path = new Path("");

        Assert.isFalse(ini.load());
        Assert.equals(0, ini.sections.length);
        Assert.isTrue(ini.keys.isEmpty());

        ini = getTestFile();
        ini.save();

        Assert.isTrue(ini.load());
        Assert.equals(1, ini.keys.length);
        Assert.equals(2, ini.sections.length);
        Assert.equals(3, ini.sections.first().keys.length);
        Assert.equals(
            (
                "; Test comment2" + Logger.OS_LINE_SEPARATOR +
                Logger.OS_LINE_SEPARATOR +
                "[Test Section]" + Logger.OS_LINE_SEPARATOR +
                "Test key=Test value" + Logger.OS_LINE_SEPARATOR +
                "Test key2=Test value2" + Logger.OS_LINE_SEPARATOR +
                ";Test comment=Test value3" + Logger.OS_LINE_SEPARATOR +
                Logger.OS_LINE_SEPARATOR +
                "[Test Section 2]" + Logger.OS_LINE_SEPARATOR +
                "; Test comment2"
            ).length,
            ini.getTextContent().length
        );

        var path = ini.path;
        ini = new IniFile(null , "lmao");
        ini.path = path;

        Assert.isTrue(ini.load());

        Assert.equals(1, ini.keys.length);
        Assert.equals(2, ini.sections.length);
        Assert.equals(3, ini.sections.first().keys.length);
        Assert.equals(
            (
                "; Test comment2" + Logger.OS_LINE_SEPARATOR +
                Logger.OS_LINE_SEPARATOR +
                "[Test Section]" + Logger.OS_LINE_SEPARATOR +
                "Test key=Test value" + Logger.OS_LINE_SEPARATOR +
                "Test key2=Test value2" + Logger.OS_LINE_SEPARATOR +
                ";Test comment=Test value3" + Logger.OS_LINE_SEPARATOR +
                Logger.OS_LINE_SEPARATOR +
                "[Test Section 2]" + Logger.OS_LINE_SEPARATOR +
                "; Test comment2"
            ).length,
            ini.getTextContent().length
        );
        l.log("Ended load test");
    }

    public function testExists() {
        var ini = new IniFile("AFile");

        Assert.equals(
            sys.FileSystem.exists(ini.path.toString())
                && !sys.FileSystem.isDirectory(ini.path.toString())
                && ini.path.ext == IniFile.EXTENTION.substr(1),
            ini.exists()
        );
    }

    public function testDelete() {
        var ini = getTestFile();

        if(!ini.exists()){
            Assert.isTrue(ini.save());
        }

        Assert.isTrue(ini.delete());
        Assert.isFalse(ini.exists());
    }

    public function testDefaultPath() {
        var ini = getTestFile();

        Assert.notEquals(true, ini.path.backslash);
        Assert.stringContains(
            "/file/ini/testini.ini",
            ini.path.toString()
        );

        ini = new IniFile("Test ini", "C:/home");

        Assert.notEquals(true, ini.path.backslash);
        Assert.equals("C:/home/Test ini.ini", ini.path.toString());
    }

    private function getTestFile():IniFile {
        var ini = new IniFile("testini");

        var s = new Section("Test Section", ini.lineSeparator);
        var s2 = new Section("Test Section 2", ini.lineSeparator);
        var k = new Key("Test Key", "Test value");
        var k2 = new Key("Test Key2", "Test value2");
        var k3 = new Key(";Test comment", "Test value3");
        var k4 = new Key("; Test comment2");

        s.keys.add(k);
        s.keys.add(k2);
        s.keys.add(k3);
        s2.keys.add(k4);

        ini.keys.add(k4);

        ini.sections.add(s);
        ini.sections.add(s2);

        return ini;
    }

    public function teardown():Void {
        new IniFile("Test IniFile").delete();
        /*var test = getTestFile();
        test.save();
        test.load();
        test.save();
        test.load();
        test.save();*/
    }
}
