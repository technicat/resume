My résumé in [JSON](https://jsonresume.org/), output to various formats using scripts written in [Gauche](https://practical-scheme.net/gauche/).

Markdown output is created thus (and copied via GitHub Actions to the [GitHub page](http://philipchu.com) of this repo).

```sh
./resume.scm -f resume.json -o index.md
```

resume.scm processes additions to the original [schema](https://github.com/jsonresume/resume-schema/issues), including images for projects, schools, and awards.

Themes.scm exports the resume.json to HTML and PDF using [resume-cli](https://github.com/jsonresume/resume-cli) and various [themes](https://jsonresume.org/themes/) (all the ones I could find that didn't generate too many warnings or errors). It requires the themes be installed local to the project via npm.

## License

The Gauche scripts are MIT License. Feel free to use my résumé JSON file as a template. Recruiters, you do not have permission to put these in your database.

