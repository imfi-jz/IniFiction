package nl.imfi_jz.test.file.ini;

import utest.ui.Report;
import utest.Runner;

class Entry {
    public function new() {
        
    }

    static function main() {
        final runner = new Runner();
        runner.addCases(nl.imfi_jz.test.file.ini);

        Report.create(runner);
        runner.run();
        
        new BuildLog().exec();
    }
}