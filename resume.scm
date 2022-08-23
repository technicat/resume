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
  (h1 name out)
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
  (markdown-education r out)
  (newline out)
  (markdown-languages r out)
  (newline out)
  (markdown-interests r out)
  (newline out)
  (markdown-skills r out)))

(define (markdown-location r out)
 (let ((location (basics-value "location" r)))
  (if location
   (let ((address (res-value "address" location))
         (zip (res-value "postalCode" location))
         (city (res-value "city" location))
         (country (code->country (res-value "countryCode" location)))
         (region (res-value "region" location)))
    (write-string (comma-list (delete #f (list address city region zip country)))
     out)))))

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
    (h2 "Career" out)
    (news out)
    (for-each (lambda (r) (markdown-job r out)) p)))))

(define (markdown-job r out)
 (let ((name (res-value "name" r))
       (pos (res-value "position" r))
       (url (res-value "url" r))
       (summary (res-value "summary" r)))
  (h3 #"~pos @ [~name](~url) " out)
  (news out)
  (markdown-date-range r out)
  (news out)
  (if summary (write-string summary out))
  (news out)))

(define (markdown-projects r out)
 (let ((p (res-value "projects" r)))
  (if p
   (begin
    (h2 "Projects" out)
    (news out)
    (for-each (lambda (r) (markdown-project r out)) p)))))

(define (markdown-project r out)
 (let ((name (res-value "name" r))
       (url (res-value "url" r))
       (type (res-value "type" r))
       (roles (res-value "roles" r))
       (keywords (res-value "keywords" r))
       (highlights (res-value "highlights" r))
       (entity (res-value "entity" r))
       (description (res-value "description" r)))
  (h3 #"[~name](~url) @ ~entity" out)
  (news out)
  (if roles (write-string #"~(comma-vector roles) from " out))
  (markdown-date-range r out)
  (news out)
  (if description (write-string description out))
  (news out)
  (if highlights
   (for-each (lambda (h) (write-string #"> ~h" out) (news out))
    highlights))
  (if type (write-string #"*~|type|:* " out))
  (tags keywords out)
  (news out)))

(define (markdown-education r out)
 (let ((p (res-value "education" r)))
  (if p
   (begin
    (h2 "Education" out)
    (news out)
    (for-each (lambda (r) (markdown-school r out)) p)))))

(define (markdown-school r out)
 (let ((name (res-value "institution" r))
       (url (res-value "url" r))
       (type (res-value "studyType" r))
       (area (res-value "area" r)))
  (h3 #"[~name](~url)" out)
  (news out)
  (markdown-date-range r out)
  (news out)
  (write-string #"~type in ~area" out)
  (news out)))

(define (markdown-languages r out)
 (let ((p (res-value "languages" r)))
  (if p
   (begin
    (h2 "Languages" out)
    (news out)
    (for-each (lambda (r) (markdown-language r out)) p)))))

(define (markdown-language r out)
 (let ((lang (res-value "language" r))
       (fluent (res-value "fluency" r)))
  (write-string #"~fluent in ~lang" out)
  (news out)))

(define (markdown-publications r out)
 (let ((p (res-value "publications" r)))
  (if p
   (begin
    (h2 "Publications" out)
    (news out)
    (for-each (lambda (r) (markdown-book r out)) p)))))

(define (markdown-book r out)
 (let ((name (res-value "name" r))
       (url (res-value "url" r))
       (summary (res-value "summary" r))
       (date (format-date (res-value "releaseDate" r)))
       (pub (res-value "publisher" r)))
  (h3 #"[~name](~url)" out)
  (news out)
  (write-string #"Published ~date by ~pub" out)
  (news out)
  (if summary (write-string summary out))
  (news out)))

(define (markdown-date-range r out)
 (let ((start (format-date (res-value "startDate" r)))
       (end (format-date (res-value "endDate" r))))
  (write-string #"~start to ~end" out)
  (news out)))

(define (res-value key r)
 (let ((b (find (lambda (item)
                 (string=? (car item) key))
           r)))
  (and b (cdr b))))

(define (basics-value key r)
 (res-value key (res-value "basics" r)))

; these could go into a lib
(define (news out)
 (newline out)
 (newline out))

(define (h1 title out)
 (write-string #"## ~title" out))

(define (h2 title out)
 (write-string #"## ~title" out))

(define (h3 title out)
 (write-string #"### ~title" out))

(define (comma-vector v)
 (comma-list (vector->list v)))

(define (comma-list l)
 (string-join l ", "))


(define (markdown-interests r out)
 (let ((p (res-value "interests" r)))
  (if p
   (begin
    (h2 "Interests" out)
    (news out)
    (for-each (lambda (r) (markdown-interest r out)) p)))))

(define (markdown-interest r out)
 (let ((name (res-value "name" r))
       (keywords (res-value "keywords" r)))
  (h3 name out)
  (news out)
  (tags keywords out)
  (news out)))

(define (markdown-skills r out)
 (let ((p (res-value "skills" r)))
  (if p
   (begin
    (h2 "Skills" out)
    (news out)
    (for-each (lambda (r) (markdown-skill r out)) p)))))

(define (markdown-skill r out)
 (let ((name (res-value "name" r))
       (level (res-value "level" r))
       (keywords (res-value "keywords" r)))
  (h3 name out)
  (if level (write-string #" (~level)" out))
  (news out)
  (tags keywords out)
  (news out)))

(define (tags keywords out)
 (if keywords
  (write-string #"*~(comma-vector keywords)*" out)))

(define (format-date date)
 (if date
  (parse-date date)
  "present"))

(define months #("Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"))

(define (parse-date str)
 (letrec ((match (#/^(\d\d\d\d)\-(\d\d?)\-(\d\d?)$/ str))
                  (year (match 1))
                  (month (ref months (- (string->number (match 2)) 1)))
                  (day (match 3)))
           #"~month ~year"))
