local socket = require("socket")
local http = require("socket.http")

local function handleRequest(request)
    -- Your routing logic can be added here based on the requested URL
    local response = "Hello user!\n"
    return "HTTP/1.1 200 OK\r\nContent-Length: " .. #response .. "\r\n\r\n" .. response
end

local function handleClient(client)
    local request, err = client:receive()

    if not err then
        local response = handleRequest(request)
        client:send(response)
    else
        print("Error receiving request:", err)
    end

    client:close()
end

local function startServer()
    local host = "127.0.0.1"
    local port = 8080

    local server = assert(socket.bind(host, port))
    print("Server is listening at http://" .. host .. ":" .. port)

    while true do
        local client = server:accept()
        if client then
            local co = coroutine.create(handleClient)
            local success, errorMsg = coroutine.resume(co, client)
            if not success then
                print("Error starting coroutine:", errorMsg)
                client:close()
            end
        end
    end
end

startServer()