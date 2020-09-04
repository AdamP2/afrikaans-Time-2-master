-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
--BUGS
--Music image off then on other scene on 
-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"
local functions = require ("functions")
xInset = display.contentWidth/20
yInset = display.contentHeight/20
-- load menu screen
hoursBeadCount = 0
hoursStarCount = 0
buildBeadCount = 0
buildStarCount = 0
matchBeadCount = 0
matchStarCount = 0
hoursBeadCount = 0
hoursStarCount = 0
halfHourBeadCount = 0
halfHourStarCount = 0
quarterHoursStarCount = 0
quarterHoursBeadCount  = 0
stopBeadCount = 0
stopStarCount = 0
stopGameComplete = true
gameExit = false
qtrGameComplete = true
halfHourGameComplete = true
gameExit = false
gameEntered = false
gameComplete = false

xanderPraiseDelay = 800
tmrPraise = nil

if ( string.sub(system.getInfo( "model" ), 1, 4 ) == "iPad") then
scaleAdjust = 1.2
else
scaleAdjust = 1
end	  

praiseText = {"Puik.","Fantasties.","Baie mooi."}
praiseSound = {"Audio/puik.mp3","Audio/fantasties.mp3","Audio/baie_mooi.mp3"}
mnuSpeechtextInit = "Hello! Kom ons leer hoe\nom tyd te lees. Kies\n'n speletjie."
mnuSpeechtextAfter = "Kies 'n speletjie."



audio.reserveChannels( 1 )
audio.setVolume( 0.3, { channel=1 } )


audio.setVolume( 0.3)

numSound = {"Een.mp3","Twee.mp3","Drie.mp3","Vier.mp3","Vyf.mp3","Ses.mp3","Sewe.mp3","Agt.mp3","Nege.mp3","Tien.mp3","Elf.mp3","Twaalf.mp3"}
popSound = audio.loadSound("Audio/Blop.mp3")
clockTick = audio.loadStream("Audio/clockTick.mp3")
alarmRing = audio.loadSound("Audio/Alarm_v1.mp3")
correctSound = audio.loadSound("Audio/beadCorrect.mp3")
incorrectSound =  audio.loadSound("Audio/incorrect.mp3")
audioMusic1 =   audio.loadStream( "Audio/music1.mp3" )
audioMusic2 =   audio.loadStream( "Audio/music2.mp3" )
kwartVoor =  audio.loadStream( "Audio/kwart voor.mp3" )
kwartOor =  audio.loadStream( "Audio/kwart oor.mp3" )
half =  audio.loadStream( "Audio/half.mp3" )

currentHour = 0

local loadCount = 0

local backGroupParent = display.newGroup()
local backGroup = display.newGroup()
local timeCountFull

local cloudGroup = display.newGroup()
local cloudCount = 1 
local clouds = {}
local cloudGroup = display.newGroup()
local chooseCloudType
local genProbability
local scaleBy
local transitionTime
local toAlpha
local firstTime = true


local function frameUpdate(event)

 
 local date = os.date( "*t" )    -- Returns table of date & time values
 
 timeCountFull = date.hour*60 + date.min


  if ( backGroupParent ~= nil ) then
	backGroupParent:remove(backGroup)

 end
 backGroup = functions.drawBackground(timeCountFull)

	backGroupParent:insert(backGroup)
	backGroupParent:toBack()
	
timePrev = timeCountFull

end
Runtime:addEventListener( "enterFrame", frameUpdate )

sheetxanderbottomwaveInfo0 = require("Animations.xanderbottomwave.xanderbottomwave-0")
sheetxanderbottomwaveInfo1 = require("Animations.xanderbottomwave.xanderbottomwave-1")



sheetxanderbottomwave0 = graphics.newImageSheet( "Animations/xanderbottomwave/xanderbottomwave-0.png" ,sheetxanderbottomwaveInfo0:getSheet())
sheetxanderbottomwave1 = graphics.newImageSheet( "Animations/xanderbottomwave/xanderbottomwave-1.png" ,sheetxanderbottomwaveInfo1:getSheet())


sequenceDataxanderbottomwaveinit = {
				{ name="xanderbottomwave0", sheet=sheetxanderbottomwave0, start=1, count=83, time=1500, loopCount=1 },
                { name="xanderbottomwave1", sheet=sheetxanderbottomwave1, start=1, count=72, time=1400, loopCount=1}
			
                }

 sequenceDataxanderbottomwaveloop = {
				--{ name="xanderbottomwave0", sheet=sheetxanderbottomwave0, start=25, count=83, time=1000, loopCount=1,loopDirection = "bounce" },
                { name="xanderbottomwave1", sheet=sheetxanderbottomwave1, start=1, count=72, time=2000, loopCount=0,loopDirection = "bounce" }
			
                }
				
 sheetthumbssideInfo0 = require("Animations.thumbsside.thumbsside-0")
sheetthumbssideInfo1 = require("Animations.thumbsside.thumbsside-1")



sheetthumbsside0 = graphics.newImageSheet( "Animations/thumbsside/thumbsside-0.png" ,sheetthumbssideInfo0:getSheet())
sheetthumbsside1 = graphics.newImageSheet( "Animations/thumbsside/thumbsside-1.png" ,sheetthumbssideInfo1:getSheet())


sequenceDatathumbssideinit = {
				{ name="thumbsside0", sheet=sheetthumbsside0, start=1, count=83, time=3000, loopCount=1 },
                { name="thumbsside1", sheet=sheetthumbsside1, start=1, count=72, time=3000, loopCount=1}
			
                }
				
sheetxanderbottomwaveInfo0 = require("Animations.xanderbottomwave2.xanderbottomwave-0")

sheetxanderbottomwave0 = graphics.newImageSheet( "Animations/xanderbottomwave2/xanderbottomwave-0.png" ,sheetxanderbottomwaveInfo0:getSheet())

sequencexanderbottomwave1 = {
				{ name="xanderbottomwave0", sheet=sheetxanderbottomwave0, start=1, count=62, time= 2000, loopCount=1,loopDirection = "bounce" }
				}			

local function screenshot()

        --I set the filename to be "widthxheight_time.png"
        --e.g. "1920x1080_20140923151732.png"
        local date = os.date( "*t" )
        local timeStamp = table.concat({date.year .. date.month .. date.day .. date.hour .. date.min .. date.sec})
        local fname = display.pixelWidth.."x"..display.pixelHeight.."_"..timeStamp..".png"

        --capture screen
        local capture = display.captureScreen(false)

        --make sure image is right in the center of the screen
        capture.x, capture.y = display.contentWidth * 0.5, display.contentHeight * 0.5

        --save the image and then remove
        local function save()
                display.save( capture, { filename=fname, baseDir=system.DocumentsDirectory, isFullResolution=true } )
                capture:removeSelf()
                capture = nil
        end
        timer.performWithDelay( 100, save, 1)

        return true
end


--works in simulator too
local function onKeyEvent(event)
        if event.phase == "up" then
                --press s key to take screenshot which matches resolution of the device
				local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print( message )
            if event.keyName == "s" then
				print("snap")
                screenshot()
            end
        end
end

Runtime:addEventListener("key", onKeyEvent)
composer.gotoScene( "menu" )






