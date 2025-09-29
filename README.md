# Features

- [x] Tags: \<tag1\> \<tag2\> ...
- [ ] Localização: Acima do subtitle.
- [ ] Diferenciar subtítulos.
- [x] Código inline.
- [x] Palavra com código inline.
- [x] Blocos de código com ```bloco```.
- [x] Imagens (paragraph).
- [x] Links.
- [ ] Footnote.
- [x] Divisores.
- [x] Colunas.
- [ ] CSS padrão.
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
