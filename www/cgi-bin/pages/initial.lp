<!doctype html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>MJSXJ02HL: <%= page_info.title %></title>
        <link rel="icon" href="/favicon.ico">
        <link rel="stylesheet" href="/css/initial.css">
    </head>
    <body>
        <%
        cgilua.lp.include("pages/" .. page_info.file, {
            cgilua = cgilua,
            required = required,
            page_info = page_info,
        })
        %>
    </body>
</html>
