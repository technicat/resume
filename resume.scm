#!/usr/local/bin/gosh

; reads a json-resume
; not sure what to do next

(use file.util)
(use gauche.collection)
(use gauche.parseopt)
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
       (url (basics-value "url" r))
       (email (res-value "email" r))
       (phone (res-value "phone" r)))
  (write-string #"# ~name" out)
  (if label (write-string #", ~label" out))
  (newline out)
  (markdown-location r out)
  (newline out)
  (newline out)
  (if url (write-string #" [~url](~url)" out))
  (if phone (write-string #" ~phone " out))
  (if email (write-string #" ~email " out))
  (newline out)
  (newline out)
  (if image (write-string #"![image](~image)" out))
  (newline out)
  (newline out)
  (markdown-profiles r out)
  (newline out)
  (newline out)
  (write-string summary out)
  (newline out)
  (markdown-work r out)
  (newline out)
  (markdown-projects r out)
  (newline out)
  (markdown-publications r out)
  (newline out)
  (markdown-education r out)))

(define (markdown-location r out)
 (letrec ((location (basics-value "location" r))
          (address (res-value "address" location))
          (zip (res-value "postalCode" location))
          (city (res-value "city" location))
          (country (code->country (res-value "countryCode" location)))
          (region (res-value "region" location))
          (all (list address city region zip country)))
          (write-string (string-join (delete #f all) ", ") out)))

(define (code->country code)
 "United States" ; todo - put in a list of code translations
 )

(define (markdown-profiles r out)
 (let ((p (basics-value "profiles" r)))
  (if p
   (for-each (lambda (r) (markdown-profile r out)) p))))

(define (markdown-profile r out)
 (let ((network (res-value "network" r))
       (url (res-value "url" r))
       (username (res-value "username" r)))
  (write-string #" [~username](~url) @ ~network" out)))

(define (markdown-work r out)
 (let ((p (res-value "work" r)))
  (if p
   (begin
    (write-string "## Career" out)
    (newline out)
    (newline out)
    (vector-for-each (lambda (r) (markdown-job r out)) p)))))

(define (markdown-job r out)
 (let ((name (res-value "name" r))
       (pos (res-value "position" r))
       (url (res-value "url" r))
       (description (res-value "summary" r)))
  (write-string #"~pos @ [~name](~url) " out)
  (newline out)
  (newline out)
  (markdown-date-range r out)
  (newline out)
  (newline out)
  (write-string description out)
  (newline out)
  (newline out)))

(define (markdown-projects r out)
 (let ((p (res-value "projects" r)))
  (if p
   (begin
    (write-string "## Projects" out)
    (newline out)
    (newline out)
    (vector-for-each (lambda (r) (markdown-project r out)) p)))))

(define (markdown-project r out)
 (let ((name (res-value "name" r))
       (url (res-value "url" r))
       (roles (res-value "roles" r))
       (keywords (res-value "keywords" r))
       (entity (res-value "entity" r))
       (description (res-value "description" r)))
  (write-string #"[~name](~url) @ ~entity" out)
  (newline out)
  (newline out)
  (markdown-date-range r out)
  (newline out)
  (newline out)
  (vector-for-each (lambda (role) (write-string #"~role " out)) roles)
  (newline out)
  (newline out)
  (write-string description out)
  (newline out)
  (newline out)
  (vector-for-each (lambda (key) (write-string #"~key " out)) keywords)
  (newline out)
  (newline out)))

(define (markdown-education r out)
 (let ((p (res-value "education" r)))
  (if p
   (begin
    (write-string "## Education" out)
    (newline out)
    (newline out)
    (vector-for-each (lambda (r) (markdown-school r out)) p)))))

(define (markdown-school r out)
 (let ((name (res-value "institution" r))
       (url (res-value "url" r))
       (type (res-value "studyType" r))
       (area (res-value "area" r)))
  (write-string #"[~name](~url)" out)
  (newline out)
  (newline out)
  (write-string #"~type in ~area" out)
  (newline out)
  (newline out)
  (markdown-date-range r out)
  (newline out)
  (newline out)))

(define (markdown-publications r out)
 (let ((p (res-value "publications" r)))
  (if p
   (begin
    (write-string "## Publications" out)
    (newline out)
    (newline out)
    (vector-for-each (lambda (r) (markdown-book r out)) p)))))

(define (markdown-book r out)
 (let ((name (res-value "name" r))
       (url (res-value "url" r))
       (date (format-date (res-value "releaseDate" r)))
       (pub (res-value "publisher" r)))
  (write-string #"[~name](~url)" out)
  (newline out)
  (newline out)
  (write-string #"Published ~date by ~pub" out)
  (newline out)
  (newline out)))

(define (markdown-date-range r out)
 (let ((start (format-date (res-value "startDate" r)))
       (end (format-date (res-value "endDate" r))))
  (write-string #"~start to ~end" out)
  (newline out)
  (newline out)))

(define (format-date date)
 (or date
  "present"))

(define (res-value key r)
 (let ((b (find (lambda (item)
                 (string=? (car item) key))
           r)))
  (and b (cdr b))))

(define (basics-value key r)
 (res-value key (res-value "basics" r)))


