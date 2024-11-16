## Wikipedia scraper

```js
let rows = Array.from(document.querySelectorAll("tr"));

let parties = Array.from(rows[0].children)
  .slice(2)
  .map((element) => element.innerText)
  .filter(Boolean);

function batchByBr(arr) {
  let out = [];
  let temp = [];
  for (let i in arr) {
    if (arr[i].tagName === "BR") {
      let next = arr[Number(i) + 1];
      if (next && next.innerText != "(") {
        out.push(temp);
        temp = [];
      }
    } else {
      temp.push(arr[i]);
    }
  }
  out.push(temp);

  return out;
}

let candidates = rows
  .slice(2)
  .map((el) => el.children)
  .flatMap(([constituency, ...candidates]) =>
    candidates.flatMap((candidateList, columnIndex) =>
      batchByBr(Array.from(candidateList.childNodes).filter(Boolean)).map(
        (candidate) => ({
          party: parties[columnIndex],
          constituency: constituency.innerText.split("\n")[0],
          candidateName: candidate[0].textContent,
          candidate: JSON.stringify(candidate, null, 2),
        })
      )
    )
  );
```

## FF

Candidates list: https://www.fiannafail.ie/our-people?position=8

```js
Array.from(document.querySelectorAll("#representatives-cards .card")).map(
  (card) => ({
    name: card.querySelector("h5").innerText,
    imageURL: card.querySelector("img").attributes["src"].value,
    candidatePage: card.querySelector("a.people-link").attributes["href"].value,
    titles: Array.from(card.querySelectorAll("div.person-info > p")).map(
      (title) => title.innerText
    ),
  })
);
```

## FG

Candidates list: https://www.finegael.ie/our-people/general-election-candidates/

```js
Array.from(document.querySelectorAll("div.row.people-list > div")).map(
  (card) => ({
    name: card.querySelector("h3").innerText,
    imageURL: card.querySelector("img").attributes["src"].value,
    candidatePage: card.querySelector("a").attributes["href"].value,
    titles: Array.from(card.querySelectorAll("a > p"))
      .map((title) => title.innerText)
      .filter(Boolean),
  })
);
```

## Green

Candidates list: https://www.greenparty.ie/people/

```js
Array.from(document.querySelectorAll("article.node--type-person")).map(
  (card) => ({
    name: card.querySelector("div.person-teaser__title").innerText,
    imageURL: new URL(
      card.querySelector("img").attributes["src"].value,
      "https://www.greenparty.ie/"
    ).href,
    candidatePage: new URL(
      card.querySelector("a").attributes["href"].value,
      "https://www.greenparty.ie"
    ).href,
    titles: Array.from(
      card.querySelectorAll(
        "div.person-teaser__text-wrapper div.field:last-child"
      )
    )
      .map((title) => title.innerText)
      .filter(Boolean),
  })
);
```

## Labour

Candidates list: https://labour.ie/people

```js
Array.from(document.querySelectorAll(".user")).map((card) => ({
  name: card.querySelector("div.user-content h3").innerText,
  imageURL: new URL(
    card.querySelector("img.attachment-user-teaser").attributes[
      "data-lazy-src"
    ].value,
    "https://www.labour.ie"
  ).href,
  candidatePage: new URL(
    card.querySelector("a").attributes["href"].value,
    "https://www.labour.ie"
  ).href,
  titles: [],
  contact: {
    email: card.querySelector("div.user-contact div.email span").innerText,
    phone: card.querySelector("div.user-contact div.phone a")?.innerText,
  },
}));
```

## PBP

Candidates list: https://www.pbp.ie/ge24/candidates/

```js
Array.from(document.querySelectorAll("details[name='candidate'] article")).map(
  (card) => ({
    name: card.querySelector("h1.post-title").innerHTML,
    imageURL:
      new URL(
        card.querySelector("img")?.attributes["src"].value,
        "https://www.pbp.ie"
      ).href ?? null,
    candidatePage: null,
    titles: [],
    statement: Array.from(
      card.querySelectorAll("section.relative p:not(:last-of-type)")
    )
      .map((el) => el.innerHTML)
      .join("\n"),
    contact: {
      email:
        card.querySelector("a[href*='mailto:']")?.innerText.replace("✉ ", "") ??
        null,
      phone:
        card.querySelector("a[href*='tel:']")?.innerText.replace("📞 ", "") ??
        null,
      ...Object.fromEntries(
        Array.from(card.querySelectorAll("section div:last-child a"))
          .map((el) => {
            try {
              const href = new URL(el.attributes["href"].value);
              return [href.host, href.href];
            } catch {
              console.log(el.attributes["href"]);
              return null;
            }
          })
          .filter(Boolean)
      ),
    },
  })
);
```

## SF

Candidates List: https://vote.sinnfein.ie

```js
// I had to manually add the #candidates to an ancestor
Array.from(document.querySelectorAll("#candidates article.dp-dfg-item")).map(
  (card) => ({
    name: card.querySelector("h2").innerText,
    imageURL: new URL(
      card.querySelector("figure a img").attributes["src"].value,
      "https://vote.sinnfein.ie"
    ).href,
    candidatePage: new URL(
      card.querySelector("figure a").attributes["href"].value,
      "https://vote.sinnfein.ie"
    ).href,
  })
);
```

## SD

Candidates list: https://www.socialdemocrats.ie/position/candidate-general-election

```js
Array.from(document.querySelectorAll(".people-card")).map((card) => ({
  name: card.querySelector("h2").innerText,
  imageURL: new URL(
    card.querySelector(".people-img").attributes["data-back"].value,
    "https://www.socialdemocrats.ie"
  ).href,
  candidatePage: new URL(
    card.attributes["href"].value,
    "https://www.socialdemocrats.ie"
  ).href,
}));
```
