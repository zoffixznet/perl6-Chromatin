unit class Chromatin::Command::generate;

use Chromatin::Util::Template;

method run ($name, *@args, *%args) {
    $name.chars or die "Usage: chroma generate MODULE-NAME";
    my %params = :dist-name($name), :dist-version('0.001001');
    copy-template 'README.md', :%params;
    copy-template 'META6.json', :%params;
}
