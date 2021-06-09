local functions = {
    number = {},
}
package.loaded[...] = functions.number

-- Checks if the passed argument is a number
functions.number.is_number = function(num)
    return (type(num) == "number")
end

return functions.number
