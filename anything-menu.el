;;;; anything-menu.el --- menu command using anything interface
;; $Id: anything-menu.el,v 1.2 2010-02-23 10:10:34 rubikitch Exp $

;; Copyright (C) 2010  rubikitch

;; Author: rubikitch <rubikitch@ruby-lang.org>
;; Keywords: menu, tools, convenience, anything
;; URL: http://www.emacswiki.org/cgi-bin/wiki/download/anything-menu.el

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; 

;;; Commands:
;;
;; Below are complete command list:
;;
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; Installation:
;;
;; Put anything-menu.el to your load-path.
;; The load-path is usually ~/elisp/.
;; It's set in your ~/.emacs like this:
;; (add-to-list 'load-path (expand-file-name "~/elisp"))
;;
;; And the following to your ~/.emacs startup file.
;;
;; (require 'anything-menu)
;;
;; No need more.

;;; Customize:
;;
;;
;; All of the above can customize by:
;;      M-x customize-group RET anything-menu RET
;;


;;; History:

;; $Log: anything-menu.el,v $
;; Revision 1.2  2010-02-23 10:10:34  rubikitch
;; implemented
;;
;; Revision 1.1  2010/02/23 09:44:09  rubikitch
;; initial
;;

;;; Code:

(defvar anything-menu-version "$Id: anything-menu.el,v 1.2 2010-02-23 10:10:34 rubikitch Exp $")
(require 'anything)
(defgroup anything-menu nil
  "anything-menu"
  :group 'emacs)

(defvar am/tmp-file "/tmp/.am-tmp-file")
(defvar am/frame nil)
(defun am/set-frame ()
  (unless (and am/frame (frame-live-p am/frame))
    (setq am/frame (make-frame '((name . "anything menu")
                                 (title . "anything menu")))))
  (select-frame am/frame)
  (sit-for 0))

(defun am/close-frame ()
  (ignore-errors (make-frame-invisible am/frame))
  (when (fboundp 'do-applescript)
    (funcall 'do-applescript "tell application \"iTerm\"
                                activate
                             end")))
(defun am/write-result (line)
  (write-region (or line "") nil am/tmp-file))

(defun anything-menu (&optional any-sources any-input any-prompt any-resume any-preselect any-buffer)
  (interactive)
  (am/set-frame)
  (unwind-protect
      (let ((anything-samewindow t)
            (anything-display-function 'anything-default-display-buffer))
        (anything any-sources any-input any-prompt any-resume any-preselect any-buffer))
    (am/close-frame)))

(defun anything-menu-select (am-prompt &rest am-selections)
  (anything-menu `(((name . ,am-prompt)
                    (candidates . am-selections)
                    (action . am/write-result)))
                 nil (concat am-prompt ": ") nil nil "*anything menu select*"))
(provide 'anything-menu)

;; (save-window-excursion (bg2 "gnudoit '(anything-menu-select \"selections\" \"a\" \"b\")'"))
;; (find-sh0 "cat /tmp/.am-tmp-file")

;; How to save (DO NOT REMOVE!!)
;; (emacswiki-post "anything-menu.el")
;;; anything-menu.el ends here
