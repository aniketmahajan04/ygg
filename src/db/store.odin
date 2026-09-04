package db

import sqlite "../../shared/sqlite"
import "../cli"
import "core:fmt"
import "core:strings"

DB_PATH :: "./events.db"

db_init :: proc() -> bool {
	sqlite.db_cache_cap(16)

	c_path := strings.clone_to_cstring(DB_PATH)

	if err := sqlite.db_init(c_path); err != .OK {
		fmt.printfln("❌ Failed to open database at %s (Error: %v)", DB_PATH, err)
		return false
	}

	schema := `
    CREATE TABLE IF NOT EXISTS events (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      date TEXT NOT NULL
    );
  `

	if err := sqlite.db_execute_simple(schema); err != .OK {
		fmt.printfln("❌ Failed to create table schema (Error: %v)", err)
		return false
	}

	fmt.printfln("✅ Database initialized successfully!")
	return true
}

db_close :: proc() {
	sqlite.db_cache_destroy()
	sqlite.db_destroy()
}

db_load_events :: proc() {
	clear(&cli.events)

	cmd := "SELECT id, title, date FROM events ORDER BY id ASC;"

	stmt, err := sqlite.db_cache_prepare(cmd)

	if err != .OK {
		fmt.println("❌Failed to prepare SELECT statement")
		return
	}

	for {
		res := sqlite.step(stmt)

		if res == .DONE {
			break
		} else if res != .ROW {
			fmt.printfln("❌ Query error: %v", res)
			break
		}

		var_id := sqlite.column_int(stmt, 0)
		var_title := string(sqlite.column_text(stmt, 1))
		var_date := string(sqlite.column_text(stmt, 2))

		append(
			&cli.events,
			cli.Event {
				id = int(var_id),
				title = strings.clone(var_title),
				date = strings.clone(var_date),
			},
		)

	}
	sqlite.reset(stmt)
}

db_add_event :: proc(title, date: string) -> bool {
	err := sqlite.db_execute("INSERT INTO events (title, date) VALUES (?, ?);", title, date)

	if err != .OK {
		fmt.printfln("❌Failed to insert event: %v", err)
		return false
	}

	return true
}

db_delete_event :: proc(id: int) -> bool {

	err := sqlite.db_execute("DELETE FROM events WHERE id = ?;", i32(id))
	if err != .OK {
		fmt.printfln("❌Failed to delete event #%d: %v", id, err)
		return false
	}
	return true
}

db_update_event :: proc(id: int, title, date: string) -> bool {

	err := sqlite.db_execute(
		"UPDATE events SET title = COALESCE(NULLIF(?, ''), title), date = COALESCE(NULLIF(?, ''), date) WHERE id = ?;",
		title,
		date,
		i32(id),
	)

	if err != .OK {
		fmt.printfln("❌Failed to update event #%d: %v", id, err)
		return false
	}

	return true
}
