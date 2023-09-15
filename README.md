# Repro Nginx / uvicorn / FastAPI failing on non-standard URL characters

This error appeared when I failed to load a file using a path including äåö from a simple FastAPI endpoint. All I got back was
`Invalid HTTP request received.` and this appeared to come from `uvicorn` side as the request never reached to my FastAPI code.
This also only happened when running in our container.

First, I suspected some basic URL encoding issue, but I could see that even i typed `ö`, what was sent was the encoded version `%C3%B6`.

Then, I suspected something different between container and local environment, and for a moment I thought I had the error representing
in Docker on one endpoint but not the other. But it was dead end, because eventually they were identical in code and still one gave an error.
How could that be? Well, in the browser I was unknowlingy adding https before one and http before the other, and https straight into a FastAPI
without SSL setup gives the same exact error message: `Invalid HTTP request received.`

Then I built this test case to isolate away all irrelevant things, and I started realizing the difference must be due to Nginx running in
production but not locally. For a while I suspected that Nginx somehow did send HTTPS onwards to uvicorn but the `proxy_pass` directive
clearly only sent http traffic.

Finally I found [this deep in Stackoverflow](https://stackoverflow.com/a/49702013): Nginx normally passes the URL when proxying normalized / decoded, e.g. converting `%C3%B6` back to `ö`.
When this happens depends on small details in the config (typical Nginx style), e.g. if we end `proxy_pass` with a slash or not. In our Nginx proxy setup, we have multiple services running, so we have it setup so that when a caller goes to https://backend.fictivereality.com/service1/some/route this directs it to docker container named `service1` and it receives the path `/some/route`. We had earlier fought with nginx config to make this possible at all, and while we won that time we never realized we also decoded URLs that we passed on to services. Maybe that was never an issue, or maybe other app servers than uvicorn don't mind to get unicode in paths.

The fix ended up being a change where we use the original unencoded URI and rewrite that before passing it on to app server.