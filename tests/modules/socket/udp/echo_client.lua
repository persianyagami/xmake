import("core.base.bytes")
import("core.base.socket")

function main(data)
    local addr = "127.0.0.1"
    local port = 9091
    local buff = bytes(8192)
    local sock = socket.udp()
    local send = sock:sendto(data or "hello xmake!", addr, port, {block = true})
    print("%s: send to %s:%d %d bytes!", sock, addr, port, send)
    local recv, data, peer_addr, peer_port = sock:recvfrom(buff, 8112, {block = true})
    if recv > 0 then
        print("%s: recv %d bytes from %s:%d", sock, recv, peer_addr, peer_port)
        data:dump()
    end
    sock:close()
end
