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

(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 12)
      doom-variable-pitch-font (font-spec :family "Source Sans Variable" :size 14)
      mixed-pitch-set-height t ; need to set this, otherwise the :size parameter is ignored for the pitch font
)
;;(setq doom-variable-pitch-font (font-spec :family "Input Sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-moonlight)
(setq doom-theme 'doom-palenight)

(unless (equal "Battery status not available"
               (battery))
  (display-battery-mode 1))                       ; On laptops it's nice to know how much power you have

(setq doom-modeline-persp-name t)                 ; show workspace
(after! doom-modeline
  (setq doom-modeline-env-version t
        doom-modeline-github t
        doom-modeline-github-interval (* 10 60)
        doom-modeline-major-mode-icon t)
  (add-hook 'doom-modeline-before-github-fetch-notification-hook #'auth-source-pass-enable))
(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

(set-docsets! 'python-mode "Python 3")
(set-docsets! 'lua-mode "Lua")
(set-docsets! 'emacs-lisp-mode "Emacs Lisp")

;; Gmail
(set-email-account! "Gmail"
                    '((mu4e-sent-folder       . "/Sent")
                      (mu4e-drafts-folder     . "/Drafts")
                      (mu4e-trash-folder      . "/Trash")
                      (mu4e-refile-folder     . "/All")
                      (smtpmail-smtp-user     . "folke.lemaitre@gmail.com")
                      (mu4e-compose-signature . "---\nFolke"))
                    t)

(add-hook! 'elfeed-search-mode-hook 'elfeed-update) ; Update Elfeed when launched

(setq +lookup-open-url-fn #'+lookup-xwidget-webkit-open-url-fn)
(setq browse-url-browser-function '+lookup-xwidget-webkit-open-url-fn)

(setq org-directory "~/projects/org/"
      org-ellipsis "  " ; nerd fonts chevron character
      org-journal-file-type 'weekly
      org-tags-column -80
      org-log-done 'time
      +org-capture-notes-file "inbox.org"
      deft-directory "~/projects/org"
      deft-recursive t)

(after! org
  (setq org-tags-column -80))


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
