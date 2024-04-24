# Openresty service to serve images

<h3 style="color: #B2B2B280">It is a simple reverse proxy server for image processing</h3>

## Key Purposes

<ul style="color: #BB8800">
    <li><b >Provide the fast way to edit images from the external source</b></li>
    <li><b>Minimise size of the image</b></li>
    <li><b>Change image extention</b></li>
    <li><b>Chenge default dimention of image</b></li>
</ul>

## Deploy

<b style="color: #F93030">NOTE: Recommended to use deployment via Dockerfile</b>

```bash
git clone http://github.com/turbokirichenko/static-serve.git
cd ./static-serve
docker buildx build --tag "static-serve" .
docker run -d -p 8082:8080 -n "image-service" static-serve
```

## Usage

<b style="color: #F9F9F9">First of all encode the url of a static resource in base64 encoding:</b>

```bash
$ echo -n 'https://avatars.githubusercontent.com/u/92226824?v=4' | base64

# aHR0cDovL2ltYWdlc291cmNlL25hbWUuanBn
```

<b style="color: #F9F9F9">Now you can interract with the service by simply API: </b>

```js
/** HTTP GET /image/<base64Url>/?...
 *
 * @param {string} base64url - is external image url in base64 encoding
 * @param {string | undefined} ext - new extention of the image (see MIMIE TYPES...)
 * @param {number | undefined} w - new width of the image
 * @param {number | undefined} h - new height of the image
 *
 * NOTE: service will resize image proportionally!
 *
 *
 * RESPONSE 200 OK
 */
```

<b style="color: #F93030">NOTE: service will resize image proportionally!</b>
<br />
<b>Example:</b>
<br />

```bash
$ curl -v -X GET "http://localhost:8082/image/aHR0cHM6Ly9hdmF0YXJzLmdpdGh1YnVzZXJjb250ZW50LmNvbS91LzkyMjI2ODI0P3Y9NA==?w
=200&ext=jpg" --output ./avatar.jpg
Note: Unnecessary use of -X or --request, GET is already inferred.
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0*   Trying 127.0.0.1:8082...
* Connected to localhost (127.0.0.1) port 8082 (#0)
> GET /image/aHR0cHM6Ly9hdmF0YXJzLmdpdGh1YnVzZXJjb250ZW50LmNvbS91LzkyMjI2ODI0P3Y9NA==?w=200&ext=avif HTTP/1.1
> Host: localhost:8082
> User-Agent: curl/7.75.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Server: openresty/1.21.4.1
< Date: Wed, 24 Apr 2024 15:35:26 GMT
< Content-Type: image/avif
< Content-Length: 1009
< Connection: keep-alive
<
{ [1009 bytes data]
100  1009  100  1009    0     0   2287      0 --:--:-- --:--:-- --:--:--  2293
* Connection #0 to host localhost left intact
```

<b>Result:</b>
![result image](https://github.com/turbokirichenko/image-serve/blob/main/avatar.jpg)

## Mime Types

<b style="color: #F9F9F9">There are available Mime Types:</b>

```lua
mime_types = {
    apng = 'image/apng',
    avif = 'image/avif',
    gif = 'image/gif',
    png = 'image/png',
    jpg = 'image/jpg',
    jpeg = 'image/jpg',
    jfif = 'image/jpg',
    pjpeg = 'image/jpg',
    svg = 'image/svg+xml',
    webp = 'image/webp',
    bmp = 'image/bmp',
    ico = 'image/x-icon',
    cur = 'image/x-icon',
    tif = 'image/tiff',
    tiff = 'image/tiff',
}
```

## ERROR

<b>You will get this image if the service returns an error:</b>

![error image](https://github.com/turbokirichenko/image-serve/blob/main/www/static/400.jpg)

<br />
<b>To change default error image, just replace it from www/static/400.jpg</b>

<br />
<b style="color: #F93030">NOTE: to more imformation about an error see: <i>'/var/log/nginx/error.log'</i>!</b>

## LOGS

- Access: <b>/var/log/nginx/amedia.log</b>
- Error: <b>/var/log/nginx/error.log</b>

## TODO

<ul style="color: #FF8800">
    <li><b>ENV variables</b></li>
    <li><b>E2E tests</b></li>
    <li><b>To increase the number of commands</b></li>
    <li><b>CLI version</b></li>
</ul>
