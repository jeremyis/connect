connect
======

Command Line Tool for launching URI-scheme (e.g. mysql, mongo) clients
from URI-formatted addresses.

e.g.
takes: `postgres://tombrady:forlife@patriots.com:222/foxborough`
and opens psql connected to patriots.com:222/foxborough as user tombrady.

# Support
* mongo
* mysql
* postgresql

# Usage:
```
npm install
chmod u+x connect
./connect
```
optionally, add the folder to PATH.
