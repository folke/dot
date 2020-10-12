(setq user-full-name "Folke Lemaitre"
      user-mail-address "folke.lemaitre@gmail.com"
      command-line-default-directory "~/"         ; set default directory to home
      default-directory "~/"
      ns-use-proxy-icon nil                       ; empty title
      frame-title-format '"\n"                    ; use a new-line to make sure rezising info is on the next line
      undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      truncate-string-ellipsis "…"                ; Unicode ellispis are nicer than "...", and also save /precious/ space
      display-line-numbers-type 'relative
      which-key-idle-delay 0.3                    ; Show key binding help quicker
      which-key-idle-secondary-delay 0
      shell-file-name "/usr/local/bin/bash"       ; Use Bash as default shell for running term which is faster
      vterm-shell "/usr/local/bin/fish")          ; Use Fish in vterm

(after! projectile
  (setq projectile-project-root-files-bottom-up '("package.json" ".projectile" ".project" ".git")
        projectile-project-search-path '("~/projects" "~/projects/splora/libs" "~/projects/splora/apps" "~/projects/splora/tools")))

(setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))

;; prefer right and bottom split
(setq evil-vsplit-window-right t
      evil-split-window-below t)

;; show buffer popup when splitting
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (+ivy/switch-buffer))

;; Syntax checking and linting
(after! popup
  (set-popup-rule! "^\\*Flycheck errors\\*$" :side 'bottom :size 0.2 :select t))
(after! window-select
  (custom-set-faces!
    '(aw-leading-char-face
      :foreground "white" :background "red"
      :weight bold :height 2.5 :box (:line-width 10 :color "red"))))

(after! flycheck
  (setq flycheck-check-syntax-automatically '(mode-enabled save new-line idle-change)))

(after! (flycheck lsp-mode)
  (add-hook 'lsp-after-initialize-hook (lambda()
                                        (flycheck-add-next-checker 'lsp '(warning . javascript-eslint)))))
(after! lsp-mode
  (setq lsp-lua-diagnostics-globals ["hs" "spoon"]))

(setq swiper-use-visual-line nil
      swiper-use-visual-line-p (lambda (a) nil))

;; There's a weird bug where fringe-modes < 8 dont show the fringes
(after! git-gutter
  (fringe-mode 8)
  (after! git-gutter-fringe
    (fringe-mode 8))
  (setq +vc-gutter-diff-unsaved-buffer t))


(after! centaur-tabs
  (centaur-tabs-group-by-projectile-project))
(after! (elfeed centaur-tabs)
  (add-hook 'elfeed-search-mode-hook 'centaur-tabs-local-mode))

(setq +ivy-buffer-preview 1)

(setq +treemacs-git-mode 'extended)
(setq doom-themes-treemacs-theme "doom-colors")
(after! treemacs
  (treemacs-follow-mode t))

(setq browse-url-browser-function '+lookup-xwidget-webkit-open-url-fn)

(setq doom-font (font-spec :family "Fira Code" :size 12)
      doom-variable-pitch-font (font-spec :family "Fira Code" :size 12)
      ;mixed-pitch-set-height t ; need to set this, otherwise the :size parameter is ignored for the pitch font
)
;;(setq doom-variable-pitch-font (font-spec :family "Input Sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-moonlight)
;;(setq doom-theme 'doom-palenight)

(unless (equal "Battery status not available"
               (battery))
  (display-battery-mode 1))                       ; On laptops it's nice to know how much power you have

(after! doom-modeline
  (setq doom-modeline-github t
        doom-modeline-github-interval (* 10 60)
        doom-modeline-major-mode-icon t)
  (add-hook 'doom-modeline-before-github-fetch-notification-hook #'auth-source-pass-enable)
  (doom-modeline--github-fetch-notifications))
(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

(setq writeroom-fullscreen-effect t)
(after! writeroom-mode
  (setq writeroom-fullscreen-effect t))

(set-docsets! 'python-mode "Python 3")
(set-docsets! 'lua-mode "Lua")
(set-docsets! 'emacs-lisp-mode "Emacs Lisp")
(setq +lookup-open-url-fn #'+lookup-xwidget-webkit-open-url-fn)

;; Gmail
(set-email-account! "Gmail"
                    '((mu4e-sent-folder       . "/Sent")
                      (mu4e-drafts-folder     . "/Drafts")
                      (mu4e-trash-folder      . "/Trash")
                      (mu4e-refile-folder     . "/All")
                      (smtpmail-smtp-user     . "folke.lemaitre@gmail.com")
                      (mu4e-compose-signature . "---\nFolke"))
                    t)

(after! elfeed
  (add-hook! 'elfeed-search-mode-hook 'elfeed-update)) ; Update Elfeed when launched

(after! org-gcal
  (require 'auth-source-pass)
  (auth-source-pass-enable)
  (let ((foo "foooo") (bar "barr")) (message foo))
  (let ((client-id (funcall (plist-get (nth 0 (auth-source-search :max 1 :host "gmail.com" :user "folke^gcal-id")) :secret)))
        (client-secret (funcall (plist-get (nth 0 (auth-source-search :max 1 :host "gmail.com" :user "folke^gcal-secret")) :secret))))
    (setq org-gcal-client-id client-id
          org-gcal-client-secret client-secret
          org-gcal-fetch-file-alist '(("folke.lemaitre@gmail.com" .  "~/org/calendar.org")))))

(setq org-directory "~/projects/org/"
      org-ellipsis "  " ; nerd fonts chevron character
      org-agenda-breadcrumbs-separator "  "
      org-journal-file-type 'weekly
      org-use-property-inheritance t
      org-log-done 'time
      +org-capture-notes-file "inbox.org"
      deft-directory "~/projects/org"
      deft-recursive t)

(after! org
  (setq org-tags-column -80))

(after! org
  (with-no-warnings
    (custom-declare-face '+org-todo-soon  '((t (:inherit (bold org-drawer org-todo)))) "")
    (custom-declare-face '+org-todo-next  '((t (:inherit (bold font-lock-keyword-face org-todo)))) "")
    (custom-declare-face '+org-todo-onhold  '((t (:inherit (bold warning org-todo)))) ""))
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"  ; A task that needs doing & is ready to do
           "SOON(s)"  ; A project, which usually contains other tasks
           "NEXT(n)"  ; A task that is in progress
           "WAIT(w)"  ; Something external is holding up this task
           "HOLD(h)"  ; This task is paused/on hold because of me
           "|"
           "DONE(d)"  ; Task successfully completed
           "KILL(k)")) ; Task was cancelled, aborted or is no longer applicable
        org-todo-keyword-faces
        '(("NEXT" . +org-todo-next)
          ("WAIT" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)
          ("SOON" . +org-todo-soon))))

(after! org-roam
  (setq org-roam-directory "~/projects/org/notes"
        org-roam-tag-sources '(prop all-directories)
        +org-roam-open-buffer-on-find-file t
        ;; Create new roam notes under ~/org/notes
        org-roam-capture-ref-templates
        '(("d" "default" plain (function org-roam-capture--get-point)
           "%?"
           :file-name "${slug}"
           :head "#+title: ${title}\n"
           :unnarrowed t
           :immediate-finish t))))

(after! org
  (setq org-tags-column -80)
  (appendq! +ligatures-extra-symbols
            `(:checkbox      ""
              :doing         ""
              :checkedbox    ""
              :list_property "∷"))
  (set-ligatures! 'org-mode
    :merge t
    :checkbox      "[ ]"
    :doing         "[-]"
    :checkedbox    "[X]"
    :list_property "::"))

(setq org-agenda-category-icon-alist `(
        ("inbox" ,(list (all-the-icons-faicon "inbox" :face 'all-the-icons-blue :v-adjust -0.1)) nil nil :ascent center)
        ("dev" ,(list (all-the-icons-faicon "code" :face 'all-the-icons-blue :height 0.8 :v-adjust 0)) nil nil :ascent center)
        ("splora" ,(list (all-the-icons-material "terrain" :face 'all-the-icons-blue :height 0.8)) nil nil :ascent center)
        ("home" ,(list (all-the-icons-faicon "home" :face 'all-the-icons-blue)) nil nil :ascent center)
        ("personal" ,(list (all-the-icons-faicon "asterisk" :face 'all-the-icons-blue)) nil nil :ascent center)
        ("calendar" ,(list (all-the-icons-faicon "google" :face 'all-the-icons-blue)) nil nil :ascent center)
        ("todo" ,(list (all-the-icons-faicon "calendar-check-o" :face 'all-the-icons-blue)) nil nil :ascent center)))

(after! org-agenda
  (setq org-agenda-prefix-format '(
                                   (agenda . "\t\t\t%-2i %-12t % s")
                                   (todo . "\t%-2i %-30b ")
                                   (tags . " %i %-12:c")
                                   (search         . " %i %-12:c"))
        org-agenda-block-separator nil
        org-agenda-time-grid (quote ((today daily require-timed remove-match) (0900 2100) " ╴╴╴╴╴" "──────────────────────"))
        org-agenda-current-time-string " now ────────────────")
  (set-face-attribute 'org-agenda-structure nil
                      :height 1.2
                      :foreground (face-attribute 'org-level-1 :foreground nil t)))

(setq org-agenda-sorting-strategy '(
    (agenda habit-down time-up priority-down category-keep)
    (todo   priority-down todo-state-down category-keep)
    (tags   priority-down category-keep)
    (search category-keep)))

(setq org-agenda-format-date 'my-org-agenda-format-date-aligned)
(defun my-org-agenda-format-date-aligned (date)
  (require 'cal-iso)
  (let* ((dayname (calendar-day-name date nil nil))
         (day (cadr date))
         (month (car date))
         (monthname (calendar-month-name month nil))
         (year (nth 2 date)))
    (format "    %-10s %2d %s %4d"
            dayname day monthname year)))

(use-package! org-super-agenda
  :after org-agenda)

(after! org-super-agenda
  (setq org-super-agenda-unmatched-name "⚡ Backlog")
  (org-super-agenda-mode))

(setq org-agenda-custom-commands
      '(("o" "Overview"
         ((todo "NEXT|SOON" ((org-agenda-overriding-header "\n ⚡ Today")
                             (org-agenda-remove-tags t)))
          (agenda "" ((org-agenda-skip-scheduled-if-done t)
                      (org-agenda-skip-timestamp-if-done t)
                      (org-agenda-skip-deadline-if-done t)
                      (org-agenda-overriding-header "\n ⚡ Agenda")
                      (org-agenda-repeating-timestamp-show-all nil)
                      (org-agenda-remove-tags t)
                      (org-agenda-time)))
          (todo "TODO|WAIT|HOLD" ((org-agenda-overriding-header "")
                                  (org-agenda-prefix-format "\t%-1i %-28b")
                                  (org-agenda-remove-tags t)
                                  (org-super-agenda-groups
                                   '(;; Each group has an implicit boolean OR operator between its selectors.
                                     (:name "⚡ Next"  ; Optionally specify section name
                                      :todo "NEXT")  ; Items that have this TODO keyword
                                     (:name "⚡ Soon"  ; Optionally specify section name
                                      :todo "SOON")  ; Items that have this TODO keyword
                                     (:todo ("WAIT" "HOLD") :name "⚡ On Hold" :order 11)  ; Set order of this section
                                     ));; match any of these groups, with the default order position of 103
                                  ))))))
