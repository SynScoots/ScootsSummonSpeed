local SSS = {}
SSS.frame = CreateFrame('Frame', 'ScootsSummonSpeedMasterFrame', UIParent)
SSS.summon = false

function SSS.onLoad()
	if(_G['SSS_AUTOACCEPT'] ~= nil) then
		SSS.autoAcceptFrom = _G['SSS_AUTOACCEPT']
	else
		SSS.autoAcceptFrom = {}
	end
	
	print('|cffdce317[ScootsSummonSpeed] Addon loaded. Type "/scootssummonspeed" or "/sss" to use.|r')
end

function SSS.onLogout()
	_G['SSS_AUTOACCEPT'] = SSS.autoAcceptFrom
end

SLASH_SSS1 = '/sss'
SLASH_SSS2 = '/scootssummonspeed'

SlashCmdList['SSS'] = function(argumentsString)
	local arguments = {}
	for argument in string.gmatch(argumentsString, '([^%s]+)') do
		table.insert(arguments, argument)
	end

	if(arguments[2] ~= nil) then
		arguments[2] = string.lower(arguments[2]):gsub('^%l', string.upper)
	end
	
	if(arguments[1] == 'add' and arguments[2] ~= nil) then
		if(SSS.autoAcceptFrom[arguments[2]] == nil) then
			SSS.autoAcceptFrom[arguments[2]] = true
			print('|cffdce317[ScootsSummonSpeed] |cff3bd17a' .. arguments[2] .. ' added to the auto-accept list.|r')
		else
			print('|cffdce317[ScootsSummonSpeed] |cffd98148' .. arguments[2] .. ' is already on the auto-accept list.|r')
		end
	elseif(arguments[1] == 'remove' and arguments[2] ~= nil) then
		if(SSS.autoAcceptFrom[arguments[2]] ~= nil) then
			SSS.autoAcceptFrom[arguments[2]] = nil
			print('|cffdce317[ScootsSummonSpeed] |cff3bd17a' .. arguments[2] .. ' removed from the auto-accept list.|r')
		else
			print('|cffdce317[ScootsSummonSpeed] |cffd98148' .. arguments[2] .. ' is not on the auto-accept list.|r')
		end
	elseif(arguments[1] == 'list') then
		print('|cffdce317[ScootsSummonSpeed] |rAutomatically accepting party and summon requests from:')
		local hasEntries = false
		for key, value in pairs(SSS.autoAcceptFrom) do
			hasEntries = true
			print('- ' .. key)
		end
		
		if(hasEntries == false) then
			print('|cffdce317[ScootsSummonSpeed] |rNot automatically accepting party and summon requests from any character.')
		end
	else
		print('|cffdce317[ScootsSummonSpeed] Usage:|r')
		print('|cffdce317/sss add CharacterName|r - adds the specified character name to the auto-accept list.')
		print('|cffdce317/sss remove CharacterName|r - removes the specified character name to the auto-accept list.')
		print('|cffdce317/sss list|r - lists all characters currently on the auto-accept list.')
	end
end

function SSS.eventHandler(self, event, arg1)
	if(event == 'ADDON_LOADED' and arg1 == 'ScootsSummonSpeed') then
		SSS.onLoad()
	elseif(event == 'PLAYER_LOGOUT') then
		SSS.onLogout()
	elseif(event == 'PARTY_INVITE_REQUEST') then
		arg1 = string.lower(arg1):gsub('^%l', string.upper)
		if(SSS.autoAcceptFrom[arg1] ~= nil) then
			AcceptGroup()
			_G['StaticPopup1Button1']:Click()
		end
	elseif(event == 'CONFIRM_SUMMON') then
		SSS.summon = true
	end
end

SSS.frame:SetScript('OnUpdate', function()
	if(SSS.summon == true) then
		local characterName = _G['StaticPopup1'].text:GetText():match('([^%s]+)')
		if(characterName ~= nil) then
			SSS.summon = false
			
			characterName = string.lower(characterName):gsub('^%l', string.upper)
			if(SSS.autoAcceptFrom[characterName] ~= nil) then
				_G['StaticPopup1Button1']:Click()
			end
		end
	end
end)

SSS.frame:SetScript('OnEvent', SSS.eventHandler)

SSS.frame:RegisterEvent('ADDON_LOADED')
SSS.frame:RegisterEvent('PLAYER_LOGOUT')
SSS.frame:RegisterEvent('PARTY_INVITE_REQUEST')
SSS.frame:RegisterEvent('CONFIRM_SUMMON')