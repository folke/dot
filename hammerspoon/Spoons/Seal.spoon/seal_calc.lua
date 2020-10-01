local obj = {}
obj.__index = obj
obj.__name = "seal_calc"
obj.icon = hs.image.imageFromAppBundle("com.apple.Calculator")

function obj:commands()
    return {}
end

function obj:bare()
    return self.bareCalc
end

function obj.bareCalc(query)
    local choices = {}
    if query == nil or query == "" then
        return choices
    end

    -- Filter out commas and dollar signs
    query, _ = query:gsub("[%,%$]", "")

    -- We need to determine if the query only contains mathematical calculations
    -- To do this we'll see if it matches the inverse of that set of characters
    if string.match(query, "[^%d^%.^%+^%-^/^%*^%^^ ^%(^%)]") == nil then
        local choice = {}
        local compile_result, fn = load("return " .. query)
        if type(compile_result) == "function" then
            local result = compile_result()
            choice["text"] = result
            choice["subText"] = "Copy result to clipboard"
            choice["image"] = obj.icon
            choice["plugin"] = obj.__name
            choice["type"] = "copyToClipboard"
            table.insert(choices, choice)
        end
    end
    return choices
end

function obj.completionCallback(rowInfo)
    if rowInfo["type"] == "copyToClipboard" then
        hs.pasteboard.setContents(rowInfo["text"])
    end
end

return obj
