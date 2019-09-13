# Fyodor

Convert your Amazon Kindle highlights and notes into markdown files.

## What is it about
This application parses `My Clippings.txt` from your Amazon Kindle and generates a markdown file for each/book document.

This way, you have the highlights and notes for each book you read conveniently stored and easily manipulable.

Unlike other similar applications, this one tries to be locale agnostic, so it should work whichever language you are using.

## How to run

The only dependency is Ruby. Clone the repo with:

```
$ git clone https://github.com/rccavalcanti/fyodor.git
```

And run:

```
$ cd fyodor/app
$ ./app.rb CLIPPINGS_FILE OUTPUT_DIR
```

Where:
* `CLIPPINGS_FILE` is the path for `My Clippings.txt`
* `OUTPUT_DIR` is the path to the directory where you want to the markdown files to be written

## LICENSE

Released under [GNU GPL v3](LICENSE).

Copyright 2019 Rafael Cavalcanti <hi@rafaelc.org>