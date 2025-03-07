import("core.base.bytes")
import("core.base.socket")
import("core.base.scheduler")

function _listen(addr, port)
    local buff = bytes(8192)
    local sock = socket.udp()
    sock:bind(addr, port)
    while true do
        print("%s: recv in %s:%d ..", sock, addr, port)
        local recv, data, peer_addr, peer_port = sock:recvfrom(buff, 8192, {block = true})
        print("%s: recv %d bytes from: %s:%d", sock, recv, peer_addr, peer_port)
        if data then
            data:dump()
            sock:sendto(data, peer_addr, peer_port)
        end
    end
    sock:close()
end

function main()
    scheduler.co_start(_listen, "127.0.0.1", 9091)
end
