local composer = require( "composer" )
local functions = require ("functions")
local scene = composer.newScene( sceneName )

if system.getInfo( "platformName" ) == "Win" then
	teachersPetFont = "TeachersPet"
else
	teachersPetFont = "tp.ttf"
end

local DispGroup = display.newGroup()
local txtGroup = display.newGroup()
local ChooseClockGroup = display.newGroup()
local speechGroupStop = display.newGroup()

local XanderSetup
local Xander5
local btnStop

local speechGroupSetup
local starsCount
local starFallAnimation
local playPraise = true
local blockEnd



local runtime = 0
local Theta_Degrees_M = 0
local Theta_Degrees_H = 0
local AClock 	  
local DClock 	
local GameMode = "Analogue"
local minutes
local hours

local beadnames = {"purplebeads.png","orangebeads.png","greenbeads.png","yellowbeads.png","bluebeads.png"}
local beads = {}
local matchCount = 0
local beadGroup
local beadsParent = display.newGroup()

local minuteangle = 0
local HourOrMinute = 2 -- 1 for static hour hand and 2 for static minute hand
local ClockSpeed = 0.5
local count = 1

local ClockCenter
local minutehand
local hourhand
local HandsGroup
local greenarm = false
local aniPlaying = false
local tmrNextTime = nil
local tmrShowerPlay

local sheetxanderthinkingtopInfo0 = require("Animations.thinkingtop.xanderthinkingtop-0")

local sheetxanderthinkingtop0 = graphics.newImageSheet( "Animations/thinkingtop/xanderthinkingtop-0.png" ,sheetxanderthinkingtopInfo0:getSheet())

local sequencetxanderthinkingtop1 = {
				{ name="thinkingtop0", sheet=sheetxanderthinkingtop0, start=1, count=60, time= 5000, loopCount=1,loopDirection = "bounce" }
				}
				
				
local sheetxander5bottomInfo0 = require("Animations.xander5bottom.xander5bottom-0")

local sheetxander5bottom0 = graphics.newImageSheet( "Animations/xander5bottom/xander5bottom-0.png" ,sheetxander5bottomInfo0:getSheet())

local sequencexander5bottom1 = {
				{ name="xander5bottom0", sheet=sheetxander5bottom0, start=1, count=60, time= 3000, loopCount=1,loopDirection = "bounce" }
				}
				
local sheetstopInfo0 = require("Animations.stop.stop-0")

local sheetstop0 = graphics.newImageSheet( "Animations/stop/stop-0.png" ,sheetstopInfo0:getSheet())

local sequencestop1 = {
				{ name="stop0", sheet=sheetstop0, start=1, count=8, time= 100, loopCount=1,loopDirection = "bounce" }
				}
				
				
				
-- local musicIconGroup = display.newGroup()
-- local musicIconOff
-- local musicIconOn
-- local function toggleMusic(event)

-- if bPlayMusic == true then
-- musicIconOff:toFront()
-- musicIconOff.alpha = 1
-- musicIconOn.alpha = 0

-- audio.setVolume( 0, { channel=1 } )
-- bPlayMusic = false
-- else
-- musicIconOn:toFront()
-- musicIconOn.alpha = 1
-- musicIconOff.alpha = 0

-- audio.setVolume( 1, { channel=1 } )
-- bPlayMusic = true
-- end
-- end


-- local function setupMusicIcon()
-- musicIconOn = display.newImage("Graphics/Music_on.png")
-- musicIconOff = display.newImage("Graphics/Music_off.png")

-- musicIconOn:scale(0.1*display.contentHeight/musicIconOn.contentHeight,0.1*display.contentHeight/musicIconOn.contentHeight)
-- musicIconOff:scale(0.1*display.contentHeight/musicIconOff.contentHeight,0.1*display.contentHeight/musicIconOff.contentHeight)
-- musicIconOn.x = musicIconOn.contentWidth/2 +xInset/2.3
-- musicIconOn.y = display.contentHeight - musicIconOn.contentHeight/2 - yInset/2
-- musicIconOff.x = musicIconOn.contentWidth/2+xInset/2.3
-- musicIconOff.y = display.contentHeight - musicIconOn.contentHeight/2 - yInset/2
-- musicIconOff.isHitTestable =true
-- musicIconOn.isHitTestable =true
-- musicIconGroup:insert(musicIconOff)
-- musicIconGroup:insert(musicIconOn)
-- musicIconOn:addEventListener("tap",  toggleMusic)
-- return musicIconGroup
-- end

local function showSpeechSetup()
speechGroupSetup = display.newGroup()
		
		local speech = display.newImage("Graphics/StopTheClock/stoptheclock_speechbubble.png")
		speech:scale(0.35,0.35)
		speech.x	= XanderSetup.x - speech.contentWidth/2
		speech.y = yInset*3
		speechGroupSetup = display.newGroup()
		
		speech:scale(0,0)

		speechGroupSetup:insert(speech)
		
		 local options2 = 
	{
	
		text = "Kies jou horlosie!",     
		x = speech.x - xInset/2,
		y = speech.y,		
		font = teachersPetFont,   
		fontSize = 20,
		align = "center"  -- alignment parameter
	}

	local txtspeech = display.newText(options2)
	txtspeech:setFillColor(1)
	txtspeech.alpha = 0
	
		speechGroupSetup:insert(txtspeech)		
		ChooseClockGroup:insert(speechGroupSetup)

XanderSetup:toFront()		
transition.to(speech,{time = 500, xScale = 0.35, yScale = 0.35})
transition.to(txtspeech,{time = 500, alpha = 1})

end

local function showSpeechStop(Type,variation)
		speechGroupStop.alpha = 1
		if grp ~= nil then
		grp:removeSelf()
		end
		local grp = display.newGroup()
		local speechStop = display.newImage("Graphics/StopTheClock/stoptheclock_xanderspeehbubble.png")

		grp:insert(speechStop)
		
			local playPraise = false
		  local txtBubble

		if (Type == "praise") then
			playPraise = true
			txtBubble = praiseText[variation]
		else
			txtBubble = "Stop die\nhorlosie!"
		end
		
		 local options2 = 
	{
	
		text = txtBubble,     
		x = speechStop.x ,
		y = speechStop.y ,		
		font = teachersPetFont,   
		fontSize = 25,
		align = "center"  -- alignment parameter
	}

	local txtspeech = display.newText(options2)
	txtspeech:setFillColor(1)
	txtspeech.alpha = 0

	grp:insert(txtspeech)
	speechStop.x	= xander5.x + xInset*0.5
	speechStop.y = display.contentHeight/2 + yInset*2	
	speechGroupStop:insert(grp)
	txtspeech.x = speechStop.x
	txtspeech.y = speechStop.y - yInset/5
	

		
	local sX,sY = (txtspeech.contentWidth+ xInset)/speechStop.contentWidth,(txtspeech.contentHeight+ yInset)/speechStop.contentHeight
	speechStop:scale(0,0)
	
		 if playPraise == true then
		-- audio.stop()
		  audio.play(audio.loadSound(praiseSound[variation]))
		 end	
		 
transition.to(speechStop,{time = 500, xScale = sX, yScale =sY})
transition.to(txtspeech,{time = 500, alpha = 1,onComplete = function() timer.performWithDelay(3000,
function()  
	grp:removeSelf()

 end) 
 end})
end

local function swapSheetXSetup(event)
		if(event.phase=="bounce" )then


        elseif (event.phase=="ended" )then
		transition.to(speechGroupSetup,{time = 500, xScale = 0, yScale = 0, alpha = 0})
		end
end

local function swapSheetXStop(event)
		if(event.phase=="bounce" )then


        elseif (event.phase=="ended" )then
		aniPlaying = false
		transition.to(speechGroupStop,{time = 500, alpha = 0})
		end
end

local function play5(Type,variation)
  if aniPlaying == false then
	aniPlaying = true
 xander5:play()
  timer.performWithDelay(2500, function() showSpeechStop(Type,variation)  end)
  end
end

local function getRandomHour()
	hours = math.random(1,12)
return hours
end

local function getRandomMinute()
	minutes  = math.random(1,3)*15
	if (minutes == 60) then
		minutes = 0
	end	
return minutes
end

local function getHourAngle()
	local hourangle 	
	if (HourOrMinute == 1) then
	 hourangle  = hours*30 + minutes*6/12
	else
		hourangle  = Theta_Degrees_H
	end	
return hourangle
end

local function getMinuteAngle()
local minuteangle
	if (HourOrMinute ==2) then
		minuteangle = minutes*6
	else
		minuteangle = Theta_Degrees_M
	end
return minuteangle
end

local function getCurrentMins()
	local curMins = math.floor(getMinuteAngle()/6)
	print("CurrentMins: "..curMins)
return curMins
end

local function getCurrentHours()
	local curHours = math.floor(getHourAngle()/30)
	if (curHours < 1) then
		local temp = curHours 
		curHours = 12 + temp
	end
	print("curHours"..curHours)
return curHours
end


local function ShowTime(h,m)

 txtGroup:remove(txtTime)
 local options2 = 
{
    
    text = "",     
    x = DClock.x,
    y = DClock.y - yInset/4,
    
    font = native.systemFontBold,   
    fontSize = 20,
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
txtTime.text = h..":"..m
txtGroup:insert(txtTime)
end


local function frameUpdate()
   Theta_Degrees_M = Theta_Degrees_M  + ClockSpeed
   Theta_Degrees_H =  Theta_Degrees_H  + ClockSpeed
   if (Theta_Degrees_M >= 360) then
	Theta_Degrees_M = 0
   end
   if (Theta_Degrees_H >= 360) then
	Theta_Degrees_H = 0
   end
   if (GameMode == "Analogue") then
	drawhands(getHourAngle(),getMinuteAngle()) 
   else
	ShowTime(getCurrentHours(),getCurrentMins())
   end
   

end

local clockStoppedCount = 0

local function clockStopped(event)


	math.randomseed( os.time() )

	if  (math.abs(getCurrentMins() - minutes)<= 5) and (math.abs(getCurrentHours() - hours) <= 1) then
		audio.stop({channel = 3})
		clockStoppedCount = clockStoppedCount +1
		if clockStoppedCount < 2 then
	
		ClockSpeed = ClockSpeed + 0.5
		stopBeadCount = stopBeadCount + 1

		if stopBeadCount >= 5 then
			stopBeadCount = 0
			if (beadGroup ~= nil) then
			beadsParent:remove(beadGroup)
			end
			beadGroup = functions.drawbeads(stopBeadCount)
			beadsParent:insert(beadGroup)
			stopStarCount = stopStarCount + 1
			functions.playStarAni(starAnimation,stopStarCount,minutes*6,hours)
			if stopStarCount >= 3 then
				stopStarCount = 0			
			    stopGameComplete = true			
				playPraise = false	
				blockEnd	=  functions.lockScreen()		
				tmrShowerPlay = timer.performWithDelay(2000,function() functions.starShowerPlay("stopClock")end)
			end
			ClockSpeed = 0.5
		end
			local randomlyPraise = math.random(1,6)
			local playSound = true
			if (playPraise) then			
				if (randomlyPraise == 1) then
				--playSound = false
				local rndm = math.random(1,3) 
				tmrPraise = timer.performWithDelay(xanderPraiseDelay,function() play5("praise",rndm) end)
				end
			end
		greenarm = true
		print("HourOrMinute:".. HourOrMinute)
		drawhands(hours*30 + minutes*6/12,minutes*6)
		greenarm = false
		audio.play(correctSound, {onComplete =function() functions.moveBeads(stopBeadCount,playSound,minutes*6,hours)	end	} )	
		Runtime:removeEventListener( "enterFrame", frameUpdate )
		ShowTime(hours,minutes)		
		tmrNextTime = timer.performWithDelay(2000, function() 
		
		audio.play(clockTick,{loops=-1,channel = 3})
		
		

		clockStoppedCount = 0
		clockStopped = false
		HourOrMinute = math.random(1,2)
		Runtime:addEventListener( "enterFrame", frameUpdate )
		if (GameMode == "Analogue") then
			ShowTime(getRandomHour(),getRandomMinute())
		else
		   local  hr = getRandomHour()
		   local mn = getRandomMinute()
		   drawhands(hr*30 + mn*6/12,mn*6) 
		end
		end)
		end

	else
					system.vibrate()
				audio.play(incorrectSound)
	end
end

local function getDeltaTime()
    local temp = system.getTimer()  -- Get current game time in ms
    local dt = (temp-runtime) / (1000/60)  -- 60 fps or 30 fps as base
    runtime = temp  -- Store game time
    return dt
end 





 
function drawhands(H,M)

   if (HandsGroup ~= nil)  then 
	HandsGroup:removeSelf()
   end
    HandsGroup = display.newGroup()
		
		
	local ClockCenter = display.newImage("Graphics/StopTheClock/stoptheclock_centerclock.png")		  
	ClockCenter.x = Aclock.x
	ClockCenter.y = Aclock.y
	ClockCenter:scale(0.55,0.55)
	
	if greenarm == true and  HourOrMinute == 1   then
		 minutehand = display.newImage("Graphics/QuarterHours/quaterhour_greenarm.png")	
	else
	    minutehand = display.newImage("Graphics/StopTheClock/buildtheclock_bluearm@2x.png")	
	end
    minutehand.anchorX = 0.5
    minutehand.anchorY = 0.9		  
	minutehand.x = ClockCenter.x
	minutehand.y = ClockCenter.y 
	OrgX = ClockCenter.x
	OrgY = ClockCenter.y
	minutehand:scale(0.15*display.contentHeight/minutehand.contentHeight,0.15*display.contentHeight/minutehand.contentHeight)
	minutehand:rotate(M)

	
	if greenarm == true and HourOrMinute == 2 then
	hourhand = display.newImage("Graphics/QuarterHours/buildtheclock_greenhrarm.png")
	else
	hourhand = display.newImage("Graphics/StopTheClock/buildtheclock_redarm@2x.png")	
	end
    hourhand.anchorX = 0.5
    hourhand.anchorY = 0.9	
	hourhand:scale(0.12*display.contentHeight/hourhand.contentHeight,0.12*display.contentHeight/hourhand.contentHeight)   	
	hourhand.x = ClockCenter.x
	hourhand.y = ClockCenter.y
	hourhand:rotate(H)


	HandsGroup:insert(minutehand)		
	HandsGroup:insert(hourhand)
	HandsGroup:insert(ClockCenter)
	HandsGroup:toFront()
	DispGroup:insert(HandsGroup)

	return HandsGroup
end 



 local function PlaySetup()
	audio.play(clockTick,{loops=-1,channel = 3})
    ChooseClockGroup.isVisible = false

    Aclock = display.newImage("Graphics/StopTheClock/stoptheclock_clock.png")		
	Aclock.x = display.contentWidth/3.5 
	Aclock.y = display.contentHeight/2 - yInset*3
	Aclock:scale(1.5*AClock.contentWidth/display.contentWidth,1.5*AClock.contentWidth/display.contentWidth)
	
	DispGroup:insert(Aclock)
    drawhands(0,0) 

	
	DClock = display.newImage("Graphics/Hours/hour_analogueclockcorrect.png")
	DClock:scale(0.25*display.contentWidth/DClock.contentWidth,0.25*display.contentWidth/DClock.contentWidth)
	DClock.x = Aclock.x + Aclock.contentWidth + xInset/2
	DClock.y = Aclock.y 
	DispGroup:insert(DClock) 
	DispGroup:insert(txtGroup)
	 local options2 = 
	{
		
		text = "",     
		x = DClock.x,
		y = DClock.y - yInset/4,
		
		font = teachersPetFont,   
		fontSize = 25,
		align = "left"  -- alignment parameter
		}
	

	txtTime = display.newText(options2)
	txtTime:setFillColor(0)
	txtGroup:insert(txtTime)
	DispGroup:insert(txtGroup)
	ShowTime(getRandomHour(),getRandomMinute())
	
	btmPanel = display.newImage("Graphics/StopTheClock/stoptheclock_bottombluebar.png")
	btmPanel:scale(0.955*display.contentWidth/btmPanel.contentWidth,0.955*display.contentWidth/btmPanel.contentWidth)
	btmPanel.x = display.contentWidth/2
	btmPanel.y = display.contentHeight - btmPanel.contentHeight/2 - yInset*0.8
	DispGroup:insert(btmPanel)
	
	btnStop = display.newSprite(sheetstop0,sequencestop1)
	btnStop:scale(0.8*btmPanel.contentHeight/btnStop.contentHeight,0.8*btmPanel.contentHeight/btnStop.contentHeight)
	btnStop.x = display.contentWidth/2
	btnStop.y = btmPanel.y
	
	beadGroup = functions.drawbeads(stopBeadCount)
	beadsParent:insert(beadGroup)
	
	starAnimation = functions.starsCount()
	functions.playStarAni(starAnimation,stopStarCount)
	
	DispGroup:insert(starAnimation)
	DispGroup:insert(beadsParent)

	btnStop:addEventListener("tap", clockStopped)
	DispGroup:insert(btnStop)
		
	Runtime:addEventListener( "enterFrame", frameUpdate )
	if (GameMode == "Digital") then
   local  hr = getRandomHour()
   local mn = getRandomMinute()
   drawhands(hr*30 + mn*6/12,mn*6) 
   end

 xander5.anchorY = 1  
 xander5.anchorX = 0
 
 DispGroup:insert(xander5)
 
 xander5:scale(0.0035*display.contentHeight/xander5.contentHeight,0.0035*display.contentHeight/xander5.contentHeight)
 xander5.y = display.contentHeight
 xander5.x = xInset*2
 xander5:addEventListener("sprite", swapSheetXStop)

 play5("any",0)
   
	end
 
 


local function ChoseDigital(event)
AClock .fill.effect = "filter.grayscale"
DClock.fill.effect = ""
GameMode = "Digital"	
end

local function ChoseAnalogue(event)
DClock .fill.effect = "filter.grayscale"
AClock.fill.effect = ""
GameMode = "Analogue"
end

local function setupGame(event)

end 
 

local function ChooseClockSetup()

if (AClock ~= nil) then
ChooseClockGroup:remove(AClock)
end

if (DClock ~= nil) then
ChooseClockGroup:remove(DClock)
end

if (btnBegin ~= nil) then
ChooseClockGroup:remove(btnBegin)
end

if (txtBegin ~= nil) then
ChooseClockGroup:remove(txtBegin)
end

if (speech ~= nil) then
ChooseClockGroup:remove(speech)
end

if (Xander  ~= nil) then
ChooseClockGroup:remove(speech)
end

if (txtspeech ~= nil) then
ChooseClockGroup:remove(txtspeech )
end


	  
DClock = display.newImage("Graphics/StopTheClock/stoptheclock_analogueclockselected.png")		
AClock = display.newImage("Graphics/StopTheClock/stoptheclock_clockselected.png")	

DClock.fill.effect = "filter.grayscale"	  
	  
AClock.x = display.contentWidth/3
AClock.y = display.contentHeight/2
AClock:scale(0.5*display.contentHeight/AClock.contentHeight,0.5*display.contentHeight/AClock.contentHeight)
ChooseClockGroup:insert(AClock)

DClock:scale(0.25*display.contentHeight/DClock.contentHeight,0.25*display.contentHeight/DClock.contentHeight)
DClock.x = AClock.x + AClock.contentWidth + xInset/2
DClock.y = display.contentHeight/2
ChooseClockGroup:insert(DClock)

	AClock:addEventListener( "tap", ChoseAnalogue)
    DClock:addEventListener( "tap", ChoseDigital)

local btnBegin = display.newImage("Graphics/StopTheClock/stoptheclock_beginbutton.png")
btnBegin.x = display.contentWidth/2
btnBegin.y = display.contentHeight/1.2
btnBegin:scale(0.3*display.contentWidth/btnBegin.contentWidth,0.3*display.contentWidth/btnBegin.contentWidth)
ChooseClockGroup:insert(btnBegin)

btnBegin:addEventListener("tap", function()

			ChooseClockGroup.alpha = 0
			PlaySetup()
			stopGameComplete = false 
end )

 local options = 
	{	
		text = "BEGIN",     
		x = btnBegin.x,
		y = btnBegin.y,		
		font = teachersPetFont,   
		fontSize = 25,
		align = "left"  -- alignment parameter
	}

	local txtBegin = display.newText(options)
	txtBegin:setFillColor(1)

ChooseClockGroup:insert(txtBegin)
	
XanderSetup.anchorY = 0
XanderSetup.x = display.contentWidth/1.5
XanderSetup.y = 0
XanderSetup:scale(0.005*display.contentHeight/XanderSetup.contentHeight,0.005*display.contentHeight/XanderSetup.contentHeight)
ChooseClockGroup:insert(XanderSetup)
	
timer.performWithDelay(500,function() XanderSetup:play() timer.performWithDelay(1000, function() showSpeechSetup() end) end )
XanderSetup:addEventListener("sprite",swapSheetXSetup)
end




function scene:create( event )
    local sceneGroup = self.view
	local phase = event.phase
	audio.stop()
	gotoHomeCnt = 0
	gameEntered = true
 	sceneGroup:insert(functions.setBackground())
	

XanderSetup = display.newSprite( sheetxanderthinkingtop0, sequencetxanderthinkingtop1 )
xander5 = display.newSprite(sheetxander5bottom0,sequencexander5bottom1)

	functions.removeSceneName = "stopClock"

	sceneGroup:insert(ChooseClockGroup)

	sceneGroup:insert(beadsParent)
	sceneGroup:insert(DispGroup)
	sceneGroup:insert(speechGroupStop)
	--sceneGroup:insert(setupMusicIcon())


	
end



function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
	
	
    if phase == "will" then
	ChooseClockSetup()		
    elseif phase == "did" then
	audio.stop()
  
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
		Runtime:removeEventListener( "enterFrame", frameUpdate )
		if (tmrNextTime ~= nil) then
		timer.cancel(tmrNextTime)
		end
		audio.stop({channel = 3})
	if tmrShowerPlay~= nil then
	timer.cancel(tmrShowerPlay)
	end
	if blockEnd ~= nil then
	blockEnd:removeSelf()
	end

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene