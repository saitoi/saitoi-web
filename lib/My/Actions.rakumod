unit class My::Actions;

my Str $html-boilerplate-upper = q:to/END/;
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>HTML 5 Boilerplate</title>
    <meta name="keywords" content="%s">
    <link rel="stylesheet" href="style.css">
  </head>
  <body>
END

my Str $html-boilerplate-lower = q:to/END/;
    <script src="index.js"></script>
  </body>
</html>
END

method TOP ($/) { make $<page>.made }
method page ($/) {
    make sprintf($html-boilerplate-upper, $<tag>.made) ~ qq:to/END/;
      {$<header>.made}
      {$<body>.made}
    {$html-boilerplate-lower}
    END
}
method header ($/) {
    my Int $level = $0.chars;
    make qq[<h{$level}>{$<line>.Str}</h{$level}>];
}
method body  ($/)       { make $<paragraph>.map(*.made).join("\n") }
method tag   ($/)       { make $<word>.map(*.made).join(", ") }
method digit ($/)       { make ~$/ }

# proto methods
method paragraph:sym<default> ($/) {
    make qq:to/HTML/.chomp;
    <p>
    {$<line>.map("  " ~ *.made).join("<br>\n")}
    </p>
    HTML
}
method paragraph:sym<code> ($/) {
    make qq:to/HTML/.chomp;
    <pre><code>
    {$<line>.map("  " ~ *.made).join("\n")}
    </code></pre>
    HTML
}
method paragraph:sym<divisor> ($/) { make qq[<hr>] }
method paragraph:sym<columns> ($/) {
    make qq:to/HTML/.chomp;
    <table>
    <tr>
    {$<paragraph>.map({ qq[<td>{.made}</td>] }).join("\n")}
    </tr>
    </table>
    HTML
}
method paragraph:sym<subtitle> ($/) {
    my Int $level = $<level>.chars;
    make qq[<h{$level}>{$<line>.made}</h{$level}>];
}
method paragraph:sym<list> ($/) {
    my @nodes = $<list_item>.Array;
    make self.build_list(@nodes, 0);
}
method build_list(@nodes, $current_indent) {
    return "" unless @nodes;
    my $first = @nodes[0];
    my $type = $first<marker> ~~ /\d/ ?? 'ol' !! 'ul';
    my $html = "<$type>\n";

    while @nodes {
        my $node = @nodes[0];
        my $indent = $node<indent>.chars;
        if $indent < $current_indent {
            last;
        }
        if $indent > $current_indent {
            # Improper nesting without a parent node - treat it as current level
            @nodes.shift;
            $html ~= "  " x ($current_indent/2 + 1) ~ "<li>{$node<line>.made}";
            if @nodes && @nodes[0]<indent>.chars > $indent {
                $html ~= "\n" ~ self.build_list(@nodes, @nodes[0]<indent>.chars);
            }
            $html ~= "</li>\n";
        } else {
            @nodes.shift;
            $html ~= "  " x ($current_indent/2 + 1) ~ "<li>{$node<line>.made}";
            if @nodes && @nodes[0]<indent>.chars > $indent {
                $html ~= "\n" ~ self.build_list(@nodes, @nodes[0]<indent>.chars);
            }
            $html ~= "</li>\n";
        }
    }
    $html ~= "  " x ($current_indent/2) ~ "</$type>";
    return $html;
}
method paragraph:sym<footnote_def> ($/) {
    my Str $id = ~$<id>;
    make qq[<div class="footnote" id="fn-{$id}"><sup>{$id}</sup> {$<line>.map(*.made).join('<br>')}</div>];
}
method paragraph:sym<image> ($/) {
    my Str $alt = ~$<alt>;
    my Str $src = ~$<src>;
    my Str $attrs = $<word> ?? qq[ width="{$<word>[0].made}" height="{$<word>[1].made}"] !! '';
    make qq[<img src="{$src}" alt="{$alt}"{$attrs}>];
}

method line:sym<default> ($/) { make $<word>.map(*.made).join(' ') }
method line:sym<bold>    ($/) { make qq[<strong>{$<word>.map(*.made).join(' ')}</strong>] }
method line:sym<italic>  ($/) { make qq[<em>{$<word>.map(*.made).join(' ')}</em>] }
method line:sym<code>    ($/) { make qq[<code>{$<word>.map(*.made).join(' ')}</code>] }

method word:sym<bold>    ($/) { make qq[<strong>{$<word>.made}</strong>] }
method word:sym<italic>  ($/) { make qq[<em>{$<word>.made}</em>] }
method word:sym<code>    ($/) { make qq[<code>{$<word>.made}</code>] }
method word:sym<link> ($/) {
    my Str $desc = ~$<desc>;
    my Str $src = ~$<src>;
    make qq[<a href="{$src}">{$desc}</a>];
}
method word:sym<footnote_ref> ($/) {
    my Str $id = ~$<id>;
    make qq[<sup id="fnref-{$id}"><a href="#fn-{$id}">{$id}</a></sup>];
}
method word:sym<punct> ($/) { make ~$/ }
method word:sym<default> ($/) { make ~$/ }
