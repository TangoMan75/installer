TangoMan Universal Installer
============================

**TangoMan Universal Installer** is a fast and handy way to deploy git repositories.

Since [RawGit](https://rawgit.com) is down **TangoMan Universal Installer** relies on awesome [jsDelivr](https://www.jsdelivr.com/) for fast CDN.

jsDelivr can take up to 24h to update cache, as an alternative you can use `raw.githubusercontent.com` (not recommended).

Usage
-----

All parameters are optional

| Parameter  |         Description          |   Default    |
|------------|------------------------------|--------------|
| repository | required git repository      | promts user  |
| -s         | git server name              | github.com   |
| -u         | git username                 | TangoMan75   |
| -S         | use ssh                      | false        |
| -H         | use https                    | true         |
| -c         | command to send installer    | make install |
| -b         | (shortcut for bitbucket.org) |              |
| -l         | (shortcut for gitlab.com)    |              |
| -g         | (shortcut for github.com)    |              |
| -h         | print help message           |              |

Execute following command in your terminal

### With wget
```bash
# jsDelivr
bash -c "`wget -q https://cdn.jsdelivr.net/gh/TangoMan75/installer/install.sh -O -`"
# raw.githubusercontent.com
bash -c "`wget -q https://raw.githubusercontent.com/TangoMan75/installer/master/install.sh -O -`"
```

### With cURL
if you have `curl` installed:
```bash
# jsDelivr
bash -c "`curl -fsSL https://cdn.jsdelivr.net/gh/TangoMan75/installer/install.sh`"
# raw.githubusercontent.com
bash -c "`curl -fsSL https://raw.githubusercontent.com/TangoMan75/installer/master/install.sh`"
```

#### Curl options

| Option |   Description    |
|--------|------------------|
| -f     | Fail silently    |
| -s     | Silent mode      |
| -S     | Show errors      |
| -L     | Follow redirects |
| -o     | Output file      |

### With PHP
if you have `php` installed:
```bash
# jsDelivr
php -r "file_put_contents('install.sh', file_get_contents('https://cdn.jsdelivr.net/gh/TangoMan75/installer/install.sh'));" && bash install.sh
# raw.githubusercontent.com
php -r "file_put_contents('install.sh', file_get_contents('https://raw.githubusercontent.com/TangoMan75/installer/master/install.sh'));" && bash install.sh
```

Requirements
------------
**TangoMan Universal Installer** will automatically install _git_ or _make_ when required. You can install _cURL_, _git_, and _make_ manually with the following commands though.
```bash
$ sudo apt-get install -y curl
```
```bash
$ sudo apt-get install -y git
```
```bash
$ sudo apt-get install -y make
```

License
=======

Copyrights (c) 2019 Matthias Morin

[![License][license-MIT]][license-url]
Distributed under the MIT license.

If you like **TangoMan Universal Installer** please star!
And follow me on GitHub: [TangoMan75](https://github.com/TangoMan75)
... And check my other cool projects.

[Matthias Morin | LinkedIn](https://www.linkedin.com/in/morinmatthias)

[license-MIT]: https://img.shields.io/badge/Licence-MIT-green.svg
[license-url]: LICENSE
