# 🌿 ygg — Yggdrasil Terminal Calendar

**ygg** is a lightweight, fast, terminal-based calendar and event management tool written in **Odin**.

It provides a clean calendar grid directly in your terminal, along with simple commands for creating, listing, and deleting events. Events are persisted locally using JSON, so your schedule remains available between runs.

---

## ✨ Features

- 📅 **Terminal Calendar** — View the current month directly from your terminal.
- ⚡ **Fast & Lightweight** — Written in Odin with minimal dependencies.
- 🧮 **Calendar Calculations** — Generates accurate calendar layouts using date calculations.
- 💾 **Persistent Events** — Events are automatically stored in a local `events.json` file.
- 🏷️ **Event IDs** — Every event receives a numeric ID for easy management.
- 🎯 **Simple CLI** — Add, list, and delete events using straightforward command-line flags.
- 🎨 **ANSI Styling** — Designed to support colored terminal output for important dates and events.

---

## 🚀 Getting Started

### Prerequisites

You need the **Odin compiler** installed and available in your `PATH`.

- [Odin Programming Language](https://odin-lang.org/?utm_source=chatgpt.com)

You can verify your installation with:

```bash
odin version
```

### Clone the Repository

```bash
git clone https://github.com/your-username/ygg.git
cd ygg
```

### Build

Build the project with Odin:

```bash
odin build src/ -out:ygg -o:speed
```

This creates the `ygg` executable in the project directory.

### Run

```bash
./ygg
```

---

## 📖 Usage

### View the Current Month

Running `ygg` without any arguments displays the current calendar month:

```bash
./ygg
```

Example:

```text
       August 2026

 Mon Tue Wed Thu Fri Sat Sun
                      1   2
  3   4   5   6   7   8   9
 10  11  12  13  14  15  16
 17  18  19  20  21  22  23
 24  25  26  27  28  29  30
 31
```

---

### Add an Event

Use `-a` to add a new event.

```bash
./ygg -a "Doctor Appointment"
```

If no target date is provided, the event is associated with today's date.

You can specify a date with `-t`:

```bash
./ygg -a "Doctor Appointment" -t "2026-08-28"
```

The date format is:

```text
YYYY-MM-DD
```

For example:

```bash
./ygg -a "Project Submission" -t "2026-09-01"
```

---

### List Events

Use `-l` to display all saved events:

```bash
./ygg -l
```

Example:

```text
[1] Doctor Appointment - 2026-08-28
[2] Project Submission - 2026-09-01
```

---

### Delete an Event

Every event has a numeric ID.

Use `-d` followed by the event ID to delete it:

```bash
./ygg -d 1
```

This removes the event with ID `1` from persistent storage.

---

## 💾 Event Storage

`ygg` stores events locally in:

```text
events.json
```

The file is automatically created when events are saved.

A typical event structure looks like:

```json
[
  {
    "id": 1,
    "title": "Doctor Appointment",
    "date": "2026-08-28"
  }
]
```

This keeps the application simple and makes the event data easy to inspect or back up.

---

## 🛠️ Project Structure

```text
ygg/
├── events.json
├── LICENSE
├── README.md
└── src/
    ├── main.odin
    ├── cal.odin -- Not structured yet
    ├── cli.odin
    └── store.odin
```

### Source Files

| File         | Responsibility                               |
| ------------ | -------------------------------------------- |
| `main.odin`  | Application entry point and command routing  |
| `cal.odin`   | Calendar calculations and terminal rendering |
| `cli.odin`   | Command-line argument parsing                |
| `store.odin` | Event loading, saving, and JSON persistence  |

---

## 🧱 Architecture

The project is intentionally split into small modules:

```text
                 ┌──────────────┐
                 │  main.odin   │
                 │ Entry Point  │
                 └──────┬───────┘
                        │
              ┌─────────┴─────────┐
              │                   │
       ┌──────▼──────┐     ┌──────▼──────┐
       │  cli.odin   │     │   cal.odin  │
       │ CLI Parsing  │     │  Calendar   │
       └──────┬──────┘     │  Rendering  │
              │            └─────────────┘
              │
       ┌──────▼──────┐
       │ store.odin  │
       │ Event Store │
       └──────┬──────┘
              │
       ┌──────▼──────┐
       │ events.json │
       └─────────────┘
```

This separation keeps CLI parsing, calendar rendering, and persistence independent from each other.

---

## 🧑‍💻 Development

Clone the repository:

```bash
git clone https://github.com/your-username/ygg.git
cd ygg
```

Build during development:

```bash
odin build src/
```

Or use optimized compilation:

```bash
odin build src/ -o:speed
```

Run:

```bash
./ygg
```

---

## 🗺️ Roadmap

### Calendar

- [x] Generate monthly calendar grid
- [x] Display the current month
- [x] Calculate correct weekday positions
- [ ] Navigate between months
- [ ] Display selected month/year
- [ ] Highlight today's date
- [ ] Highlight days containing events

### Events

- [x] Add events
- [x] List events
- [x] Delete events
- [x] Persist events to JSON -- Not done yet
- [ ] Improve event ID handling after deletion
- [ ] Edit existing events
- [ ] Search events
- [ ] Filter events by date
- [ ] Display events directly inside the calendar

### Terminal UI

- [ ] ANSI color highlighting
- [ ] Colored event indicators
- [ ] Interactive TUI mode
- [ ] Keyboard navigation
- [ ] Event selection
- [ ] Interactive event creation
- [ ] Interactive event deletion

### Notifications

- [ ] Background daemon
- [ ] Scheduled notifications
- [ ] SMS notifications
- [ ] Webhook integrations
- [ ] Mobile notifications

---

## 🎨 Planned Calendar Highlighting

One of the upcoming features is highlighting important dates directly in the calendar.

For example:

```text
       August 2026

 Mon Tue Wed Thu Fri Sat Sun
                      1   2
  3   4   5   6   7   8   9
 10  11  12  13  14  15  16
 17  18  19  20  21  22  23
 24  25  26  27  28  29  30
 31
```

Eventually, `ygg` will use ANSI escape sequences to visually distinguish:

- Today's date
- Dates containing events
- Selected dates
- Important events

---

## ⚡ Design Goals

`ygg` is being built around a few simple principles:

### Lightweight

The application should remain small and avoid unnecessary dependencies.

### Fast

Calendar rendering and event operations should be quick enough to feel instantaneous in a terminal.

### Simple

Commands should be easy to remember and predictable.

### Local First

Events are stored locally rather than requiring an external service or account.

### Terminal Native

The interface should embrace the terminal instead of trying to imitate a traditional graphical calendar.

---

## 🤝 Contributing

Contributions, ideas, and improvements are welcome.

To contribute:

1. Fork the repository.
2. Create a feature branch:

```bash
git checkout -b feature/my-feature
```

3. Make your changes.
4. Test the project:

```bash
odin build src/
./ygg
```

5. Commit your changes:

```bash
git add .
git commit -m "feat: add my feature"
```

6. Push the branch:

```bash
git push origin feature/my-feature
```

7. Open a pull request.

---

## 📄 License

`ygg` is distributed under the **MIT License**.

See the [`LICENSE`](LICENSE) file for more information.

---

## 🌿 Why "ygg"?

The name comes from **Yggdrasil**, the great tree from Norse mythology that connects the different worlds.

A calendar similarly connects different points in time — days, weeks, months, and events — into one navigable structure.

Hence:

```text
Yggdrasil → Ygg → Calendar
```

---

<p align="center">
  Built with ❤️ and <a href="https://odin-lang.org/">Odin</a>.
</p>
