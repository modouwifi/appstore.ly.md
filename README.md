# App Store for Modouwifi

## APIs

### list all apps

`GET /apps`

    $ http get appstore.ly.md/apps

Output:

```
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 1750
Content-Type: application/json
Date: Mon, 18 Aug 2014 02:46:42 GMT
Server: WEBrick/1.3.1 (Ruby/2.0.0/2014-05-08)
Via: 1.1 vegur
X-Content-Type-Options: nosniff

[
    {
        "author": "modouwifi",
        "description": "魔豆上基于 Samba 协议的文件共享",
        "email": "tech@mochui.net",
        "homepage": "https://github.com/modouwifi/modou-samba",
        "icon": null,
        "instructions": null,
        "md5_sum": "5dfd3edd3694f42c2ed5c88fa3ea7284",
        "name": "modou-samba",
        "package_id": "com.modouwifi.modou-samba",
        "release_date": null,
        "size": 1351698,
        "url": "http://appstore.ly.md/apps/modou-samba-0.1.mpk",
        "version": "0.1"
    },
    {
        "author": "modouwifi",
        "description": "自定义上网欢迎页",
        "email": "tech@mochui.net",
        "homepage": "https://github.com/modouwifi/welcome-page",
        "icon": null,
        "instructions": null,
        "md5_sum": "64ed6161d3910d97c6dec161adc7949a",
        "name": "welcome-page",
        "package_id": "com.modouwifi.welcome-page",
        "release_date": null,
        "size": 1056,
        "url": "http://appstore.ly.md/apps/welcome-page-0.1.mpk",
        "version": "0.1"
    }
]
```

### get info of a certain app

`GET /apps/APP_NAME`

    $ http get appstore.ly.md/apps/hdns

Output:

```
HTTP/1.1 200 OK
Connection: Keep-Alive
Content-Length: 395
Content-Type: application/json
Date: Mon, 18 Aug 2014 04:02:55 GMT
Server: WEBrick/1.3.1 (Ruby/2.0.0/2013-05-14)
X-Content-Type-Options: nosniff

{
    "author": "modouwifi",
    "description": "魔豆上的高级 DNS",
    "email": "tech@mochui.net",
    "homepage": "https://github.com/modouwifi/hdns",
    "icon": null,
    "instructions": null,
    "md5_sum": "8b5369b1a4d14e80b44f7440304c1898",
    "name": "hdns",
    "package_id": "com.modouwifi.hdns",
    "release_date": null,
    "size": 12827,
    "url": "http://appstore.ly.md/apps/hdns-0.4.2.mpk",
    "version": "0.4.2"
}
```

### download a certain app

`GET /apps/APP_NAME/download`

    $ http get appstore.ly.md/apps/hdns/download

Output:

```
HTTP/1.1 200 OK
Connection: Keep-Alive
Content-Disposition: attachment; filename="hdns-0.4.2.mpk"
Content-Length: 12827
Content-Type: application/octet-stream
Date: Mon, 18 Aug 2014 04:03:31 GMT
Last-Modified: Mon, 28 Jul 2014 08:55:44 GMT
Server: WEBrick/1.3.1 (Ruby/2.0.0/2013-05-14)
X-Content-Type-Options: nosniff



+-----------------------------------------+
| NOTE: binary data not shown in terminal |
+-----------------------------------------+

```
