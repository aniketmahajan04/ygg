package main

import "cli"
import "core:fmt"
import "core:os"
import "core:time"

// Imported Event structure from cli package
/*
  Global dynamic arrray to store the events locally
*/
events: [dynamic]cli.Event

print_days :: proc(year, month: int) {
	// Day for loop
	days: [7]string : {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"}

	months := []string {
		"",
		"January",
		"February",
		"March",
		"April",
		"May",
		"June",
		"July",
		"August",
		"September",
		"October",
		"November",
		"December",
	}
	fmt.printfln("\n   --- %s %d ---", months[month], year)
	for day in days {
		fmt.printf("%s  ", day)
	}
	fmt.println()
}

days_in_months :: proc(year: int, month: int) -> int {
	switch month {
	case 1, 3, 5, 7, 8, 10, 12:
		return 31

	case 4, 6, 9, 11:
		return 30

	case 2:
		is_leap := (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
		return is_leap ? 29 : 28
	}
	return 0
}

first_day_of_month :: proc(year, month: int) -> int {

	y := year
	m := month

	// Zeller's adjustment for Jan/Feb
	if m <= 2 {
		m += 12
		y -= 1
	}

	q := 1
	K := y % 100
	J := y / 100

	h := (q + (13 * (m + 1)) / 5 + K + K / 4 + J / 4 - 2 * J) % 7

	if h < 0 do h += 7

	return (h + 6) % 7
}

print_current_calendar :: proc(year: int, month: time.Month, current_day: int) {
	month_int := int(month)
	print_days(year, month_int)

	first_day := first_day_of_month(year, month_int)
	total_days_in_the_month := days_in_months(year, month_int)

	for i in 0 ..< first_day do fmt.print("     ")
	for day in 1 ..= total_days_in_the_month {
		if (day == current_day) {
			fmt.printf("\x1b[31m% 3d  \x1b[0m", day)
		} else {
			fmt.printf("% 3d  ", day)
		}

		if (day + first_day) % 7 == 0 {
			fmt.println()
		}
	}
	fmt.println("\n")
}

main :: proc() {
	// 1. Get the current date/time to set default calendar view
	now := time.now()

	year, month, today_date := time.date(now)

	fmt.printfln("Yggdrasil Terminal Calendar (ygg)")
	fmt.printf("Today is: %d-%02d-%02d\n", year, int(month), today_date)

	if len(os.args) < 2 {
		print_current_calendar(year, month, today_date)
		return
	}
	opts := cli.parse_flag(os.args)

	if opts.add_title != "" {
		target_date :=
			opts.date_str != "" ? opts.date_str : fmt.tprintf("%d-%02d-%02d", year, int(month), today_date)

		new_event := cli.Event {
			id    = len(events) + 1,
			title = opts.add_title,
			date  = target_date,
		}
		append(&events, new_event)
		fmt.printfln(
			"✅ Added Event #%d: '%s' on %s",
			new_event.id,
			new_event.title,
			new_event.date,
		)
	} else if opts.list_mode {
		// Read/List events from array
		fmt.println("--- Scheduled Events ---")
		if len(events) == 0 {
			fmt.println("No event registed yet.")
		} else {
			for ev in events {
				fmt.printfln("#%d | %s | %s", ev.id, ev.title, ev.date)
			}
		}
	} else if opts.delete_id > 0 {
		// Delete an event from the array by ID
		removed := false

		for i := 0; i < len(events); i += 1 {
			if events[i].id == opts.delete_id {
				unordered_remove(&events, i)
				removed = true
				fmt.printfln("Deleted Event #%d", opts.delete_id)
				break
			}
		}
		if !removed {
			fmt.printfln("❌ Event #%d not found.", opts.delete_id)
		}
	} else {
		// Print the helper flag warning so user can see how flags are used
	}

}
