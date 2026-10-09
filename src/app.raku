#!/opt/homebrew/bin/raku
use lib 'lib';
use My::Grammar;
use My::Actions;

sub USAGE() {
    say q:to/END/;
md-to-html - Convert markdown structure to full fledged HTML site.

USAGE:
  mytool <command> [options] [args]

COMMANDS:
  help        
  verbose     Increase verbosity.
  build       Builds HTML site.
  deploy      Builds HTML site and deploys it.
  serve       Coming soon..

Run 'mytool <command> --help' for details.
END
}

multi sub MAIN(
    Str $file where *.IO.f && !($_ eq 'build' || $_ eq 'deploy'),
    Bool :v(:$verbose) = False,
) {
    my $content = $file.IO.slurp;
    my $match = My::Grammar.parse($content, actions => My::Actions.new);
    if $match {
        if $verbose {
            say "Parsed {$file} successfully.";
            say $match.made;
        } else {
            say "Success!!";
        }
    } else {
        say "Parse failed for {$file}..";
    }
}

multi sub MAIN(
    Bool :v(:$verbose) = False,
    Bool :t(:$test) = False,
) {
    if $test {
        my Int $i = 0;
        my &output = -> Match $f --> Str { $verbose ?? $f.made !! qq[Success!!] };
        "t".IO.dir(:recursive)
            ==> grep(*.f && *.extension eq qq[md])
            ==> map({ $_.slurp })
            ==> map({ My::Grammar.parse($_, actions => My::Actions.new) })
            ==> map({ $_ ?? &output($_) !! qq[Parse failed..] })
            ==> map({ spurt "output/t_{$i++}.html", $_ if $verbose })
    } else {
        USAGE();
    }
}

multi sub MAIN('build', Bool :v(:$verbose) = False) {
    say "Building HTML site..." if $verbose;
    unless "blog-md".IO.d {
        say "blog-md directory not found.";
        return;
    }
    unless "blog-html".IO.d {
        mkdir "blog-html";
    }

    my @files = "blog-md".IO.dir(:recursive).grep(*.f && *.extension eq qq[md]);
    for @files -> $f {
        say "Processing {$f.basename}..." if $verbose;
        my $match = My::Grammar.parse($f.slurp, actions => My::Actions.new);
        if $match {
            my $html-file = "blog-html/" ~ $f.basename.subst(/\.md$/, '.html');
            spurt $html-file, $match.made;
            say "Wrote {$html-file}" if $verbose;
        } else {
            say "Failed to parse {$f.basename}";
        }
    }
}

multi sub MAIN('deploy', Bool :v(:$verbose) = False) {
    say "Building HTML site..." if $verbose;
    unless "blog-md".IO.d {
        say "blog-md directory not found.";
        return;
    }
    unless "blog-html".IO.d {
        mkdir "blog-html";
    }

    my @files = "blog-md".IO.dir(:recursive).grep(*.f && *.extension eq qq[md]);
    for @files -> $f {
        say "Processing {$f.basename}..." if $verbose;
        my $match = My::Grammar.parse($f.slurp, actions => My::Actions.new);
        if $match {
            my $html-file = "blog-html/" ~ $f.basename.subst(/\.md$/, '.html');
            spurt $html-file, $match.made;
            say "Wrote {$html-file}" if $verbose;
        } else {
            say "Failed to parse {$f.basename}";
        }
    }
    say "Deploying..." if $verbose;
    say "Site deployed successfully!";
}
