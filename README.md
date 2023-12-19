# Bridge

> In compliance with Brown's academic policy, the source code is not published.
This repository only houses the development container source.

[Website](https://alexding.me/bridge) | [Demo Video](https://www.youtube.com/watch?v=E2NQlRVIX6Q)

Bridge is an RFC-compliant custom IP/TCP/HTTP implementation in Rust that runs through UDP sockets to create a virtual network.
This virtual network can be bridged with the real kernel network stack to interface with real-world networking applications using a combination of `iptables` settings and a custom proxy thread to relay packets between a dummy Linux network interface and the virtual network.
Moreover, each virtual host is abstracted as a microkernel that serves networking "syscalls" via RPC, allowing multiple applications to use the same virtual IP address simultaneously just as they would on a real host.

As shown in our [demo video](https://www.youtube.com/watch?v=E2NQlRVIX6Q), we use Bridge to build a variety of networking applications on this custom network stack--including a netcat clone, a static HTTP file server, and a dynamic HTTP file server serving POST requests--to interface with themselves, as well as other real-world networking applications across the internet.

We also publish a [website](https://alexding.me/bridge) online running our static and dynamic HTTP file servers to serve internet traffic and demonstrate our entire network stack.
The content of the website goes into much greater detail explaining the technical details of the project and the design decisions and challenges.

When a TCP packet comes in addressed to a port forwarded by our virtual stack (i.e., port 80, served by the file server), Linux sends the packet to a virtual network device, created by our virtual router proxy.
The virtual router proxy, listening for traffic on the virtual network device, forwards the byte stream to our virtual network stack.
Our custom IP layer then parses the byte stream and forwards the datagram from the virtual router to the appropriate virtual host using its internal IP table.
On the virtual host, our custom TCP layer then parses the body of the datagram to appropriately handle the TCP packet.
Our custom HTTP server, running on top of this TCP implementation, makes `read` and `write` calls to the TCP socket, parsing HTTP requests and sending back HTTP responses according to an application-registered HTTP handler.
Importantly, the virtual host runs as an RPC server, and the application's TCP-related system calls (e.g., `read` and `write`) are done via RPC calls in order to allow multiple applications to use the same virtual host.
This enables us to host both the static HTTP server and the dynamic HTTP server on two different ports of the same virtual IP address.

## Getting Started

### Deployment Container

While we cannot share the source code, we did package our demo website's server into a deployment container and published it at `ghcr.io/alexander-ding/bridge-server`.

To run:

```bash
docker pull ghcr.io/alexander-ding/bridge-server:latest 
docker run -d -it --privileged -p 80:80 -p 1000:1000 ghcr.io/alexander-ding/bridge-server:latest
```

Now, you can visit `localhost` (defaults to port 80) on your browser see the website!

### Development Container

If you do have access to the source code and would like to get a development environment for Bridge, we also publish a development container at:

```bash
ghcr.io/alexander-ding/bridge:latest
```

The recommended way to run it is the script in this repository:

```bash
./run-container
```

Then clone the source code into the `home` and work from there.

## Credits

Bridge is created by [Alex Ding](https://github.com/alexander-ding), [Elizabeth Jones](https://github.com/L1Z3), and [Weili Shi](https://github.com/WillyKidd) as the final project for Brown's CSCI 1680: Computer Networks, fall 2023.
