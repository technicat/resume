#!/usr/local/bin/gosh

; reads a json-resume
; not sure what to do next

(use gauche.parseopt)
(use rfc.json)

(define (main args)
 (let-args (cdr args)
  ((h "h|help" => (cut help (car args)))
   (f "f|file=s")
   (v "v|verbose")
   . restargs)
  (if (not h)
   (if f
    (print (read-resume f))))))

(define (help file)
 (print "Read JSON resume"))

(define (read-resume file)
 (guard (e (else (print #"JSON error in ~file")
            (print (condition-message e))
            #\f))
  (let ((exp (call-with-input-file file parse-json)))
   exp)))

