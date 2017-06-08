#!/bin/sh

cat <<BEGIN
<html>
    <head>
        <meta name="viewport" content="width=device-width">
        <style>
            * {
                margin: 0;
                padding: 0;
                zoom: 1;
                font-family: sans-serif;
            }
            body {
                background: #ddd;
            }
            menu {
                max-width: 1000px;
                margin:10px auto;
            }
            menu ul {
                width:100%;
                height:100%;
                display: flex;
                flex-wrap: wrap;
                justify-content: space-around;
                align-items: center;
                align-content: space-around;
                list-style-type: none;
            }
            menu li {
                display:block;
            }
            menu a {
                display: flex;
                flex-wrap: wrap;
                justify-content: space-around;
                align-items: center;
                align-content: space-around;
                flex-direction: column;
                text-decoration: none;
                color: #333;
                margin: 10px;
                height: 150px;
                width: 120px;
                background: #fff;
                padding:10px;
            }
            menu a:hover{
                background: #eee;
            }
            .img {
                display:block;
                width:100%;
                font-size:0;
                line-height:0;
                height:0;
                padding-top:90%;
                background-repeat:no-repeat;
                background-color:transparent;
                background-size:contain;
                background-position: center center;
            }
            .lib {
                display:block;
                text-align:center;
                font-weight:bold;
            }
        </style>
    </head>
    <body>
        <menu>
            <ul>
BEGIN

while read code name url dom dest img
do
cat <<DOMAINS
                <li>
                    <a href="${url}">
                        <span class="img" style="background-image:url('img/${img}')">${name}</span>
                        <span class="lib">${name}</span>
                    </a>
                </li>
DOMAINS
done < $ALIAS

cat <<END
            </ul>
        </menu>
    </body>
</html>
END
