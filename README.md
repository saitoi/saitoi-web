# Features

- [x] Tags: \<tag1\> \<tag2\> ...
- [ ] Listas ordenadas, não ordenadas e recursivas.
- [ ] Habilidade de testar um arquivo específico, passando o nome como argumento. Pode ser um `multi` da MAIN
- [ ] Dockerfile.
- [ ] Diferenciar subtítulos.
- [ ] Homepage, About, Index Blog Posts.
- [x] Código inline.
- [x] Palavra com código inline.
- [x] Blocos de código com ```bloco```.
- [x] Imagens (paragraph).
- [x] Links.
- [ ] Footnote.
- [x] Divisores.
- [x] Colunas.
- [ ] CSS.
- [x] Modularizar.
- [ ] CLI commands:
    - [ ] verbose (v)
    - [ ] deploy (d)
    - [ ] build (d)

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
