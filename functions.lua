local composer = require( "composer" )
local scene = composer.newScene( sceneName )
local functions={}
local bPlayMusic = true

--[[
Function Name: 	hasCollided()
Description: 	A function that detects when two objects have crossed outer boundaries 
				ie. has collided
Parameters:		The two objects that need to be tested for collision.
Return Value:	Boolean of collision detection.
Notes:			-
]]

function functions.hasCollided( obj1, obj2 )
	 if ( obj1 == nil ) then  -- Make sure the first object exists
        return false
    end
    if ( obj2 == nil ) then  -- Make sure the other object exists
        return false
    end
 
    local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
 
    return (left or right) and (up or down)
end

function functions.hasCollidedCircle( obj1, obj2 )
    if ( obj1 == nil ) then  -- Make sure the first object exists
       print("obj1 is nil")
	   return false
    end
    if ( obj2 == nil ) then  -- Make sure the other object exists
        print("obj2 is nil")
		return false
    end
	
    local dx = obj1.x - obj2.x
    local dy = obj1.y - obj2.y
 
    local distance = math.sqrt( dx*dx + dy*dy )
	print("distance: ".. distance)
    local objectSize = 40
 
    if ( distance < objectSize ) then
        return true
    end
    return false
end

--[[
Function Name: 	lockScreen()
Description: 	A function that creates a transparant recangle over the device screen
				used for blocking any interaction with the UI. Can be used after the
				completion of a game to remove the funtionality of event listeners.
Parameters:		None
Return Value:	rect. It is the display object, the transparant rectangle.
Notes:			Remember to move objects, for example the home buttom,to the front if
				the functionality is still required
]]

function functions.lockScreen()
	-- Creates rectangle over entire screen
	local rect = display.newRect(display.contentWidth/1.8,display.contentHeight/2,display.contentWidth- xInset*2.5,display.contentHeight - yInset)
	--Make rectangle transarant
	rect.alpha = 0
	--Allows an object to continue to receive hit events even if it is not visible
	rect.isHitTestable = true
	--catches any tap or touches on screen
	local function block(event)
		return true
	end
	rect:addEventListener("tap",block)
	rect:addEventListener("touch",block)
	return rect
end

function functions.shuffleTable( t )
    local rand = math.random
    assert( t, "shuffleTable() expected a table, got nil" )
    local iterations = #t
    local j

    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------PROJECT SPECIFIC FUNCTIONS-----------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------XANDER TIME--------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------
local timeCountFull = 0
local timeCountHalf = 0
local dayMode
local DayTrack = 0
local r 
local SomethingInTheAir 
local rectBack
local frontCloud
local starNames = {"star1.png","star2.png","star3.png","star4.png","star5.png"}
local stars
local maxStars
local AppearProbability
local cntOverFlow = 0
local starIndex = 1
local starPlaceMode
local starGroup = display.newGroup()
local starSheet

local cloudCount = 1 
local clouds = {}
local cloudGroup = display.newGroup()
local chooseCloudType
local genProbability
local scaleBy
local transitionTime
local toAlpha


local cHue1
local cSat1
local cBrightness1
local cHue2
local cSat2
local cBrightness2
local cAlpha2

local paint


function rgbToHsv(r, g, b, a)
  r, g, b, a = r / 255, g / 255, b / 255, a / 255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, v
  v = max

  local d = max - min
  if max == 0 then s = 0 else s = d / max end

  if max == min then
    h = 0 -- achromatic
  else
    if max == r then
    h = (g - b) / d
    if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, v, a
end

function hsvToRgb(h, s, v, a)
  local r, g, b
  h = h/255
  s = s/255
  v = v/255
  a = a/255
  local i = math.floor(h * 6);
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end

  return r , g , b , a 
end

local backGroup
local rect
local xOffset = 0

local cloudGroup = display.newGroup()

function functions.insertCloud()

	if cloudCount == 1 then
	genProbability = math.random(1,50)
	else
	genProbability = math.random(1,1500)
	end
	if genProbability == 1 then

		if cloudCount < 5 then
			local cloud
			chooseCloudType = math.random(1,2)
			if chooseCloudType == 1 then
				cloud = display.newImage("Graphics/Background/night-opacitycloud@2x.png")
			elseif chooseCloudType == 2 then
				cloud = display.newImage("Graphics/Background/night-whitebackcloud@2x.png")
			end		
			cloudGroup:insert(cloud)
			 local cX,cY = -cloud.contentWidth/2, math.random(cloud.contentHeight/2,display.contentHeight/2 - cloud.contentHeight/2)
			cloud.x = cX
			cloud.y = cY
			scaleBy = math.random(10,90)/100
			cloud:scale(scaleBy,scaleBy)
			scaleBy = math.random(0,120)/100
			toAlpha = math.random(0,100)/100
			transitionTime = math.random(20000,120000)
			 cloudCount = cloudCount + 1
			 transition.to(cloud,{time = transitionTime, x= display.contentWidth + xInset*2,alpha = toAlpha,xScale = scaleBy, yScale = scaleBy,onComplete =
				function() 
				if cloudCount > 0 then
					cloudCount = cloudCount - 1 
				end
				if cloud ~= nil then
				cloud:removeSelf()
				end					
				end})
		end
	end
end

function functions.destroyClouds()
	 transition.cancel()
	 cloudGroup:remove(1)
	 cloudGroup:remove(2)
	 cloudCount = 1
end

local musicIconGroup = display.newGroup()
local musicIconOff
local musicIconOn
function functions.toggleMusic(event)

if bPlayMusic == true then
musicIconOff.alpha = 0
musicIconOff.alpha = 1
--musicIcon:addEventListener("tap", functions.toggleMusic )
audio.setVolume( 0, { channel=1 } )
bPlayMusic = false
else
musicIconOff.alpha = 1
musicIconOff.alpha = 0
--musicIcon:addEventListener("tap", functions.toggleMusic)
audio.setVolume( 0.3, { channel=1 } )
bPlayMusic = true
end
end

function functions.setupMusicIcon()
musicIconOn = display.newImage("Graphics/Music_on.png")
musicIconOff = display.newImage("Graphics/Music_off.png")
musicIconGroup:insert(musicIconOn)
musicIconGroup:insert(musicIconOff)
musicIconOff.alpha = 0
musicIconOn:addEventListener("tap",  functions.toggleMusic)
return musicIconGroup
end

function functions.drawBackground(timeCountFull)

starSheet =  display.newImage("Graphics/Background/night-stars@2x.png")
starSheet:scale(display.contentWidth/starSheet.contentWidth,display.contentWidth/starSheet.contentWidth)
backGroup = display.newGroup()

if (timeCountFull >= 360 and timeCountFull <= 1080) then
dayMode = "Day"
else
dayMode = "Night"
end

if (timeCountFull >= 0 and timeCountFull < 360) then
	DayTrack = 360 - timeCountFull
elseif (timeCountFull >= 360 and timeCountFull < 720) then
DayTrack = timeCountFull - 360
elseif (timeCountFull >= 720 and timeCountFull < 1080) then
	DayTrack = 1080 - timeCountFull
elseif (timeCountFull >= 1080 and timeCountFull < 1440) then
	DayTrack = timeCountFull - 1080
end

if (timeCountFull >= 0 and timeCountFull < 360) then
	timeCountHalf = 360 + timeCountFull + xOffset
elseif (timeCountFull >= 360 and timeCountFull < 1080) then
	timeCountHalf = timeCountFull - 360 - xOffset
elseif (timeCountFull >= 1080 and timeCountFull < 1440) then
	timeCountHalf = timeCountFull - 1080 - xOffset
end
 
rectBack = display.newRect( display.contentWidth/2,display.contentHeight/3,display.contentWidth, display.contentHeight/4*3  )
rectBack:setFillColor( hsvToRgb(21, 179, 252, 255) )

 if dayMode == "Night" then
	  cHue1 = 155
	  cSat1 = 150
	  cBrightness1 = 155 - 155/360*DayTrack
	  cHue2 = 130 + 30/360*DayTrack
	  cSat2 = 180
	  cBrightness2 = 105 - 80/360*DayTrack
	  cAlpha2 = 255 - 255/50*(50-DayTrack)
 else
	   cHue1 = 175 - 35/360*DayTrack
	  cSat1 = 180
	  cBrightness1 = 200--155 - 155/360*DayTrack
	  cHue2 = 130 --+ 30/360*DayTrack
	  cSat2 = 180
	  cBrightness2 = 200--105 - 80/360*DayTrack
  if DayTrack < 180 then
	cAlpha2 = 255 - 255/180*(180-DayTrack)
  else
	cAlpha2 = 255
  end
 end

  paint = {
    type = "gradient",
    color1 = { hsvToRgb(cHue1, cSat1, cBrightness1, 255)},
    color2 = {hsvToRgb(cHue2, cSat2, cBrightness2, cAlpha2)},
    direction = "down"
}


 rect = display.newRect( display.contentWidth/2,display.contentHeight/3,display.contentWidth, display.contentHeight/4*3 )
rect.fill = paint	

backGroup:insert(rectBack)
 backGroup:insert(rect)
cntOverFlow = cntOverFlow + 1

if starIndex == 180 then
starPlaceMode = "Decrease"
elseif starIndex == 1 then
starPlaceMode = "Increase"
end

if cntOverFlow == 2 then
		cntOverFlow = 0
	if starPlaceMode == "Increase" then
		starIndex = starIndex + 1
	elseif  starPlaceMode == "Decrease" then
		starIndex = starIndex -1
	end
end
 
if (dayMode == "Day") then	
	SomethingInTheAir = display.newImage("Graphics/Background/sun-sunlight@2x.png")
	SomethingInTheAir:scale(0.3*(1 - DayTrack/2/360  )*display.contentWidth/SomethingInTheAir.contentWidth,0.3*(1-DayTrack/2/360 )*display.contentWidth/SomethingInTheAir.contentWidth)
	starSheet.alpha = 0
else
	SomethingInTheAir = display.newImage("Graphics/Background/night-moon@2x.png")
	SomethingInTheAir:scale(0.2*( DayTrack/3/360 + 1  )*display.contentWidth/SomethingInTheAir.contentWidth,0.2*(DayTrack/3/360 + 1 )*display.contentWidth/SomethingInTheAir.contentWidth)
	starSheet.alpha = 1 -  (360 - DayTrack)/360 
end


starSheet.x  = display.contentWidth/2
starSheet.y = display.contentHeight/3

r = SomethingInTheAir.contentWidth/2

local y 
local cloudAdjust
if ( string.sub(system.getInfo( "model" ), 1, 4 ) == "iPad") then
--(x-h)^2 + (y-k)^2 = r
--                    k                                                           r                                            x                                h
	y =  display.contentHeight*0.8- math.sqrt((display.contentHeight*0.7)^2 - (timeCountHalf - display.contentWidth/2)^2) 
	cloudAdjust = 0
else
	y =  display.contentHeight*1.2- math.sqrt((display.contentHeight*1.1)^2 - (display.contentWidth/(720+xOffset)*timeCountHalf - display.contentWidth/2)^2) 
	cloudAdjust = yInset*2.9
end
SomethingInTheAir.x = display.contentWidth/720*timeCountHalf
SomethingInTheAir.y = y

	frontCloud  = display.newImage("Graphics/Background/sun-whitefront@2x.png")
	frontCloud:scale(display.contentWidth/frontCloud.contentWidth,0.55)
	frontCloud.anchorY = 1
	frontCloud.y = display.contentHeight + cloudAdjust
	frontCloud.x = display.contentWidth/2
	backGroup:insert(starSheet)
	backGroup:insert(SomethingInTheAir)
	backGroup:insert(frontCloud)

return backGroup

end

------------------------------------------------------------------------------------


functions.removeSceneName = ""
 function functions.gotoHome(event)

	 if event.phase == "began" then
	  gotoHomeCnt = gotoHomeCnt + 1
	    print("HelOooooooO")
		--transition image to shrink with a small delay then gotoScene	
		gameExit = true
		audio.stop()
		if tmrPraise ~= nil then
			timer.cancel(tmrPraise)
		end
		if gotoHomeCnt <= 1 then
		timer.performWithDelay(150, 
		function() 
			gotoHomeCnt = 0
			composer.removeScene(functions.removeSceneName)
			composer.gotoScene("menu", "fade", 200)
		end)
		print(functions.removeSceneName)
			end
		return true
	end
end
 

function functions.getTimeH(HourDegrees)
	local Hours = math.modf(math.abs(HourDegrees /30))
	if Hours == 0 then
		Hours= 0
	end
return Hours
end

function functions.getTimeM(HourDegrees)
	local Minutes = HourDegrees %30
	Minutes = math.floor(Minutes*12/360*60)
return Minutes
end

function functions.getHourAngle(Theta_Degrees_H)
return Theta_Degrees_H
end

function functions.getMinuteAngle(Theta_Degrees_H)
	local Minutes = Theta_Degrees_H %30
	Minutes = math.floor(Minutes*12)
return Minutes
end

function functions.getRotationDirection(V1x,V1y,V2x,V2y)
	local Turn_Switch_Point = 20
	local Rotation_Direction = 1
	if (V2x >= Turn_Switch_Point) or (V2x <= -Turn_Switch_Point) then 		
		if (V2x > 0 ) and (V2y < V1y)			
		or (V2x <= 0) and (V2y >= V1y)	  
		then
			Rotation_Direction = 1
		else
			Rotation_Direction = -1
		end
	elseif (V2y >= Turn_Switch_Point) or (V2y <= -Turn_Switch_Point) then 			
		if (V2y > 0 ) and (V2x > V1x)			
		or (V2y <= 0) and (V2x <= V1x)		 
		then
			Rotation_Direction = 1
		else
			Rotation_Direction = -1
		end
	end
return Rotation_Direction 
end

function functions.getAngleChange(V1x,V1y,V2x,V2y)
	local dTheta 
		if (V1x ~= nil and V1y ~= nil and V2x ~= nil and V2y ~= nil) then
			dTheta = math.acos((V1x*V2x + V1y*V2y)/(math.sqrt(V1x^2 +V1y^2)*math.sqrt(V2x^2 +V2y^2)))

			if ( not (dTheta > 0 and dTheta < math.pi) ) then
				dTheta = 0.001*functions.getRotationDirection(V1x,V1y,V2x,V2y)
			end
		return dTheta
		end
	return 0
end


function functions.turnSign(Ang, pos)
	if (( pos - Ang) > 0) then
		return 1
	else
		return -1
end

end


function functions.setBackground()

    local DispGroup = display.newGroup()	
	local backRect = display.newRect(display.contentWidth/2,display.contentHeight/2,display.contentWidth,display.contentHeight)
	backRect:setFillColor(1)	
	local background = display.newImage("Graphics/BuildTheClock/tracingpaper_background.png")		
	background.x = display.contentWidth/2
	background.y = display.contentHeight/2
	--Use ratio between screen contentwidth and background image to scale background
	background:scale(display.contentWidth/background.contentWidth,display.contentHeight/background.contentHeight)
	
	local boarder = display.newImage("Graphics/BuildTheClock/boarder.png")
	boarder.x = display.contentWidth/2
	boarder.y = display.contentHeight/2
	boarder:scale((display.contentWidth - xInset/2)/boarder.contentWidth,(display.contentHeight- xInset/2)/boarder.contentHeight)
	
	
	local btnHome = display.newImage("Graphics/BuildTheClock/homebutton.png")
	btnHome:scale(display.contentHeight/btnHome.contentHeight*0.15,display.contentHeight/btnHome.contentHeight*0.15)
	btnHome.x = boarder.x - boarder.contentWidth/2 + btnHome.contentWidth/2 - 1
	btnHome.y = boarder.y - boarder.contentHeight/2 + btnHome.contentWidth/2 -1
	
	btnHome:addEventListener( "touch", functions.gotoHome )
	DispGroup:insert(backRect)

	DispGroup:insert(background)
	DispGroup:insert(btnHome)
	DispGroup:insert(boarder)

	return DispGroup
		
end

local beadnames = {"purplebeads.png","orangebeads.png","greenbeads.png","yellowbeads.png","bluebeads.png"}
local beads = {}
local beadAdjust 
local beadSpace
local beadCounter
if ( string.sub(system.getInfo( "model" ), 1, 4 ) == "iPad") then
beadAdjust = 8
beadSpace = 13
else
beadAdjust = 0
beadSpace = 18
end	  

local beadShiftSound = audio.loadSound("Audio/beadshift.mp3")

function functions.playNumSound(tag,bPlayUur)
tag = 12 - tag
if (tag == 0) then
tag = 12
end
print("Audio tag"..tag)
local audioPlay = audio.loadSound( "Audio/"..numSound[tag] )
local audioUur = audio.loadSound( "Audio/Uur.mp3")
local options =
{
 
	onComplete = 
	function()
	if bPlayUur == true then
	audio.play(audioUur)
	end
	end

}
audio.play(audioPlay,options)
end

function functions.playTimeSound(angleMinute, hour)
local angelMin =  angleMinute
local hourSound = hour

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

function functions.moveBeads(fmatchCount,doPlay,angleMinute,hour)
    if (fmatchCount > 0) then
		audio.play(beadShiftSound,{onComplete = function() if doPlay == true then functions.playTimeSound(angleMinute, hour) end end })
		transition.to( beads[fmatchCount], { time=400, y= beads[fmatchCount].y -beadCounter.contentHeight/4.5 } )
	end
end

function functions.drawbeads(fmatchCount)
    	
	if (beadGroup~= nil) then
		beadGroup:removeSelf()
		beads:removeSelf()
	end
	
    local beadGroup = display.newGroup()    
	beadCounter = display.newImage("Graphics/StopTheClock/counterwihtoutbeads.png")
	beadCounter:scale(0.35*display.contentHeight/beadCounter.contentHeight,0.35*display.contentHeight/beadCounter.contentHeight)
	beadCounter.anchorY = 1
	beadCounter.x = display.contentWidth - beadCounter.contentWidth/2 - xInset/3
	beadCounter.y = display.contentHeight/1.5
	beadGroup:insert(beadCounter)
	
	for i = #beadnames,1,-1 do
		beads[i] = display.newImage("Graphics/StopTheClock/"..beadnames[i])
		beadGroup:insert(beads[i])	
		beadGroup.i = beads[i]
		beads[i]:scale(0.13*beadCounter.contentHeight/beads[i].contentHeight,0.13*beadCounter.contentHeight/beads[i].contentHeight)
		beads[i].x = beadCounter.x - xInset/12
		beads[i].y = beadCounter.y - beadCounter.contentHeight/6  - (beads[i].contentHeight - beads[i].contentHeight/9)*(#beadnames-i) 
	end
	
	if (fmatchCount > 0) then
		for j = 1,fmatchCount,1 do
			functions.moveBeads(j,false)
		end
	end
	beadGroup:toFront()
	return beadGroup
end



function functions.resetBeads()
	for i = #beadnames,1,-1 do
		beads[i].y = beadCounter.y - beadCounter.contentHeight/6  - (beads[i].contentHeight - beads[i].contentHeight/9)*(#beadnames-i) 
	end
end


function functions.starsCount()

local sheetInfo0 = require("sheets.stars-0")
local sheet0 = graphics.newImageSheet( "img/stars-0.png" ,sheetInfo0:getSheet())
local sequenceData = {
                { name="stars1", sheet=sheet0, start=1, count=25, time=1500, loopCount=1 },
				  { name="stars2", sheet=sheet0, start=25, count=50, time=1500, loopCount=1 },
				    { name="stars3", sheet=sheet0, start=51, count=125, time=1500, loopCount=1 }
                }
				
local myAnimation = display.newSprite( sheet0, sequenceData )
myAnimation:scale(0.2*display.contentWidth/myAnimation.contentWidth,0.2*display.contentWidth/myAnimation.contentWidth)
myAnimation.x = display.contentWidth- myAnimation.contentWidth/2 - xInset  ; myAnimation.y = myAnimation.contentHeight/2 + yInset
return myAnimation
end

local correctStarSound = audio.loadSound("Audio/starCorrect.mp3")

function functions.playStarAni(Ani,fstarCount,angleMinute,hour)
if (fstarCount > 0) then

		audio.play(correctStarSound, {onComplete =  function() if hour ~= nil then  functions.playTimeSound(angleMinute, hour)	 end end})
		Ani:setSequence( "stars"..fstarCount)
		Ani:play()
end
end

local count = 1
local sceneToRemove
local starShower
function functions.swapSheet(event)
		if(event.phase=="ended" and count<9)then
        	starShower:setSequence( "fall"..count )
        	starShower:play()
        	count = count + 1
			if (count == 7) then
			composer.removeScene(sceneToRemove)
			 composer.gotoScene("menu")
			end
			if (count == 8) then
			starShower:removeSelf()
			count = 1
			end
        end
end


function functions.starShowerLoad()

local sheetInfo0 = require("sheets.falling-0")
local sheetInfo1 = require("sheets.falling-1")
local sheetInfo2 = require("sheets.falling-2")
local sheetInfo3 = require("sheets.falling-3")
local sheetInfo4 = require("sheets.falling-4")
local sheetInfo5 = require("sheets.falling-5")
local sheetInfo6 = require("sheets.falling-6")
local sheetInfo7 = require("sheets.falling-7")
local sheetInfo8 = require("sheets.falling-8")

local sheet0 = graphics.newImageSheet( "img/falling-0.png" ,sheetInfo0:getSheet())
local sheet1 = graphics.newImageSheet( "img/falling-1.png" ,sheetInfo1:getSheet())
local sheet2 = graphics.newImageSheet( "img/falling-2.png" ,sheetInfo2:getSheet())
local sheet3 = graphics.newImageSheet( "img/falling-3.png" ,sheetInfo3:getSheet())
local sheet4 = graphics.newImageSheet( "img/falling-4.png" ,sheetInfo4:getSheet())
local sheet5 = graphics.newImageSheet( "img/falling-5.png" ,sheetInfo5:getSheet())
local sheet6 = graphics.newImageSheet( "img/falling-6.png" ,sheetInfo6:getSheet())
local sheet7 = graphics.newImageSheet( "img/falling-7.png" ,sheetInfo7:getSheet())
local sheet8 = graphics.newImageSheet( "img/falling-8.png" ,sheetInfo8:getSheet())

local sequenceData = {
				{ name="fall0", sheet=sheet0, start=1, count=16, time=600, loopCount=1 },
                { name="fall1", sheet=sheet1, start=1, count=8, time=300, loopCount=1},
				{ name="fall2", sheet=sheet2, start=1, count=8, time=300, loopCount=1 },
                { name="fall3", sheet=sheet3, start=1, count=8, time=300, loopCount=1},
				{ name="fall4", sheet=sheet4, start=1, count=8, time=300, loopCount=1 },
                { name="fall5", sheet=sheet5, start=1, count=8, time=300, loopCount=1},
				{ name="fall6", sheet=sheet6, start=1, count=8, time=300, loopCount=1 },
                { name="fall7", sheet=sheet7, start=1, count=8, time=300, loopCount=1},
				{ name="fall8", sheet=sheet8, start=1, count=3, time=100, loopCount=1 }				
                }
				
starShower = display.newSprite( sheet0, sequenceData )
starShower.x = display.contentWidth/2 ; starShower.y = display.contentHeight/2


return starShower
end
local starShowerSound = audio.loadSound("Audio/starShowerSound.mp3")

function functions.starShowerPlay(SceneName)
audio.play(starShowerSound)
hoursBeadCount = 0
hoursStarCount = 0
buildBeadCount = 0
buildStarCount = 0
matchBeadCount = 0
matchStarCount = 0
hoursBeadCount = 0
hoursStarCount = 0
halfHourBeadCount = 0
quarterHoursBeadCount  = 0
stopBeadCount = 0
stopGameComplete = false

starShower = Animation
sceneToRemove = SceneName



local emitterParams = {
    startColorAlpha = 1,
    startParticleSizeVariance = 50,
   startColorGreen =1,
    startColorRed = 1,
	startColorBlue = 1,
	finishColorBlue = 1,
   finishColorGreen = 1,
    finishColorRed = 1,
    yCoordFlipped = -1,
   blendFuncSource = 770,
    rotatePerSecondVariance = 153.95,
    particleLifespan = 10,
    tangentialAcceleration = -250,
	
    blendFuncDestination =1,
    startParticleSize = 1,
  
    textureFileName = "Graphics/Background/emitterStar.png",
    startColorVarianceAlpha =0,
    maxParticles = 1500,
    finishParticleSize = 25,
    duration = 2.5,
   
    maxRadiusVariance = 72.63,
    finishParticleSizeVariance = 50,
    gravityx = -130,
	gravityy = 220,
    speedVariance = 100,
    tangentialAccelVariance = 180,
    angleVariance = 360,
    angle = 135
}

local emitterParams2 = {
    startColorAlpha = 0.3,
	finishColorVarianceAlpha = 0.8,
	startColorVarianceAlpha = 0.8,
	finishColorAlpha = 1,
    startParticleSizeVariance = 50,
   startColorGreen =1,
    startColorRed = 1,
	startColorBlue = 1,
	finishColorBlue = 1,
   finishColorGreen = 1,
    finishColorRed = 1,
    yCoordFlipped = -1,
   blendFuncSource = 1,
    rotatePerSecondVariance = 153.95,
    particleLifespan = 10,
    tangentialAcceleration = 250,
	
    blendFuncSource = 770,
    blendFuncDestination =771,
    startParticleSize = 1,
  
    textureFileName = "Graphics/Background/emitterStar.png",
    
    maxParticles = 5000,
    finishParticleSize = 25,
    duration = 2.5,
   
    maxRadiusVariance = 72.63,
    finishParticleSizeVariance = 50,
    gravityx = -130,
	gravityy = 220,
    speedVariance = 100,
    tangentialAccelVariance = 180,
    angleVariance = 360,
    angle = 135
}

local emitter1 = display.newEmitter( emitterParams )
 emitter1.x = display.contentWidth - xInset*2
 emitter1.y = yInset*2
 
 local emitter2 = display.newEmitter( emitterParams2 )
 emitter2.x = display.contentWidth - xInset*2
 emitter2.y = yInset*2
 
 timer.performWithDelay(2500, function() 
 composer.removeScene(sceneToRemove)
 composer.gotoScene("menu")
 timer.performWithDelay(1500, 
 function() 
		transition.to(emitter1,{time = 500, alpha = 0, onComplete = 
			 function()
				emitter1:removeSelf()
			 end})
				transition.to(emitter2,{time = 500, alpha = 0, onComplete = 
			 function()
				emitter2:removeSelf()
			 end})
		 end )
 end)
 
end

return functions