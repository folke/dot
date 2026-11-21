; extends

(((inline) @_inline
  (#match? @_inline "^\(import\|export\)")) @injection.content
  (#set! injection.language "tsx"))

; (((inline) @_inline
;   (#lua-match? @_inline "{{.-}}")) @injection.content
;   (#set! injection.language "javascript"))
