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
 (markdown-basics r out))

(define (markdown-basics r out)
 (let ((name (basics-value "name" r))
       (image (basics-value "image" r))
       (label (basics-value "label" r))
       (summary (basics-value "summary" r))
       (url (basics-value "url" r)))
  (write-string #"# ~name" out)
  (if label (write-string #", ~label" out))
  (newline out)
  (markdown-location r out)
  (newline out)
  (newline out)
  (if url (write-string #" [~url](~url)" out))
  (newline out)
  (newline out)
  (if image (write-string #"![image](~image)" out))
  (newline out)
  (newline out)
  (write-string summary out)
  (newline out)))

(define (markdown-location r out)
 (letrec ((location (basics-value "location" r))
          (address (res-value "address" location))
          (zip (res-value "postalCode" location))
          (city (res-value "city" location))
          (country (res-value "countryCode" location))
          (region (res-value "region" location)))
  (if address (write-string #"~address, " out))
  (if city (write-string #"~city, " out))
  (if region (write-string #"~region " out))
  (if zip (write-string #"~zip" out))
  (if country (write-string #"~country" out))))

(define (res-value key r)
 (let ((b (find (lambda (item)
                 (string=? (car item) key))
           r)))
  (and b (cdr b))))

(define (basics-value key r)
 (res-value key (res-value "basics" r)))


