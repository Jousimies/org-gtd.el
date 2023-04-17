(defun ogt-clarify-as-single-action ()
  (execute-kbd-macro (kbd "C-c c s")))

(defun ogt-clarify-as-project ()
  (execute-kbd-macro (kbd "C-c c p")))

(defun ogt-clarify-as-incubated-item (&optional date)
  (let* ((date (or date (calendar-current-date)))
         (year (nth 2 date))
         (month (nth 0 date))
         (day (nth 1 date)))
    (execute-kbd-macro (kbd "C-c c i %s-%s-%s RET"))))

(defun ogt-clarify-as-delegated-item (&optional to-whom date)
  (let* ((person (or to-whom "Someone"))
         (date (or date (calendar-current-date)))
         (year (nth 2 date))
         (month (nth 0 date))
         (day (nth 1 date)))
    (execute-kbd-macro (kbd (format "C-c c d %s RET %s-%s-%s RET" to-whom year month day)))))

(defun ogt-clarify-as-calendar-item (&optional date)
  (let* ((date (or date (calendar-current-date)))
         (year (nth 2 date))
         (month (nth 0 date))
         (day (nth 1 date)))
    (execute-kbd-macro (kbd (format "C-c c c %s-%s-%s RET" year month day)))))

(defun ogt-clarify-as-knowledge-item ()
  (execute-kbd-macro (kbd "C-c c k")))


(defun ogt-clarify-as-trash-item ()
  (execute-kbd-macro (kbd "C-c c t")))
