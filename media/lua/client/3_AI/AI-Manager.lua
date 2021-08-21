
function AIManager(TaskMangerIn)
	
	local ASuperSurvivor = TaskMangerIn.parent	
	if(ASuperSurvivor.DebugMode) then print(ASuperSurvivor:getName().." "..ASuperSurvivor:getAIMode() .. " AIManager1 " .. TaskMangerIn:getCurrentTask()) end
	
	if(ASuperSurvivor:needToFollow()) or (ASuperSurvivor:Get():getVehicle() ~= nil) then return TaskMangerIn end
	
	if(ASuperSurvivor.DebugMode) then print(ASuperSurvivor:getName().." "..ASuperSurvivor:getAIMode() .. " AIManager2") end
	if (TaskMangerIn == nil) or (ASuperSurvivor == nil) then 
		print("error TaskMangerIn or ASuperSurvivor was nil")
		return false 
	end
	
	local EnemyIsSurvivor = (instanceof(ASuperSurvivor.LastEnemeySeen,"IsoPlayer"))
	local EnemySuperSurvivor = nil
	local LastSuperSurvivor = nil
	local EnemyIsSurvivorHasGun = false
	local LastSurvivorHasGun = false
	if(EnemyIsSurvivor) then 
		local id = ASuperSurvivor.LastEnemeySeen:getModData().ID
		
		EnemySuperSurvivor = SSM:Get(id) 
		if(EnemySuperSurvivor) then
			EnemyIsSurvivorHasGun = EnemySuperSurvivor:hasGun()
		end
	end
	if(ASuperSurvivor.LastSurvivorSeen) then 
		local lsid = ASuperSurvivor.LastSurvivorSeen:getModData().ID
		
		LastSuperSurvivor = SSM:Get(lsid) 
		if(LastSuperSurvivor) then
			LastSurvivorHasGun = LastSuperSurvivor:hasGun()
		end
	end
	local IHaveInjury = ASuperSurvivor:HasInjury()
	local weapon = ASuperSurvivor.player:getPrimaryHandItem()
	local IsInAction = ASuperSurvivor:isInAction()
	local HisGroup = ASuperSurvivor:getGroup()
	local IsInBase = ASuperSurvivor:isInBase()
	local CenterBaseSquare = nil
	local DistanceBetweenMainPlayer = getDistanceBetween(getSpecificPlayer(0),ASuperSurvivor:Get()) 
	if(HisGroup) then CenterBaseSquare = HisGroup:getBaseCenter() end
	
		-------------shared ai for all -----------------------------------------------
	
	if (TaskMangerIn:getCurrentTask() ~= "Enter New Building") and (TaskMangerIn:getCurrentTask() ~= "Threaten") and ASuperSurvivor:isWalkingPermitted() and EnemyIsSurvivor and ASuperSurvivor:hasWeapon() and (EnemyIsSurvivorHasGun == false or ASuperSurvivor:hasGun()) and (ASuperSurvivor.LastEnemeySeen ~= nil) and (ASuperSurvivor:getDangerSeenCount() == 0) and (IHaveInjury == false) and TaskMangerIn:getCurrentTask() ~= "Pursue" then
		if(ASuperSurvivor:Get():getModData().isHostile) and (ASuperSurvivor:isSpeaking() == false) then ASuperSurvivor:Speak(getSpeech("GonnaGetYou")) end
		TaskMangerIn:AddToTop(PursueTask:new(ASuperSurvivor,ASuperSurvivor.LastEnemeySeen))
	end
	

		
	--if( (TaskMangerIn:getCurrentTask() ~= "Surender") and EnemyIsSurvivor and EnemyIsSurvivorHasGun and  EnemySuperSurvivor and not ASuperSurvivor:usingGun() and EnemyIsSurvivor.player:isAiming() and (getDistanceBetween(EnemySuperSurvivor:Get(),ASuperSurvivor:Get()) < 6)) then
	--	TaskMangerIn:AddToTop(SurenderTask:new(ASuperSurvivor, EnemySuperSurvivor))
	--end
	if(getSpecificPlayer(0) ~= nil) then
		local facingResult = getSpecificPlayer(0):getDotWithForwardDirection(ASuperSurvivor.player:getX(),ASuperSurvivor.player:getY())
		--ASuperSurvivor:Speak( tostring(facingResult) )
		if( (TaskMangerIn:getCurrentTask() ~= "Surender") and (TaskMangerIn:getCurrentTask() ~= "Flee" )and (TaskMangerIn:getCurrentTask() ~= "Flee From Spot") and (TaskMangerIn:getCurrentTask() ~= "Clean Inventory") and SSM:Get(0):usingGun() and  getSpecificPlayer(0) and getSpecificPlayer(0):CanSee(ASuperSurvivor.player) and (not ASuperSurvivor:usingGun() or (not ASuperSurvivor:RealCanSee(getSpecificPlayer(0)) and DistanceBetweenMainPlayer<=3 )) and getSpecificPlayer(0):isAiming() and IsoPlayer.getCoopPVP() and not ASuperSurvivor:isInGroup(getSpecificPlayer(0)) and (facingResult > 0.95 ) and (DistanceBetweenMainPlayer < 6)) then
			TaskMangerIn:clear()
			TaskMangerIn:AddToTop(SurenderTask:new(ASuperSurvivor, SSM:Get(0)))
			return TaskMangerIn
		end
	end
		
	if ((TaskMangerIn:getCurrentTask() ~= "Attack") and (TaskMangerIn:getCurrentTask() ~= "Threaten") and not ((TaskMangerIn:getCurrentTask() == "Surender") and EnemyIsSurvivor) and (TaskMangerIn:getCurrentTask() ~= "Doctor") and (ASuperSurvivor:isInSameRoom(ASuperSurvivor.LastEnemeySeen)) and (TaskMangerIn:getCurrentTask() ~= "Flee")) and ((ASuperSurvivor:hasWeapon() and ((ASuperSurvivor:getDangerSeenCount() >= 1) or (ASuperSurvivor:isEnemyInRange(ASuperSurvivor.LastEnemeySeen)))) or (ASuperSurvivor:hasWeapon() == false and (ASuperSurvivor:getDangerSeenCount() == 1) and (not EnemyIsSurvivor))) and (IHaveInjury == false) then
		--ASuperSurvivor:Speak( ASuperSurvivor:getName()..": need to attack")
		if(ASuperSurvivor.player:getModData().isRobber) and (not ASuperSurvivor.player:getModData().hitByCharacter) and EnemyIsSurvivor and (not EnemySuperSurvivor.player:getModData().dealBreaker) then TaskMangerIn:AddToTop(ThreatenTask:new(ASuperSurvivor,EnemySuperSurvivor,"Scram"))
		else TaskMangerIn:AddToTop(AttackTask:new(ASuperSurvivor)) end
	end
	-- find safe place if injured and enemies near
	if (TaskMangerIn:getCurrentTask() ~= "Find Building") and (TaskMangerIn:getCurrentTask() ~= "Flee") and (IHaveInjury) and (ASuperSurvivor:getDangerSeenCount() > 0) then
		TaskMangerIn:AddToTop(FindBuildingTask:new(ASuperSurvivor))
	end
	-- bandage injuries if no threat near by
	if (TaskMangerIn:getCurrentTask() ~= "First Aide") and (TaskMangerIn:getCurrentTask() ~= "Flee From Spot") and (TaskMangerIn:getCurrentTask() ~= "Flee") and (TaskMangerIn:getCurrentTask() ~= "Doctor") and (TaskMangerIn:getCurrentTask() ~= "Hold Still") and (IHaveInjury) and (ASuperSurvivor:getDangerSeenCount() == 0) then
		TaskMangerIn:AddToTop(FirstAideTask:new(ASuperSurvivor))
	end
	-- flee from too many zombies
	if (TaskMangerIn:getCurrentTask() ~= "Flee") and ((TaskMangerIn:getCurrentTask() ~= "Surender") and not EnemyIsSurvivor) and (ASuperSurvivor:getDangerSeenCount() > 0) and ((ASuperSurvivor:isTooScaredToFight()) or (not ASuperSurvivor:hasWeapon() and ASuperSurvivor:getDangerSeenCount() > 1) or (IHaveInjury and ASuperSurvivor:getDangerSeenCount() > 0) or (EnemyIsSurvivorHasGun and ASuperSurvivor:hasGun() == false) ) then
		if(TaskMangerIn:getCurrentTask() == "LootCategoryTask") then -- currently to dangerous to loot said building. so give up it
			TaskMangerIn:getTask():ForceFinish()
		end
		TaskMangerIn:AddToTop(FleeTask:new(ASuperSurvivor))
	end
	-- eat food on person or go find food in building if in building
	if (ASuperSurvivor:getAIMode() ~= "Random Solo") and ((ASuperSurvivor:isStarving()) or (ASuperSurvivor:isDyingOfThirst())) then  -- leave group and look for food if starving
	
		ASuperSurvivor:setAIMode("Random Solo") 
		if(ASuperSurvivor:getGroupID() ~= nil) then
		local group = SSGM:Get(ASuperSurvivor:getGroupID())
			group:removeMember(ASuperSurvivor:getID())
		end
		ASuperSurvivor:getTaskManager():clear()
		if (ASuperSurvivor:Get():getStats():getHunger() > 0.40) then ASuperSurvivor:Get():getStats():setHunger(0.40) end
		if (ASuperSurvivor:Get():getStats():getThirst() > 0.40) then ASuperSurvivor:Get():getStats():setThirst(0.40) end
		ASuperSurvivor:Speak(getText("ContextMenu_SD_LeaveGroupHungry"))
		
	elseif (TaskMangerIn:getCurrentTask() ~= "Enter New Building") and (TaskMangerIn:getCurrentTask() ~= "Clean Inventory") and (IsInAction == false) and (TaskMangerIn:getCurrentTask() ~= "Eat Food") and (TaskMangerIn:getCurrentTask() ~= "Find This") and (TaskMangerIn:getCurrentTask() ~= "First Aide")and (TaskMangerIn:getCurrentTask() ~= "Listen") and (((ASuperSurvivor:isHungry()) and (IsInBase)) or ASuperSurvivor:isVHungry() ) and (ASuperSurvivor:getDangerSeenCount() == 0) then
			--ASuperSurvivor:Speak(tostring(ASuperSurvivor:getNoFoodNearBy()))
		if(not ASuperSurvivor:hasFood()) and (ASuperSurvivor:getNoFoodNearBy() == false) then
			if(HisGroup) then 
				local area = HisGroup:getGroupAreaCenterSquare("FoodStorageArea")
				if(area) then ASuperSurvivor:walkTo(area) end
			end	
			print("FindThisTask Food added")
			TaskMangerIn:AddToTop(FindThisTask:new(ASuperSurvivor, "Food", "Category", 1))
		elseif (ASuperSurvivor:hasFood()) then
			print("hasFood: EatFoodTask Food added")
			TaskMangerIn:AddToTop(EatFoodTask:new(ASuperSurvivor,ASuperSurvivor:getFood()))
		end
	end
	if  (TaskMangerIn:getCurrentTask() ~= "Enter New Building") and (IsInAction == false) and (TaskMangerIn:getCurrentTask() ~= "Eat Food") and (TaskMangerIn:getCurrentTask() ~= "Find This") and (TaskMangerIn:getCurrentTask() ~= "First Aide") and (((ASuperSurvivor:isThirsty()) and (IsInBase)) or ASuperSurvivor:isVThirsty() ) and (ASuperSurvivor:getDangerSeenCount() == 0) then
		if(ASuperSurvivor:getNoFoodNearBy() == false) then
			if(HisGroup) then 
				local area = HisGroup:getGroupAreaCenterSquare("FoodStorageArea")
				if(area) then ASuperSurvivor:walkTo(area) end
			end
			TaskMangerIn:AddToTop(FindThisTask:new(ASuperSurvivor, "Water", "Category", 1))
		end		
	end
	
	if((ASuperSurvivor:Get():getModData().InitGreeting ~= nil) or (ASuperSurvivor:getAIMode() == "Random Solo")) and (TaskMangerIn:getCurrentTask() ~= "Listen") and (TaskMangerIn:getCurrentTask() ~= "Surender") and (TaskMangerIn:getCurrentTask() ~= "Flee From Spot") and (TaskMangerIn:getCurrentTask() ~= "Take Gift") and (ASuperSurvivor.LastSurvivorSeen ~= nil) and (ASuperSurvivor.LastSurvivorSeen:isGhostMode() == false) and (ASuperSurvivor:getSpokeTo(ASuperSurvivor.LastSurvivorSeen:getModData().ID) == false) and (getDistanceBetween(ASuperSurvivor.LastSurvivorSeen,ASuperSurvivor:Get()) < 8) and (ASuperSurvivor:getDangerSeenCount()==0) and (TaskMangerIn:getCurrentTask() ~= "First Aide") and (ASuperSurvivor:Get():CanSee(ASuperSurvivor.LastSurvivorSeen)) then
			ASuperSurvivor:Speak(getText("ContextMenu_SD_HeyYou"))
			ASuperSurvivor:SpokeTo(ASuperSurvivor.LastSurvivorSeen:getModData().ID)
			print(ASuperSurvivor:getName() .. " adding listen task")
			TaskMangerIn:AddToTop(ListenTask:new(ASuperSurvivor,ASuperSurvivor.LastSurvivorSeen,true))
	end
		
	--ASuperSurvivor:Speak( tostring(ASuperSurvivor:getNeedAmmo()) ..",".. tostring(ASuperSurvivor:hasAmmoForPrevGun()) ..",".. tostring(IsInAction == false) ..",".. tostring(TaskMangerIn:getCurrentTask() ~= "Take Gift") ..",".. tostring(ASuperSurvivor:getDangerSeenCount()==0) )
	if(ASuperSurvivor:getNeedAmmo()) and (ASuperSurvivor:hasAmmoForPrevGun()) and (IsInAction == false) and (TaskMangerIn:getCurrentTask() ~= "Take Gift") and (ASuperSurvivor:getDangerSeenCount()==0)  then
			ASuperSurvivor:setNeedAmmo(false)
			ASuperSurvivor:reEquipGun()
	end
	
	if(ASuperSurvivor:hasWeapon()) and (ASuperSurvivor:Get():getPrimaryHandItem() == nil) and (TaskMangerIn:getCurrentTask() ~= "Equip Weapon")  then
			TaskMangerIn:AddToTop(EquipWeaponTask:new(ASuperSurvivor))
	end
	
	
	--print( tostring(IsInAction == false) .." and ".. tostring(ASuperSurvivor:getNeedAmmo() == false) .." and ".. tostring(ASuperSurvivor:usingGun()) .." and ".. tostring(ASuperSurvivor:getDangerSeenCount() == 0) .." and (".. tostring(ASuperSurvivor:needToReload()) .." or ".. tostring(ASuperSurvivor:needToReadyGun(weapon)) .. ")" )
	if(IsInAction == false) and (ASuperSurvivor:getNeedAmmo() == false) and ASuperSurvivor:usingGun() and (ASuperSurvivor:getDangerSeenCount() == 0) and ((ASuperSurvivor:needToReload()) or (ASuperSurvivor:needToReadyGun(weapon))) then			
		--print(ASuperSurvivor:getName() .. " AI detected need to ready gun")
		ASuperSurvivor:ReadyGun(weapon)				
	end	
	
	-------------shared ai for all --------------END---------------------------------
	
	
	
	-------------If in base tasks ----------------------------------------
	if(getSpecificPlayer(0) == nil) or (not getSpecificPlayer(0):isAsleep()) then
		SafeToGoOutAndWork = true
		
		if(RainManager.isRaining()) and (ASuperSurvivor:Get():isOutside()) and (TaskMangerIn.TaskUpdateLimit ~= 0) and (TaskMangerIn:getCurrentTask() ~= "Enter New Building") and (TaskMangerIn:getCurrentTask() ~= "Find Building") then
			ASuperSurvivor:Speak(getText("ContextMenu_SD_RainingGoInside"))
			TaskMangerIn:clear()
			TaskMangerIn:AddToTop(AttemptEntryIntoBuildingTask:new(ASuperSurvivor,nil))
			TaskMangerIn:AddToTop(FindBuildingTask:new(ASuperSurvivor))
		end
		
		if (ASuperSurvivor:getCurrentTask() == "None") and (IsInBase) and (not IsInAction) and (ZombRand(4)==0) then
				local AutoWorkTaskTimeLimit = 300
				
				if(ASuperSurvivor:getGroupRole() == "Doctor") then
				
					local medicalarea = HisGroup:getGroupArea("MedicalStorageArea")
					
					local gotoSquare
					if(medicalarea) and (medicalarea[1] ~= 0) then gotoSquare = getCenterSquareFromArea(medicalarea[1],medicalarea[2],medicalarea[3],medicalarea[4],medicalarea[5]) end
					if(not gotoSquare) then gotoSquare = CenterBaseSquare end
					
					if(gotoSquare ) then ASuperSurvivor:walkTo(gotoSquare) end
					TaskMangerIn:AddToTop(DoctorTask:new(ASuperSurvivor))
					return TaskMangerIn
				
				elseif(ASuperSurvivor:getGroupRole() == "Worker") then
					print("yes im a worker:"..tostring(SurvivorsFindWorkThemselves))
					if(SurvivorsFindWorkThemselves) and (RainManager.isRaining() == false) then
					print("yes i should look for work")
						if(SafeToGoOutAndWork) then
							TaskMangerIn:setTaskUpdateLimit(AutoWorkTaskTimeLimit)
							local randresult = ZombRand(5) + 1
							print("random job result is:"..tostring(randresult))
							if(randresult == 1) then
								ASuperSurvivor:Speak(getText("ContextMenu_SD_IGoRelax"))
								TaskMangerIn:AddToTop(WanderInBaseTask:new(ASuperSurvivor))
							elseif(randresult == 2) then
								ASuperSurvivor:Speak(getText("ContextMenu_SD_IGoGetWood"))
								local dropSquare = CenterBaseSquare
								local woodstoragearea = HisGroup:getGroupArea("WoodStorageArea")
								if(woodstoragearea[1] ~= 0) then dropSquare = getCenterSquareFromArea(woodstoragearea[1],woodstoragearea[2],woodstoragearea[3],woodstoragearea[4],woodstoragearea[5]) end
								TaskMangerIn:AddToTop(GatherWoodTask:new(ASuperSurvivor,dropSquare)) 
								TaskMangerIn:setTaskUpdateLimit(AutoWorkTaskTimeLimit)
							elseif(randresult == 3) then
								ASuperSurvivor:Speak(getText("ContextMenu_SD_IGoPileCorpse"))
								local baseBounds = HisGroup:getBounds()
								local dropSquare = getCell():getGridSquare(baseBounds[1]-5,baseBounds[3]-5,0)
								local storagearea = HisGroup:getGroupArea("CorpseStorageArea")
								if(storagearea[1] ~= 0) then dropSquare = getCenterSquareFromArea(storagearea[1],storagearea[2],storagearea[3],storagearea[4],storagearea[5]) end
								if(dropSquare) then
									TaskMangerIn:AddToTop(PileCorpsesTask:new(ASuperSurvivor,dropSquare)) 
									TaskMangerIn:setTaskUpdateLimit(AutoWorkTaskTimeLimit)
								end
							elseif(randresult == 4) then
								
								local dropSquare = CenterBaseSquare
								local FoodStorageCenter = HisGroup:getGroupAreaCenterSquare("FoodStorageArea")
								if(FoodStorageCenter) then dropSquare = FoodStorageCenter end
								
								local forage = HisGroup:getGroupAreaCenterSquare("ForageArea")
								if(forage ~= nil) then 				
									ASuperSurvivor:Speak(getText("ContextMenu_SD_IGoForage"))
									TaskMangerIn:AddToTop(CleanInvTask:new(ASuperSurvivor,dropSquare,false)) 
									TaskMangerIn:AddToTop(ForageTask:new(ASuperSurvivor)) 
									TaskMangerIn:setTaskUpdateLimit(AutoWorkTaskTimeLimit)
									ASuperSurvivor:walkTo(forage)
								else
									print("forage was nil")
								end
								
							elseif(randresult == 5) then
								
								local area = HisGroup:getGroupAreaCenterSquare("ChopTreeArea")
								if(area) then 		
									ASuperSurvivor:Speak(getText("ContextMenu_SD_IGoChopWood"))
									TaskMangerIn:AddToTop(ChopWoodTask:new(ASuperSurvivor)) 					
									TaskMangerIn:setTaskUpdateLimit(AutoWorkTaskTimeLimit)					
								else
									print("area was nil")
								end
								
							end
						else
							TaskMangerIn:AddToTop(WanderInBaseTask:new(ASuperSurvivor))
						end -- safeto go out end
					end -- allowed to go out work end
					
				
				elseif(ASuperSurvivor:getGroupRole() == "Guard") then
					
					local randresult = 2 --ZombRand(2) + 1
					print("random job result is:"..tostring(randresult))
					if(randresult == 1) then
					
						ASuperSurvivor:Speak(getText("ContextMenu_SD_IGoRelax"))
						TaskMangerIn:AddToTop(WanderInBaseTask:new(ASuperSurvivor))
						
					elseif(randresult == 2) then
					
						local area = HisGroup:getGroupArea("GuardArea")
						if(area) then 		
							ASuperSurvivor:Speak(getText("ContextMenu_SD_IGoGuard"))
							TaskMangerIn:AddToTop(WanderInAreaTask:new(ASuperSurvivor,area)) 					
							TaskMangerIn:setTaskUpdateLimit(AutoWorkTaskTimeLimit)					
						else
							print("area was nil")
						end
					end
					
				elseif(ASuperSurvivor:getGroupRole() == "Farmer") then
					
					local randresult = 2 --ZombRand(2) + 1
					print("random job result is:"..tostring(randresult))
					if(randresult == 1) then
					
						ASuperSurvivor:Speak(getText("ContextMenu_SD_IGoRelax"))
						TaskMangerIn:AddToTop(WanderInBaseTask:new(ASuperSurvivor))
						TaskMangerIn:setTaskUpdateLimit(AutoWorkTaskTimeLimit)
						
					elseif(randresult == 2) then
					
						local area = HisGroup:getGroupArea("FarmingArea")
						if(area) then 		
							ASuperSurvivor:Speak(getText("ContextMenu_SD_IGoFarm"))
							TaskMangerIn:AddToTop(FarmingTask:new(ASuperSurvivor)) 					
							TaskMangerIn:setTaskUpdateLimit(AutoWorkTaskTimeLimit)					
						else
							print("farming area was nil")
						end
					end
					
				end
		end
		if (ASuperSurvivor:getCurrentTask() == "None") and (IsInBase == false) and (not IsInAction) and (HisGroup~=nil) then
			local baseSq = CenterBaseSquare
			if(baseSq ~= nil) then 
				ASuperSurvivor:Speak(getText("ContextMenu_SD_IGoBackBase"))
				TaskMangerIn:AddToTop(ReturnToBaseTask:new(ASuperSurvivor)) 
			end
		end
	end	
	-------------If in base tasks --END--------------------------------------
	
	if(ASuperSurvivor.DebugMode) then print(ASuperSurvivor:getAIMode()) end
	
	if(ASuperSurvivor:getAIMode() == "Random Solo") and (TaskMangerIn:getCurrentTask() ~= "Listen") and (TaskMangerIn:getCurrentTask() ~= "Take Gift") then -- solo random survivor AI flow	

		if(TaskMangerIn:getCurrentTask() == "None") and (ASuperSurvivor.TargetBuilding ~= nil) and (not ASuperSurvivor:getBuildingExplored(ASuperSurvivor.TargetBuilding)) then
			TaskMangerIn:AddToTop(AttemptEntryIntoBuildingTask:new(ASuperSurvivor, ASuperSurvivor.TargetBuilding))
		elseif(TaskMangerIn:getCurrentTask() == "None") then
			TaskMangerIn:AddToTop(FindUnlootedBuildingTask:new(ASuperSurvivor))
		end
		
		if(ASuperSurvivor.TargetBuilding ~= nil) or (ASuperSurvivor:inUnLootedBuilding()) then
			if ASuperSurvivor.TargetBuilding == nil then ASuperSurvivor.TargetBuilding = ASuperSurvivor:getBuilding() end
			if (not ASuperSurvivor:hasWeapon()) and (TaskMangerIn:getCurrentTask() ~= "Loot Category") and (ASuperSurvivor:getDangerSeenCount() <= 0) and (ASuperSurvivor:inUnLootedBuilding()) then
				TaskMangerIn:AddToTop(LootCategoryTask:new(ASuperSurvivor,ASuperSurvivor.TargetBuilding,"Food",0))
				TaskMangerIn:AddToTop(EquipWeaponTask:new(ASuperSurvivor))
				TaskMangerIn:AddToTop(LootCategoryTask:new(ASuperSurvivor,ASuperSurvivor.TargetBuilding,"Weapon",2))
			elseif (ASuperSurvivor:hasRoomInBag()) and (TaskMangerIn:getCurrentTask() ~= "Loot Category") and (ASuperSurvivor:getDangerSeenCount() <= 0) and (ASuperSurvivor:inUnLootedBuilding()) then
				TaskMangerIn:AddToTop(LootCategoryTask:new(ASuperSurvivor,ASuperSurvivor.TargetBuilding,"Food",0))
			end
		end
		--turning this off for now, somehow already used group ids being given as new ones?
		if(false) and (ASuperSurvivor:getBaseBuilding() == nil) and (ASuperSurvivor:getBuilding()) and (TaskMangerIn:getCurrentTask() ~= "First Aide") and (TaskMangerIn:getCurrentTask() ~= "Attack") and (TaskMangerIn:getCurrentTask() ~= "Barricade Building") and (ASuperSurvivor:hasWeapon())  and (ASuperSurvivor:hasFood()) then
			TaskMangerIn:clear()
			ASuperSurvivor:setBaseBuilding(ASuperSurvivor:getBuilding())
			TaskMangerIn:AddToTop(WanderInBuildingTask:new(ASuperSurvivor,ASuperSurvivor:getBuilding()))
			TaskMangerIn:AddToTop(LockDoorsTask:new(ASuperSurvivor,true))
			TaskMangerIn:AddToTop(BarricadeBuildingTask:new(ASuperSurvivor))
			--ASuperSurvivor:Speak("This will be my base.")
			local GroupId = SSGM:GetGroupIdFromSquare(ASuperSurvivor:Get():getCurrentSquare())
			--ASuperSurvivor:Speak(tostring(GroupId))
			if(GroupId == -1) then -- if the base this npc is gonna stay in is not declared as another base then they set it as thier base.
				local nGroup = SSGM:newGroup()					
				nGroup:addMember(ASuperSurvivor,"Leader")
				local def = ASuperSurvivor:getBuilding():getDef()
				local bounds = {def:getX()-1,(def:getX() + def:getW()+1 ), def:getY()-1,(def:getY() + def:getH()+1),0}
				nGroup:setBounds(bounds)
				--ASuperSurvivor:Speak(tostring(nGroup:getID()))
			elseif(GroupId ~= SSM:Get(0):getGroupID()) then
				local OwnerGroup = SSGM:Get(GroupId)
				local LeaderID = OwnerGroup:getLeader()
				if(LeaderID ~= 0) then
					OwnerGroup:addMember(ASuperSurvivor,"Worker")
					ASuperSurvivor:Speak("Please let me stay here")
					local LeaderObj = SSM:Get(LeaderID)
					if(LeaderObj) then LeaderObj:Speak("Welcome to our Group") end
				end
			end
			
		end
		
		
		if ((ASuperSurvivor:isStarving()) or (ASuperSurvivor:isVThirsty())) and (ASuperSurvivor:getBaseBuilding() ~= nil) then  -- leave group and look for food if starving
			-- random survivor in base is starving - reset so he goes back out looking for food and re base there
			ASuperSurvivor:setAIMode("Random Solo") 
			if(ASuperSurvivor:getGroupID() ~= nil) then
				local group = SSGM:Get(ASuperSurvivor:getGroupID())
				group:removeMember(ASuperSurvivor:getID())
			end
			ASuperSurvivor:getTaskManager():clear()
			ASuperSurvivor:Speak(getText("ContextMenu_SD_LeaveBCHungry"))
			ASuperSurvivor:resetAllTables()
			ASuperSurvivor:setBaseBuilding(nil)
			if (ASuperSurvivor:Get():getStats():getHunger() > 0.30) then ASuperSurvivor:Get():getStats():setHunger(0.30) end
			if (ASuperSurvivor:Get():getStats():getThirst() > 0.30) then ASuperSurvivor:Get():getStats():setThirst(0.30) end
			
		end
			
	
	
	end
	
	

		if(ASuperSurvivor.DebugMode) then print(ASuperSurvivor:getName().." "..ASuperSurvivor:getAIMode() .. " AIManager3 " .. TaskMangerIn:getCurrentTask()) end
	
	
	return TaskMangerIn

end