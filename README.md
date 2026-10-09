# Features

- [x] Tags: \<tag1\> \<tag2\> ...
- [x] Listas ordenadas, não ordenadas e recursivas.
- [x] Habilidade de testar um arquivo específico, passando o nome como argumento. Pode ser um `multi` da MAIN
- [x] Dockerfile.
- [x] Diferenciar subtítulos.
- [x] Homepage, About, Index Blog Posts.
- [x] Código inline.
- [x] Palavra com código inline.
- [x] Blocos de código com ```bloco```.
- [x] Imagens (paragraph).
- [x] Links.
- [x] Footnote.
- [x] Divisores.
- [x] Colunas.
- [x] CSS.
- [x] Modularizar.
- [x] CLI commands:
    - [x] verbose (v)
    - [x] deploy (d)
    - [x] build (d)

# Structure

```txt
saitoi-web
|
-> lib/
    |
    -> grammar.rakumod
    -> blog-structure.rakumod
-> bin/
    |
    -> app.raku
-> blog-md/
    |
    -> index.md
    -> ...
-> blog-html/
    |
    -> index.html
    -> ...
```
