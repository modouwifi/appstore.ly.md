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

### get icon of a certain app

`GET /apps/APP_NAME/icon`

    $ http get appstore.ly.md/apps/wps/icon

Output:

```
HTTP/1.1 200 OK
Connection: Keep-Alive
Content-Disposition: inline; filename="wps-0.4.png"
Content-Length: 1672
Content-Type: image/png
Date: Mon, 18 Aug 2014 11:12:12 GMT
Last-Modified: Mon, 18 Aug 2014 10:52:30 GMT
Server: WEBrick/1.3.1 (Ruby/2.0.0/2013-05-14)
X-Content-Type-Options: nosniff



+-----------------------------------------+
| NOTE: binary data not shown in terminal |
+-----------------------------------------+

```

## Service Benchmark

Throughput 500 requests per second, or 20,000 requests per minute.

benchmark with command

    $ ab -n 2000 -c 200 http://appstore.ly.md/apps

Output:

```
Server Software:        Cowboy
Server Hostname:        appstore.ly.md
Server Port:            80

Document Path:          /apps
Document Length:        4137 bytes

Concurrency Level:      200
Time taken for tests:   3.733 seconds
Complete requests:      2000
Failed requests:        0
Write errors:           0
Total transferred:      8722000 bytes
HTML transferred:       8274000 bytes
Requests per second:    535.82 [#/sec] (mean)
Time per request:       373.263 [ms] (mean)
Time per request:       1.866 [ms] (mean, across all concurrent requests)
Transfer rate:          2281.92 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:       72   74   1.4     74      80
Processing:   114  265  77.3    250     824
Waiting:      114  262  71.7    249     757
Total:        187  339  77.5    325     897

Percentage of the requests served within a certain time (ms)
  50%    325
  66%    346
  75%    363
  80%    377
  90%    423
  95%    478
  98%    571
  99%    647
 100%    897 (longest request)
```
