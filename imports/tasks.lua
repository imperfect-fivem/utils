---@generic Fn : function
---@param method Fn
---@return Fn
function CreateLastInvoker(method)
    local invoking, args = false, nil
    local function invoke()
        if invoking then return end
        invoking = true
        if args then
            method(table.unpack(args))
            invoking, args = false, nil
            invoke()
        else
            invoking = false
        end
    end
    return function(...)
        args = { ... }
        invoke()
    end
end
