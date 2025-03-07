import("core.base.bytes")
import("core.base.socket")

function main()
    local addr = "127.0.0.1"
    local port = 9091
    local sock = socket.udp()
    local buff = bytes(8192)
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
