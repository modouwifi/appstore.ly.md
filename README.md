# 魔豆路由器应用商店

[![Code Climate](https://codeclimate.com/github/modouwifi/appstore.ly.md/badges/gpa.svg)](https://codeclimate.com/github/modouwifi/appstore.ly.md)
[![Build Status](https://travis-ci.org/modouwifi/appstore.ly.md.svg?branch=master)](https://travis-ci.org/modouwifi/appstore.ly.md)

## APIs

For latest API definitions, please refer to [app_store_server.rb](https://github.com/modouwifi/appstore.ly.md/blob/master/app_store_server.rb)

### list all apps

`GET /apps`

    $ http get appstore.ly.md/apps

Output:

```
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 4137
Content-Type: application/json
Date: Tue, 19 Aug 2014 08:50:28 GMT
Server: Cowboy
Status: 200 OK
Via: 1.1 vegur
X-Content-Type-Options: nosniff

[
    {
        "author": "魔豆路由器",
        "description": "科学上网",
        "display_name": "科学上网",
        "email": "rd@mochui.net",
        "homepage": "www.modouwifi.com",
        "icon": "./res/icon_111X111.png",
        "icon_url": "http://appstore.ly.md/icons/hdns-0.4.4.png",
        "install_location": "internal",
        "instructions": null,
        "md5_sum": "8f06cbeca5ed5b6225e95dbc760851f0",
        "name": "hdns",
        "package_id": "com.modouwifi.hdns",
        "release_date": "2014.08.18",
        "require_os_version": null,
        "size": 13259,
        "url": "http://appstore.ly.md/apps/hdns-0.4.4.mpk",
        "version": "0.4.4"
    },
    {
        "author": "魔豆路由器",
        "description": "欢迎页",
        "display_name": "welcome-page",
        "email": "rd@mochui.net",
        "homepage": "www.modouwifi.com",
        "icon": "./res/icon_111X111.png",
        "icon_url": "http://appstore.ly.md/icons/welcome-page-0.4.1.png",
        "install_location": "internal",
        "instructions": null,
        "md5_sum": "bec09075dfcafaf07061a8d8b76f7fc2",
        "name": "welcome-page",
        "package_id": "com.modouwifi.welcome-page",
        "release_date": "2014.08.19",
        "require_os_version": null,
        "size": 69218,
        "url": "http://appstore.ly.md/apps/welcome-page-0.4.1.mpk",
        "version": "0.4.1"
    }
]
```

### list available apps

`GET /apps?os_version=CURRENT_OS_VERSION&install_location=INSTALL_LOCATION`

    $ http get 'appstore.ly.md/apps?os_version=0.6.13&install_location=internal'

#### params format

| params                | format                    | example
| --------------------- | ------------------------- | --------
| CURRENT_OS_VERSION    | major.minor.patch         | 0.6.20
| INSTALL_LOCATION      | 'internal' or 'external'  | internal

All params are __optional__

### get info of a certain app

`GET /apps/APP_NAME`

    $ http get appstore.ly.md/apps/hdns

Output:

```
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 508
Content-Type: application/json
Date: Tue, 19 Aug 2014 08:57:38 GMT
Server: Cowboy
Status: 200 OK
Via: 1.1 vegur
X-Content-Type-Options: nosniff

{
    "author": "魔豆路由器",
    "description": "科学上网",
    "display_name": "科学上网",
    "email": "rd@mochui.net",
    "homepage": "www.modouwifi.com",
    "icon": "./res/icon_111X111.png",
    "icon_url": "http://appstore.ly.md/icons/hdns-0.4.4.png",
    "install_location": "internal",
    "instructions": null,
    "md5_sum": "8f06cbeca5ed5b6225e95dbc760851f0",
    "name": "hdns",
    "package_id": "com.modouwifi.hdns",
    "release_date": "2014.08.18",
    "require_os_version": null,
    "size": 13259,
    "url": "http://appstore.ly.md/apps/hdns-0.4.4.mpk",
    "version": "0.4.4"
}
```

### download a certain app

`GET /apps/APP_NAME/download`

    $ http get appstore.ly.md/apps/hdns/download

Output:

```
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Disposition: attachment; filename="hdns-0.4.4.mpk"
Content-Length: 13259
Content-Type: application/octet-stream
Date: Tue, 19 Aug 2014 08:58:01 GMT
Last-Modified: Tue, 19 Aug 2014 08:43:15 GMT
Server: Cowboy
Status: 200 OK
Via: 1.1 vegur
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
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Disposition: inline; filename="wps-0.4.png"
Content-Length: 1672
Content-Type: image/png
Date: Tue, 19 Aug 2014 08:58:47 GMT
Last-Modified: Tue, 19 Aug 2014 08:43:15 GMT
Server: Cowboy
Status: 200 OK
Via: 1.1 vegur
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
