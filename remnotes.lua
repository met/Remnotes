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

local addonName, NS = ...;

local cYellow = "\124cFFFFFF00";
local cRed = "\124cFFFF0000";
local cWhite = "\124cFFFFFFFF";
local cError = cRed;

-- valid types of reminders and their parameters
-- eg "mail" use no parameter => "nil", "levelup" use number => "number"
local reminderTypes = {
	["login"] = "nil",
	["mail"] = "nil",
	["bank"] = "nil",
	["levelup"] = "number",
	["money"] = "number",

	["cooking"] = "number",
	["first aid"] = "number",
	["fishing"] = "number",

	["herbalism"] = "number",
	["mining"] = "number",
	["skinning"] = "number",

	["alchemy"] = "number",
	["blacksmithing"] = "number",
	["enchanting"] = "number",
	["engineering"] = "number",	
	["leatherworking"] = "number",
	["tailoring"] = "number",
};

function NS.printCharacterNotes(notesDB, charname)

	assert(notesDB ~= nil, "printCharacterNotes - notesDB is nil");
	assert(charname ~= nil, "printCharacterNotes - charname is nil");


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

				if v.reminder.activated == true then
					--note has reminer thas was already activated
					print(cYellow.."*"..k, "-", v.text);
				else
					--note has reminder not yet activated
					print("\124cFFE0FFFF".."="..k, "-", v.text);
				end
			end
		end
	end

	-- TODO we can print different way notes without reminders, notes with reminders and notes with reminders that fired already
end

function NS.printAllNotes(notesDB)

	assert(notesDB ~= nil, "printAllNotes - notesDB is nil");

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

	assert(notesDB ~= nil, "printNotesWithFilter - notesDB is nil");
	assert(filter ~= nil, "printNotesWithFilter - filter is nil");


	-- TODO

	-- filter: charname, reminders, type of reminders, activated...
end

function NS.addNote(notesDB, charname, noteText)

	assert(notesDB ~= nil, "addNote - notesDB is nil");
	assert(charname ~= nil, "addNote - charname is nil");
	assert(noteText ~= nil, "addNote - noteText is nil");

	if notesDB[charname] == nill then
		notesDB[charname] = {};
	end

	local note = { text=noteText };

	table.insert(notesDB[charname], note);

	print(cYellow.."Added note to character "..charname..".");
	print("Note: "..noteText);
end

function NS.deleteNote(notesDB, charname, index)

	assert(notesDB ~= nil, "deleteNote - notesDB is nil");
	assert(charname ~= nil, "deleteNote - charname is nil");
	assert(index ~= nil, "deleteNote - index is nil");
	assert(type(index) == "number", "deleteNote - index must be number");

	if notesDB[charname] == nill or notesDB[charname][index] == nill then
		print("There is no note "..index.." for "..charname..".");
		return;
	end

	local noteText = notesDB[charname][index].text;

	table.remove(notesDB[charname], index);
	print(cYellow.."Note "..index.." was deleted.");
	print("Note was: ", noteText);
end

function NS.countPlayerNotes(notesDB, charname)

	assert(notesDB ~= nil, "countPlayerNotes - notesDB is nil");
	assert(charname ~= nil, "countPlayerNotes - charname is nil");

	if notesDB[charname] == nil then
		return 0;
	else
		return #notesDB[charname];
	end
end

function NS.addReminder(notesDB, charname, index, reminderType, reminderCondition)

	assert(notesDB ~= nil, "addReminder - notesDB is nil");
	assert(charname ~= nil, "addReminder - charname is nil");
	assert(index ~= nil, "addReminder - index is nil");
	assert(type(index) == "number", "addReminder - index must be number");
	assert(reminderType ~= nil, "addReminder - reminderType is nil");	
	-- reminderCondition could be nil for some reminderType, so we check validity of reminderCondition later

	if notesDB[charname] == nill or notesDB[charname][index] == nill then
		print("There is no note "..index.." for "..charname..".");
		return;
	end

	reminderType = string.lower(reminderType);

	if reminderTypes[reminderType] == nil then
		print(cError.."Reminder type "..reminderType.." is not valid.");
		return;
	end

	-- validate reminder condition parameter
	if reminderTypes[reminderType] == "nil" then
		reminderCondition = ""; -- reminders without conditions, eg mail, bank

	elseif reminderTypes[reminderType] == "number" then
		if reminderCondition ~= nil and tonumber(reminderCondition) ~= nil then
			reminderCondition = tonumber(reminderCondition);
		else
			print(cError.."Condition must be number.");
			return;
		end

	elseif reminderTypes[reminderType] == "string" then
		if reminderCondition ~= nil and tostring(reminderCondition) ~= nil then
			reminderCondition = tostring(reminderCondition);
		else
			print(cError.."Condition must be string.");
			return;
		end		
	end


	if notesDB[charname][index].reminder == nil then
		notesDB[charname][index].reminder = { type = reminderType, condition = reminderCondition, activated = false};
		print("Added reminder.");
	else
		print(cError.."There is already reminder on note "..index..". Delete it first.");
	end

end

-- Activite (fire) all reminders that match criteria
-- the first criterium is reminderType
-- the second optional is defined in callback function
-- conditionCallback(note) should return true it there is criteria match 
function NS.activateMatchedReminders(notesDB, charname, reminderType, conditionCallback)

	assert(notesDB ~= nill, "activateMatchedReminders - notesDB is nil");
	assert(charname ~= nill, "activateMatchedReminders - charname is nil");
	assert(reminderType ~= nill, "activateMatchedReminders - reminderType is nil");	

	-- there are no notes
	if notesDB[charname] == nill then
		return;
	end

	for n = 1, #notesDB[charname] do
		local note = notesDB[charname][n];

		if note.reminder ~= nil and note.reminder.type ~= nil and note.reminder.condition ~= nil and note.reminder.activated ~= nil and note.reminder.activated == false then
			-- if there is reminder with same type 
			if note.reminder.type == reminderType then

				-- if there is conditionCallback defined, then we must check if it match too
				-- for some reminders (eg. bank, mail) is no conditionCallback necessary
				-- for other (eg levelup) is obligatory
				if conditionCallback == nill or conditionCallback(note) then

					if NS.activateReminder(note) then
						NS.displayActivatedReminder(note);
						NS.logReminder(RemnotesLog, date(), charname, note);
					end
					
				end
			end
		end
	end

end

function NS.activateReminder(note)

	assert(note ~= nil, "activateReminder - note is nil");

	if note.reminder ~= nil then
		note.reminder.activated = true;
		return true;
	end

	return false;
end

function NS.logReminder(log, date, charname, note)

	assert(log ~= nil, "logReminder - log is nil");
	assert(date ~= nil, "logReminder - date is nil");
	assert(charname ~= nil, "logReminder - charname is nil");
	assert(note ~= nil, "logReminder - note is nil");

	table.insert(log, { date = date, event = "REMINDER_ACTIVATED", charname = charname, type = note.reminder.type, condition = note.reminder.condition, text = note.text });
end

function NS.displayActivatedReminder(note)

	assert(note ~= nil, "displayActivatedReminder - note is nil");

	print(cYellow.."=== "..cRed.."REMINDER ACTIVATED"..cYellow.." ===");

	if note.reminder ~= nill and note.reminder.type ~= nill then
		print(cYellow.."=== Type: "..note.reminder.type.." ===");
	end

	if note.text then 
		print(note.text);
	end

	print(cYellow.."==============================");
end