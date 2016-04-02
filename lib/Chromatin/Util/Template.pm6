unit module Chromatin::Util::Template;
use Template::Protone;

my $templates-dir = $*SPEC.catdir: home-dir, <.chromatin templates>;

sub copy-template (
    Str:D $name,
    Str:D $dest = $*SPEC.catdir($*SPEC.curdir, $name),
    :%params,
    --> IO::Path
) is export {
    my $t = template $name;
    $dest.IO.e and die "$dest already exists. Won't overwrite.";
    spurt $dest, Template::Mojo.new($t.slurp).render: %params;
    return $dest.IO;
}

sub home-dir (--> Str) {
    return do given $*KERNEL.name {
        when %*ENV<HOME> | 'linux' | 'darwin' { %*ENV<HOME>; }
        when 'win32' { %*ENV<HOMEDRIVE> ~ %*ENV<HOMEPATH> }
        default {
            die 'Failed to determine your home directory. Please set HOME'
                ~ ' environmental variable to the appropriate path';
        }
    }
}

sub template (Str:D $name --> IO::Path) {
    my $t = $*SPEC.catfile($templates-dir, $name).IO;
    $t.e or $t = %?RESOURCES{ $*SPEC.catfile: 'templates', $name };
    $t.e or die "Cound not find template `$name` neither in home templates "
        ~ "directory ($templates-dir) nor in Chromatin's core templates.";
    return $t;
}




my $templ = Template::Protone.new;

$templ.parse(template => [q|
Hello <% print "WORLD!"; %>

Oh, did you want variables too?  I can do <% print $data<what>; %> too.

<% for ^3 { %>
<% print $_ ~ ($_ == 2 ?? '' !! ', '); %>
<% } %>
|], :name<example>);

say $templ.render(:name<example>, :data(what => 'that'))
