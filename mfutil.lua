local _M = {}

local ffi = require("ffi")
ffi.cdef[[
char *mfutil_get_unique_hexa_identifier();
void g_free(void *data);
int link(const char *oldpath, const char *newpath);
long mfutil_get_file_size(const char *filepath);
]]
local mfutil = ffi.load("mfutil")

function _M.get_unique_hexa_identifier()
   if mfutil == nil then
       return nil
    end
    local cres = mfutil.mfutil_get_unique_hexa_identifier()
    local res = ffi.string(cres)
    mfutil.g_free(cres)
    return res
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
    if mfutil == nil then
        return nil
    end
    local cres = mfutil.mfutil_get_file_size(filepath)
    return tonumber(cres)
end

return _M
