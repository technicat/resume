#!/usr/local/bin/gosh

; reads a json-resume
; not sure what to do next

(use gauche.parseopt)
(use file.util)
(use rfc.json)

(define (main args)
 (let-args (cdr args)
  ((h "h|help" => (cut help (car args)))
   (f "f|file=s")
   (o "o|out=s")
   (v "v|verbose")
   . restargs)
  (if (not h)
   (if f
    (let ((r (read-json f)))
     (if v (print r))
     (if o
      (let-values (((dir name ext) (decompose-path o)))
       (if (string=? ext "json")
        (write-json r o))
       (if (string=? ext "md")
        (write-markdown r o)))))))))

(define (help file)
 (print "Read/convert JSON resume"))

(define (read-json file)
 (guard (e (else (print #"JSON error in ~file")
            (print (condition-message e))
            #\f))
  ; assume one json obj, otherwise use parse-json*
  (let ((exp (call-with-input-file file parse-json)))
   exp)))

(define (write-json r file)
 (call-with-output-file file
  (lambda (out) (construct-json r out))))

(define (write-markdown r file)
 (call-with-output-file file
  (lambda (out) (markdown r out))))

(define (markdown r out)
 (write-string #"# résumé of ~(name r), ~(label r)" out))

(define (basics r)
 (let ((b (find (lambda (item)
                 (string=? (car item) "basics"))
           r)))
  (and b (cdr b))))

(define (name r)
 (let ((n (find (lambda (item)
                 (string=? (car item) "name"))
           (basics r))))
  (and n (cdr n))))

(define (label r)
 (let ((n (find (lambda (item)
                 (string=? (car item) "label"))
           (basics r))))
  (and n (cdr n))))



