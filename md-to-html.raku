#!/opt/homebrew/bin/raku

grammar md-to-html {
    token TOP       { ^ <header> \n+ <body> $ }
    token header    { (<[#]>+) \h+ <line> }
    token body      { <paragraph>+ %% \n }
    token paragraph { <line>+ %% \n }
    token line      { <sup-word>+ %% \h+ }
    token sup-word  { <bword> | <iword> | <word> } # convert to proto token later
    token bword     { '*' <word> '*' }
    token iword     { '**' <word> '**' }
    token word      { \w+ }

}

class md-to-html-actions {
    method header ($/) {
        my $level = $0.chars;
        make "<h{$level}>{$<line>.Str}</h{$level}>";
    }
    method word ($/) { make $/.Str }
    method bword ($/) { make "<strong>{$<word>.made}</strong>" }
    method iword ($/) { make "<em>{$<word>.made}</em>" }
    method sup-word  ($/) { make $<bword> ?? $<bword>.made !! $<iword> ?? $<iword>.made !! $<word>.made }
    method line ($/)       { say make $<sup-word>.map(*.made).join(' ') }
    method paragraph ($/)  { make "<p>\n{$<line>.map("\t" ~ *.made).join("\n")}\n</p>" }
    method body ($/)       { make $<paragraph>.map(*.made).join("\n") }
    method TOP ($/)        { make { header => $<header>.made, body => $<body>.made } }
}

my $doc = q:to/END/;
# Hello
This is a paragraph
This is also inside the same pg
This is *bold*

This is another paragraph and **italic**
END

my $m = md-to-html.parse($doc, actions => md-to-html-actions.new);
say $m ?? $m.made !! "Parse failed";
