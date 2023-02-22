;;; spacetab.el --- Tool for changing tabs to spaces and spaces to tabs

;; Author: Gregory Bakhtin <https://github.com/kra53n>
;; Version: 0.1
;; Homepage: https://github.com/kra53n/spacetab

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Tool for changing tabs to spaces and spaces to tabs

;;; Code:

(defun spacetab-delete-margin ()
  (interactive)
  (beginning-of-line-text)
  (set-mark-command nil)
  (beginning-of-line)
  (delete-backward-char 1))

(defun spacetab-paste-char (char num)
  (beginning-of-line)
  (let ((i 0))
	(while (< i num)
	  (insert char)
	  (setq i (+ i 1)))))

(defun spacetab-ask-num (prompt)
  (let ((num (string-to-number (read-from-minibuffer prompt))))
	(if (and (integerp num) (> num 0))
		num
	  nil)))

(defun spacetab-paste-spaces (&optional num)
  (interactive "P")
  (save-excursion
	(spacetab-paste-char " " (or num (spacetab-ask-num "Spaces num: ") 0))))

(defun spacetab-paste-tabs (&optional num)
  (interactive "P")
  (save-excursion
	(spacetab-paste-char "\t" (or num (spacetab-ask-num "Tabs num: ") 0))))

(defun spacetab-set-spaces (&optional num)
  (interactive "P")
  (save-excursion
	(spacetab-delete-margin)
	(spacetab-paste-char " " (or num (spacetab-ask-num "Spaces num: ") 0))))

(defun spacetab-set-tabs (&optional num)
  (interactive "P")
  (save-excursion
	(spacetab-delete-margin)
	(spacetab-paste-char "\t" (or num (spacetab-ask-num "Spaces num: ") 0))))

(defun spacetab-spaces-to-tabs (&optional indent-size)
  (interactive "P")
  (setq indent-size (or indent-size (spacetab-ask-num "Indent size: ")))
  (save-excursion
	(beginning-of-line-text)
	(let ((point-end (- (point) 1)))
	  (beginning-of-line)
	  (let ((point-start (point)))
		(while (< point-start point-end)
		  (goto-char point-start)
		  (when (string= " " (char-to-string (char-after (point))))
			(delete-forward-char indent-size)
			(insert "\t"))
		  (setq point-start (+ point-start 1)))))))

(defun spacetab-tabs-to-spaces (&optional indent-size)
  (interactive "P")
  (setq indent-size (or indent-size (spacetab-ask-num "Indent size: ")))
  (save-excursion
	(beginning-of-line-text)
	(let ((point-end (+ (point) 1)))
	  (beginning-of-line)
	  (let ((point-start (point)))
		(while (<= point-start point-end)
		  (goto-char point-start)
		  (when (string= "\t" (char-to-string (char-after (point))))
			(delete-forward-char 1)
			(spacetab-paste-char " " indent-size))
		  (setq point-start (+ point-start 1)))))))
