Résumé in [JSON](https://jsonresume.org/), exported to HTML and PDF using [resume-cli](https://github.com/jsonresume/resume-cli) and various [themes](https://jsonresume.org/themes/) (all the ones I could find that didn't generate too many warnings or errors).

The scripts themes.scm and resume.scm are written in [Gauche](https://practical-scheme.net/gauche/).

resume.scm processes additions to the original [schema](https://github.com/jsonresume/resume-schema/issues), such as project images.

Themes.scm also requires the themes be installed local to the project via npm.

