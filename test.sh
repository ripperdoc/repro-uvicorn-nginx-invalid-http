#!/bin/bash

# In /etc/hosts, map doing.test to 127.0.0.1
clear
curl http://fictive-dev.engine.fictivereality.com.test/testserver/test/a?b=c
echo -e '\n--------\n'
curl http://fictive-dev.engine.fictivereality.com.test/testserver/test/ö?b=c
echo -e  '\n--------\n'
curl https://fictive-dev.engine.fictivereality.com.test/testserver/test/a?b=c
echo -e  '\n--------\n'
curl https://fictive-dev.engine.fictivereality.com.test/testserver/test/ö?b=c
echo -e  '\n--------\n'
