# Bridge Development Container

This repo contains the development container for our Bridge final project, built for Brown's cs1680, fall 2023.

## Getting started

```bash
./cs1680-run-docker --setup
./cs1680-run-docker
```

For detailed setup instructions, refer to our Lab 0 setup guide!

## Wireshark setup

Wireshark is a tool for monitoring network traffic and will come handy for the IP and TCP projects. 
Since docker does not offer a graphical environment, running GUI applications (like wireshark) can be tricky.
However, there's a few tricks that can be leveraged to run GUI applications. After looking at  host of options, 
we recommend the following otion through with the wireshark GUI can be exposed through any browser. We have added 
the instructions below.

```
# 1. start the docker image. 
docker run -p 14500:14500 --restart unless-stopped --name wireshark --privileged ffeldhaus/wireshark

# 2. wireshrk GUI can be accessed here.
http://localhost:14500/?floating_menu=false&password=wireshark
```

The browser-based GUI is exactly the same as the regular one. Note that ```--privileged``` option is essential for allowing the packet capture. Further, it is assumed that ```port 14500``` is free.

## Acknowledgments

This setup is a modified version of the setup used by
[CSCI0300](https://cs.brown.edu/courses/csci0300) and reused with
permission, which is based on [Harvard's CS61](https://cs61.seas.harvard.edu/site/2021/).  
For wireshark, we have used the setup described in [Wireshark Web Container Image](https://github.com/ffeldhaus/docker-wireshark).
