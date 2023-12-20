;; NEVER put loads or requires in here.  That's the point of this helper: to
;; help test things in an environment where things aren't loaded.

(defun ogt--prepare-gtd-directory ()
  "Run before autoload test that needs the gtd directory to exist."
  (setq org-gtd-directory (make-temp-file "org-gtd" t)))

(defmacro ogt--with-temp-org-buffer (contents &rest body)
  "Like `with-temp-buffer', but in Org mode.

CONTENTS is inserted and point is set to the buffer's beginning
before running BODY."
  (declare (debug t))
  `(with-temp-buffer
     (org-mode)
     (insert ,contents)
     (goto-char 1)
     ,@body))

(defun ogt--clear-gtd-directory ()
  "Clean up after `ogt--prepare-gtd-directory'."
  (delete-directory org-gtd-directory t))
