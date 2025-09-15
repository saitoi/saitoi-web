#!/opt/homebrew/bin/raku

my Str $html-boilerplate-upper = q:to/END/;
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>HTML 5 Boilerplate</title>
    <link rel="stylesheet" href="style.css">
  </head>
  <body>
END

my Str $html-boilerplate-lower = q:to/END/;
    <script src="index.js"></script>
  </body>
</html>
END

grammar md-to-html {
    token TOP        { ^ <page> $ }
    token page       { <header> \n+ <body> }
    token header     { (<[#]>+) \h+ <line> }
    token body       { [ <line:sym<italic>> \n ** 2..* ]? <paragraph>+ %% \n }
    token paragraph  { <line:sym<default>>+ %% \n }

    proto token line              { * }
          token line:sym<default> { <word>+ %% \h+ }
          token line:sym<bold>    { '*' <word:sym<bold>>+ %% \h+ '*' }      
          token line:sym<italic>  { '**' <word:sym<italic>>+ %% \h+ '**' }      
          token line:sym<icode>   { '`' <word:sym<code>>+ %% \h+ '`' }

    proto token word              { * }
          token word:sym<bold>    { '*' <word:sym<default>> '*' }
          token word:sym<italic>  { '**' <word:sym<default>> '**' }
          token word:sym<icode>   { '`' <word:sym<default>> '`' }
          token word:sym<default> { \w+ }
}

class md-to-html-actions {
    method TOP ($/) { make $<page> }
    method page ($/) {
        make qq:to/END/; {$html-boilerplate-upper}
              {$<header>.made}
              {$<body>.made}
            {$html-boilerplate-lower}
            END
    }
    method header ($/) {
        my $level = $0.chars;
        make "<h{$level}>{$<line>.Str}</h{$level}>";
    }
    method body ($/)       { make $<paragraph>.map(*.made).join("\n") }
    method paragraph ($/)  { make "<p>\n{$<line>.map("  " ~ *.made).join("<br>")}\n</p>" }

    method line:sym<default> ($/) { make $<word>.map(*.made).join(' ') }
    method line:sym<bold>    ($/) { make "<strong>" ~ $<word>.map(*.made).join(' ') ~ "</strong>" }
    method line:sym<italic>  ($/) { make "<em>" ~ $<word>.map(*.made).join(' ') ~ "</em>" }
    method line:sym<icode>   ($/) { make "<code>" ~ $<word>.map(*.made).join(' ') ~ "</code>" }

    # proto methods
    method word:sym<bold>    ($/) { make "<strong>{$<word>.made}</strong>" }
    method word:sym<italic>  ($/) { make "<em>{$<word>.made}</em>" }
    method word:sym<icode>   ($/) { make "<code>{$<word>.made}</code>" }
    method word:sym<default> ($/) { make ~$/ }
}


my Str $doc = q:to/END/;
# Hello
This is a paragraph
This is also inside the same pg
This is *bold*
This is an `inline` `code`

`This an inline line`
**This is an italic line**
*This is a bold line*

This is another paragraph and **italic**
END

my Match $m = md-to-html.parse($doc, actions => md-to-html-actions.new);
say $m ?? $m<page>.made !! "Parse failed";
