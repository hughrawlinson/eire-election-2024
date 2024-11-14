document.addEventListener("DOMContentLoaded", () => {
  let existingRequestController = null;
  let resultsContainer = document.querySelector("div#results");

  function makeCard({ title, subtitle, link }) {
    const a = document.createElement("a");
    a.setAttribute("href", link);
    const card = document.createElement("div");
    a.appendChild(card);
    card.className = "result-card";
    const titleElement = document.createElement("h4");
    titleElement.innerText = title;
    card.appendChild(titleElement);
    if (subtitle) {
      const subtitleElement = document.createElement("span");
      subtitleElement.innerText = subtitle;
      card.appendChild(subtitleElement);
    }
    return a;
  }

  async function populateResults(results) {
    resultsContainer.innerHTML = "";
    [
      results.candidates.slice(0, 5).map((candidate) =>
        makeCard({
          title: `${candidate.name} - ${candidate.party}`,
          subtitle: "Candidate",
          link: encodeURI(`/candidates/${candidate.name}`),
        })
      ),
      results.parties.slice(0, 5).map((party) =>
        makeCard({
          title: party.party,
          subtitle: "Party",
          link: encodeURI(`/parties/${party.party}`),
        })
      ),
      results.constituencies.slice(0, 5).map((constituency) =>
        makeCard({
          title: constituency.constituency,
          subtitle: "Constituency",
          link: encodeURI(`/constituencies/${constituency.constituency}`),
        })
      ),
    ]
      .flat()
      .forEach((card) => resultsContainer.appendChild(card));
    return Promise.resolve();
  }

  function clearResults() {}

  async function getResults(value) {
    if (value.length < 3) {
      return [];
    }

    if (existingRequestController) {
      existingRequestController.abort();
    }
    existingRequestController = new AbortController();
    const response = await fetch(
      `/election-2024.json?sql=select%0D%0A++json_object%28%0D%0A++++%27candidates%27%2C%0D%0A++++%28%0D%0A++++++select%0D%0A++++++++json_group_array%28%0D%0A++++++++++json_object%28%0D%0A++++++++++++%27name%27%2C%0D%0A++++++++++++name%2C%0D%0A++++++++++++%27party%27%2C%0D%0A++++++++++++party%2C%0D%0A++++++++++++%27constituency%27%2C%0D%0A++++++++++++constituency%0D%0A++++++++++%29%0D%0A++++++++%29%0D%0A++++++from%0D%0A++++++++candidates%0D%0A++++++where%0D%0A++++++++name+like+%27%25%27+%7C%7C+%3Aquery+%7C%7C+%27%25%27%0D%0A++++%29%2C%0D%0A++++%27parties%27%2C%0D%0A++++%28%0D%0A++++++select%0D%0A++++++++json_group_array%28json_object%28%27party%27%2C+party%29%29%0D%0A++++++from%0D%0A++++++++%28%0D%0A++++++++++select%0D%0A++++++++++++party%0D%0A++++++++++from%0D%0A++++++++++++candidates%0D%0A++++++++++group+by%0D%0A++++++++++++party%0D%0A++++++++%29%0D%0A++++++where%0D%0A++++++++party+like+%27%25%27+%7C%7C+%3Aquery+%7C%7C+%27%25%27%0D%0A++++%29%2C%0D%0A++++%27constituencies%27%2C%0D%0A++++%28%0D%0A++++++select%0D%0A++++++++json_group_array%28json_object%28%27constituency%27%2C+constituency%29%29%0D%0A++++++from%0D%0A++++++++constituencies%0D%0A++++++where%0D%0A++++++++constituency+like+%27%25%27+%7C%7C+%3Aquery+%7C%7C+%27%25%27%0D%0A++++%29%0D%0A++%29&query=${value}`,
      { signal: existingRequestController.signal }
    );
    if (!existingRequestController.aborted) {
      const result = await response.json();
      await populateResults(JSON.parse(result.rows[0][0]));
    }
  }

  function debounce(func, timeout = 800) {
    let timer;
    return (...args) => {
      clearTimeout(timer);
      timer = setTimeout(() => {
        func.apply(this, args);
      }, timeout);
    };
  }

  document.querySelector("input#search").addEventListener("keyup", (event) => {
    debounce(getResults)(event.target.value);
  });
});
