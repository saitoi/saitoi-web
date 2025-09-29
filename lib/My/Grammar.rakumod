unit grammar My::Grammar;

token TOP    { ^ <page> $ }
token page   { <header> \n ** 2 <tag> \n+ <body> }
token header { (<[#]>+) \h+ <line> }
token body   { <paragraph>+ %% \n+ }
token tag    { [ '<' <word:sym<default>> '>' \h* ]* }
token digit  { \d+ }

proto token paragraph              { * }
      token paragraph:sym<default> { <line>+ %% \n }
      token paragraph:sym<code>    { '```' \n <line:sym<default>>+ %% \n \n? '```' }
      token paragraph:sym<divisor> { '---' \h* }
      token paragraph:sym<columns> { [ '{' <paragraph:sym<default>> '}' ]+ %% [\h* \n | \h*] }
      token paragraph:sym<image>   { '![' $<alt>=[ <-[\]]>+ ] ']' '(' $<src>=[ <-[)]>+ ] ')' [ '{' \h* 'width=' <word> \h* 'height=' \h* <word> \h* '}' ]? \h* }

proto token line              { * }
      token line:sym<default> { <word>+ %% \h+ }
      token line:sym<bold>    { '*' <word:sym<default>>+ %% \h+ '*' }
      token line:sym<italic>  { '**' <word:sym<default>>+ %% \h+ '**' }
      token line:sym<code>    { '`' <word:sym<default>>+ %% \h+ '`' }

proto token word              { * }
      token word:sym<bold>    { '*' <word:sym<default>> '*' }
      token word:sym<italic>  { '**' <word:sym<default>> '**' }
      token word:sym<code>    { '`' <word:sym<default>> '`' }
      token word:sym<link>    { '[' $<desc>=[ <-[\]]>+ ] ']' '(' $<src>=[ <-[)]>+ ] ')' }
      token word:sym<default> { \w+ }
