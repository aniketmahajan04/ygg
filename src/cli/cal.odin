package cli

import "core:fmt"
import "core:time"

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
	fmt.printf("\n   --- %s %d ---\n", months[month], year)
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
	// fmt.println("\n")
}
