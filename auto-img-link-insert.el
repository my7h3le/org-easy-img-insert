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

(defvar auto-img-extensions
  '("jpg" "jpeg" "gif" "bmp" "pgm" "pnm" "svg" "png")
  "List of file/URL extensions considered to be images.")

(defun auto-img--extract-file-format (img-link)
  (when (string-match (concat "\\." (regexp-opt auto-img-extensions)) img-link)
    (match-string 0 img-link)))

(defun auto-img--get-current-raw-file-name ()
  ;; Removes the file extension from the currently opened file and it's directory leaving just its raw file name
  (let ((current-file-name (buffer-file-name)))
    (let ((current-file-ext (concat "." (file-name-extension current-file-name))))
      current-file-ext
      (let ((current-file-dir (file-name-directory current-file-name)))
        current-file-dir
        (let ((current-raw-file-name (string-remove-prefix current-file-dir current-file-name)))
          current-raw-file-name
          (let ((current-raw-file-name (string-remove-suffix current-file-ext current-raw-file-name)))
            current-raw-file-name))))))

(defun auto-img--create-img-res-dir ()
  (let ((current-file-name (buffer-file-name)))
    (let ((current-dir (file-name-directory current-file-name)))
      (let ((img-res-dir (concat  current-dir "Resources/")))
        (unless (file-exists-p img-res-dir)
          (make-directory img-res-dir))

        (let ((img-res-dir (concat img-res-dir (auto-img--get-current-raw-file-name) "/")))
          (unless (file-exists-p img-res-dir)
            (make-directory img-res-dir))
          img-res-dir)))))

(defun auto-img--get-local-img-file-loc (img-name img-type)
  (let ((img-local-file-loc (concat (auto-img--create-img-res-dir) img-name img-type)))
    img-local-file-loc))

(defun auto-img-link-insert (img-link img-name img-caption)
  "Automatically download web image and insert it into emacs"
  (interactive "MImage link: \nMImage name: \nMImage caption (optional): ")

  (let ((img-type (auto-img--extract-file-format img-link)))
    (let ((img-local-file-loc (auto-img--get-local-img-file-loc img-name img-type)))
      (start-process "img-download"
                     (get-buffer-create "*auto-img-insert*")
                     "wget"
                     img-link
                     "-O" img-local-file-loc)
      (auto-img--embed-img-at-cursor img-name img-caption img-local-file-loc))))

(defun auto-img--embed-img-at-cursor (img-name img-caption img-local-file-loc)
  (unless (string= "" img-caption)
    (insert (concat "#+CAPTION: " img-caption "\n")))
  (insert (concat "#+NAME: " img-name "\n"))
  (insert (concat "[[" img-local-file-loc "]]")))

(provide 'auto-img-link-insert)

;;; auto-img-link-insert.el ends here
