import json
import sys
import urllib.parse

from bs4 import BeautifulSoup

input = "".join(sys.stdin.readlines())
soup = BeautifulSoup(input, "html.parser")


def isurl(url):
    try:
        urllib.parse.urlparse(url)
        return True
    except (ValueError, TypeError):
        return False


result = {
    "statement": (
        statement.text.strip()
        if (statement := soup.select_one(".people-biography"))
        else ""
    ),
    "contact": {
        "email": (
            email.text.strip() if (email := soup.select_one(".people-email a")) else ""
        ),
        "phone": (
            phone.text.strip() if (phone := soup.select_one(".people-call a")) else ""
        ),
        **(
            {
                urllib.parse.urlparse(link).hostname: link
                for link in [
                    anchor.attrs["href"]
                    for anchor in soup.select(".people-social-network a")
                ]
                if isurl(link)
            }
        ),
    },
}

print(json.dumps(result))
