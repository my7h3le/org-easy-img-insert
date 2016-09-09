;;; auto-img-link-insert.el --- An easier way to add images from the web

;; Name: Auto Image Link Insert
;; Author: Tashrif Sanil
;; Version: 1.0
;; Keywords: web, image, quick, insertion
;; URL: https://github.com/tashrifsanil/auto-img-link-insert

        ;;; Commentary:

;; This package makes inserting images from the web much easier, and quicker. Launching, it opens up a
;; mini-buffer where you can paste your link, enter a name for it and optionally a caption.
;; The rest is taken care of by auto-img-link-insert, and it will be embed this at your current cursor position

        ;;; Code:

(require 'subr-x)

(defvar img-type "The image file format")
(defvar img-caption "The caption of the image")
(defvar img-res-dir "The directory that the image has been downloaded to")
(defvar img-local-file-loc "The file location of the locally downloaded image")


(defun extract-file-format (img-link)
  (cond
   ((string-match-p "\\.jpg" img-link) ".jpg")
   ((string-match-p "\\.jpeg" img-link) ".jpeg")
   ((string-match-p "\\.gif" img-link) ".gif")
   ((string-match-p "\\.bmp" img-link) ".bmp")
   ((string-match-p "\\.pgm" img-link) ".pgm")
   ((string-match-p "\\.pnm" img-link) ".pnm")
   ((string-match-p "\\.svg" img-link) ".svg")
   ((string-match-p "\\.png" img-link) ".png")))

(defun get-current-raw-file-name ()
  ;; Removes the file extension from the currently opened file and it's directory leaving just its raw file name
  (setq current-file-name (buffer-file-name))
  (setq current-file-ext (concat "." (file-name-extension current-file-name)))
  (setq current-file-dir (file-name-directory current-file-name))

  (setq current-raw-file-name (string-remove-prefix current-file-dir current-file-name))
  (setq current-raw-file-name (string-remove-suffix current-file-ext current-raw-file-name))

  (message current-raw-file-name)
  )

(defun create-img-res-dir ()
  (setq current-file-name (buffer-file-name))
  (setq current-dir (file-name-directory current-file-name))
  (setq img-res-dir (concat  current-dir "Resources/"))

  (if (file-exists-p img-res-dir) nil 
    (make-directory img-res-dir))

  (setq img-res-dir (concat img-res-dir (get-current-raw-file-name) "/"))

  (if (file-exists-p img-res-dir) nil 
    (make-directory img-res-dir))
  img-res-dir
  )

(defun set-local-img-file-loc (img-name img-type)
  (setq img-local-file-loc (concat (create-img-res-dir) img-name img-type))
  img-local-file-loc    
  )

(defun auto-img-link-insert (img-link img-name img-caption)
  "Automatically download web image and insert it into emacs"
  (interactive "MImage link: \nMImage name: \nMImage caption (optional): ")

  (setq img-type (extract-file-format img-link))
  (setq img-caption img-caption)

  (set-local-img-file-loc img-name img-type)

  (start-process "img-download" 
                 (get-buffer-create "*auto-img-insert*") 
                 "wget" 
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
