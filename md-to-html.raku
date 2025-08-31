#!/opt/homebrew/bin/raku

my $html-boilerplate-upper = q:to/END/;
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

my $html-boilerplate-lower = q:to/END/;
    <script src="index.js"></script>
  </body>
</html>
END

grammar md-to-html {
    token TOP        { ^ <page> $ }
    token page       { <header> \n+ <body> }
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
    method TOP ($/) { make $<page> }
    method page ($/) {
        make qq:to/END/;
            {$html-boilerplate-upper}
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
    method line ($/)       { make $<word>.map(*.made).join(' ') }
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
say $m ?? $m<page>.made !! "Parse failed";
