-- thanks and some credit to Fenris_Wolf from ORGM mod for creating this hotkeys file!  I just tweaked it to use my own key bindings! and added support for settings too ~Nolan


function SuperSurvivorGetOption(option)
	
	if(SuperSurvivorOptions[option] ~= nil) then return tonumber(SuperSurvivorOptions[option])
	else return 1 end

end
function SuperSurvivorGetOptionValue(option)
	
	local num = SuperSurvivorGetOption(option)
	print("num:"..tostring(num))
	if(option == "WifeSpawn") then return (num ~= 1)
	elseif(option == "LockNLoad") then return (num ~= 1)
	elseif(option == "SpawnRate") and (num == 8) then return 0
	elseif(option == "SpawnRate") and (num == 7) then return 400
	elseif(option == "SpawnRate") and (num == 6) then return 1000
	elseif(option == "SpawnRate") and (num == 5) then return 2500
	elseif(option == "SpawnRate") and (num == 4) then return 4000
	elseif(option == "SpawnRate") and (num == 3) then return 8000
	elseif(option == "SpawnRate") and (num == 2) then return 16000
	elseif(option == "SpawnRate") and (num == 1) then return 32000
	
	elseif(option == "GunSpawnRate") then return (num * 5) - 5
	elseif(option == "WepSpawnRate") then return (num * 5) - 5
	elseif(option == "HostileSpawnRate") then return (num * 5) - 5
	elseif(option == "MaxHostileSpawnRate") then return (num * 5) - 5
	elseif(option == "InfinitAmmo") then return (num ~= 1)
	elseif(option == "NoPreSetSpawn") then return (num ~= 1)
	elseif(option == "SafeBase") then return (num ~= 1)
	elseif(option == "DebugOptions") then return (num ~= 1)
	elseif(option == "FindWork") then return (num == 1)
	elseif(option == "SurvivorHunger") then return (num == 1)
	elseif(option == "SurvivorFriendliness") then return (10 - ((num-1)*2)) -- 1 = 10, 2 = 8, 3 = 6
	
	elseif(option == "RaidersAtLeastHours") and (num == 21) then return 24
	elseif(option == "RaidersAtLeastHours") and (num == 22) then return 1
	elseif(option == "RaidersAtLeastHours") and (num == 23) then return 0
	elseif(option == "RaidersAtLeastHours") then return ((num * 5) * 24)
	
	elseif(option == "RaidersAfterHours") and (num == 2) then return 24
	elseif(option == "RaidersAfterHours") and (num == 22) then return 9999999
	elseif(option == "RaidersAfterHours") then return (((num-2) * 5) * 24)
	
	elseif(option == "RaidersChance") then return ((num + 2) * 24 * 14)  -- (6 * 24 * 14)
	elseif(option == "Bravery") then return (num - 1)
	
	else return num end
	

end
function SuperSurvivorSetOption(option,ToValue)

	SuperSurvivorOptions[option] = ToValue
	SaveSurvivorOptions()

end

 function SaveSurvivorOptions()
	local destFile = "SurvivorOptions.lua"
	local writeFile = getModFileWriter("SuperbSurvivors", destFile, true, false)

	for index,value in pairs(SuperSurvivorOptions) do
	
		writeFile:write(tostring(index) .. " " .. tostring(value) .. "\r\n");
	
	end
	writeFile:close();
end

function LoadSurvivorOptions( )
	
	if(doesOptionsFileExist() == false) then 
		print("could not load survivor options file")
		return nil 
	end

	local fileTable = {}
	local readFile = getModFileReader("SuperbSurvivors","SurvivorOptions.lua", true)
	local scanLine = readFile:readLine()
	while scanLine do
	
		local values = {}
		for input in scanLine:gmatch("%S+") do table.insert(values,input) end
		--print("loading line: "..values[1] .. " " .. values[2])
		if(fileTable[values[1]] == nil) then fileTable[values[1]] = {} end
			fileTable[values[1]]=tonumber(values[2])
		scanLine = readFile:readLine()
		if not scanLine then break end
	end
	readFile:close()
	print("Loaded survivor options file")
	return fileTable
end

function doesOptionsFileExist(  )
	local fileTable = {}
	local readFile = getModFileReader("SuperbSurvivors","SurvivorOptions.lua", false)
	
	if(readFile) then return true
	else return false end
end


SuperSurvivorOptions = LoadSurvivorOptions()
if(not SuperSurvivorOptions) then SuperSurvivorOptions = {} end
if(not SuperSurvivorOptions["SpawnRate"]) then SuperSurvivorOptions["SpawnRate"] = 4 end
if(not SuperSurvivorOptions["WifeSpawn"]) then SuperSurvivorOptions["WifeSpawn"] = 1 end
if(not SuperSurvivorOptions["LockNLoad"]) then SuperSurvivorOptions["LockNLoad"] = 1 end
if(not SuperSurvivorOptions["GunSpawnRate"]) then SuperSurvivorOptions["GunSpawnRate"] = 2 end
if(not SuperSurvivorOptions["WepSpawnRate"]) then SuperSurvivorOptions["WepSpawnRate"] = 2 end
if(not SuperSurvivorOptions["HostileSpawnRate"]) then SuperSurvivorOptions["HostileSpawnRate"] = 1 end
if(not SuperSurvivorOptions["MaxHostileSpawnRate"]) then SuperSurvivorOptions["MaxHostileSpawnRate"] = 17 end
if(not SuperSurvivorOptions["InfinitAmmo"]) then SuperSurvivorOptions["InfinitAmmo"] = 1 end
if(not SuperSurvivorOptions["NoPreSetSpawn"]) then SuperSurvivorOptions["NoPreSetSpawn"] = 1 end
if(not SuperSurvivorOptions["FindWork"]) then SuperSurvivorOptions["FindWork"] = 1 end
if(not SuperSurvivorOptions["SurvivorHunger"]) then SuperSurvivorOptions["SurvivorHunger"] = 1 end
if(not SuperSurvivorOptions["SurvivorFriendliness"]) then SuperSurvivorOptions["SurvivorFriendliness"] = 4 end

if(not SuperSurvivorOptions["RaidersAtLeastHours"]) then SuperSurvivorOptions["RaidersAtLeastHours"] = 13 end
if(not SuperSurvivorOptions["RaidersAfterHours"]) then SuperSurvivorOptions["RaidersAfterHours"] = 7 end
if(not SuperSurvivorOptions["RaidersChance"]) then SuperSurvivorOptions["RaidersChance"] = 3 end
if(not SuperSurvivorOptions["Bravery"]) then SuperSurvivorOptions["Bravery"] = 2 end
if(not SuperSurvivorOptions["SSHotkey1"]) then SuperSurvivorOptions["SSHotkey1"] = 6 end
if(not SuperSurvivorOptions["SSHotkey2"]) then SuperSurvivorOptions["SSHotkey2"] = 10 end
if(not SuperSurvivorOptions["SSHotkey3"]) then SuperSurvivorOptions["SSHotkey3"] = 27 end
if(not SuperSurvivorOptions["SSHotkey4"]) then SuperSurvivorOptions["SSHotkey4"] = 42 end
	

local GameOption = ISBaseObject:derive("GameOption")

function GameOption:new(name, control, arg1, arg2)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.name = name
	o.control = control
	o.arg1 = arg1
	o.arg2 = arg2
	if control.isCombobox then
		control.onChange = self.onChangeComboBox
		control.target = o
	end
	if control.isTickBox then
		control.changeOptionMethod = self.onChangeTickBox
		control.changeOptionTarget = o
	end
	if control.isSlider then
		control.targetFunc = self.onChangeVolumeControl
		control.target = o
	end
	return o
end

function GameOption:toUI()
	print('ERROR: option "'..self.name..'" missing toUI()')
end

function GameOption:apply()
	print('ERROR: option "'..self.name..'" missing apply()')
end

function GameOption:onChangeComboBox(box)
	self.gameOptions:onChange(self)
	if self.onChange then
		self:onChange(box)
	end
end

function GameOption:onChangeTickBox(index, selected)
	self.gameOptions:onChange(self)
	if self.onChange then
		self:onChange(index, selected)
	end
end

function GameOption:onChangeVolumeControl(control, volume)
	self.gameOptions:onChange(self)
	if self.onChange then
		self:onChange(control, volume)
	end
end

-- -- -- -- --

--[[
hotkey options
]]
SSHotKeyOptions = {}
for i=1,#Orders do
	SSHotKeyOptions[i] = getText("ContextMenu_SD_OrderAll") .. " " .. OrderDisplayName[Orders[i]]
end
for i=1,#Orders do
	table.insert(SSHotKeyOptions,OrderDisplayName[Orders[i]])
end

-- We need to use the global keyBinding table, this stores all our binding values
local index = nil -- index will be the position we want to insert into the table
for i,b in ipairs(keyBinding) do
    -- we need to find the index of the item we want to insert after
    -- in this case its "Equip/Unequip Stab weapon"
    if b.value == "Shout" then
        index = i -- found the index, set it and break from the loop
        break
    end
end

if index then
    -- we got a index, first lets insert our new entries
    table.insert(keyBinding, index+1, {value = "Call Closest Group Member", key = 20})
    table.insert(keyBinding, index+2, {value = "Call Closest Non-Group Member", key = 21})
    table.insert(keyBinding, index+3, {value = "Ask Closest Group Member to Follow", key = 34})
    table.insert(keyBinding, index+4, {value = "Toggle Group Window", key = 22})
    table.insert(keyBinding, index+5, {value = "Spawn Wild Survivor", key = 53})
    table.insert(keyBinding, index+6, {value = "Lower Follow Distance", key = 74})
    table.insert(keyBinding, index+7, {value = "Raise Follow Distance", key = 78})
   
   table.insert(keyBinding, index+8, {value = "SSHotkey_1", key = 50})
   table.insert(keyBinding, index+9, {value = "SSHotkey_2", key = 51})
   table.insert(keyBinding, index+10, {value = "SSHotkey_3", key = 52})
   table.insert(keyBinding, index+11, {value = "SSHotkey_4", key = 53})
    
    -- store the original MainOptions:create() method in a variable
    local oldCreate = MainOptions.create

    -- overwrite it
    function MainOptions:create()
        oldCreate(self)
        for _, keyTextElement in pairs(MainOptions.keyText) do repeat
            -- if keyTextElement is nil or doesn't have a ISLabel, break out of the 
            -- "repeat ... until true"  loop, and continue with the "for .. do ... end" 
            -- loop
            if not keyTextElement or not keyTextElement.txt then break end
            
            local label = keyTextElement.txt -- our ISLabel item is stored in keyTextElement.txt
            -- We need to do a few things here to prep the new entries.
            -- 1) We wont have a proper translation, and the translation will be set to
            --    "UI_optionscreen_binding_Equip/Unequip Pistol", which will look funny on the 
            --    options screen, so we need to fix
            -- 2) the new translation doesn't properly adjust the x position and width, so we need to 
            --    manually adjust these
            
            if label.name == "Call Closest Group Member" then
                label:setTranslation(getText("ContextMenu_SOption_CallClosestGroupMember"))
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "Call Closest Non-Group Member" then 
                label:setTranslation(getText("ContextMenu_SOption_CallClosestNonGroupMember"))
                label:setX(label.x)
                label:setWidth(label.width)
             elseif label.name == "Ask Closest Group Member to Follow" then 
                label:setTranslation(getText("ContextMenu_SOption_AskClosestGroupMembertoFollow"))
                label:setX(label.x)
                label:setWidth(label.width)
             elseif label.name == "Spawn Wild Survivor" then 
                label:setTranslation(getText("ContextMenu_SOption_SpawnWildSurvivor"))
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "Toggle Group Window" then  
                label:setTranslation(getText("ContextMenu_SOption_ToggleGroupWindow"))
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "Lower Follow Distance" then  
                label:setTranslation(getText("ContextMenu_SOption_LowerFollowDistance"))
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "Raise Follow Distance" then  
                label:setTranslation(getText("ContextMenu_SOption_RaiseFollowDistance"))
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "SSHotkey_1" then  
                label:setTranslation(getText("ContextMenu_SShotkey1"))
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "SSHotkey_2" then  
                label:setTranslation(getText("ContextMenu_SShotkey2"))
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "SSHotkey_3" then  
                label:setTranslation(getText("ContextMenu_SShotkey3"))
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "SSHotkey_4" then  
                label:setTranslation(getText("ContextMenu_SShotkey4"))
                label:setX(label.x)
                label:setWidth(label.width)
            end
		   
        until true end
		
		
		
		----- Survivor options in Game Options -----
		local spacing = 10
	
		self:addPage("SUPER SURVIVORS")
		self.addY = 0
		
		local label
		local y = 5
		local comboWidth = 300
		local splitpoint = self:getWidth() / 3;
	
		
		local options = {getText("ContextMenu_SD_ExtremelyLow"),getText("ContextMenu_SD_VeryLow"), getText("ContextMenu_SD_Low"),getText("ContextMenu_SD_Normal"), getText("ContextMenu_SD_High"),getText("ContextMenu_SD_VeryHigh"),getText("ContextMenu_SD_ExtremelyHigh"),getText("ContextMenu_SD_Off")}
		local spawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SOption_SurvivorSpawnRate"), options, 1)
		spawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SOption_SurvivorSpawnRateDesc")});
		
		gameOption = GameOption:new('SpawnRate', spawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("SpawnRate")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("SpawnRate",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		
		
		
		y = y + spacing
		
		
		
		local options = {getText("ContextMenu_SD_Off"),getText("ContextMenu_SD_On")}
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SD_NoPreSetSpawn"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SD_NoPreSetSpawnDesc")});
		
		gameOption = GameOption:new('NoPreSetSpawn', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("NoPreSetSpawn")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("NoPreSetSpawn",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		
		y = y + spacing
		
		
		
		local options = {"0%","5%","10%","15%","20%","25%","30%","35%","40%","45%","50%","55%","60%","65%","70%","75%","80%","85%","90%","95%","100%"}
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SOption_ChancetoSpawnWithGun"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SOption_ChancetoSpawnWithGunDesc")});
		
	
		gameOption = GameOption:new('GunSpawnRate', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("GunSpawnRate")
			--MainOptions.instance.reloadLabel.name = ReloadManager[1]:getDifficultyDescription(box.selected):gsub("\\n", "\n")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("GunSpawnRate",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
			--MainOptions.instance.reloadLabel.name = ReloadManager[1]:getDifficultyDescription(box.selected):gsub("\\n", "\n")
		end
		self.gameOptions:add(gameOption)
		
		
		--- raiders --- start
		
		y = y + spacing
		
		
		
		local options = {getText("ContextMenu_SD_Every5Days"), getText("ContextMenu_SD_Every10Days"), getText("ContextMenu_SD_Every15Days"), getText("ContextMenu_SD_Every20Days"), getText("ContextMenu_SD_Every25Days"), getText("ContextMenu_SD_Every30Days"), getText("ContextMenu_SD_Every35Days"), getText("ContextMenu_SD_Every40Days"), getText("ContextMenu_SD_Every45Days"), getText("ContextMenu_SD_Every50Days"), getText("ContextMenu_SD_Every55Days"), getText("ContextMenu_SD_Every60Days"), getText("ContextMenu_SD_Every65Days"), getText("ContextMenu_SD_Every70Days"), getText("ContextMenu_SD_Every75Days"), getText("ContextMenu_SD_Every80Days"), getText("ContextMenu_SD_Every85Days"), getText("ContextMenu_SD_Every90Days"), getText("ContextMenu_SD_Every95Days"), getText("ContextMenu_SD_Every100Days"),getText("ContextMenu_SD_EveryDay"),getText("ContextMenu_SD_EveryHour"),getText("ContextMenu_SD_Every10Minutes")}
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20, getText("ContextMenu_SOption_RaidersGuaranteed"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SOption_RaidersGuaranteedDesc")});
		
		gameOption = GameOption:new('RaidersAtLeastHours', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("RaidersAtLeastHours")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("RaidersAtLeastHours",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		
		
		
		
		y = y + spacing
		
		
		
		local options = {getText("ContextMenu_SD_StartImmediately"),getText("ContextMenu_SD_AfterDay1"), getText("ContextMenu_SD_AfterDay5"), getText("ContextMenu_SD_AfterDay10"), getText("ContextMenu_SD_AfterDay15"), getText("ContextMenu_SD_AfterDay20"), getText("ContextMenu_SD_AfterDay25"), getText("ContextMenu_SD_AfterDay30"), getText("ContextMenu_SD_AfterDay35"), getText("ContextMenu_SD_AfterDay40"), getText("ContextMenu_SD_AfterDay45"), getText("ContextMenu_SD_AfterDay50"), getText("ContextMenu_SD_AfterDay55"), getText("ContextMenu_SD_AfterDay60"), getText("ContextMenu_SD_AfterDay65"), getText("ContextMenu_SD_AfterDay70"), getText("ContextMenu_SD_AfterDay75"), getText("ContextMenu_SD_AfterDay80"), getText("ContextMenu_SD_AfterDay85"), getText("ContextMenu_SD_AfterDay90"), getText("ContextMenu_SD_AfterDay95"), getText("ContextMenu_SD_AfterDay100"),getText("ContextMenu_SD_Never")}
	
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SOption_RaidersAfterHours"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SOption_RaidersAfterHoursDesc")});
		
		
		gameOption = GameOption:new('RaidersAfterHours', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("RaidersAfterHours")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("RaidersAfterHours",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		
		
		
		
		y = y + spacing
		
		
		
		local options = {getText("ContextMenu_SD_VeryHigh"),getText("ContextMenu_SD_High"),getText("ContextMenu_SD_Normal"),getText("ContextMenu_SD_Low"),getText("ContextMenu_SD_VeryLow")}
		--MainOptions.reloadLabel = ISLabel:new(self.width / 3 - 100, y + 40, 20, '', 1, 1, 1, 1, UIFont.Small)
		--self.mainPanel:addChild(MainOptions.reloadLabel)
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SOption_RaidersChance"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SOption_RaidersChanceDesc")});
		
		gameOption = GameOption:new('RaidersChance', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("RaidersChance")
			--MainOptions.instance.reloadLabel.name = ReloadManager[1]:getDifficultyDescription(box.selected):gsub("\\n", "\n")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("RaidersChance",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
			--MainOptions.instance.reloadLabel.name = ReloadManager[1]:getDifficultyDescription(box.selected):gsub("\\n", "\n")
		end
		self.gameOptions:add(gameOption)
		
		
		--- raiders --- end
		
		
		y = y + spacing
		
		
		
		local options = {"0%","5%","10%","15%","20%","25%","30%","35%","40%","45%","50%","55%","60%","65%","70%","75%","80%","85%","90%","95%","100%"}
		--MainOptions.reloadLabel = ISLabel:new(self.width / 3 - 100, y + 40, 20, '', 1, 1, 1, 1, UIFont.Small)
		--self.mainPanel:addChild(MainOptions.reloadLabel)
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SOption_WepSpawnRate"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SOption_WepSpawnRateDesc")});
		
		gameOption = GameOption:new('WepSpawnRate', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("WepSpawnRate")
			--MainOptions.instance.reloadLabel.name = ReloadManager[1]:getDifficultyDescription(box.selected):gsub("\\n", "\n")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("WepSpawnRate",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
			--MainOptions.instance.reloadLabel.name = ReloadManager[1]:getDifficultyDescription(box.selected):gsub("\\n", "\n")
		end
		self.gameOptions:add(gameOption)
		
		
		
		
		
		y = y + spacing
		
		
		
		local options = {"0%","5%","10%","15%","20%","25%","30%","35%","40%","45%","50%","55%","60%","65%","70%","75%","80%","85%","90%","95%","100%"}
		--MainOptions.reloadLabel = ISLabel:new(self.width / 3 - 100, y + 40, 20, '', 1, 1, 1, 1, UIFont.Small)
		--self.mainPanel:addChild(MainOptions.reloadLabel)
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SOption_ChancetobeHostile"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SOption_ChancetobeHostileDesc")});
		
		
		gameOption = GameOption:new('HostileSpawnRate', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("HostileSpawnRate")
			--MainOptions.instance.reloadLabel.name = ReloadManager[1]:getDifficultyDescription(box.selected):gsub("\\n", "\n")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("HostileSpawnRate",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
			--MainOptions.instance.reloadLabel.name = ReloadManager[1]:getDifficultyDescription(box.selected):gsub("\\n", "\n")
		end
		self.gameOptions:add(gameOption)
		
		
		y = y + spacing
		
		
		
		local options = {"0%","5%","10%","15%","20%","25%","30%","35%","40%","45%","50%","55%","60%","65%","70%","75%","80%","85%","90%","95%","100%"}
		--MainOptions.reloadLabel = ISLabel:new(self.width / 3 - 100, y + 40, 20, '', 1, 1, 1, 1, UIFont.Small)
		--self.mainPanel:addChild(MainOptions.reloadLabel)
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SOption_MaxHostileSpawnRate"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SOption_MaxHostileSpawnRateDesc")});
		
		gameOption = GameOption:new('MaxHostileSpawnRate', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("MaxHostileSpawnRate")
			--MainOptions.instance.reloadLabel.name = ReloadManager[1]:getDifficultyDescription(box.selected):gsub("\\n", "\n")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("MaxHostileSpawnRate",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
			--MainOptions.instance.reloadLabel.name = ReloadManager[1]:getDifficultyDescription(box.selected):gsub("\\n", "\n")
		end
		self.gameOptions:add(gameOption)
		
		
		
		
		y = y + spacing
		
		
		
		local options = {getText("ContextMenu_SD_Off"),getText("ContextMenu_SD_On")}
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SOption_LockNLoad"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SOption_LockNLoadDesc")});
		
		gameOption = GameOption:new('LockNLoad', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("LockNLoad")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("LockNLoad",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		y = y + spacing
		
		
		
		local options = {getText("ContextMenu_SD_Off"),getText("ContextMenu_SD_On")}
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SOption_WifeSpawn"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SOption_WifeSpawnDesc") });
		
		gameOption = GameOption:new('WifeSpawn', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("WifeSpawn")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("WifeSpawn",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		
			y = y + spacing
		
		
		
		local options = {getText("ContextMenu_SD_DesperateforHumanContact"), getText("ContextMenu_SD_VeryFriendly"), getText("ContextMenu_SD_Friendly"), getText("ContextMenu_SD_Normal"), getText("ContextMenu_SD_Mean"), getText("ContextMenu_SD_VeryMean")}
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SOption_SurvivorFriendliness"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SOption_SurvivorFriendlinessDesc")});
		
		gameOption = GameOption:new('SurvivorFriendliness', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("SurvivorFriendliness")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("SurvivorFriendliness",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		
			y = y + spacing
		
		
		
		local options = {getText("ContextMenu_SD_Cowardly"), getText("ContextMenu_SD_Normal"), getText("ContextMenu_SD_Brave"), getText("ContextMenu_SD_VeryBrave")}
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SOption_SurvivorBravery"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SOption_SurvivorBraveryDesc")});
		
		gameOption = GameOption:new('Bravery', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("Bravery")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("Bravery",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		
			y = y + spacing
		
		
		
		local options = {getText("ContextMenu_SD_Off"),getText("ContextMenu_SD_On")}
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SOption_InfinitAmmo"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SOption_InfinitAmmoDesc")});
		
		gameOption = GameOption:new('InfinitAmmo', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("InfinitAmmo")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("InfinitAmmo",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		
		y = y + spacing
		
		
		
		local options = {getText("ContextMenu_SD_On"),getText("ContextMenu_SD_Off")}
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SOption_FindWork"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SOption_FindWorkDesc")});
		
		gameOption = GameOption:new('FindWork', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("FindWork")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("FindWork",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		
		y = y + spacing
		
		
		
		local options = {getText("ContextMenu_SD_On"),getText("ContextMenu_SD_Off")}
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SOption_SurvivorHunger"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SOption_SurvivorHungerDesc")});
		
		gameOption = GameOption:new('SurvivorHunger', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("SurvivorHunger")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("SurvivorHunger",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		
		y = y + spacing
		
		
		
		local options = {getText("ContextMenu_SD_Off"),getText("ContextMenu_SD_On")}
		local SafeBaseOptionsCombo = self:addCombo(splitpoint, y, comboWidth, 20,"Safe Base", options, 1)
		SafeBaseOptionsCombo:setToolTipMap({defaultTooltip = "Wild Survivors will avoid your marked base"});
		
		gameOption = GameOption:new('SafeBase', SafeBaseOptionsCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("SafeBase")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("SafeBase",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		
		y = y + spacing
		
		
		
		local options = {getText("ContextMenu_SD_Off"),getText("ContextMenu_SD_On")}
		local DebugOptionsCombo = self:addCombo(splitpoint, y, comboWidth, 20,"Debug Options", options, 1)
		DebugOptionsCombo:setToolTipMap({defaultTooltip = "Turns on debug right click survivor options"});
		
		gameOption = GameOption:new('DebugOptions', DebugOptionsCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("DebugOptions")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("DebugOptions",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		------hot keys-------
		
		y = y + spacing
		
		
		
		local options = SSHotKeyOptions
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SShotkey1"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SShotkeyDesc")});
		
		gameOption = GameOption:new('SSHotkey1', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("SSHotkey1")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("SSHotkey1",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		y = y + spacing
		
		local options = SSHotKeyOptions
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SShotkey2"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SShotkeyDesc")});
		
		gameOption = GameOption:new('SSHotkey2', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("SSHotkey2")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("SSHotkey2",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		y = y + spacing
		
		local options = SSHotKeyOptions
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SShotkey3"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SShotkeyDesc")});
		
		gameOption = GameOption:new('SSHotkey3', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("SSHotkey3")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("SSHotkey3",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		y = y + spacing
		
		local options = SSHotKeyOptions
		local gunspawnrateCombo = self:addCombo(splitpoint, y, comboWidth, 20,getText("ContextMenu_SShotkey4"), options, 1)
		gunspawnrateCombo:setToolTipMap({defaultTooltip = getText("ContextMenu_SShotkeyDesc")});
		
		gameOption = GameOption:new('SSHotkey4', gunspawnrateCombo)
		function gameOption.toUI(self)
			local box = self.control
			box.selected = SuperSurvivorGetOption("SSHotkey4")
		end
		function gameOption.apply(self)
			local box = self.control
			if box.options[box.selected] then
				SuperSurvivorSetOption("SSHotkey4",box.selected)
				print("setting survivor option")
			else
				print("error could not set survivor option")
			end
		end
		function gameOption:onChange(box)
			print("option changed to ".. tostring(box.selected))
		end
		self.gameOptions:add(gameOption)
		
		------hot keys------- END
	
		 self.addY = self.addY+MainOptions.translatorPane:getHeight()+22;

		self.mainPanel:setScrollHeight(y + self.addY + 20)
		
		
    end
end

