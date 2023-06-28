;;; config.el -*- lexical-binding: t; -*-
(setq user-full-name "Folke Lemaitre"
      user-mail-address "folke.lemaitre@gmail.com"
      command-line-default-directory "~/"         ; set default directory to home
      +doom-dashboard-pwd-policy "~/"
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
      shell-file-name "/bin/sh"       ; Use Bash as default shell for running term which is faster
      vterm-always-compile-module t               ; Compile the vterm-module when needed without asking
      vterm-shell "/usr/local/bin/fish")          ; Use Fish in vterm

(after! projectile
  (setq projectile-project-root-files-bottom-up '("package.json" ".projectile" ".project" ".git")
        projectile-ignored-projects '("~/.emacs.d/")
        projectile-project-search-path '("~/projects" "~/projects/splora/libs" "~/projects/splora/apps" "~/projects/splora/tools"))
  (defun projectile-ignored-project-function (filepath)
    "Return t if FILEPATH is within any of `projectile-ignored-projects'"
    (or (mapcar (lambda (p) (s-starts-with-p p filepath)) projectile-ignored-projects))))

(setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))

(after! forge
  ;; Add more columns to the issue list
  (setq forge-topic-list-columns
        '(("#" 5 forge-topic-list-sort-by-number (:right-align t) number nil)
          ("State" 10 t nil state nil)
          ("Title" 65 t nil title  nil)
          ("Labels" 30 t nil labels nil)
          ("Updated" 20 t nil updated nil)))

  ;; Show at most 100 open issue and when toggling visibility, the last 10 closed issues
  (setq forge-topic-list-limit '(100 . -10)
        forge-owned-accounts '(("folke"))))

(defun +fl/counsel-recentf-candidates (candidates)
  (seq-filter (lambda (f) (not
                      (or (string-match "^/private" f)
                          (string-match "^~/.emacs.d" f)
                          (string-match "^/Applications" f)))
                ) candidates))

(advice-add 'counsel-recentf-candidates :filter-return #'+fl/counsel-recentf-candidates)

(after! popup
  (set-popup-rule! "^\\*Flycheck errors\\*$" :side 'bottom :size 0.2 :select t))

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


(after! ibuffer
  (set-popup-rule! "^\\*Ibuffer\\*$" :side 'bottom :size 0.4 :select t :ignore nil))

(setq +ivy-buffer-preview t)
(after! ivy-posframe
  (setf (alist-get t ivy-posframe-display-functions-alist)
        #'ivy-posframe-display-at-frame-top-center))
(setq doom-themes-treemacs-theme "doom-colors")
(after! treemacs
  (setq +treemacs-git-mode 'extended)
  (treemacs-follow-mode t))
(after! rainbow-mode
  (setq rainbow-html-colors-major-mode-list '(html-mode css-mode php-mode nxml-mode xml-mode typescript-mode javascript-mode)))

(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 12)
      doom-variable-pitch-font (font-spec :family "DejaVuSansMono Nerd Font" :size 12))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-moonlight)
(custom-set-faces!
  '(font-lock-comment-face :slant italic))
;;(setq doom-theme 'doom-palenight)
;; (setq doom-theme 'doom-dracula)

(defvar +fl/splashcii-query ""
  "The query to search on asciiur.com")

(defun +fl/splashcii-banner ()
  (mapc (lambda (line)
          (insert (propertize (+doom-dashboard--center +doom-dashboard--width line)
                              'face 'doom-dashboard-banner) " ")
          (insert "\n"))
        (split-string (with-output-to-string
                        (call-process "splashcii" nil standard-output nil +fl/splashcii-query))
                      "\n" t)))

(setq +doom-dashboard-ascii-banner-fn #'+fl/splashcii-banner)

(setq +fl/splashcii-query "christmas")

(after! centaur-tabs
  (centaur-tabs-group-by-projectile-project)

  (+popup-window-p) ; needed to prevent recursive auto-loading of popup

  ;; Automatically turn off tabs in popups
  (defun +fl/hide-tabs-in-popup ()
    (if (+popup-window-p)
        (centaur-tabs-local-mode)
      (centaur-tabs-local-mode 0)))
  (add-hook! 'buffer-list-update-hook '+fl/hide-tabs-in-popup))

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

(setq +workspaces-on-switch-project-behavior t)
;; prefer right and bottom split
(setq evil-vsplit-window-right t
      evil-split-window-below t)

;; show buffer popup when splitting
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (projectile-find-file))

(set-docsets! 'python-mode "Python 3")
(set-docsets! 'lua-mode "Lua")
(set-docsets! 'emacs-lisp-mode "Emacs Lisp")
(setq +lookup-open-url-fn #'+lookup-xwidget-webkit-open-url-fn)

;; change default notmuch func to open primary inbox
(defun +notmuch ()
  "Activate (or switch to) `notmuch' in its workspace."
  (interactive)
  (unless (featurep! :ui workspaces)
    (user-error ":ui workspaces is required, but disabled"))
  (condition-case-unless-debug e
      (progn
        (+workspace-switch "*email*" t)
        (if-let* ((buf (cl-find-if (lambda (it) (string-match-p "^\\*notmuch" (buffer-name (window-buffer it))))
                                   (doom-visible-windows))))
            (select-window (get-buffer-window buf))
          (notmuch-search "(tag:inbox (tag:personal or tag:flagged) not tag:trash"))
        (+workspace/display))
    ('error
     (+notmuch/quit)
     (signal (car e) (cdr e)))))

(map! :leader :desc "Open Notmuch" "o m" '+notmuch)

(after! notmuch
  ;; Popup rules
  (set-popup-rule! "^\\*notmuch.*search.*" :ignore t)
  (set-popup-rule! "^ \\*notmuch update.*" :select nil :quit t)
  (set-popup-rule! "^\\*notmuch-thread.*" :side 'bottom :size 0.6 :select t)

  ;; Show Images
  (setq notmuch-show-text/html-blocked-images nil)

  ;; dont use buffernames with thread subjects
  (defun notmuch-show--proper-buffer-name (args)
    (when (= (length args) 5)
      (setq args (butlast args)))
    args)
  (advice-add 'notmuch-show :filter-args 'notmuch-show--proper-buffer-name)

  ;; prefer html over text
  (setq notmuch-multipart/alternative-discouraged '("text/plain" "text/html"))

  (setq notmuch-saved-searches
        '((:name "  Inbox"      :query "(tag:inbox (tag:personal or tag:flagged) not tag:trash" :key "i")
          (:name "  Social"     :query "tag:social"              :key "cs")
          (:name "  Updates"    :query "tag:updates"             :key "cu")
          (:name "  Promotions" :query "tag:promotions"          :key "cp")
          (:name "󰇮  All Mail"   :query ""                        :key "a")
          (:name "  Starred"    :query "tag:flagged"             :key "*")
          (:name "  Sent"       :query "tag:sent"                :key "s")
          (:name "  Drafts"     :query "tag:draft"               :key "d"))))

(after! elfeed
  (set-popup-rule! "^\\*elfeed-entry\\*" :side 'bottom :size 0.6 :select t :slot -1 :vslot -10)
  (add-hook! 'elfeed-search-mode-hook 'elfeed-update)) ; Update Elfeed when launched

(after! org-gcal
  (setq org-gcal-client-id (+pass-get-secret "folke^gcal-id@gmail.com")
        org-gcal-client-secret (+pass-get-secret "folke^gcal-secret@gmail.com")
        org-gcal-fetch-file-alist '(("folke.lemaitre@gmail.com" .  "~/org/gcal/personal.org")
                                    ("013uicuadeh4t1culpvrnna5hs@group.calendar.google.com" . "~/org/gcal/family.org"))))

(defvar +fl--browse-url-xwidget-last-session-buffer nil)

(defun +fl/browse-url-xwidget (url &optional new-session)
  (let ((orig-last-session-buffer
         (if (boundp 'xwidget-webkit-last-session-buffer)
             xwidget-webkit-last-session-buffer
           nil)))
    (setq xwidget-webkit-last-session-buffer +fl--browse-url-xwidget-last-session-buffer)
    (save-window-excursion
      (xwidget-webkit-browse-url url new-session))
    (with-popup-rules! '(("^\\*xwidget" :vslot -10 :size 0.6 :select t :slot -1))
      (pop-to-buffer xwidget-webkit-last-session-buffer))
    (setq +fl--browse-url-xwidget-last-session-buffer xwidget-webkit-last-session-buffer
          xwidget-webkit-last-session-buffer orig-last-session-buffer)))

(setq browse-url-browser-function '+fl/browse-url-xwidget)

(use-package! wakatime-mode
  :hook (after-init . global-wakatime-mode)
  :config
  (setq wakatime-cli-path "/Users/folke/Library/Python/3.8/bin/wakatime"
        wakatime-python-bin "/usr/local/bin/python3"))

(setq org-directory "~/projects/org/"
      org-ellipsis "  "                ; nerd fonts chevron character
      org-journal-file-type 'weekly
      org-use-property-inheritance t
      org-log-done 'time
      org-hide-emphasis-markers t
      org-enforce-todo-dependencies t
      org-enforce-todo-checkbox-dependencies t
      org-log-into-drawer t
      org-log-state-notes-into-drawer t
      org-log-repeat 'time
      org-todo-repeat-to-state "TODO"
      +org-capture-notes-file "inbox.org"
      deft-directory "~/projects/org"
      deft-recursive t)

(after! org
  (setq org-tags-column -80
        org-agenda-sticky nil))

(advice-add 'org-refile :after 'org-save-all-org-buffers)
(advice-add 'org-gcal-fetch :after 'org-save-all-org-buffers)

(after! org
  (with-no-warnings
    (custom-declare-face '+org-todo-soon  '((t (:inherit (bold org-drawer org-todo)))) "")
    (custom-declare-face '+org-todo-next  '((t (:inherit (bold font-lock-keyword-face org-todo)))) "")
    (custom-declare-face '+org-todo-done  '((t (:inherit (bold org-headline-done org-done)))) "")
    (custom-declare-face '+org-todo-onhold  '((t (:inherit (bold warning org-todo)))) ""))
  (setq org-todo-keywords
        '((sequence
           "NEXT(n)"     ; A task that is in progress
           "WEEK(w)"     ; A task for this week
           "MONTH(m)"    ; A task for this month
           "TODO(t)"     ; A task that needs doing & is ready to do
           "HOLD(h@/!)"  ; This task is paused/on hold because of me
           "|"
           "DONE(d!)"    ; Task successfully completed
           "KILL(k@!)")) ; Task was cancelled, aborted or is no longer applicable
        org-todo-keyword-faces
        '(("NEXT" . +org-todo-next)
          ("WEEK" . +org-todo-soon)
          ("MONTH" . +org-todo-soon)
          ("HOLD" . +org-todo-onhold)
          ("DONE" . +org-todo-done)
          ("KILL" . +org-todo-done))))

(use-package! ox-tailwind
  :after ox)
(after! ox-tailwind
  (setq org-tailwind-class-inner-container "")
  (setq org-tailwind-footer ""
        org-tailwind-class-h1 "mb-6 text-6xl text-gray-700 border-b hover:text-green-500
border-gray-500"
        org-tailwind-class-footer "invisible"
        org-tailwind-class-src-container "my-12 shadow"
        org-tailwind-class-sidebar "px-24 py-12 bg-gray-200 lg:border-r lg:border-gray-500
lg:fixed lg:pt-2 lg:w-64 lg:px-2 lg:overflow-y-auto lg:inset-y-0
lg:mt-16"
        org-tailwind-class-content-container "flex-grow px-4 py-12 sm:px-8 md:px-12 lg:ml-64 lg:px-12
lg:overflow-x-auto xl:px-32"
        org-tailwind-head-files "
        <!-- Tailwind CSS -->
        <link href=\"https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/1.9.2/tailwind.min.css\" rel=\"stylesheet\"/>
        <!-- Prism Css -->
        <link href=\"https://cdnjs.cloudflare.com/ajax/libs/prism/1.22.0/themes/prism.min.css\" rel=\"stylesheet\" />
        <!-- Mathjax -->
        <!-- Toc tree file -->
        <script>const tocTree = []</script>
"
        org-tailwind-bottom-files "
        <script src=\"https://cdnjs.cloudflare.com/ajax/libs/prism/1.22.0/prism.min.js\"></script>
        <script src=\"https://cdnjs.cloudflare.com/ajax/libs/mermaid/8.8.2/mermaid.min.js\"></script>
        <script src=\"https://cdnjs.cloudflare.com/ajax/libs/prism/1.22.0/plugins/autoloader/prism-autoloader.min.js\"></script>
        <script>mermaid.initialize({startOnLoad:true});</script>"))

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
            `(:checkbox      "󰄱"
              :doing         "󰄮"
              :checkedbox    "󰄵"
              :list_property "∷"))
  (set-ligatures! 'org-mode
    :merge t
    :checkbox      "[ ]"
    :doing         "[-]"
    :checkedbox    "[X]"
    :list_property "::"))

(setq org-agenda-category-icon-alist
      `(("inbox" ,(list (all-the-icons-faicon "inbox" :face 'all-the-icons-blue :v-adjust -0.1)) nil nil :ascent center)
        ("dev" ,(list (all-the-icons-faicon "code" :face 'all-the-icons-blue :height 0.8 :v-adjust 0)) nil nil :ascent center)
        ("splora" ,(list (all-the-icons-material "terrain" :face 'all-the-icons-blue :height 0.8)) nil nil :ascent center)
        ("home" ,(list (all-the-icons-faicon "home" :face 'all-the-icons-blue)) nil nil :ascent center)
        ("habits" ,(list (all-the-icons-faicon "undo" :face 'all-the-icons-pink)) nil nil :ascent center)
        ("life" ,(list (all-the-icons-faicon "asterisk" :face 'all-the-icons-blue)) nil nil :ascent center)
        ("birthdays" ,(list (all-the-icons-faicon "birthday-cake" :face 'all-the-icons-red)) nil nil :ascent center)
        ("calendar" ,(list (all-the-icons-faicon "google" :face 'all-the-icons-blue)) nil nil :ascent center)
        ("holidays" ,(list (all-the-icons-faicon "calendar-check-o" :face 'all-the-icons-green)) nil nil :ascent center)))

(after! org-agenda
  (set-popup-rule! "^\\*Org Agenda\\*$" :side 'bottom :size 0.4 :select t :quit t)
  (setq org-agenda-prefix-format
        '((agenda . "\t\t\t%-2i %-12t % s")
          (todo . "\t%-2i %-30b ")
          (tags . " %i %-12:c")
          (search         . " %i %-12:c"))
        org-agenda-block-separator nil
        org-agenda-span 7
        org-agenda-start-on-weekday 1
        org-agenda-start-day nil
        org-agenda-breadcrumbs-separator "  "
        org-agenda-files  (list org-directory (concat org-directory "gcal/"))
        org-agenda-time-grid (quote ((today daily require-timed remove-match) (0900 2100) " ╴╴╴╴╴" "──────────────────────"))
        org-agenda-current-time-string " now ────────────────")
  (set-face-attribute 'org-agenda-structure nil
                      :height 1.2
                      :foreground (face-attribute 'org-level-1 :foreground nil t)))

(setq org-agenda-sorting-strategy
      '((agenda habit-down time-up priority-down category-keep)
        (todo   todo-state-up priority-down category-keep)
        (tags   todo-state-up priority-down category-keep)
        (search todo-state-up priority-down category-keep)))

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
  :hook (org-agenda-mode . org-super-agenda-mode)
  :config
  (setq org-super-agenda-unmatched-name "⚡ Backlog"
        org-super-agenda-unmatched-order 50))

;; (after! org-super-agenda
;;   (setq org-super-agenda-unmatched-name "⚡ Backlog"
;;         org-super-agenda-unmatched-order 50)
;;   (org-super-agenda-mode))

;; Super Agenda seems to jump to the last line, let's fix this!
(defun +fl/agenda-jump-to-start ()
  (goto-char (point-min)))
(add-hook 'org-agenda-finalize-hook '+fl/agenda-jump-to-start 90)

(setq org-agenda-custom-commands
      '(("o" "Overview"
         ((todo "NEXT|WEEK"
                ((org-agenda-overriding-header "\n ⚡ Today")
                 (org-agenda-remove-tags t)))
          (agenda ""
                  ((org-agenda-skip-scheduled-if-done t)
                   (org-agenda-start-day "0d")
                   (org-agenda-span 3)
                   (org-agenda-skip-timestamp-if-done t)
                   (org-habit-show-all-today t)
                   (org-agenda-skip-deadline-if-done t)
                   (org-agenda-overriding-header "\n ⚡ Agenda")
                   (org-agenda-repeating-timestamp-show-all nil)
                   (org-agenda-remove-tags t)
                   (org-agenda-time)))
          (todo "TODO|WAIT|HOLD"
                ((org-agenda-overriding-header "")
                 (org-agenda-remove-tags t)
                 (org-super-agenda-groups
                  '((:category "habits" :name "⚡ Habits" :order 60)
                    (:name "⚡ Inbox"
                     :category "inbox")
                    (:name "⚡ Next"
                     :todo "NEXT")
                    (:name "⚡ Week"
                     :todo "WEEK")
                    (:name "⚡ Month"
                     :todo "MONTH")
                    (:todo ("WAIT" "HOLD") :name "⚡ On Hold" :order 11)))))))))

(after! org-agenda
  (setq org-habit-show-all-today nil
        org-habit-today-glyph ?⚡
        org-habit-completed-glyph ?+ ))
