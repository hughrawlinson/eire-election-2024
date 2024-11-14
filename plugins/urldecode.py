import urllib.parse

from datasette import hookimpl


@hookimpl
def prepare_jinja2_environment(env):
    env.filters["urldecode"] = lambda u: urllib.parse.unquote(u)
