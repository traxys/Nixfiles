#!/usr/bin/env lua

if arg[1] == nil then
	io.stderr:write("Missing note name argument\n")
	os.exit(1)
end

local data, error = loadfile(
	os.getenv("HOME") .. "/GameData/WoW/World of Warcraft/_retail_/WTF/Account/114770488#3/SavedVariables/Notes.lua"
)

if data == nil then
	io.stderr:write(error .. "\n")
	os.exit(1)
end

data()

for _, note in ipairs(NotesData.notes) do
	if note.title == arg[1] then
		local hdl = io.popen("wl-copy", "w")
		hdl:write(note.text)
		hdl:close()
		os.exit(0)
	end
end

io.stderr:write("Note not found\n")
os.exit(1)
