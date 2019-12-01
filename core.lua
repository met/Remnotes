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

local msgPrefix = cYellow.."["..addonName.."] "..cWhite;

local frame = CreateFrame("FRAME");


function frame:OnEvent(event, arg1, ...)

	if event == "ADDON_LOADED" and arg1 == addonName then

		print(msgPrefix.."version "..GetAddOnMetadata(addonName, "version"));
		print(msgPrefix.."Use /remnotes for help");

		if RemnotesSettings == nil then
			RemnotesSettings = {};
			print(msgPrefix.."Loaded for the first time. Setting defaults.");
		end

		if RemnotesData == nil then
			RemnotesData = {};
			print(msgPrefix.."Data storage initialized.");
		end

		if RemnotesLog == nil then
			RemnotesLog = {};
			print(msgPrefix.."Log initialized.");
		end

		local playerName = GetUnitName("player");
		local nNotes = NS.countPlayerNotes(RemnotesData, playerName);

		if type(nNotes) == "number" and nNotes > 0 then
			print(msgPrefix.."There are "..nNotes.." notes for character "..playerName..".");
		end

	elseif event =="BANKFRAME_OPENED" then
		--print("BANKFRAME_OPENED");
		--print(arg1, ...);

		-- TODO player opened bank window, fire bank reminders here

	elseif event == "CHAT_MSG_SKILL" then
		-- Msg templates: ERR_SKILL_GAINED_S , ERR_SKILL_UP_SI.
		-- We look for this: Your skill in Fishing has increased to 131.
		local skill, skilllevel = string.match(arg1, "Your skill in (.+) has increased to (%d+).");
		-- we must check it match succeded, because there are another messages for this event as well
		-- e.g. You have gained the First Aid skill. -- this we ignore here
		if skill ~= nil and skilllevel ~= nil then
			-- TODO player gained new skill level, fire reminders for this here
		end

	elseif event == "MAIL_SHOW" then
		print("MAIL_SHOW");
		print(arg1, ...);

		-- TODO player opened mail window, fire mail reminders here

	elseif event == "PLAYER_MONEY" then
		--print(event, arg1, ...);
		--print("Money=", GetMoney());

		-- TODO player money amount change, fire money reminders here

	elseif event == "PLAYER_LEVEL_UP" then
		print("PLAYER_LEVEL_UP");
		print(arg1, ...); -- arg1 should contain new level number

		-- TODO fire level up reminders

	elseif event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or event == "ZONE_CHANGED_NEW_AREA" then

		-- TODO fire zone reminders here
		-- ZONE_CHANGED_NEW_AREA should be handled with special care
	end
end



frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("BANKFRAME_OPENED");
frame:RegisterEvent("CHAT_MSG_SKILL");
frame:RegisterEvent("MAIL_SHOW");
frame:RegisterEvent("PLAYER_MONEY");
frame:RegisterEvent("PLAYER_LEVEL_UP");

frame:RegisterEvent("ZONE_CHANGED");
frame:RegisterEvent("ZONE_CHANGED_INDOORS");
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");

frame:SetScript("OnEvent", frame.OnEvent);