#!/opt/homebrew/bin/raku

grammar md-to-html {
    token TOP        { ^ <header> \n+ <body> $ }
    token header     { (<[#]>+) \h+ <line> }
    token body       { <paragraph>+ %% \n }
    token paragraph  { <line>+ %% \n }
    token line       { <word>+ %% \h+ }

    proto token word              { * }
          token word:sym<bold>    { '*' <word:sym<default>> '*' }
          token word:sym<italic>  { '**' <word:sym<default>> '**' }
          token word:sym<default> { \w+ }
}

class md-to-html-actions {
    method TOP ($/) {
        make {
            header => $<header>.made,
            body => $<body>.made
        }
    }
    method header ($/) {
        my $level = $0.chars;
        make "<h{$level}>{$<line>.Str}</h{$level}>";
    }
    method line ($/)       { say make $<word>.map(*.made).join(' ') }
    method paragraph ($/)  { make "<p>\n{$<line>.map("\t" ~ *.made).join("\n")}\n</p>" }
    method body ($/)       { make $<paragraph>.map(*.made).join("\n") }
    # proto methods
    method word:sym<bold>    ($/) { make "<strong>{$<word>.made}</strong>" }
    method word:sym<italic>  ($/) { make "<em>{$<word>.made}</em>" }
    method word:sym<default> ($/) { make ~$/ }
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
