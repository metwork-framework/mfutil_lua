local _M = {}

local str = require "resty.string"
local resty_random = require "resty.random"

local ffi = require("ffi")
ffi.cdef[[
int link(const char *oldpath, const char *newpath);
]]

function _M.get_unique_hexa_identifier()
    local random = resty_random.bytes(16)
    return str.to_hex(random)
end

function _M.link(oldpath, newpath)
    return ffi.C.link(oldpath, newpath)
end

function _M.exit_with_ngx_error(code, message, log_message)
    if log_message ~= nil then
        if log_message == "SAME" then
            ngx.log(ngx.ERR, message)
        else
            ngx.log(ngx.ERR, log_message)
        end
    end
    ngx.status = code
    ngx.say(message)
    ngx.exit(200) -- yes this is normal
end

function _M.get_file_size(filepath)
    local file = assert(io.open(filepath, "r"))
    local current = file:seek()
    local size = file:seek("end")
    file:seek("set", current)
    assert(file:close())
    return size
end

return _M
