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

sub MAIN(
    :v(:$verbose) = False,
    :t(:$test) = False,
) {
    if $test {
        "t".IO.dir(:recursive)
            ==> grep(*.f && *.extension eq qq[md])
            ==> map({ $_.slurp })
            ==> map({ My::Grammar.parse($_, actions => My::Actions.new) })
            ==> map({ say $_ ?? qq[Success!!] !! qq[Parse failed..] })
    }
}

# multi sub MAIN(
#     'init',
#     :v(:$verbose),
#     :dir(:$dir) = '.',
#     :$force,
# ) {
#     say "init dir=$dir verbose=$verbose force=$force";
# }

# multi sub MAIN('add',
#     :v(:$verbose),
#     *@files where *.elems > 0,
# ) {
#     say "add files=@files verbose=$verbose";
# }

# enum BuildMode <debug release>;
# multi sub MAIN('build',
#     BuildMode :m(:$mode) = 'debug',
#     Int :j(:$jobs where * > 0) = 4,
#     :I(:@include),
#     :D(:%define),
#     :o(:$output)!,
#     :$dry-run(:$dry_run),
# ) {
#     say "mode=$mode jobs=$jobs includes=@include defs=%define out=$output dry=$dry_run";
# }
