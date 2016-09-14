# auto-img-link-insert
An emacs package that makes inserting web images into org-mode much easier and quicker.

# Usage
Hit `M-x` RET `auto-img-link-insert`. Issuing this will open up a mini buffer prompting you for the image link, image name, and an optional caption. The rest is taken care of by the package.

# Installation
Installation can be done through `MELPA`. Hit `M-x package-install` RET auto-img-link-insert. Then paste this to your `.emacs` or start up script.

```  
(autoload 'auto-img-link-insert "auto-img-link-insert" "Launch auto-img-link-insert with  org-mode" t)
(add-hook 'org-mode-hook (lambda () (auto-img-link-insert 1)))
```

# How it works?
* The package will first create a `Resources` directory at the current location of the currently opened file. 
* Then it will create a subdirectory within the `Resources` directory with the name of the currently opened file (for example, if the currently opened file is `test.org`, the package will create a subdirectory `test` within the Resources directory).
* Lastly, the package will download the image to the subdirectory, with the image name that you specified in the mini buffer.

# Contributing
Feel free to fork this package, and submit pull requests. Comments with sugesstions are appreciated, but I'd appreciate code more. 

# Upcoming Features
* Inserting image directly from the clipboard
* Ability to change the directory that the package downloads the image to.

# Note
This package will be renamed to `org-easy-img-insert` soon enough.
