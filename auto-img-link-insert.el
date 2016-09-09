;;; auto-img-link-insert.el --- An easier way to add images from the web in org mode  -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Tashrif Sanil

;; Author: Tashrif Sanil <tashrif@arch-blade>
;; URL: https://github.com/tashrifsanil/auto-img-link-insert
;; Version: 1.0
;; Keywords: convenience, hypermedia, files

;;; Commentary:
;;
;; This package makes inserting images from the web int org-mode much easier, and
;; quicker. Launching, it opens up a mini-buffer where you can paste your link,
;; enter a name for it and optionally add a caption. The rest is taken care of by 
;; auto-img-link-insert, and it will be embed this data at your current cursor position.
;;

;;; Code:

(defun auto-img/extract-file-format (img-link)
  (cond
   ((string-match-p "\\.jpg" img-link) ".jpg")
   ((string-match-p "\\.jpeg" img-link) ".jpeg")
   ((string-match-p "\\.gif" img-link) ".gif")
   ((string-match-p "\\.bmp" img-link) ".bmp")
   ((string-match-p "\\.pgm" img-link) ".pgm")
   ((string-match-p "\\.pnm" img-link) ".pnm")
   ((string-match-p "\\.svg" img-link) ".svg")
   ((string-match-p "\\.png" img-link) ".png")))

(defun auto-img/get-current-raw-file-name ()
  ;; Removes the file extension from the currently opened file and it's directory leaving just its raw file name
  (setq current-file-name (buffer-file-name))
  (setq current-file-ext (concat "." (file-name-extension current-file-name)))
  (setq current-file-dir (file-name-directory current-file-name))

  (setq current-raw-file-name (string-remove-prefix current-file-dir current-file-name))
  (setq current-raw-file-name (string-remove-suffix current-file-ext current-raw-file-name))

  (message current-raw-file-name)
  )

(defun auto-img/create-img-res-dir ()
  (setq current-file-name (buffer-file-name))
  (setq current-dir (file-name-directory current-file-name))
  (setq img-res-dir (concat  current-dir "Resources/"))

  (if (file-exists-p img-res-dir) nil 
    (make-directory img-res-dir))

  (setq img-res-dir (concat img-res-dir (auto-img/get-current-raw-file-name) "/"))

  (if (file-exists-p img-res-dir) nil 
    (make-directory img-res-dir))
  img-res-dir
  )

(defun auto-img/get-local-img-file-loc (img-name img-type)
  (setq img-local-file-loc (concat (auto-img/create-img-res-dir) img-name img-type))
  img-local-file-loc    
  )

(defun auto-img-link-insert (img-link img-name img-caption)
  "Automatically download web image and insert it into emacs"
  (interactive "MImage link: \nMImage name: \nMImage caption (optional): ")

  (setq img-type (auto-img/extract-file-format img-link))
  (setq img-caption img-caption)

  (setq img-local-file-loc (auto-img/get-local-img-file-loc img-name img-type))

  (start-process "img-download" 
                 (get-buffer-create "*auto-img-insert*") 
                 "wget" 
                 img-link
                 "-O" img-local-file-loc
                 )
  (embed-img-at-cursor)
  )

(defun auto-img/embed-img-at-cursor ()
  (if (not (string= "" img-caption))
      (insert (concat "#+CAPTION: " img-caption "\n"))
    )
  (insert (concat "#+NAME: " img-name "\n"))
  (insert (concat "[[" img-local-file-loc "]]"))
  )

(provide 'auto-img-link-insert)

;;; auto-img-link-insert.el ends here
