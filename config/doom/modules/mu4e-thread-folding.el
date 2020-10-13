;; Refactored from https://github.com/djcb/mu/pull/783


(defun mu4e~headers-msg-unread-p (msg)
  "Check if MSG is unread."
  (let ((flags (mu4e-message-field msg :flags)))
    (and (member 'unread flags) (not (member 'trashed flags)))))

(defvar mu4e-headers-folding-slug-function
  (lambda (headers) (format " (%d)" (length headers)))
  "Function to call to generate the slug that will be appended to folded threads.
This function receives a single argument HEADERS, which is a list
of headers about to be folded.")

(defun mu4e~headers-folded-slug (headers)
  "Generate a string to append to the message line indicating the fold status.
HEADERS is a list with the messages being folded (including the root header)."
  (funcall mu4e-headers-folding-slug-function headers))

(defun mu4e~headers-fold-make-overlay (beg end headers)
  "Hides text between BEG and END using an overlay.
HEADERS is a list with the messages being folded (including the root header)."
  (let ((o (make-overlay beg end)))
    (overlay-put o 'mu4e-folded-thread t)
    (overlay-put o 'display (mu4e~headers-folded-slug headers))
    (overlay-put o 'evaporate t)
    (overlay-put o 'invisible t)))

(defun mu4e~headers-fold-find-overlay (loc)
  "Find and return the 'mu4e-folded-thread overlay at LOC, or return nil."
  (cl-dolist (o (overlays-in (1- loc) (1+ loc)))
    (when (overlay-get o 'mu4e-folded-thread)
      (cl-return o))))

(defun mu4e-headers-fold-all ()
  "Fold all the threads in the current view."
  (interactive)
  (let ((thread-id "") msgs fold-start fold-end)
    (mu4e-headers-for-each
     (lambda (msg)
       (end-of-line)
       (push msg msgs)
       (let ((this-thread-id (mu4e~headers-get-thread-info msg 'thread-id)))
         (if (string= thread-id this-thread-id)
             (setq fold-end (point))
           (when (< 1 (length msgs))
             (mu4e~headers-fold-make-overlay fold-start fold-end (nreverse msgs)))
           (setq fold-start (point)
                 fold-end (point)
                 msgs nil
                 thread-id this-thread-id)))))
    (when (< 1 (length msgs))
      (mu4e~headers-fold-make-overlay fold-start fold-end (nreverse msgs)))))

(defun mu4e-headers-toggle-thread-folding (&optional subthread)
  "Toggle the folding state for the thread at point.
If SUBTHREAD is non-nil, only fold the current subthread."
  ;; Folding is accomplished using an overlay that starts at the end
  ;; of the parent line and ends at the end of the last descendant
  ;; line. If there's no overlay, it means it isn't folded
  (interactive "P")
  (if-let ((o (mu4e~headers-fold-find-overlay (point-at-eol))))
      (delete-overlay o)
    (let* ((msg (mu4e-message-at-point))
           (thread-id (mu4e~headers-get-thread-info msg 'thread-id))
           (path-re (concat "^" (mu4e~headers-get-thread-info msg 'path)))
           msgs first-marked-point last-marked-point)
      (mu4e-headers-for-each
       (lambda (submsg)
         (when (and (string= thread-id (mu4e~headers-get-thread-info submsg 'thread-id))
                    (or (not subthread)
                        (string-match-p path-re (mu4e~headers-get-thread-info submsg 'path))))
           (push msg msgs)
           (setq last-marked-point (point-at-eol))
           (unless first-marked-point
             (setq first-marked-point last-marked-point)))))
      (when (< 1 (length msgs))
        (mu4e~headers-fold-make-overlay first-marked-point last-marked-point (nreverse msgs))))))
