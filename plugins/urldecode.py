import json
import urllib.parse

from datasette import hookimpl


@hookimpl
def prepare_jinja2_environment(env):
    env.filters["urldecode"] = lambda u: urllib.parse.unquote(u)
    env.filters["prepimage"] = lambda u: urllib.parse.quote(u, safe="").replace(
        ".", "%2E"
    )
    env.filters["parsejson"] = lambda u: json.loads(u)


# https%3A%2F%2Fwww%2Epbp%2Eie%2Fcontent%2Fimages%2Fsize%2Fw2000%2F2024%2F11%2FZoe-Laplaud%2Epng
# https%3A%2F%2Fwww.pbp.ie%2Fcontent%2Fimages%2Fsize%2Fw2000%2F2024%2F11%2FZoe-Laplaud.png
