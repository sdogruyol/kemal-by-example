(() => {
  const historyNode = document.getElementById("initial-metrics");
  const history = historyNode ? JSON.parse(historyNode.textContent || "[]") : [];
  const maxPoints = 30;

  const elements = {
    cpuValue: document.getElementById("cpu-value"),
    memoryValue: document.getElementById("memory-value"),
    updatedAt: document.getElementById("updated-at"),
    cpuChart: document.getElementById("cpu-chart"),
    memoryChart: document.getElementById("memory-chart"),
    connectionStatus: document.getElementById("connection-status"),
    connectionDot: document.getElementById("connection-dot"),
  };

  const formatPercent = (value) => `${Number(value || 0).toFixed(2)}%`;

  const buildPoints = (snapshots, key) => {
    if (!snapshots.length) return "";

    const width = 320;
    const height = 160;
    const step = snapshots.length > 1 ? width / (snapshots.length - 1) : width / 2;

    return snapshots
      .map((snapshot, index) => {
        const x = snapshots.length > 1 ? index * step : width / 2;
        const y = height - (Math.min(Math.max(Number(snapshot[key] || 0), 0), 100) / 100) * (height - 16) - 8;
        return `${x},${y}`;
      })
      .join(" ");
  };

  const render = () => {
    const latest = history[history.length - 1] || {
      cpu_percent: 0,
      memory_percent: 0,
      created_at: "--:--:--",
    };

    elements.cpuValue.textContent = formatPercent(latest.cpu_percent);
    elements.memoryValue.textContent = formatPercent(latest.memory_percent);
    elements.updatedAt.textContent = latest.created_at;

    elements.cpuChart.setAttribute("points", buildPoints(history, "cpu_percent"));
    elements.memoryChart.setAttribute("points", buildPoints(history, "memory_percent"));
  };

  const setConnectionState = (state, label) => {
    elements.connectionStatus.textContent = label;
    elements.connectionDot.classList.remove("connected", "disconnected");

    if (state === "connected") elements.connectionDot.classList.add("connected");
    if (state === "disconnected") elements.connectionDot.classList.add("disconnected");
  };

  const appendSnapshot = (snapshot) => {
    history.push(snapshot);
    while (history.length > maxPoints) history.shift();
    render();
  };

  const connect = () => {
    const protocol = window.location.protocol === "https:" ? "wss" : "ws";
    const socket = new WebSocket(`${protocol}://${window.location.host}/dashboard/socket`);

    socket.addEventListener("open", () => setConnectionState("connected", "Live stream connected"));
    socket.addEventListener("close", () => {
      setConnectionState("disconnected", "Disconnected, reconnecting...");
      window.setTimeout(connect, 2000);
    });
    socket.addEventListener("error", () => socket.close());
    socket.addEventListener("message", (event) => {
      const payload = JSON.parse(event.data);
      if (payload.event === "metric_snapshot") appendSnapshot(payload.snapshot);
    });
  };

  render();
  connect();
})();
