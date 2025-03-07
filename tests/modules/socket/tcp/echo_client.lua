import("core.base.bytes")
import("core.base.socket")

function main()
    local addr = "127.0.0.1"
    local port = 9091
    print("connect %s:%d ..", addr, port)
    local sock = socket.connect(addr, port)
    if sock then
        print("%s: connected!", sock)
        local count = 0
        local buff = bytes(8192)
        while count < 10000 do
            local send = sock:send("hello world..", {block = true})
            if send > 0 then
                sock:recv(buff, 13, {block = true})
            else
                break
            end
            count = count + 1
        end
        print("%s: send ok, count: %d!", sock, count)
        sock:close()
    end
end
