;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Folke Lemaitre"
      user-mail-address "folke.lemaitre@gmail.com")

;; Set default directory to home
(setq command-line-default-directory "~/")
(setq default-directory "~/")

;; Macos stuff
(setq ns-use-proxy-icon nil)
(setq frame-title-format '"\n") ;; use a new-line to make sure rezising info is on the next line ;)
;(setq default-frame-alist (append default-frame-alist '((inhibit-double-buffering . t))))
;
(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      truncate-string-ellipsis "…")               ; Unicode ellispis are nicer than "...", and also save /precious/ space


;; (cond (IS-MAC
;;        (setq mac-command-modifier     'meta
;;              mac-option-modifier      'super
;;              ns-command-modifier      'meta
;;              ns-option-modifier       'super
;;              ns-right-option-modifier 'none)))


(map! (:when (featurep! :editor multiple-cursors)
        ;; evil-multiedit
        :v  "R"     #'evil-multiedit-match-all
        :n  "s-d"   #'evil-multiedit-match-symbol-and-next
        :n  "s-D"   #'evil-multiedit-match-symbol-and-prev
        :v  "s-d"   #'evil-multiedit-match-and-next
        :v  "s-D"   #'evil-multiedit-match-and-prev
        :nv "C-s-d" #'evil-multiedit-restore
        (:after evil-multiedit
          (:map evil-multiedit-state-map
            "s-d"    #'evil-multiedit-match-and-next
            "s-D"    #'evil-multiedit-match-and-prev
            "RET"    #'evil-multiedit-toggle-or-restrict-region
            [return] #'evil-multiedit-toggle-or-restrict-region))))

(after! which-key
  (setq
    which-key-idle-delay 0.3
    which-key-idle-secondary-delay 0))

;; There's a weird bug where fringe-modes < 8 dont show the fringes
(after! git-gutter
  (fringe-mode 8)
  (after! git-gutter-fringe
    (fringe-mode 8))
  (setq +vc-gutter-diff-unsaved-buffer t))

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "Fira Code" :size 12))
(setq doom-variable-pitch-font (font-spec :family "Source Sans Variable" :size 13))
;;(setq doom-variable-pitch-font (font-spec :family "Input Sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-moonlight)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Disable LSP formatters. Use format plugin instead
;; (setq +format-with-lsp nil)
;;

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
    :weight bold :height 2.5 :box (:line-width 10 :color "red")))
  )

(after! flycheck
  (setq flycheck-check-syntax-automatically '(mode-enabled save new-line idle-change)))

(after! (flycheck lsp-mode)
  (add-hook 'lsp-after-initialize-hook (lambda
                                       ()
                                       (flycheck-add-next-checker 'lsp '(warning . javascript-eslint))))
    )

(after! centaur-tabs
  (centaur-tabs-group-by-projectile-project))

(setq projectile-project-search-path '("~/projects"))


(display-time-mode 0)                             ; Enable time in the mode-line
(unless (equal "Battery status not available"
               (battery))
  (display-battery-mode 1))                       ; On laptops it's nice to know how much power you have


(setq +ivy-buffer-preview 1)


(setq doom-modeline-persp-name t)
(setq doom-modeline-env-version t)
(setq doom-modeline-major-mode-icon t)
(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

(setq +treemacs-git-mode 'extended)
(setq doom-themes-treemacs-theme "doom-colors")
(after! treemacs
  (treemacs-follow-mode t))

(after! lsp-mode
  ;; (require 'ht)
  ;; ;(setq lsp-enable-file-watchers t)
  ;; (load-file "~/.config/doom/lsp.el")
  ;; ;(setq lsp-client-packages '(lsp-lua))
  ;; (setq lsp-lua-workspace-max-preload 300)
  (setq lsp-lua-diagnostics-globals ["hs" "spoon"])
  ;; (setq lsp-log-io t)
  ;; (defun lsp-set-cfg ()
  ;;   ;(setq lsp-client-settings (delq (assoc "intelephense.files.associations" lsp-client-settings) lsp-client-settings))
  ;;   ;(setq lsp-client-settings (delq (assoc "intelephense.files.exclude" lsp-client-settings) lsp-client-settings))
  ;;   (setq workspace (lsp-find-workspace "lsp-luaserver"))
  ;;   (setq cfg (ht-merge
  ;;         (lsp-configuration-section "Lua")
  ;;         (lsp-configuration-section "files")))
  ;;   ;(edebug)
  ;;   (with-lsp-workspace workspace
  ;;     (lsp--set-configuration cfg
  ;;      ;(lsp-configuration-section "files")
  ;;     )
  ;;   )
  ;; )
  ;; ;(add-hook 'lsp-lua-language-server-after-open-hook 'lsp-set-cfg)
)


;; Gmail
(set-email-account! "Gmail"
  '((mu4e-sent-folder       . "/Sent")
    (mu4e-drafts-folder     . "/Drafts")
    (mu4e-trash-folder      . "/Trash")
    (mu4e-refile-folder     . "/All")
    (smtpmail-smtp-user     . "folke.lemaitre@gmail.com")
    (mu4e-compose-signature . "---\nFolke"))
  t)

(add-hook! 'elfeed-search-mode-hook 'elfeed-update)

(set-docsets! 'python-mode "Python 3")
(set-docsets! 'lua-mode "Lua")
(set-docsets! 'emacs-lisp-mode "Emacs Lisp")
(setq +lookup-open-url-fn #'+lookup-xwidget-webkit-open-url-fn)

(setq vterm-shell "/usr/local/bin/fish")

;(use-package explain-pause-mode
  ;:config
  ;;(explain-pause-mode)
  ;)

(setq browse-url-browser-function '+lookup-xwidget-webkit-open-url-fn)
(after! (elfeed centaur-tabs)
  (add-hook 'elfeed-search-mode-hook 'centaur-tabs-local-mode))
