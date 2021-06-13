local functions = {
    number = {},
}
package.loaded[...] = functions.number

-- Checks if the passed argument is a number
functions.number.is_number = function(num)
    return (type(num) == "number")
end

-- Set boundaries for the number
functions.number.boundaries = function(num, min, max)
    if num < min then num = min end
    if num > max then num = max end
    return num
end

return functions.number
