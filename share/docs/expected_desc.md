# Expected description syntax

Fyodor tries to parse entry descriptions. This allows tasks related to a cleaner output, such as:

- Ignore duplicate entries.
- Order entries by location/page.
- Render the description in a shorter and more elegant way.
- Render each type of entry differently.

The syntax depends on the user language and on characteristics of the book/document. In this document, I keep track of what I've found until the date and coded Fyodor to expect.

## Default - English

### Highlights

```
- Your Highlight on Location 2637-2637 | Added on Monday, Setember 16, 2019 9:50:16 AM
- Your Highlight at location 311-317 | Added on Tuesday, 13 May 2020 03:05:21
- Your Highlight on page 315 | Location 4444-4444 | Added on Monday, September 16, 2019 10:06:01 AM
- Your Highlight on page 21-21 | Added on Monday, 12 May 2020 11:01:03
```

### Notes

```
- Your Note on Location 2435 | Added on Monday, September...
- Your Note on page 315 | Location 4444 | Added on Monday, September 16, 2019 10:06:09 AM
```

### Bookmarks

```
- Your Bookmark on Location 2434 | Added on Monday...
- Your Bookmark on page 315 | Location 4444 | Added on Monday...
```

### Clips

```
- Clip This Article on Location 401 | Added on Monday...
```

## Locale pt-br

```
- Seu destaque ou posição 2309-2311 | Adicionado: domingo, 15 de setembro de 2019 12:40:37
- Seu destaque na página 70 | posição 952-953 | Adicionado: quinta-feira...
- Sua nota ou posição 2383 | Adicionado: ...
- Seu marcador ou posição 2637 | Adicionado: segunda-feira, 16 de setembro de 2019 11:47:02
- Seu marcador na página 315 | posição 4445 | Adicionado: segunda-feira, 16 de setembro de 2019 11:45:54
- Recortar este artigo na posição 401 | Adicionado: segunda-feira, 16 de setembro de 2019 11:44:35
```
