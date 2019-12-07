 --[[
Copyright (c) 2019 Martin Hassman

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

-- Using library https://github.com/Mirroar/wowUnit forked and fixed in https://github.com/met/wowUnit
-- Must be installed as addon.
-- Run tests by slash command:
-- /wu remnotes

local addonName, NS = ...;

-- check for testing library installed
if wowUnit == nil then
	return;
end 

remnotes = {};
remnotes.tests = {
	["basic"] = {
		["logging"] = function()
			local log = {};
			local note = { text = "Some note text.", reminder = { type = "mail", condition = "", activated = false } };
			NS.logReminder(log, "Sat Dec  7 03:06:28 2019", "Totenhot", note);

			local expected = { event = "REMINDER_ACTIVATED", date = "Sat Dec  7 03:06:28 2019", charname = "Totenhot", type = "mail", text = "Some note text.", condition = "" }

			wowUnit:assertSame(log[1], expected, "Event is logged correctly.");
		end,

		["notes"] = function()
			local db = {};

			wowUnit:assertEquals(NS.countPlayerNotes(db, "Luajito"), 0, "Zero notes.");

			NS.addNote(db, "Luajito",  "Some dummy text.");
			wowUnit:assertSame(
				db,
				{
					["Luajito"] = { {text =  "Some dummy text."} }
				},
				"New note added.");
			wowUnit:assertEquals(NS.countPlayerNotes(db, "Luajito"), 1, "We have one note.");

			NS.addNote(db, "Luajito", "Another note text.");
			wowUnit:assertSame(
				db,
				{
					["Luajito"] = { {text = "Some dummy text."}, {text = "Another note text."} }
				},
				"Another note added.");
			wowUnit:assertEquals(NS.countPlayerNotes(db, "Luajito"), 2, "We have two notes.");
			wowUnit:assertEquals(NS.countPlayerNotes(db, "Mojito"), 0, "Mojito has zero notes.");

			NS.addNote(db, "Mojito", "This is Mojito note.");
			wowUnit:assertSame(
				db,
				{
					["Luajito"] = { {text = "Some dummy text."}, {text = "Another note text."} },
					["Mojito"]  = { {text = "This is Mojito note."} }
				},
				"Another user note added.");
			wowUnit:assertEquals(NS.countPlayerNotes(db, "Luajito"), 2, "Luajito has still two notes.");
			wowUnit:assertEquals(NS.countPlayerNotes(db, "Mojito"), 1, "Mojito has one note.");

			NS.deleteNote(db, "Luajito", 1);
			wowUnit:assertSame(
				db,
				{
					["Luajito"] = { {text = "Another note text."} },
					["Mojito"]  = { {text = "This is Mojito note."} }
				},
				"Delete note.");
			wowUnit:assertEquals(NS.countPlayerNotes(db, "Luajito"), 1, "Luajito has only one note.");
			wowUnit:assertEquals(NS.countPlayerNotes(db, "Mojito"), 1, "Mojito has still one note.");
		end,

		["reminders"] = function ()
			local db = {};

			NS.addNote(db, "Luajito",  "Some dummy text.");
			NS.addNote(db, "Luajito",  "Another dummy text.");
			wowUnit:assertSame(
				db,
				{
					["Luajito"] = {
						{text = "Some dummy text."},
						{text = "Another dummy text."}
					}
				},
				"Start with 2 notes.");

			NS.addReminder(db, "Luajito", 1, "mail");
			wowUnit:assertSame(
				db,
				{
					["Luajito"] = {
						{
							text = "Some dummy text.",
							reminder = { type = "mail", condition = "", activated = false}
						},
						{text = "Another dummy text."}
					}
				},
				"Add mail reminder.");

			NS.addReminder(db, "Luajito", 2, "cooking", 150);
			wowUnit:assertSame(
				db,
				{
					["Luajito"] = {
						{
							text = "Some dummy text.",
							reminder = { type = "mail", condition = "", activated = false}
						},
						{
							text = "Another dummy text.",
							reminder = { type = "cooking", condition = 150, activated = false}
						}
					}
				},
				"Add cooking reminder.");

			NS.activateReminder(db["Luajito"][1]);
			wowUnit:assertSame(
				db,
				{
					["Luajito"] = {
						{
							text = "Some dummy text.",
							reminder = { type = "mail", condition = "", activated = true}
						},
						{
							text = "Another dummy text.",
							reminder = { type = "cooking", condition = 150, activated = false}
						}
					}
				},
				"Reminder activated.");

		end
	}
}

