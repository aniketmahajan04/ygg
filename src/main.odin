package main

import "cli"
import "core:fmt"
import "core:os"
import "core:time"
import "db"

main :: proc() {

	if !db.db_init() {
		fmt.println("❌Critical Error: Could not connect to database.")
		os.exit(1)
	}
	defer db.db_close()

	db.db_load_events()
	now := time.now()

	year, month, today_date := time.date(now)

	fmt.println("Yggdrasil Terminal Calendar (ygg)")
	fmt.printf("Today is: %d-%02d-%02d\n", year, int(month), today_date)

	if len(os.args) < 2 {
		cli.print_current_calendar(year, month, today_date)
		return
	}
	opts := cli.parse_flag(os.args)

	if opts.updated_id > 0 {
		update: bool

		if opts.add_title != "" || opts.date_str != "" {
			update = db.db_update_event(opts.updated_id, opts.add_title, opts.date_str)
		}
		if !update do fmt.printfln("❌ Event #%d not found.", opts.updated_id)
		fmt.printfln("✏️Updated Event: #%d, ", opts.updated_id)


	} else if opts.list_mode {
		fmt.println("--- Scheduled Events ---")
		if len(cli.events) == 0 {
			fmt.println("No event registed yet.")
		} else {
			for ev in cli.events {
				fmt.printf("#%d | %s | %s\n", ev.id, ev.title, ev.date)
			}
		}
	} else if opts.delete_id > 0 {

		if db.db_delete_event(opts.delete_id) do fmt.printf("Deleted Event #%d\n", opts.delete_id)
		else do fmt.printf("❌ Event #%d not found.\n", opts.delete_id)

	} else if opts.add_title != "" {
		target_date :=
			opts.date_str != "" ? opts.date_str : fmt.tprintf("%d-%02d-%02d", year, int(month), today_date)

		if db.db_add_event(opts.add_title, target_date) {
			fmt.printfln("✅ Added Event: '%s' on %s", opts.add_title, target_date)
		} else {
			fmt.println("❌Failed to add event")
		}

	}

}
