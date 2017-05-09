# Markdown2LaTeX2PDF

markdown to PDF converter

## with docker

you can use with docker.

build:

```
$ cd docker
$ docker build -t md2pdf .
```

and run:

```
$ docker run -v $PWD:/workdir --rm md2pdf
```

the container compile $PWD/document.md to $PWD/document.pdf.
if there is template.tex in $PWD, the container use it.

## without docker

### requirements

this script require blow.

* LaTeX (platex and dvipdfms is required.)
* Pandoc
* python
* PyYAML

recommended installing TeXLive

### how to run

```
$ ./md2pdf.sh document.md
```

#### use with goemon

if you want to use with [goemon](https://github.com/mattn/goemon), you can use goemon.yml or goemon-with-template.yml.

you can also do this:

```
$ goemon --
```

## more detail

you can find more detail in document.md or document.pdf(this pdf file is generated with this script).

## Pandoc

this script is wrapper of pandoc.
