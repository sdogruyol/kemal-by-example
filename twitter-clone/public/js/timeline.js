(() => {
  const timeline = document.getElementById("timeline");
  if (!timeline) return;

  const emptyState = () => document.getElementById("empty-state");

  const escapeHtml = (value) =>
    String(value).replace(/[&<>"']/g, (char) => {
      const entities = {
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        "\"": "&quot;",
        "'": "&#39;",
      };

      return entities[char] || char;
    });

  const renderTweet = (tweet) => `
    <article class="card" data-tweet-id="${tweet.id}">
      <div class="tweet-header">
        <h2>${escapeHtml(tweet.display_name)}</h2>
        <span class="handle">${escapeHtml(tweet.handle)}</span>
      </div>

      <p class="tweet-body">${escapeHtml(tweet.body)}</p>
      <p class="meta likes-count">Likes: ${escapeHtml(tweet.likes_count)}</p>
      <p class="meta">Created at: ${escapeHtml(tweet.created_at)}</p>
      <p class="meta">Updated at: ${escapeHtml(tweet.updated_at)}</p>

      <div class="actions">
        <form action="/tweets/${tweet.id}/like" method="post">
          <button class="like" type="submit">Like</button>
        </form>

        <a class="button-link secondary" href="/tweets/${tweet.id}/edit">Edit</a>

        <form action="/tweets/${tweet.id}/delete" method="post">
          <button class="danger" type="submit">Delete</button>
        </form>
      </div>
    </article>
  `;

  const upsertTweet = (tweet, prepend = false) => {
    const current = timeline.querySelector(`[data-tweet-id="${tweet.id}"]`);
    const markup = renderTweet(tweet);

    if (current) {
      current.outerHTML = markup;
    } else if (prepend) {
      emptyState()?.remove();
      timeline.insertAdjacentHTML("afterbegin", markup);
    } else {
      timeline.insertAdjacentHTML("beforeend", markup);
    }
  };

  const deleteTweet = (tweetId) => {
    timeline.querySelector(`[data-tweet-id="${tweetId}"]`)?.remove();

    if (!timeline.querySelector("[data-tweet-id]") && !emptyState()) {
      timeline.insertAdjacentHTML(
        "afterbegin",
        '<div class="card" id="empty-state"><p class="empty-state">The timeline is empty. Create the first tweet.</p></div>'
      );
    }
  };

  const protocol = window.location.protocol === "https:" ? "wss" : "ws";
  const socket = new WebSocket(`${protocol}://${window.location.host}/timeline/socket`);

  socket.addEventListener("message", (event) => {
    const payload = JSON.parse(event.data);

    if (payload.event === "tweet_created") upsertTweet(payload.tweet, true);
    if (payload.event === "tweet_updated") upsertTweet(payload.tweet);
    if (payload.event === "tweet_liked") upsertTweet(payload.tweet);
    if (payload.event === "tweet_deleted") deleteTweet(payload.tweet_id);
  });
})();
