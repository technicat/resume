My résumé in [JSON](https://jsonresume.org/) with additions to the original [schema](https://github.com/jsonresume/resume-schema/issues), including images for projects, schools, and awards.

## Scripts

Output to various formats using scripts written in [Gauche](https://practical-scheme.net/gauche/).

## Markdown

Markdown output is created thus.

```sh
./md.scm -f resume.json -o index.md
```

## HTML and PDF

```sh
./themes.scm
```

Themes.scm exports the resume.json to HTML and PDF using [resume-cli](https://github.com/jsonresume/resume-cli) and various [themes](https://jsonresume.org/themes/) (all the ones I could find that didn't generate too many warnings or errors), plus my own [variation](https://github.com/technicat/jsonresume-theme-even-more). It requires the themes be installed local to the project via npm.

## Other

This is an improvement, at least in presentation, over my old [XML résumé format](https://github.com/technicat/resumexml), and for fun I copied a [WGL résumé](https://github.com/technicat/resumewgl).

## License

The Gauche scripts are MIT License. Feel free to use my résumé JSON file as a template. Recruiters, you do not have permission to put these in your [spam database](https://recruiterspam.net/).

