; extends

(call_expression
  function: (member_expression
    object: [
      (identifier) @_obj
      (member_expression
        property: (property_identifier) @_obj)
      (member_expression
        property: (private_property_identifier) @_obj)
    ]
    property: (property_identifier) @_name)
  arguments: [
    (arguments
      (template_string) @injection.content)
    (arguments
      (string) @injection.content)
    (template_string) @injection.content
  ]
  (#any-of? @_obj "db" "database" "#db")
  (#any-of? @_name
    "exec" "query" "execute" "executeQuery" "executeUpdate" "executeBatch" "prepareStatement" "run"
    "prepare" "prepareQuery" "prepareUpdate" "prepareBatch")
  (#set! injection.language "sql")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children))
