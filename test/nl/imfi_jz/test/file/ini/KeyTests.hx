package nl.imfi_jz.test.file.ini;

import nl.imfi_jz.file.ini.Comment;
import utest.Assert;
import nl.imfi_jz.file.ini.Key;

class KeyTests extends utest.Test {

    public function testInitialisation() {
        var k = new Key(null, null);

        Assert.isFalse(k == null);
        Assert.equals(null, k.key);
        Assert.equals(null, k.value);
    }

    public function testGetContent() {
        var k = new Key("", null);

        Assert.equals("", k.getTextContent());

        k.key = "Some key";
        k.value = "true";

        Assert.equals("Some key=true", k.getTextContent());
    }

    public function testComment() {
        var k = new Key("Test");
        var c = new Comment("Test");
        var c2 = new Comment(";Test");

        Assert.equals("Test", k.getTextContent());
        Assert.equals("; Test", c.getTextContent());
        Assert.equals(";Test", c2.getTextContent());
    }
}
