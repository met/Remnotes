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

local addonName, NS = ...

local cYellow = "\124cFFFFFF00";
local cRed = "\124cFFFF0000";
local cWhite = "\124cFFFFFFFF";
local cError = cRed;

function NS.printCharacterNotes(notesDB, charname)

	if notesDB == nil or charname == nil then
		print(cError.."ERROR: printCharacterNotes called with nil arguments");
		return;
	end

	if notesDB[charname] == nill then
		print(cYellow.."No notes for character "..charname..".");
		return;
	end

	print(cYellow.."Notes for character "..charname..":");

	for k,v in pairs(notesDB[charname]) do
		if v.text ~= nil then

			if v.reminder == nil then
				print(k, "-", v.text);
			else

				if v.reminder.fired == true then
					--note has reminer thas was already fired
					print(cYellow.."*"..k, "-", v.text);
				else
					--note has reminder not yet fired
					print("\124cFFE0FFFF".."="..k, "-", v.text);
				end
			end
		end
	end

	-- TODO we can print different way notes without reminders, notes with reminders and notes with reminders that fired already
end

function NS.printAllNotes(notesDB)

	if notesDB == nil then
		print(cError.."ERROR: printAllNotes called with nil arguments");
		return;
	end

	print(cYellow.."Notes for all characters:");

	for charname,_ in pairs(notesDB) do

		for k,v in pairs(notesDB[charname]) do
			if v.text ~= nil then
				print(cYellow..charname..cWhite.." : ".. k, "-", v.text);
			end
		end
	end
end


function NS.printNotesWithFilter(notesDB, filter)

	if notesDB == nil or filter == nil then
		print(cError.."ERROR: printNotesWithFilter called with nil arguments");
		return;
	end

	-- TODO

	-- filter: charname, reminders, type of reminders, fired...
end

function NS.addNote(notesDB, charname, noteText)

	if notesDB == nil or charname == nil or noteText == nil then
		print(cError.."ERROR: addNote called with nil arguments");
		return;
	end

	if notesDB[charname] == nill then
		notesDB[charname] = {};
	end

	local note = { text=noteText };

	table.insert(notesDB[charname], note);

	print("Added note to character "..charname..".");

end

function NS.deleteNote(notesDB, charname, index)

	if notesDB == nil or charname == nil or index == nil then
		print(cError.."ERROR: deleteNote called with nil arguments");
		return;
	end

	if type(index) ~= "number" then
		print(cError.."ERROR: deleteNote called with index not number");
		return;
	end

	if notesDB[charname] == nill or notesDB[charname][index] == nill then
		print("There is no note "..index..".");
		return;
	end


	local noteText = notesDB[charname][index].text;

	table.remove(notesDB[charname], index);
	print(cYellow.."Note "..index.." was deleted");
	print("Note text was: ", noteText);
end

function NS.countPlayerNotes(notesDB, charname)

	if notesDB == nil or charname == nil then
		print(cError.."ERROR: currentPlayerNotes called with nil arguments.");
		return;
	end

	if notesDB[charname] == nil then
		return 0;
	end

	return #notesDB[charname];
end

function NS.addReminder(notesDB, charname, index, reminderType, reminderCondition)

	if notesDB == nil or charname == nil or index == nil or reminderType == nil or reminderCondition == nil then
		print(cError.."ERROR: addReminder called with nil arguments.");
		return;
	end

	if type(index) ~= "number" then
		print(cError.."ERROR: addReminder called with index not number");
		return;
	end

	if notesDB[charname] == nill or notesDB[charname][index] == nill then
		print("There is no note "..index..".");
		return;
	end

	--check validity or reminderType and reminderCondition here
	reminderType = string.lower(reminderType);

	if reminderType == "levelup" then
		if tonumber(reminderCondition) ~= nil then
			reminderCondition = tonumber(reminderCondition);
		else
			print(cError.."Level number is not valid.");
			return;
		end
	else
		print(cError.."Unknown reminder type.");
		return;
	end

	if notesDB[charname][index].reminder == nil then
		notesDB[charname][index].reminder = { type = reminderType, condition = reminderCondition, fired = false};
		print("Added reminder.");
	else
		print(cError.."There is already reminder on note "..index..". Delete it first.");
	end

end

function NS.fireRemindersLevelUp(notesDB, charname, level)

	if notesDB == nil or charname == nil or level == nil then
		print(cError.."ERROR: fireRemindersLevelUp called with nil arguments.");
		return;
	end

	if tonumber(level) == nill then
		print(cError.."ERROR: fireRemindersLevelUp called with invalid level number.");
		return;
	end


	if notesDB[charname] == nill then
		return;
	end

	for n = 1, #notesDB[charname] do
		if notesDB[charname][n].reminder ~= nil and notesDB[charname][n].reminder.type == "levelup" then

			if notesDB[charname][n].reminder.condition ~= nil and tonumber(notesDB[charname][n].reminder.condition) ~= nil and tonumber(notesDB[charname][n].reminder.condition) <= level then
				NS.reminderFired(notesDB[charname][n]);
			end
		end
	end

end

function NS.reminderFired(note)

	if note == nil then
		print(cError.."ERROR: reminderFired called with nil arguments.");
		return;
	end

	if note.reminder ~= nil then
		note.reminder.fired = true;
	end

	print(cYellow.."======= REMINDER =======");

	if note.text then 
		print(note.text);
	end

	print(cYellow.."======================")
end