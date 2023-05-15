;; -*- lexical-binding: t; coding: utf-8 -*-

(load "test/helpers/setup.el")
(require 'org-gtd)
(require 'buttercup)
(require 'with-simulated-input)

(describe
 "A single action"

 :var ((inhibit-message t))

 (before-each (ogt--configure-emacs))
 (after-each (ogt--close-and-delete-files))

  (it "can be added programmatically"
     (org-gtd-single-action-create "Write this test")
     (org-gtd-engage)
     (with-current-buffer org-agenda-buffer
       (expect (ogt--current-buffer-raw-text)
               :to-match
               "Write this test"))))
