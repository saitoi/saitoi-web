#!/opt/homebrew/bin/raku

use Grammar::Tracer;

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

    proto token paragraph { * }
          token paragraph:sym<default> { <line:sym<default>>+ %% \n }
          token paragraph:sym<code>    { '```' \n <line:sym<default>>+ %% \n '```' }

    proto token line              { * }
          token line:sym<default> { <word>+ %% \h+ }
          token line:sym<bold>    { '*' <word:sym<bold>>+ %% \h+ '*' }      
          token line:sym<italic>  { '**' <word:sym<italic>>+ %% \h+ '**' }      
          token line:sym<code>    { '`' <word:sym<code>>+ %% \h+ '`' }

    proto token word              { * }
          token word:sym<bold>    { '*' <word:sym<default>> '*' }
          token word:sym<italic>  { '**' <word:sym<default>> '**' }
          token word:sym<code>    { '`' <word:sym<default>> '`' }
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

    # proto methods
    method paragraph:sym<default> ($/)  { make "<p>\n{$<line>.map("  " ~ *.made).join("<br>")}\n</p>" }
    method paragraph:sym<code>    ($/)  { make "<pre><code>\n{$<line>.map("  " ~ *.made).join("<br>")}\n</code></pre>" }

    method line:sym<default> ($/) { make $<word>.map(*.made).join(' ') }
    method line:sym<bold>    ($/) { make "<strong>" ~ $<word>.map(*.made).join(' ') ~ "</strong>" }
    method line:sym<italic>  ($/) { make "<em>" ~ $<word>.map(*.made).join(' ') ~ "</em>" }
    method line:sym<code>    ($/) { make "<code>" ~ $<word>.map(*.made).join(' ') ~ "</code>" }

    method word:sym<bold>    ($/) { make "<strong>{$<word>.made}</strong>" }
    method word:sym<italic>  ($/) { make "<em>{$<word>.made}</em>" }
    method word:sym<code>    ($/) { make "<code>{$<word>.made}</code>" }
    method word:sym<default> ($/) { make ~$/ }
}

my Str $doc = $*IN.slurp;

my Match $m = md-to-html.parse($doc, actions => md-to-html-actions.new);
say $m ?? $m<page>.made !! "Parse failed";
