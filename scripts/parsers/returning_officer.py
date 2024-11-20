import json
import sys
from urllib.parse import urlparse, urlunparse

from bs4 import BeautifulSoup

input = "".join(sys.stdin.readlines())
soup = BeautifulSoup(input, "html.parser")


def isurl(url):
    try:
        urlparse(url)
        return True
    except (ValueError, TypeError):
        return False


def wrap(l, d=None):
    try:
        return l()
    except Exception as e:
        if d:
            return d
        return str(e)


def qualify(path):
    hurl = urlparse(sys.argv[2])
    purl = urlparse(path)
    return urlunparse((hurl.scheme, hurl.netloc, purl.path, "", "", ""))


result = [
    (
        wrap(
            lambda: {
                "constituency": sys.argv[1],
                "surname": row.contents[0].text,
                "party": (
                    wrap(lambda: v[0].text)
                    if (v := [x for x in (row.select("td"))][1].contents)
                    else ""
                ),
                "full_name": (
                    wrap(lambda: v[2].text.split(", of ")[0].strip("()"))
                    if (v := [x for x in (row.select("td"))][1].contents)
                    else ""
                ),
                "occupation": (
                    wrap(lambda: v[4].text.strip("()"))
                    if (v := [x for x in (row.select("td"))][1].contents)
                    else ""
                ),
                "imageUrl": (
                    qualify(v.attrs["src"]) if (v := row.select_one("img")) else ""
                ),
            },
            d={"constituency": sys.argv[1]},
        )
    )
    for row in soup.select("table tr")
]

# result = {
#     "statement": (
#         statement.text.strip()
#         if (statement := soup.select_one(".people-biography"))
#         else ""
#     ),
#     "contact": {
#         "email": (
#             email.text.strip() if (email := soup.select_one(".people-email a")) else ""
#         ),
#         "phone": (
#             phone.text.strip() if (phone := soup.select_one(".people-call a")) else ""
#         ),
#         **(
#             {
#                 urllib.parse.urlparse(link).hostname: link
#                 for link in [
#                     anchor.attrs["href"]
#                     for anchor in soup.select(".people-social-network a")
#                 ]
#                 if isurl(link)
#             }
#         ),
#     },
# }

print(json.dumps(result))
