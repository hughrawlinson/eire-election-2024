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
