import("core.base.socket")

function main(filepath)

    local addr = "127.0.0.1"
    local port = 9092
    local sock = socket.bind(addr, port)
    sock:listen(20)
    print("%s: listening %s:%d ..", sock, addr, port)
    while true do
        local sock_client = sock:accept()
        if sock_client then
            print("%s: accepted", sock_client)
            local file = io.open(filepath, 'rb')
            if file then
                local send = sock_client:sendfile(file, {block = true})
                print("%s: send %s %d bytes!", sock_client, filepath, send)
                file:close()
            end
            sock_client:close()
        end
    end
    sock:close()
end
