#!/usr/local/bin/gosh

(use gauche.parseopt)

(define (main args)
 (let-args (cdr args)
  ((h "h|help" => (cut help (car args)))
   . restargs)
  (if (not h)
   (use-themes))))

(define (use-themes)
 (theme "actual")
 (theme "even")
 (theme "github")
 (theme "jacrys")
 (theme "kendall")
 (theme "orbit"))

(define (help file)
 (print "Convert JSON resume to HTML"))

(define (theme theme)
 (print #"applying theme ~theme")
;; (sys-system #"npx resumed render -o html/~|theme|.html -t ~theme")
 (sys-system #"npx resumed render -o pdf/~|theme|.pdf -t ~theme")
 (sys-system #"npx resume-cli export html/~|theme|.html -t ~theme")
 (sys-system #"npx resume-cli export pdf/~|theme|.pdf -t ~theme")
 )

