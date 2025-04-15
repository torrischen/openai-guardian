local http = require "resty.http"
local json = require "cjson"

local _M = {}

function _M.validate(token, client_ip)
    local httpc = http.new()
    local res, err = httpc:request_uri("http://auth-service/validate", {
        method = "POST",
        body = json.encode({
            client_ip = client_ip,
            token = token
        }),
        headers = {
            ["Content-Type"] = "application/json"
        }
    })
    
    if not res then
        ngx.log(ngx.ERR, "Validation request failed: ", err)
        return false
    end
    
    if res.status ~= 200 then
        return false
    else
        return true
    end
end

function _M.authorize()
    local headers = ngx.req.get_headers()
    local auth_header = headers["Authorization"] or ""
    local token = auth_header:match("^[Bb]earer%s+(.+)$")
    local client_ip = ngx.var.remote_addr
    
    if token and _M.validate(token, client_ip) then
        ngx.req.set_header("Authorization", "Bearer 123456")
        return true
    else
        ngx.log(ngx.WARN, "Invalid token or IP. Token: ", token or "none", " IP: ", client_ip)
        return false
    end
end

return _M