#!/usr/local/bin/gosh

; reads a json-resume
; https://jsonresume.org/
; optionally write back out to json (no reason)
; or markdown

(use file.util)
(use gauche.collection)
(use gauche.parseopt)
(use rfc.json)

(include "../schematic/lib/json.scm")
(include "../schematic/lib/md.scm")

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
 (print "resume.scm -f file -o outfile -v -h"))

(define (write-markdown r file)
 (call-with-output-file file
  (lambda (out) (markdown r out))))

(define (markdown r out)
 (markdown-basics r out)
 (markdown-work r out)
 (markdown-projects r out)
 (markdown-publications r out)
 (markdown-education r out)
 (markdown-languages r out)
 (markdown-interests r out)
 (markdown-skills r out)
 (markdown-awards r out)
 (markdown-certs r out)
 (markdown-volunteer r out)
 (markdown-refs r out))

; basics

(define (markdown-basics r out)
 (let ((name (basics-value "name" r))
       (image (basics-value "image" r))
       (label (basics-value "label" r))
       (summary (basics-value "summary" r))
       (url (basics-value "url" r))
       (email (res-value "email" r))
       (phone (res-value "phone" r)))
  (if label
   (h1 #"~name, ~label" out)
   (h1 name out))
  (newline out)
  (markdown-location r out)
  (newline out)
  (if url (write-string #" [~url](~url)" out))
  (if phone (write-string #" ~phone " out))
  (if email (write-string #" ~email " out))
  (if image (embed "profile" image out))
  (markdown-profiles r out)
  (news out)
  (write-string summary out)))

(define (basics-value key r)
 (res-value key (res-value "basics" r)))

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

(define (markdown-profiles r out)
 (let ((p (basics-value "profiles" r)))
  (if p
   (for-each (lambda (r) (markdown-profile r out)) p))))

(define (markdown-profile r out)
 (let ((network (res-value "network" r))
       (url (res-value "url" r))
       (username (res-value "username" r)))
  (write-string #" [~username](~url) @ ~network" out)))

; career

(define (markdown-work r out)
 (let ((p (res-value "work" r)))
  (if p
   (begin
    (h2 "Career" out)
    (for-each (lambda (r) (markdown-job r out)) p)))))

(define (markdown-job r out)
 (let ((name (res-value "name" r))
       (pos (res-value "position" r))
       (url (res-value "url" r))
       (summary (res-value "summary" r)))
  (h3 #"~pos @ [~name](~url) " out)
  (newline out)
  (markdown-date-range r out)
  (newline out)
  (if summary (write-string summary out))
  (newline out)))

; project

(define (markdown-projects r out)
 (let ((p (res-value "projects" r)))
  (if p
   (begin
    (h2 "Projects" out)
    (newline out)
    (for-each (lambda (r) (markdown-project r out)) p)))))

(define (markdown-project r out)
 (let ((name (res-value "name" r))
       (url (res-value "url" r))
       (images (res-value "images" r))
       (type (res-value "type" r))
       (roles (res-value "roles" r))
       (keywords (res-value "keywords" r))
       (highlights (res-value "highlights" r))
       (entity (res-value "entity" r))
       (description (res-value "description" r)))
  (h3 #"[~name](~url) @ ~entity" out)
  (if roles (write-string #"~(comma-vector roles) from " out))
  (markdown-date-range r out)
  (embed-images "project image" images out)
  (if description (write-string description out))
  (newline out)
  (if highlights
   (for-each
    (lambda (h) (bullet h out))
    highlights))
  (newline out)
  (if type (write-string #"*~|type|:* " out))
  (tags keywords out)
  (newline out)))

; education

(define (markdown-education r out)
 (let ((p (res-value "education" r)))
  (if p
   (begin
    (h2 "Education" out)
    (newline out)
    (for-each (lambda (r) (markdown-school r out)) p)))))

(define (markdown-school r out)
 (let ((name (res-value "institution" r))
       (images (res-value "images" r))
       (url (res-value "url" r))
       (gpa (res-value "score" r))
       (courses (res-value "courses" r))
       (type (res-value "studyType" r))
       (area (res-value "area" r)))
  (h3 #"[~name](~url)" out)
  (newline out)
  (markdown-date-range r out)
  (write-string #"~type in ~area, ~gpa GPA" out)
  (news out)
  (embed-images "school image" images out)
  (if courses (tags courses out))))

; language

(define (markdown-languages r out)
 (let ((p (res-value "languages" r)))
  (if p
   (begin
    (h2 "Languages" out)
    (newline out)
    (for-each (lambda (r) (markdown-language r out)) p)))))

(define (markdown-language r out)
 (let ((lang (res-value "language" r))
       (fluent (res-value "fluency" r)))
  (write-string #"~fluent in ~lang" out)
  (news out)))

; publications

(define (markdown-publications r out)
 (let ((p (res-value "publications" r)))
  (if p
   (begin
    (h2 "Publications" out)
    (newline out)
    (for-each (lambda (r) (markdown-book r out)) p)))))

(define (markdown-book r out)
 (let ((name (res-value "name" r))
       (url (res-value "url" r))
       (summary (res-value "summary" r))
       (date (format-date (res-value "releaseDate" r)))
       (images (res-value "images" r))
       (pub (res-value "publisher" r)))
  (h3 #"[~name](~url)" out)
  (newline out)
  (write-string #"Published ~date by ~pub" out)
  (news out)
  (embed-images "book image" images out)
  (if summary (write-string summary out))
  (news out)))

; interests

(define (markdown-interests r out)
 (let ((p (res-value "interests" r)))
  (if p
   (begin
    (h2 "Interests" out)
    (newline out)
    (for-each (lambda (r) (markdown-interest r out)) p)))))

(define (markdown-interest r out)
 (let ((name (res-value "name" r))
       (keywords (res-value "keywords" r)))
  (h3 name out)
  (newline out)
  (tags keywords out)
  (newline out)))

; skills

(define (markdown-skills r out)
 (let ((p (res-value "skills" r)))
  (if p
   (begin
    (h2 "Skills" out)
    (newline out)
    (for-each (lambda (r) (markdown-skill r out)) p)))))

(define (markdown-skill r out)
 (let ((name (res-value "name" r))
       (level (res-value "level" r))
       (keywords (res-value "keywords" r)))
  (if level
   (h3 #"~name (~level)" out)
   (h3 name out))
  (tags keywords out)
  (news out)))

; awards

(define (markdown-awards r out)
 (let ((p (res-value "awards" r)))
  (if p
   (begin
    (h2 "Awards" out)
    (newline out)
    (for-each (lambda (r) (markdown-award r out)) p)))))

(define (markdown-award r out)
 (let ((name (res-value "title" r))
       (issuer(res-value "awarder" r))
       (date (format-date (res-value "date" r)))
       (images (res-value "images" r))
       (summary (res-value "summary" r)))
  (h3 name out)
  (write-string #"~issuer on ~date" out)
  (embed-images "award" images out)
  (if summary (write-string summary out))
  (news out)))

; certificates

(define (markdown-certs r out)
 (let ((p (res-value "certificates" r)))
  (if p
   (begin
    (h2 "Certificates" out)
    (newline out)
    (for-each (lambda (r) (markdown-cert r out)) p)))))

(define (markdown-cert r out)
 (let ((name (res-value "name" r))
       (issuer (res-value "issuer" r))
       (images (res-value "images" r))
       (date (format-date (res-value "date" r)))
       (url (res-value "url" r)))
  (h3 name out)
  (write-string #"[~issuer](~url) on ~date" out)
  (news out)
  (embed-images "certificate image" images out)))


; volunteer

(define (markdown-volunteer r out)
 (let ((p (res-value "volunteer" r)))
  (if p
   (begin
    (h2 "Volunteer" out)
    (newline out)
    (for-each (lambda (r) (markdown-vol r out)) p)))))

(define (markdown-vol r out)
 )

; references

(define (markdown-refs r out)
 (let ((p (res-value "references" r)))
  (if p
   (begin
    (h2 "References" out)
    (newline out)
    (for-each (lambda (r) (markdown-ref r out)) p)))))

(define (markdown-ref r out)
 (let ((name (res-value "name" r))
       (ref (res-value "reference" r)))
  (h3 name out)
  (newline out)
  (blockquote ref out)
  (newline out)))


(define (markdown-date-range r out)
 (let ((start (format-date (res-value "startDate" r)))
       (end (format-date (res-value "endDate" r))))
  (write-string #"~start to ~end" out)
  (news out)))

; lists

(define (tags keywords out)
 (if keywords
  (write-string #"*~(comma-vector keywords)*" out)))

; other

(define (code->country code)
 ; todo - fill this out
 "United States"
 )

; date

(define (format-date date)
 (if date
  (parse-date date)
  "present"))

(define months
 #("January" "February" "March" "April" "May" "June" "July" "August" "September" "October" "November" "December"))

(define (parse-date str)
 (letrec ((match (#/^(\d\d\d\d)\-(\d\d?)\-(\d\d?)$/ str))
                  (year (match 1))
                  (month (ref months (- (string->number (match 2)) 1)))
                  (day (match 3)))
           #"~month ~year"))
