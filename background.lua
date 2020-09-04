local composer = require( "composer" )
local scene = composer.newScene( sceneName )
local functions = require ("functions")

if system.getInfo( "platformName" ) == "Win" then
	teachersPetFont = "TeachersPet"
else
	teachersPetFont = "tp.ttf"
end



local timeCountFull = 0
local timeCountHalf = 0
local dayMode
local DayTrack = 0
local r 
local backGroupParent = display.newGroup()
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

local backGroup = display.newGroup()
local rect


local function starInit()
end


local function drawBackground(timeCountFull)
if backGroup ~= nil then
backGroupParent:remove(backGroup)
backGroup:removeSelf()
end

backGroup = display.newGroup()


	--timeCountHalf = timeCountHalf +1
	
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
timeCountHalf = 360 + timeCountFull
elseif (timeCountFull >= 360 and timeCountFull < 1080) then
timeCountHalf = timeCountFull - 360
elseif (timeCountFull >= 1080 and timeCountFull < 1440) then
timeCountHalf = timeCountFull - 1080
end
 
 

 
 --cHue1 = 125 + 36/360*DayTrack
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
   cHue1 = 165 - 35/360*DayTrack
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
 backGroup:insert(starGroup)

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
 
 
print("StarIndex: "..starIndex)
 if dayMode ~= "Day" then
 
 
 end
 
 
if (dayMode == "Day") then	
SomethingInTheAir = display.newImage("Graphics/Background/sun-sunlight@2x.png")
SomethingInTheAir:scale(0.3*(1 - DayTrack/2/360  )*display.contentWidth/SomethingInTheAir.contentWidth,0.3*(1-DayTrack/2/360 )*display.contentWidth/SomethingInTheAir.contentWidth)
--r = SomethingInTheAir.contentWidth/2
else
SomethingInTheAir = display.newImage("Graphics/Background/night-moon@2x.png")
SomethingInTheAir:scale(0.2*( DayTrack/3/360 + 1  )*display.contentWidth/SomethingInTheAir.contentWidth,0.2*(DayTrack/3/360 + 1 )*display.contentWidth/SomethingInTheAir.contentWidth)
--r = SomethingInTheAir.contentWidth/2
end



r = SomethingInTheAir.contentWidth/2

local y 
if ( string.sub(system.getInfo( "model" ), 1, 4 ) == "iPad") then
y =  display.contentHeight*0.8- math.sqrt((display.contentHeight*0.7)^2 - (timeCountHalf - display.contentWidth/2)^2) 
else
y =  display.contentHeight*1.15- math.sqrt((display.contentHeight)^2 - (timeCountHalf - display.contentWidth/2)^2) 
end
SomethingInTheAir.x = display.contentWidth/720*timeCountHalf
SomethingInTheAir.y = y

	frontCloud  = display.newImage("Graphics/Background/sun-whitefront@2x.png")
	--frontCloud.alpha = 0
	frontCloud:scale(display.contentWidth/frontCloud.contentWidth,0.5)
	frontCloud.anchorY = 1
	frontCloud.y = display.contentHeight
	frontCloud.x = display.contentWidth/2
backGroup:insert(SomethingInTheAir)
backGroup:insert(frontCloud)

backGroupParent:insert(backGroup)
	


	print(DayTrack)
end

local back = display.newGroup()
local function frameUpdate(event)
	if (back ~= nil) then
		backGroup:remove(back)
		back:removeSelf()
	end

	timeCountFull = timeCountFull + 2
	back = functions.drawBackground(timeCountFull)
		if timeCountFull == 1440 then
		timeCountFull = 0
	end
	backGroupParent:insert(back)

end

function scene:create( event )
    local sceneGroup = self.view
	local phase = event.phase


	math.randomseed( os.time() )
	--sceneGroup:insert(frontCloud)
	sceneGroup:insert(backGroupParent)
	cntOverFlow = 180
	
	


end



function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
	
    if phase == "will" then

		
    elseif phase == "did" then
			Runtime:addEventListener( "enterFrame", frameUpdate )
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
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene