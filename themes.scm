#!/usr/local/bin/gosh

(use gauche.parseopt)

(define (main args)
 (let-args (cdr args)
  ((h "h|help" => (cut help (car args)))
   (f "f|file=s")
   (o "o|out=s")
   (v "v|verbose")
   . restargs)
  (if (not h)
   (usetheme "even"))))

(define (help file)
 (print "Read/convert JSON resume"))

(define (usetheme theme)
 (sys-exec "resume" (list "resume"
                     "export" (string-append theme ".html")
                     "-t" theme))
 )

