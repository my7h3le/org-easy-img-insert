# org-easy-img-insert
An emacs package that makes inserting web images into org-mode much easier and quicker. Formerly known as auto-img-link-insert.

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-generate-toc again -->
**Table of Contents**
- [Usage](#usage)
- [Installation](#installation)
- [How it works?](#how-it-works)
- [Contributing](#contributing)
- [Upcoming Features](#upcoming-features)
- [Note](#note)

<!-- markdown-toc end -->

# Usage
Hit `M-x` RET `org-easy-img-insert`. Issuing this will open up a mini buffer prompting you for the image link, image name, and an optional caption. The rest is taken care of by the package.

![Paste Image Link](https://github.com/tashrifsanil/org-easy-img-insert/blob/master/Screenshots/img-insert-screenshot-1.png)
![Insert image name](https://github.com/tashrifsanil/org-easy-img-insert/blob/master/Screenshots/img-insert-screenshot-2.png)
![Insert an optional caption](https://github.com/tashrifsanil/org-easy-img-insert/blob/master/Screenshots/img-insert-screenshot-3.png)
![Result](https://github.com/tashrifsanil/org-easy-img-insert/blob/master/Screenshots/img-insert-screenshot-4.png)

# Installation
Installation can be done through `MELPA`. Hit `M-x package-install` RET org-easy-img-insert.

If you are using spacemacs then you would need to add org-easy-img-insert to your additional packages.

# How it works?
* The package will first create a `Resources` directory at the current location of the currently opened file.
* Then it will create a subdirectory within the `Resources` directory with the name of the currently opened file (for example, if the currently opened file is `test.org`, the package will create a subdirectory `test` within the Resources directory).
* Lastly, the package will download the image to the subdirectory, with the image name that you specified in the mini buffer.

# Contributing
Feel free to fork this package, and submit pull requests. Comments with sugesstions are appreciated, but I'd appreciate code more.

# Upcoming Features
* Inserting image directly from the clipboard
* Ability to change the directory that the package downloads the image to.
