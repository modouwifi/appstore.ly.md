# App Store for Modouwifi

## APIs

### list all apps

`GET /list`

    $ http get appstore.ly.md/list

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
        "url": "https://github.com/modouwifi/modou-samba/releases/download/modou-samba0.1/modou-samba0.1.tar.gz",
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
        "url": "https://github.com/modouwifi/welcome-page/releases/download/welcome-page.0.1/welcome-page.mpk",
        "version": "0.1"
    },
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
        "url": "https://github.com/modouwifi/hdns/releases/download/hdns0.4.2/hdns-0.4.2.mpk",
        "version": "0.4.2"
    },
    {
        "author": "modouwifi",
        "description": "魔豆路由器背光控制应用",
        "email": "tech@mochui.net",
        "homepage": "https://github.com/modouwifi/backlight-control",
        "icon": null,
        "instructions": null,
        "md5_sum": "ee895a75ffafe683ab7136026a99ffdb",
        "name": "backlight-control",
        "package_id": "com.modouwifi.backlight-control",
        "release_date": null,
        "size": 7269,
        "url": "https://github.com/modouwifi/backlight-control/releases/download/1.0/backlight-control.tar.gz",
        "version": "1.0"
    }
]
```
