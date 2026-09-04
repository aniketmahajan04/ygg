package cli

import "core:strconv"

/*
  Options structure
    Holds the structure of provided flags
*/
Options :: struct {
	add_title:  string, // Populated by -a / --add
	list_mode:  bool, // Populated by -l / --list
	updated_id: int, // Populated by -u / --update
	delete_id:  int, // Populated by -d / --delete
	date_str:   string, // Populated by -t / --time
}

parse_flag :: proc(args: []string) -> Options {
	opts: Options

	i := 1
	for i < len(args) {
		arg := args[i]
		switch arg {
		case "-a", "--add":
			if i + 1 < len(args) {
				opts.add_title = args[i + 1]
				i += 1
			}
		case "-t", "--time", "--date":
			if i + 1 < len(args) {
				opts.date_str = args[i + 1]
				i += 1
			}

		case "-l", "--list":
			opts.list_mode = true

		case "-d", "--delete":
			if i + 1 < len(args) {
				id, ok := strconv.parse_int(args[i + 1], 10)
				if ok {
					opts.delete_id = id
				}
				i += 1
			}

		case "-u", "--update":
			if i + 1 < len(args) {
				id, ok := strconv.parse_int(args[i + 1], 10)
				if ok {
					opts.updated_id = id
				}
				i += 1
			}
		}

		i += 1
	}
	return opts
}
