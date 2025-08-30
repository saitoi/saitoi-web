#!/opt/homebrew/bin/raku

grammar md-to-html {
    token TOP       { ^ <header> \n+ <body> $ }
    token header    { (<[#]>+) \h+ <line> }
    token body      { <paragraph>+ %% \n }
    token paragraph { <line>+ %% \n }
    token line      { <word>+ %% \h+ }
    token word      { \w+ }
}

# sub MAIN ( Str $md ) {
#     my $parsed = md-to-html.parse($md);
#     say $parsed;
# }

my $doc = q:to/END/;
# Hello
This is a paragraph
This is also inside the same pg

This is another paragraph
END

say $doc;
my $m = md-to-html.parse($doc);
say $m;
