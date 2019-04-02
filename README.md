<p align="center">
  <img width="300px" src="https://upload.wikimedia.org/wikipedia/commons/8/8f/Tor_project_logo_hq.png">
</p>

# Tor-socks-proxy

The super easy way to setup a [Tor](https://www.torproject.org) [SOCKS5](https://en.wikipedia.org/wiki/SOCKS#SOCKS5) [proxy server](https://en.wikipedia.org/wiki/Proxy_server) inside a [Docker](https://en.wikipedia.org/wiki/Docker_(software)) [container](https://en.wikipedia.org/wiki/Container_(virtualization)) without relay/exit feature.

## Usage

1. Setup the proxy server at the **first time**

    ```sh
    $ docker run -d --name tor_socks_proxy -p 127.0.0.1:9050:9050 dockerhub/tor-socks-proxy:latest
    ```

    - Use `127.0.0.1` to limit the connections from localhost, do not change it unless you know you're going to expose it to a local network or to the Internet.
    - Change to first `9050` to any valid and free port you want, please note that port `9050`/`9050` may already taken if you are also running other Tor client, like TorBrowser.
    - Do not touch the second `9050` as it's the port inside the docker container unless you're going to change the port in Dockerfile.

    If you already setup the instance before *(not the first time)*, just start it:

    ```sh
    $ docker start tor_socks_proxy
    ```

2. Make sure it's running, it'll take a short time to bootstrap

    ```sh
    $ docker logs tor_socks_proxy
    .
    .
    .
    Jan 10 01:06:59.000 [notice] Bootstrapped 85%: Finishing handshake with first hop
    Jan 10 01:07:00.000 [notice] Bootstrapped 90%: Establishing a Tor circuit
    Jan 10 01:07:02.000 [notice] Tor has successfully opened a circuit. Looks like client functionality is working.
    Jan 10 01:07:02.000 [notice] Bootstrapped 100%: Done
    ```

3. Configure your client to use it, target on `127.0.0.1` port `9050`(Or the other port you setup in step 1)

    Take `curl` as an example, checkout what's your IP address via Tor network:

    ```sh
    $ curl --socks5-hostname 127.0.0.1:9050 ipinfo.io/ip
    $ curl --socks5-hostname 127.0.0.1:9050 icanhazip.com
    $ curl --socks5-hostname 127.0.0.1:9050 ipecho.net/plain
    $ curl --socks5-hostname 127.0.0.1:9050 whatismyip.akamai.com
    ```

    Take `ssh` and `nc` as an example, connect to a host via Tor:

    ```sh
    $ ssh -o ProxyCommand='nc -x 127.0.0.1:9050 %h %p' target.hostname.blah
    ```

4. After using it, you can turn it off

    ```sh
    $ docker stop tor_socks_proxy
    ```

## IP renewal

- Tor changes circuit automatically every 10 minutes by default, which usually bring you the new IP address, it's affected by `MaxCircuitDirtiness` config, you can override it with your own `torrc`. See the official [manual](https://www.torproject.org/docs/tor-manual.html.en) for more details.

- To manually renew the IP that Tor gives you, simply restart your docker container to open a new circuit:

   ```sh
   $ docker restart tor_socks_proxy
   ```

   Just note that all the connections will be terminated and need to be reestablished.

## Note

**For the Tor project sustainability, I strongly encourage you to help [setup Tor bridge/exit nodes](https://trac.torproject.org/projects/tor/wiki/TorRelayGuide)([**script**](https://github.com/PeterDaveHello/ubuntu-tor-simply-setup)) and [donate](https://donate.torproject.org/) money to the Tor project *(Not this proxy project)* when you have the ability/capacity!**
