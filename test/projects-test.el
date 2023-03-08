;; -*- lexical-binding: t; coding: utf-8 -*-

(load "test/helpers/setup.el")
(require 'org-gtd)
(require 'buttercup)
(require 'with-simulated-input)

(describe
 "Project management"

 (before-each
  (ogt--configure-emacs)
  (ogt--prepare-filesystem)
  (ogt--add-and-process-project "project headline"))

 (after-each (ogt--close-and-delete-files))

 (describe "marks all undone tasks of a canceled project as canceled"
           (it "on a task in the agenda"
               (org-gtd-engage)
               (with-current-buffer org-agenda-buffer
                 (goto-char (point-min))
                 (search-forward "Task 1")
                 (org-gtd-agenda-cancel-project)
                 (org-gtd-archive-completed-items))
               (let ((archived-projects (ogt--archive-string)))
                 (expect archived-projects :to-match "project headline")))

           (it "when on the heading"
               (setq org-gtd-directory (make-temp-file "org-gtd" t))
               (ogt--add-and-process-project "project headline")
               (with-current-buffer (org-gtd--default-file)
                 (goto-char (point-min))
                 (search-forward "project headline")
                 (org-gtd-cancel-project)
                 (org-gtd-archive-completed-items)
                 (basic-save-buffer))
               (let ((archived-projects (ogt--archive-string)))
                 (expect archived-projects :to-match "project headline"))))


 (it "safely adds the stats cookie"
     (setq org-gtd-process-item-hooks '(org-set-tags-command org-priority))
     (ogt--add-single-item "project headline")
     (org-gtd-process-inbox)
     (execute-kbd-macro (kbd "M-> RET"))
     (insert ogt--project-text)
     (execute-kbd-macro (kbd "C-c c p headline_tag RET A task_1_tag RET B task_2_tag RET C task_3_tag RET A"))
     (ogt--save-all-buffers)
     (with-current-buffer (org-gtd--default-file)
       (goto-char (point-min))
       (expect (ogt--current-buffer-raw-text)
               :to-match "[0/3]")
       (search-forward "project headline")
       (expect (member "headline_tag" (org-get-tags)))
       (expect (org-element-property :priority (org-element-at-point)) :to-equal (org-priority-to-value "A"))
       (search-forward "Task 1")
       (expect (member "task_1_tag" (org-get-tags)))
       (expect (org-element-property :priority (org-element-at-point)) :to-equal (org-priority-to-value "B"))
       (search-forward "Task 2")
       (expect (member "task_2_tag" (org-get-tags)))
       (expect (org-element-property :priority (org-element-at-point)) :to-equal (org-priority-to-value "C"))
       (search-forward "Task 3")
       (expect (member "task_3_tag" (org-get-tags)))
       (expect (org-element-property :priority (org-element-at-point)) :to-equal (org-priority-to-value "A"))
       )))
