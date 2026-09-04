package cli

import "core:encoding/json"
import "core:fmt"
import "core:os"
// Event Structure
Event :: struct {
	id:    int,
	title: string,
	date:  string,
}

STORAGE_FILE :: "events.json"

// Imported Event structure from cli package
/*
  Global dynamic arrray to store the events locally
*/
events: [dynamic]Event

load_events :: proc() {

	data, err := os.read_entire_file(STORAGE_FILE, context.allocator)

	if data, err := os.read_entire_file(STORAGE_FILE, context.allocator); err != nil {
		return
	}

	defer delete(data)

	unmarshal_err := json.unmarshal(data, &events)

	if unmarshal_err != nil {
		fmt.printf("⚠️ Warning: Could not parse %s: %v\n", STORAGE_FILE, err)
	}
}

save_events :: proc() {
	opt: json.Marshal_Options = {
		pretty = true,
	}

	data, err := json.marshal(events, opt)

	if err != nil {
		fmt.printf("❌ Error serializing events to JSON: %v\n", err)
		return
	}

	defer delete(data)

	write_err := os.write_entire_file(STORAGE_FILE, data)

	if write_err != nil {
		fmt.printf("❌ Error saving data to %s\n", STORAGE_FILE)
	}

}
