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

SLASH_REMNOTES1 = "/remnotes";
SLASH_REMNOTES2 = "/remno";
SlashCmdList["REMNOTES"] = function(msg)
	msg = string.lower(msg);

	if msg == "" or msg == "help" then
			print(cYellow..addonName.." addon v"..GetAddOnMetadata(addonName, "version")..".");
			print(cYellow.."List of commands: ");
			print(" -", SLASH_REMNOTES1, SLASH_REMNOTES2);
			print(" -", SLASH_REMNOTES_NOTE1, SLASH_REMNOTES_NOTE2);
			print(" -", SLASH_REMNOTES_REMINDER1, SLASH_REMNOTES_REMINDER2);
			print("For more details use these commands with parameter help, e.g.: "..SLASH_REMNOTES_NOTE1.." help");
			print(cYellow.."General usage:");
			print(SLASH_REMNOTES_NOTE1.." add me Some notes -- add some note to your character");
			print(SLASH_REMNOTES_NOTE1.." -- print all notes of your character");
			print(SLASH_REMNOTES_NOTE1.." all -- print all notes for all your characters");
	end
end


SLASH_REMNOTES_NOTE1 = "/note";
SLASH_REMNOTES_NOTE2 = "/nt";

-- Usage:
-- /nt list
-- /nt list FILTER -- FILTER=all|CHARNAME|rem
-- /nt -- same as /nt list
-- /nt all -- same as /nt list all
-- /nt help
-- /nt add me Text...
-- /nt add CHARNAME Text...
-- /nt del me NUMBER
-- /nt del CHARNAME NUMBER
-- /nt del me all

SlashCmdList["REMNOTES_NOTE"] = function(msg)

	local arg1, arg2, arg3 = string.match(msg, "%s?(%w*)%s?(%w*)%s?(.*)");

	-- in case it for any reason did not match at all 
	if arg1 == nil then
		print(cError.."Do not understand "..cWhite..msg..cYellow.." Try "..SLASH_REMNOTES_NOTE1.." help");		
		return;
	end

	-- lower case only 1st arguments, 2nd can contain CHARNAME and the 3rd can contain the note text
	arg1 = string.lower(arg1);

	--print(arg1);
	--print(arg2);
	--print(arg3);

	local playerName = GetUnitName("player");

	if arg1 == "help" then
		print(cYellow.."Usage:");
		print(cYellow..SLASH_REMNOTES_NOTE1.." -- print notes for current character.");
		print(cYellow..SLASH_REMNOTES_NOTE1.." all -- print notes for ALL your characters.");
		print(cYellow..SLASH_REMNOTES_NOTE1.." list -- print notes for current characters.");
		print(cYellow..SLASH_REMNOTES_NOTE1.." list all -- print notes for ALL your characters.");
		print(cYellow..SLASH_REMNOTES_NOTE1.." list CHARNAME -- print notes for CHARNAME.");
		print(cYellow..SLASH_REMNOTES_NOTE1.." list rem -- print notes with reminders.");

		print(cYellow..SLASH_REMNOTES_NOTE1.." add me Some text... -- add new note to current character.");		
		print(cYellow..SLASH_REMNOTES_NOTE1.." add CHARNAME Some text... -- add new note to CHARNAME.");		

		print(cYellow..SLASH_REMNOTES_NOTE1.." del me NUMBER -- delete note NUMBER of current character.");		
		print(cYellow..SLASH_REMNOTES_NOTE1.." del CHARNAME NUMBER -- delete note NUMBER of CHARNAME.");

	-- /note or /note all /note list or /note list FILTER 
	elseif arg1 == "" or arg1 == "list" or arg1 == "all" then

		arg2 = string.lower(arg2);

		if arg1 == "" or (arg1 == "list" and arg2 == "") then	
			NS.printCharacterNotes(RemnotesData, playerName);

		elseif arg1 == "all" or (arg1 == "list" and arg2 == "all") then
			NS.printAllNotes(RemnotesData);

		elseif arg1 == "list" and arg2 ~= "" then
			NS.printNotesWithFilter(RemnotesData, arg2);
		end

	-- /note add WHOM Some text...
	elseif arg1 == "add" then

		if arg2 == "me" then
			arg2 = playerName;
		end

		if arg2 ~= "" and arg3 ~= "" then
			NS.addNote(RemnotesData, arg2, arg3);
		end

	-- /note del WHOM NUMBER
	elseif arg1 == "del" then

		if string.lower(arg2) == "me" then
			arg2 = playerName;
		end

		if arg3 == "" then
			print(cError.."Incorrect syntax. Use: "..cYellow..SLASH_REMNOTES_NOTE1.." del CHARNAME NUMBER");
		end

		arg3 = tonumber(arg3); -- return nil if arg3 is not number

		if arg2 ~= "" and arg3 ~= nil and arg3 ~= "" then
			NS.deleteNote(RemnotesData, arg2, arg3);
		else
			print(cError.."Incorrect syntax. Use: "..cYellow..SLASH_REMNOTES_NOTE1.." del CHARNAME NUMBER");			
		end

	else
		print(cError.."Do not understand "..cWhite..msg..cYellow.." Try "..SLASH_REMNOTES_NOTE1.." help");
	end
end 


-- Usage:
-- /rem -- print reminders for current character
-- /rem all -- print reminders for all characters
-- /rem add me NUMBER type arg -- add new reminder to my note NUMBER, specify type of reminder
-- /rem del me NUMBER -- delete reminder to my note NUMBER
-- /rem help
-- /rem log -- print log of activated reminders for current character
-- /rem log all -- print log of activated reminders for all characters
SLASH_REMNOTES_REMINDER1 = "/reminder";
SLASH_REMNOTES_REMINDER2 = "/rem";
SlashCmdList["REMNOTES_REMINDER"] = function(msg)

	local arg1, arg2, arg3, arg4, arg5 = string.match(msg, "%s?(%w*)%s?(%w*)%s?(%w*)%s?(%w*)%s?(.*)");

	-- in case it for any reason did not match at all 
	if arg1 == nil then
		print(cError.."Do not understand "..cWhite..msg..cYellow.." Try "..SLASH_REMNOTES_REMINDER1.." help");		
		return;
	end

	print(arg1);
	print(arg2);
	print(arg3);
	print(arg4);
	print(arg5);


	-- lower case only 1st arguments, second can contain CHARNAME and others filter text
	arg1 = string.lower(arg1);

	local playerName = GetUnitName("player");

	if arg1 == "help" then
		print(cYellow.."Usage:");
		print(cYellow..SLASH_REMNOTES_REMINDER1.." -- print reminders for current character");
		print(cYellow..SLASH_REMNOTES_REMINDER1.." all -- print reminders for ALL your characters");
		print(cYellow..SLASH_REMNOTES_REMINDER1.." add me NUMBER type arg");

	-- /rem add me NUMBER type arg -- add new reminder to my note NUMBER, specify type of reminder
	elseif arg1 == "add" then
		if string.lower(arg2) == "me" then
			arg2 = playerName;
		end


		if arg2 ~= "" and arg3 ~= "" and tonumber(arg3) ~= nill and arg4 ~= "" then
			arg3 = tonumber(arg3);

			NS.addReminder(RemnotesData, arg2, arg3, arg4, arg5); --arg5 may be emptystring for some reminders
		else
			print(cError.."Do not understand "..cWhite..msg..cYellow.." Try "..SLASH_REMNOTES_REMINDER1.." help");
		end

	end
	-- TODO



end