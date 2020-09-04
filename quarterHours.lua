local composer = require( "composer" )
local scene = composer.newScene( sceneName )
local functions = require ("functions")
local  V1i
local  V1j
local  V2i
local  V2j
local OrgX
local OrgY
local HandsGroup = display.newGroup()
local HandsGroupParent = display.newGroup()
local speechSideGroup = display.newGroup()

local dispGroup = display.newGroup()

local Rad_To_Deg = 180/math.pi
local DClock
local prevH = -1
local prevM = -1
local Hours
local Minutes
local xanderSide
local aniLoopCount = 0


local txtTime
local btnLBLAan
local btnLBLAf
local slideBar
local slideBtn
local TimeMode = "24 hour"
local hourChangeGroup = display.newGroup()
local txtGroup = display.newGroup()
local greenarm = false
local tmrTransition
local tmrShowerPlay

local starAnimation
local starFallAnimation
local beadsParent = display.newGroup()
local blockRect
local playPraise = true
local rect


local minScale = 0.32
local hrScale   = 0.25
local aniPlaying = false

local sheetthinkingsideInfo0 = require("Animations.thinkingside2.thinkingside-0")

local sheetthinkingside0 = graphics.newImageSheet( "Animations/thinkingside2/thinkingside-0.png" ,sheetthinkingsideInfo0 :getSheet())

local sequencethinkingside1 = {
				{ name="thinkingside0", sheet=sheetthinkingside0, start=1, count=60, time= 4000, loopCount=1,loopDirection = "bounce" }
				}

local musicIconGroup = display.newGroup()
local musicIconOff
local musicIconOn
local function toggleMusic(event)

if bPlayMusic == true then
musicIconOff:toFront()
musicIconOff.alpha = 1
musicIconOn.alpha = 0
--musicIconOff:addEventListener("tap", functions.toggleMusic )
audio.setVolume( 0, { channel=1 } )
bPlayMusic = false
else
musicIconOn:toFront()
musicIconOn.alpha = 1
musicIconOff.alpha = 0
--musicIconOn:addEventListener("tap", functions.toggleMusic)
audio.setVolume( 1, { channel=1 } )
bPlayMusic = true
end
end


local function setupMusicIcon()
musicIconOn = display.newImage("Graphics/Music_on.png")
musicIconOff = display.newImage("Graphics/Music_off.png")

musicIconOn:scale(0.1*display.contentHeight/musicIconOn.contentHeight,0.1*display.contentHeight/musicIconOn.contentHeight)
musicIconOff:scale(0.1*display.contentHeight/musicIconOff.contentHeight,0.1*display.contentHeight/musicIconOff.contentHeight)
musicIconOn.x = musicIconOn.contentWidth/2 +xInset/2.3
musicIconOn.y = display.contentHeight - musicIconOn.contentHeight/2 - yInset/2
musicIconOff.x = musicIconOn.contentWidth/2+xInset/2.3
musicIconOff.y = display.contentHeight - musicIconOn.contentHeight/2 - yInset/2
musicIconOff.isHitTestable =true
musicIconOn.isHitTestable =true
musicIconGroup:insert(musicIconOff)
musicIconGroup:insert(musicIconOn)
musicIconOn:addEventListener("tap",  toggleMusic)
return musicIconGroup
end
				
local function showSpeechSide(Type,variation)
		speechSideGroup.alpha = 1
		if grp ~= nil then
		grp:removeSelf()
		end
		local grp = display.newGroup()
		local speechSide = display.newImage("Graphics/HalfHours/halfhours_speechbubble.png")
		
		grp:insert(speechSide)

		
		if (Type == "praise") then
			playPraise = true
			txtBubble = praiseText[variation]
		else
			txtBubble = "Elke kwartuur\nis 15 minute."
		end

	
		 local options2 = 
	{
	
		text = txtBubble,     
		x = speechSide.x ,
		y = speechSide.y ,		
		font = teachersPetFont,   
		fontSize = 20,
		align = "center"  -- alignment parameter
	}

	local txtspeech = display.newText(options2)
	txtspeech:setFillColor(1)
	txtspeech.alpha = 0
	
	grp:insert(txtspeech)
	--speechStop:scale(sX,sY )

	speechSide.x	=  display.contentWidth/4 + xInset/2
	speechSide.y = yInset*3.5
	--speechSideGroup:insert(txtspeech)		
	txtspeech.x = speechSide.x + xInset/3
	txtspeech.y = speechSide.y - yInset/5
	
	speechSideGroup:insert(grp)
		
	local sX,sY = (txtspeech.contentWidth+ xInset*2)/speechSide.contentWidth,(txtspeech.contentHeight+ yInset*2)/speechSide.contentHeight
	speechSide:scale(0,0)
	
		
		if playPraise == true then
		-- audio.stop()
		   audio.play(audio.loadSound(praiseSound[variation]))
		 end	
		 
transition.to(speechSide,{time = 500, xScale = sX, yScale =sY})
transition.to(txtspeech,{time = 500, alpha = 1,onComplete = function() timer.performWithDelay(3000,
function()  
	grp:removeSelf()
 end) 
 end})
end
local function swapSheetXSide(event)
		print("event.next: ".. event.phase)
		if(event.phase=="bounce" )then


        elseif (event.phase=="ended" )then
		transition.to(speechSideGroup,{time = 500, alpha = 0})
		aniPlaying = false
		 elseif (event.phase=="next" ) then
		aniLoopCount = aniLoopCount + 1
		end
end

 local function playXanderSide(Type,variation)
  if aniPlaying == false then
	aniPlaying = true
 xanderSide.aplha = 1
 xanderSide:play()
 timer.performWithDelay(2500,function() showSpeechSide(Type,variation) end)
 end
 end


local function SetupXanderSide()
xanderSide = display.newSprite(sheetthinkingside0,sequencethinkingside1)
		xanderSide:scale(0.006*display.contentHeight/xanderSide.contentHeight, 0.006*display.contentHeight/xanderSide.contentHeight)
		xanderSide.anchorX = 0
		xanderSide.y = display.contentHeight/2.5
		xanderSide.x = 0
		xanderSide:addEventListener("sprite",swapSheetXSide)
end


local function playMusic()
		math.randomseed( os.time() )
	jingleChoose = math.random(1,2)
	tmrMusicPlay = timer.performWithDelay(500, 
	function() 
		audio.reserveChannels( 1 )
		audio.setVolume( 0.3, { channel=1 } )
		if jingleChoose == 1 then 
			audio.play( audioMusic1, { channel=1, loops=-1, fadein=3000 } )
		else
			audio.play( audioMusic2, { channel=1, loops=-1, fadein=3000 } )
		end
	end)
end
	
local function drawhands(hrAng,mnAng)
   
   if (HandsGroup~= nil)  then 
	HandsGroup:remove(minutehand)
		HandsGroup:remove(ClockCenter)
			HandsGroup:remove(hourhand)
			HandsGroupParent:remove(HandsGroup)
   end
    HandsGroup = display.newGroup()
			
	ClockCenter = display.newImage("Graphics/StopTheClock/stoptheclock_centerclock.png")		  
	ClockCenter.x = Aclock.x
	ClockCenter.y = Aclock.y
	ClockCenter:scale(0.55*scaleAdjust,0.55*scaleAdjust)
	if greenarm == false then
    minutehand = display.newImage("Graphics/StopTheClock/buildtheclock_bluearm@2x.png")	
	else
	 minutehand = display.newImage("Graphics/QuarterHours/quaterhour_greenarm.png")	
	end
    minutehand.anchorX = 0.5
    minutehand.anchorY = 0.9		  
	minutehand.x = ClockCenter.x
	minutehand.y = ClockCenter.y 
	--minutehand.fill.effect = "filter.grayscale"
	--minutehand:rotate(180)
	OrgX = ClockCenter.x
	OrgY = ClockCenter.y
	minutehand:scale(minScale*Aclock.contentWidth/minutehand.contentHeight,minScale*Aclock.contentWidth/minutehand.contentHeight )
	minutehand:rotate(mnAng)
	HandsGroup.minutehand = minutehand
	
	hourhand = display.newImage("Graphics/StopTheClock/buildtheclock_redarm@2x.png")	
    hourhand.anchorX = 0.5
    hourhand.anchorY = 0.9	
	hourhand:scale(hrScale*Aclock.contentWidth/hourhand.contentHeight,hrScale*Aclock.contentWidth/hourhand.contentHeight)   	
	hourhand.x = ClockCenter.x
	hourhand.y = ClockCenter.y
	local hourRect = display.newRect( hourhand.x, hourhand.y , hourhand.contentWidth*4, hourhand.contentHeight*2 )
	hourRect.isVisible = false
	hourRect.isHitTestable = true
	hourRect:setFillColor(0)
	hourRect.anchorX = 0.5
    hourRect.anchorY = 1	
	HandsGroup.hourhandVisible= hourhand
	HandsGroup.hourhand = hourRect
	hourhand:rotate(hrAng)

	HandsGroup:insert(minutehand)		
	HandsGroup:insert(hourhand)
	HandsGroup:insert(hourRect)
	HandsGroup:insert(ClockCenter)
	HandsGroup:toFront()
	HandsGroupParent:insert(HandsGroup)

	
	return HandsGroup
end




local function getHourTwelveRange()
local hrReturn
	
	if Hours == 0 then
	hrReturn = 12
	
	
	elseif (Hours > 12) then
	hrReturn = Hours - 12
	else
	hrReturn = Hours
	end
	
	return hrReturn
end

local function getRandomHour()

		if (TimeMode == "12 hour" ) then
			Hours = math.random(1,12)
		else
			Hours = math.random(0,23)
		end
	print("Hour value generated: ".. Hours)
    local actualTimeVal = getHourTwelveRange()
	print("Hour value converted to 12h range: ".. actualTimeVal)
	print("Previous Time: ".. prevH)
	if (prevH == actualTimeVal) then -- make sure the player does not get the same hour value more than once consecutively
		getRandomHour()
	end
	prevH = getHourTwelveRange()
return Hours
end

local function getRandomMinutes()
	
	local rndm = math.random(1,2)
	if rndm == 1 then
	Minutes = 15
	else
	Minutes = 45
	end
	if (Minutes == prevM) then
	getRandomMinutes()
	end
	prevM = Minutes 
return Minutes
end


local function getHourAngle()
local hourangle 
 hourangle  =getHourTwelveRange()*30  + (Minutes*6/12)
 if hourangle > 360 then 
	hourangle = hourangle - 360
end
 return hourangle
end

local function getMinuteAngle()
local minAngle = Minutes* 6
return minAngle
end

local function playTimeSound()
local angelMin =  getMinuteAngle()
local hourSound = getHourTwelveRange()

local options =
{
 
	onComplete = 
	function()
	functions.playNumSound(12 - hourSound,false)
	end

}

if angelMin == 90 then
	audio.play(kwartOor,options)
elseif angelMin == 180 then
if (hourSound == 12) then
	hourSound = 1
else
	hourSound = hourSound + 1
end
	audio.play(half,options)
elseif angelMin == 270 then

if (hourSound == 12) then
	hourSound = 1
else
	hourSound = hourSound + 1
end
	audio.play(kwartVoor,options)
end


end

local function ShowTime(h,m)


 txtGroup:remove(txtTime)
 
 local options2 = 
{
    
    text = "",     
    x = DClock.x,
    y = DClock.y - yInset/4,
    
    font = native.systemFontBold,  
    fontSize = 30,
    align = "left"  -- alignment parameter
}

 txtTime = display.newText(options2)
txtTime:setFillColor(0)

if (h < 10) then
	h = "0"..h
end
if (m < 10) then
	m = "0"..m
end
txtTime.text = h.." : "..m
txtGroup:insert(txtTime)

end

local function setupNext(minRelease)
local currentHrAngle = getHourAngle()
local currentMnAngle = getMinuteAngle()
print("currentMnAngle1: "..currentMnAngle)
getRandomMinutes()
getRandomHour()
local deltaHr = (getHourAngle() -currentHrAngle)
if deltaHr < 0 then

	deltaHr = 360 + deltaHr

end

local deltaMn = 360 - minRelease 


if deltaMn < 0 then

deltaMn = 0- currentMnAngle

end


print("currentMnAngle2: "..getMinuteAngle())
 transition.to( hourhand, {rotation= deltaHr,iterations = 1,time = 500,delta = true} )
  transition.to( minutehand, { time=500,rotation= deltaMn ,iterations = 1,delta = true} )
 print("currentMnAngle3: "..(getMinuteAngle() - currentMnAngle))
ShowTime(Hours,Minutes)
end

local function calcAngle(x,y)

			local r = math.sqrt(x^2 + y^2)
			local theta = math.asin(y/r)*Rad_To_Deg
			
			if ( x >= 0 and y >= 0) then
			theta = 90 - theta
			elseif ( x >= 0 and y < 0) then
			theta = 90 - theta			
			elseif ( x < 0 and y <0) then
			theta = 270 + theta
			elseif ( x < 0 and y >= 0) then
			theta = 270 + theta
			end

return theta
end

local function showGreenArm(angle)
HandsGroup:remove(greenarm)
local  greenarm = display.newImage("Graphics/QuarterHours/quaterhour_greenarm.png")	
    greenarm.anchorX = 0.5
    greenarm.anchorY = 0.9		  
	greenarm.x = ClockCenter.x
	greenarm.y = ClockCenter.y 
	greenarm:setFillColor( 1, 0.2, 0.2 )
	greenarm:scale(minScale*Aclock.contentWidth/greenarm.contentHeight,minScale*Aclock.contentWidth/greenarm.contentHeight )
	greenarm:rotate(angle)
	HandsGroup:insert(greenarm)
end


function removeAllListeners(obj)
  obj._functionListeners = nil
  obj._tableListeners = nil
end

local function rotatearm( event )
    if event.phase == "began" then
	    bMoved = true
        xStart,yStart = event.x,event.y   -- store x location of object
        target = event.target
        target.isFocus = true 		-- store y location of object
	    display.currentStage:setFocus( target )
		V1i = xStart-OrgX
		V1j = -yStart+OrgY
		removeAllListeners(minutehand)
    elseif event.phase == "moved" then

		if (bMoved) then
			local x = event.x
			local y = event.y

			V2i = x - OrgX
			V2j = OrgY - y
	
			local mAngle = calcAngle(V2i,V2j)
			print("Angle"..mAngle)
			drawhands(getHourAngle(),mAngle)			
			
		V1i = V2i
		V1j = V2j				
         end		
				
	else	
		if (bMoved) then	
			display.currentStage:setFocus( nil )
			target.isFocus = false	

			
			local angleReleased = calcAngle(V2i,V2j)
			local dropTolerance = 45
			if math.abs(angleReleased - getMinuteAngle()) < dropTolerance then
			rect = functions.lockScreen()
					dispGroup:insert(rect)
					

				
				for i = 0,360,90 do
					if math.abs(i - angleReleased) < 45 then
					greenarm = true
					drawhands(getHourAngle(),i)
					greenarm = false
					end
				end
				

				quarterHoursBeadCount = quarterHoursBeadCount + 1
				if (quarterHoursBeadCount == 5 ) then
					quarterHoursBeadCount = 0
					functions.resetBeads()
					quarterHoursStarCount = quarterHoursStarCount + 1
					functions.playStarAni(starAnimation,quarterHoursStarCount,getMinuteAngle(),getHourTwelveRange())
					if (quarterHoursStarCount == 3) then
					quarterHoursStarCount = 0
						qtrGameComplete = true
						playPraise = false
						tmrShowerPlay = timer.performWithDelay(2000,function() functions.starShowerPlay("quarterHours") end)
					end
				end
				if (playPraise) then
					local randomlyPraise = math.random(1,6)
					if (randomlyPraise == 1) then
					local rndm = math.random(1,3) 
					tmrPraiseplay = timer.performWithDelay(xanderPraiseDelay, function()  playXanderSide("praise",rndm) end)
					end
				end
				removeAllListeners(Aclock)
				audio.play(correctSound, {onComplete =function() functions.moveBeads(quarterHoursBeadCount,true,getMinuteAngle(),getHourTwelveRange())	end	} )	
				timer.performWithDelay(2000, function() rect:removeSelf()  drawhands(getHourAngle(),getMinuteAngle()) setupNext(getMinuteAngle()) minutehand:addEventListener("touch",function()  Aclock:addEventListener("touch",rotatearm) minutehand:removeEventListener("touch",rotatearm) end)		 end)	
					
			else
				system.vibrate()
				audio.play(incorrectSound)
				for i = 0,360,90 do
					if math.abs(i - angleReleased) < 45 then
					drawhands(getHourAngle(),i)
					end
				end

			end
			--removeAllListeners(Aclock)
			minutehand:addEventListener("touch",function()  Aclock:addEventListener("touch",rotatearm) minutehand:removeEventListener("touch",rotatearm) end)		
			bMoved = false			
		end
    end  
    return false
end


local function ChangeHours()

	if (TimeMode == "12 hour") then
	TimeMode = "24 hour"
		btnLBLAf.alpha = 0
		transition.to(slideBtn	 , { time= 400,x =slideBar.x - slideBar.contentWidth/2 + slideBtn.contentWidth/2 + 4, onComplete = 
		function()
		btnLBLAan.alpha = 1
		btnLBLAf.alpha = 0
		end})
	else
	TimeMode = "12 hour"
		btnLBLAan.alpha = 0
		transition.to(slideBtn	 , { time= 400,x =slideBar.x + slideBar.contentWidth/2 - slideBtn.contentWidth/2 - 4,onComplete =
		function()
		btnLBLAan.alpha = 0
		btnLBLAf.alpha = 1
		end})
	end
	getRandomMinutes()
	getRandomHour()	
	ShowTime(Hours,Minutes)
	HandsGroup = drawhands(getHourAngle(),0)
	minutehand:addEventListener("touch",function()  Aclock:addEventListener("touch",rotatearm) end)	
	print("Angle to match: "..getHourAngle())
end 

local function setupFirstMatch()

		print("Hourangle:".. getHourAngle())
			minutehand:addEventListener("touch",function()  Aclock:addEventListener("touch",rotatearm) end)	
			ShowTime(Hours,Minutes)
end

local function newqCircle(rotangle)
	local qCircle = display.newImage("Graphics/QuarterHours/quarterCircle.png")
	qCircle.anchorX = 1
	qCircle.anchorY = 0
	qCircle.x = Aclock.x
	qCircle.y = Aclock.y
	qCircle:scale(0.925*Aclock.contentWidth/2/qCircle.contentWidth,0.925*Aclock.contentWidth/2/qCircle.contentWidth)
	qCircle.alpha = 0
	qCircle:rotate(rotangle)

return qCircle

end

local function playStartingAnimation()
blockRect = functions.lockScreen()
	drawhands(90,0)
	HandsGroup:toFront()
local qCircleQPast = newqCircle(180)
dispGroup:insert(qCircleQPast)
local qCircleQTo = newqCircle(0)
dispGroup:insert(qCircleQTo)
ShowTime(3,0)
functions.playNumSound(12-3,true)
tmrTransition = timer.performWithDelay(2000, 
function()
  transition.to( qCircleQPast, { time=3000,alpha = 0.4 , transition=easing.inExpo,iterations = 1} )
    transition.to( minutehand, { time=3000,rotation= 90 , transition=easing.inExpo,iterations = 1,delta = true} )
  transition.to( hourhand, { time=3000,rotation= 7.5 , transition=easing.inExpo,iterations = 1,delta = true,onComplete =
  function()
	    ShowTime(3,15)
	    functions.playTimeSound(90, 3)
    	tmrTransition = timer.performWithDelay(2000, 
	  function()
	      transition.to( minutehand, { time=3000,rotation= 90 , transition=easing.inExpo,iterations = 1,delta = true} )
			transition.to( hourhand, { time=3000,rotation= 7.5 , transition=easing.inExpo,iterations = 1,delta = true,onComplete =
				function() 
					 ShowTime(3,30)
					 functions.playTimeSound(180, 3)
					 tmrTransition = timer.performWithDelay(2000, 
					 function()
								  transition.to( qCircleQTo, { time=3000,alpha = 0.4 , transition=easing.inExpo,iterations = 1} )
							      transition.to( minutehand, { time=3000,rotation= 90 , transition=easing.inExpo,iterations = 1,delta = true} )
								  transition.to( hourhand, { time=3000,rotation= 7.5 , transition=easing.inExpo,iterations = 1,delta = true, onComplete =
								   function()
							    	 ShowTime(3,45)
									 functions.playTimeSound(270, 3)
									tmrTransition = timer.performWithDelay(2000,
											function()
													transition.to( minutehand, { time=3000,rotation= 90 , transition=easing.inExpo,iterations = 1,delta = true} )
													transition.to( hourhand, { time=3000,rotation= 7.5 , transition=easing.inExpo,iterations = 1,delta = true,onComplete =
												function()
													 ShowTime( 4,0)
													 functions.playNumSound(12- 4,true)
													 tmrTransition = timer.performWithDelay(2000,function()
													qCircleQPast.alpha = 0
													qCircleQTo.alpha = 0
													setupFirstMatch()
													Hours = 4
													setupNext(0)
													qtrGameComplete = false
													blockRect.isHitTestable = false
													playMusic()
													end)
												end})
											end)
									end})
					 end)
				end})
	  end)
  end} )
end)
end


function scene:create( event )
    local sceneGroup = self.view
	local phase = event.phase
	audio.stop()
	gotoHomeCnt = 0
	gameEntered = true
	sceneGroup:insert(functions.setBackground())
	Aclock = display.newImage("Graphics/Hours/hour-clock.png")
	Aclock:scale(0.43*display.contentWidth/Aclock.contentWidth,0.43*display.contentWidth/Aclock.contentWidth)
	Aclock.x = display.contentWidth/2 + xInset*1.5
	Aclock.y = display.contentHeight/2
	sceneGroup:insert(Aclock)
	sceneGroup:insert(HandsGroup)
	
	DClock = display.newImage("Graphics/Hours/hour_analogueclockcorrect.png")
	DClock:scale(0.3*display.contentWidth/DClock.contentWidth,0.3*display.contentWidth/DClock.contentWidth)
	DClock.y = display.contentHeight/1.5
	DClock.x = display.contentWidth/5
	sceneGroup:insert(DClock)
	
	        slideBar = display.newImage("Graphics/24uur/24uur-backbar.png")
			slideBar:scale(0.3*scaleAdjust,0.3*scaleAdjust)
			slideBar.x = display.contentWidth - slideBar.contentWidth
	        slideBar.y = display.contentHeight - slideBar.contentHeight
		slideBar:addEventListener("tap",function()
	ChangeHours()
	end)		
			slideBtn =  display.newImage("Graphics/24uur/24uur-circle.png") 
			slideBtn:scale(0.3*scaleAdjust,0.3*scaleAdjust)
			slideBtn.x = slideBar.x - slideBar.contentWidth/2 + slideBtn.contentWidth/2 + 2
			slideBtn.y =  slideBar.y
			
	local lblAF = display.newImage("Graphics/24uur/24uur-afgrey.png") 
			lblAF:scale(0.3*scaleAdjust,0.3*scaleAdjust)
			lblAF.x = slideBar.x + slideBar.contentWidth/2 - slideBtn.contentWidth/2 - 2
			lblAF.y =  slideBar.y
			
	local lblAan = display.newImage("Graphics/24uur/24uur-aangrey.png") 
			lblAan:scale(0.3*scaleAdjust,0.3*scaleAdjust)
			lblAan.x = slideBar.x - slideBar.contentWidth/2 + slideBtn.contentWidth/2 + 2
			lblAan.y =  slideBar.y
			
			btnLBLAan = display.newImage("Graphics/24uur/24uur-aan.png")
			btnLBLAan:scale(0.3*scaleAdjust,0.3*scaleAdjust)
			btnLBLAan.x = lblAan.x
			btnLBLAan.y = lblAan.y	
			btnLBLAan.alpha = 0
				
			btnLBLAf = display.newImage("Graphics/24uur/24uur-af.png")
			btnLBLAf:scale(0.3*scaleAdjust,0.3*scaleAdjust)
			btnLBLAf.x = lblAF.x
			btnLBLAf.y = lblAF.y	
			btnLBLAf.alpha = 0
			
			local lbl24 = display.newImage("Graphics/24uur/24uur-text.png")
			lbl24:scale(0.35,0.35)
			lbl24.x = slideBar.x
			lbl24.y = slideBar.y - slideBar.contentHeight + xInset/3
		
			hourChangeGroup:insert(slideBar)
			hourChangeGroup:insert(lblAan)
			hourChangeGroup:insert(lblAF)
			hourChangeGroup:insert(slideBtn)
			hourChangeGroup:insert(lblAF)	
			hourChangeGroup:insert(btnLBLAan)	
			hourChangeGroup:insert(btnLBLAf)	
			hourChangeGroup:insert(lbl24)	
			sceneGroup:insert(hourChangeGroup)
			
			starAnimation = functions.starsCount()
			functions.playStarAni(starAnimation,quarterHoursStarCount)
			sceneGroup:insert(starAnimation)
							
			math.randomseed( os.time() )
			functions.removeSceneName = "quarterHours"
			
			sceneGroup:insert(HandsGroupParent)
			sceneGroup:insert(txtGroup)
			sceneGroup:insert(speechSideGroup)
			sceneGroup:insert(dispGroup)
			sceneGroup:insert(setupMusicIcon())

end



function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
	
	
    if phase == "will" then
	        ChangeHours()
			if qtrGameComplete == true then
			 playStartingAnimation()
			else
			setupNext(0)
			end
		beadsParent = functions.drawbeads(quarterHoursBeadCount)
		sceneGroup:insert(beadsParent)
    elseif phase == "did" then
		audio.stop()
		SetupXanderSide()
		playXanderSide("vsdv",0)
    end  

end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
    elseif phase == "did" then


	
    end 
end

function scene:destroy( event )
    local sceneGroup = self.view
	xanderSide:removeSelf()
	transition.cancel()
	if tmrTransition ~= nil then
		timer.cancel(tmrTransition)
	end
	
	if tmrShowerPlay~= nil then
	timer.cancel(tmrShowerPlay)
	end
	
	if blockRect ~= nil then
	blockRect:removeSelf()
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene