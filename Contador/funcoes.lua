local M = {}

function M.map(func, array)
    local result = {}
    for i, v in ipairs(array) do
        result[i] = func(v)
    end
    return result
end

function M.filter(func, array)
    local result = {}
    for _, v in ipairs(array) do
        if func(v) then
            table.insert(result, v)
        end
    end
    return result
end

return M