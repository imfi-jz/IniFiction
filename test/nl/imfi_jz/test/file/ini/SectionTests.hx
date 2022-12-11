package nl.imfi_jz.test.file.ini;

import nl.imfi_jz.file.ini.Logger;
import utest.Assert;
import nl.imfi_jz.file.ini.Key;
import nl.imfi_jz.file.ini.Section;

class SectionTests extends utest.Test {

    public function testInitialisation() {
        var s = new Section("Test section");

        Assert.isFalse(s == null);
        Assert.equals("Test section", s.name);
        Assert.equals(0, s.keys.length);
    }

    public function testGetContent() {
        var s = new Section("section1");

        Assert.equals(
            "[section1]" + Logger.OS_LINE_SEPARATOR + Logger.OS_LINE_SEPARATOR,
            s.getTextContent()
        );

        s.keys.add(new Key("key1", "value1"));
        s.keys.add(new Key("key2", "value2"));
        s.keys.add(new Key("key3", "value3"));

        Assert.equals(
            "[section1]" + Logger.OS_LINE_SEPARATOR +
            "key1=value1" + Logger.OS_LINE_SEPARATOR +
            "key2=value2" + Logger.OS_LINE_SEPARATOR +
            "key3=value3" + Logger.OS_LINE_SEPARATOR + Logger.OS_LINE_SEPARATOR,
            s.getTextContent()
        );
    }
}
