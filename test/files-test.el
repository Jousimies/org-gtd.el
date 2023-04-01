;; -*- lexical-binding: t; coding: utf-8 -*-

(load "test/helpers/setup.el")
(load "test/helpers/utils.el")
(require 'org-gtd)
(require 'buttercup)
(require 'with-simulated-input)

(describe "Create a default file"

  (before-each
    (ogt--configure-emacs))
  (after-each (ogt--close-and-delete-files))

  (describe "with default content"
    (it "for the inbox"
      (with-current-buffer (org-gtd--inbox-file)
        (expect (ogt--current-buffer-raw-text)
                :to-match
                "This is the inbox")
        (expect (ogt--current-buffer-raw-text)
                :to-match
                "#\\+STARTUP: overview hidestars logrefile indent logdone")))

    (it "has a header for the default file"
      (with-current-buffer (org-gtd--default-file)
        (expect (ogt--current-buffer-raw-text)
                :to-match
                "#\\+STARTUP: overview indent align inlineimages hidestars logdone logrepeat logreschedule logredeadline
#\\+TODO: NEXT(n) TODO(t) WAIT(w@) | DONE(d) CNCL(c@)")))



    (describe
        "when there isn't a refile target"
      (it "for a project"
        (ogt--add-and-process-project "project headline")
        (ogt--save-all-buffers)
        (expect (ogt--org-dir-buffer-string) :to-match "org-gtd-tasks\\.org"))

      (it "for a calendar item"
        (ogt--add-and-process-calendar-item "calendar headline")
        (ogt--save-all-buffers)
        (expect (ogt--org-dir-buffer-string) :to-match "org-gtd-tasks\\.org"))

      (it "for a delegated item"
        (ogt--add-and-process-delegated-item "delegated headline")
        (ogt--save-all-buffers)
        (expect (ogt--org-dir-buffer-string) :to-match "org-gtd-tasks\\.org"))

      (it "for a incubated item"
        (ogt--add-and-process-incubated-item "incubated headline")
        (ogt--save-all-buffers)
        (expect (ogt--org-dir-buffer-string) :to-match "org-gtd-tasks\\.org"))

      (it "for a single action"
        (ogt--add-and-process-single-action "single action")
        (ogt--save-all-buffers)
        (expect (ogt--org-dir-buffer-string) :to-match "org-gtd-tasks\\.org")))))
