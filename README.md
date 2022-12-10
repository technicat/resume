My résumé in [JSON](https://jsonresume.org/)

## Extensions

resume.scm processes additions to the original [schema](https://github.com/jsonresume/resume-schema/issues), including images for projects, schools, and awards.

## Scripts

Output to various formats using scripts written in [Gauche](https://practical-scheme.net/gauche/).

## Markdown

Markdown output is created thus (and copied via GitHub Actions to the [GitHub page](http://philipchu.com) of this repo).

```sh
./resume.scm -f resume.json -o index.md
```

## HTML and PDF

```sh
./themes.scm
```

Themes.scm exports the resume.json to HTML and PDF using [resume-cli](https://github.com/jsonresume/resume-cli) and various [themes](https://jsonresume.org/themes/) (all the ones I could find that didn't generate too many warnings or errors). It requires the themes be installed local to the project via npm.

## Other

This is an improvement, at least in presentation, over my old [XML résumé format](https://github.com/technicat/resumexml), and for fun I copied a [WGL résumé](https://github.com/technicat/resumewgl).

## License

The Gauche scripts are MIT License. Feel free to use my résumé JSON file as a template. Recruiters, you do not have permission to put these in your database.

