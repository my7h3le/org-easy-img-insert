;;; auto-img-link-insert.el --- An easier way to add images from the web

;; Name: Auto Image Link Insert
;; Author: Tashrif Sanil
;; Version: 1.0
;; Keywords: web, image, quick, insertion

;;; Commentary:

;; This package makes inserting images from the web much easier, and quicker.

;;; Code:

(defvar img-type "The image file format")
(defvar img-caption "The caption of the image")
(defvar img-res-dir "The directory that the image has been downloaded to")
(defvar curr-org-file-loc "The file location of the currently opened org file")
(defvar img-local-file-loc "The file location of the locally downloaded image")

(defun extract-file-format (img-link)
  (cond
   ((string-match-p "\\.jpg" img-link) ".jpg")
   ((string-match-p "\\.jpeg" img-link) "~.jpeg")
   ((string-match-p "\.gif" img-link) "~.gif")
   ((string-match-p "\.bmp" img-link) "~.bmp")
   ((string-match-p "\.pgm" img-link) "~.pgm")
   ((string-match-p "\.pnm" img-link) "~.pnm")
   ((string-match-p "\.svg" img-link) "~.svg")
   ((string-match-p "\\.png" img-link) ".png")))

(defun get-img-file-name (img-link img-name)
  (setq current-file (c-get-current-file))
  (setq img-res-dir (concat  (file-name-directory curr-org-file-loc) "Resources/" current-file "/"))
  (setq img-local-file-loc (concat img-res-dir img-name img-type))
  (message "Created Dir %s" img-res-dir)
  )

(defun auto-img-link-insert (img-link img-name img-caption)
  "Automatically download web image and insert it into emacs"
  (interactive "MImage link: \nMImage name: \nMImage caption (optional): ")

  (setq curr-org-file-loc (buffer-file-name))
  (setq img-type (extract-file-format img-link)) 
  (setq img-file-name (get-img-file-name img-link img-name))
  (setq img-caption img-caption)

  (start-process "dir-creation"
                 (get-buffer-create "*auto-img-insert*") 
                 "/usr/bin/mkdir"
                 "-pv" img-res-dir 
                 )
  (start-process "img-download" 
                 (get-buffer-create "*auto-img-insert*") 
                 "/usr/bin/wget" 
                 img-link
                 "-O" img-local-file-loc
                 )
  (embed-img-at-cursor)
  )

(defun embed-img-at-cursor ()
  (if (not (string= "" img-caption))
      (insert (concat "#+CAPTION: " img-caption "\n"))
    )
  (insert (concat "#+NAME: " img-name "\n"))
  (insert (concat "[[" img-local-file-loc "]]"))
  )
