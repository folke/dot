local obj = {}
obj.__index = obj
obj.__name = "seal_rot13"

function obj:commands()
  return {
    rot13 = {
      cmd = "rot13",
      fn = obj.rot13,
      name = "ROT13",
      description = "Apply ROT13 substitution cipher"
    }
  }
end

function obj:bare()
  return nil
end

function obj.rot13(query)
  -- ROT13 implementation taken from https://rosettacode.org/wiki/Rot-13#Lua
  local a = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
  local b = "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm"
  local rot13Text =
    query:gsub(
    "%a",
    function(c)
      return b:sub(a:find(c))
    end
  )

  return {
    {
      text = rot13Text,
      subText = "Copy result to clipboard",
      plugin = obj.__name,
      type = "copyToClipboard"
    }
  }
end

function obj.completionCallback(rowInfo)
  if rowInfo["type"] == "copyToClipboard" then
    hs.pasteboard.setContents(rowInfo["text"])
  end
end

return obj
