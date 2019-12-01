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
	end
end



frame:RegisterEvent("ADDON_LOADED");
frame:SetScript("OnEvent", frame.OnEvent);