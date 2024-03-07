; extends
; there's no jinja2 grammar, so we use twig instead since it's very similar
(block_mapping_pair
  value: [
    (block_node (block_scalar) @injection.content)
    (flow_node (double_quote_scalar) @injection.content)
  ]
  (#set! injection.language "twig")
  (#contains? @injection.content "{{")
)
(block_mapping_pair
  value: [
    (block_node (block_scalar) @injection.content)
    (flow_node (double_quote_scalar) @injection.content)
  ]
  (#set! injection.language "twig")
  (#contains? @injection.content "{%")
)
