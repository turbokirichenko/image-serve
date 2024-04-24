local ngx = require "ngx"
local imagick = require "resty.imagick.wand"

-- get base dimention of the resizing
local function get_base_dimention(query_args)
    -- set deafult value
    local def_w = "720"
    local def_h = ""
    local def_ext = ""
    -- get value from query
    local img_ext = query_args['ext'] or query_args['extention'] or def_ext
    local img_h = query_args['h'] or query_args['height'] or def_h
    local img_w = query_args['w'] or query_args['width'] or ((#img_h == 0) and def_w or "")
    return img_w, img_h, img_ext
end

-- capture request
local function capture_request(capture, uri)
    local capture_err = 'ERR: URI or captureURI is empry!'
    local response_err = 'ERR: Error while capture response!'
    -- check data
    if not capture or not uri then
        error(capture_err)
    end
    -- create capture request
    local capture_uri = capture .. uri
    local response = ngx.location.capture(capture_uri)
    if (not response) or (response.status ~= ngx.HTTP_OK) then
        ngx.log(ngx.ERR, response_err)
        error(response.body or response_err)
    end
    return response
end

-- resize image by imagick
local function resize_image_from_blob(blob, thumb_str, ext)
    -- set image to the blob format
    local image, imageErr = imagick.load_image_from_blob(blob)
    if not image then
        error(imageErr)
    end
    -- resizing image
    image:thumb(thumb_str)
    if ext and (#ext > 0) then
        -- force calling function
        image:set_format(ext)
    end
    -- get blob of the image
    local blobCode, blobErr = image:get_blob()
    if not blobCode then
        error(blobErr)
    end
    return blobCode
end

-- get mime type by current extention
local function mime_type_by_extension(ext)
    local default_mime_type = "text/plain"
    if (not ext) or (#ext == 0) then
        return default_mime_type
    end
    local mime_types = {
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
    local res = mime_types[ext] or default_mime_type
    return res
end

-- parced data
local ngx_args = ngx.req.get_uri_args()
local ngx_uri = ngx.var.uri
local capture_uri = ngx.var.capture_uri

-- create capture request
ngx.log(ngx.NOTICE, 'req_uri: ' .. ngx_uri)
local response = capture_request(capture_uri, ngx_uri)

-- resizing image
local img_w, img_h, ext = get_base_dimention(ngx_args)
local thumb_str = img_w .. "x" .. img_h
ngx.log(ngx.NOTICE, 'size: ' .. thumb_str)
ngx.log(ngx.NOTICE, 'ext: ' .. ext)
local blob = resize_image_from_blob(response.body, thumb_str, ext)

-- return the result
-- set content-type
local header_name = "Content-Type"
local mime_type = (not ext or #ext == 0)
    and response.header[header_name]
    or mime_type_by_extension(ext)

ngx.log(ngx.NOTICE, 'mime-type: ' .. mime_type)
ngx.header[header_name] = mime_type
ngx.print(blob)
