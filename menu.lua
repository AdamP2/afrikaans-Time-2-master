local composer = require( "composer" )
local scene = composer.newScene( sceneName )
local functions = require ("functions")

if system.getInfo( "platformName" ) == "Win" then
	teachersPetFont = "TeachersPet"
else
	teachersPetFont = "tp.ttf"
end
local loadCount = 0
local xanderScale
local speechScale
local fntSize
local stopAudio = false
local backGroupParent = display.newGroup()	
local count = 1
local XanderGroup = display.newGroup()
local myAnimation	
local speechGroup = display.newGroup()
local Xander
local txtSpeechString
local tmrAudioPlay
local jingleChoose
local audioMusic1 =   audio.loadStream( "Audio/music1.mp3" )
local audioMusic2 =   audio.loadStream( "Audio/music2.mp3" )
local audioHello = audio.loadSound( "Audio/1-Hallo.mp3" )
local audioPlayInstrFull = audio.loadSound( "Audio/2-Kom ons leer.mp3" )
local audioPlayInstrKies = audio.loadSound( "Audio/kies.mp3" )
local gotoTapCnt = 0
local bPlayMusic = true


if ( string.sub(system.getInfo( "model" ), 1, 4 ) == "iPad") then
fntSize = 18
speechScale = 0.3
xanderScale = 0.4
else
fntSize = 13
speechScale = 0.25
xanderScale = 0.35
end	  

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


local function playIntroSound()

local options = 
{
onComplete = 
	function()

	if stopAudio == false then
		audio.play(audioPlayInstrFull,{onComplete =
		function()  
	if jingleChoose == 1 then 
		audio.play( audioMusic1, { channel=1, loops=-1, fadein=3000 } )
	else
		audio.play( audioMusic2, { channel=1, loops=-1, fadein=3000 } )
	end
	end})
	end

	end
}
	if gameEntered == false then
		if stopAudio == false then
			audio.play(audioHello,options)
		end
	else
	audio.play(audioPlayInstrKies,{onComplete =
		function()  
	if jingleChoose == 1 then 
		audio.play( audioMusic1, { channel=1, loops=-1, fadein=3000 } )
	else
		audio.play( audioMusic2, { channel=1, loops=-1, fadein=3000 } )
	end
	end})
	end
end

local function loadStuffies()
	
			
sheetthinkingsideInfo0 = require("Animations.thinkingside.thinkingside-0")
sheetthinkingsideInfo1 = require("Animations.thinkingside.thinkingside-1")



sheetthinkingside0 = graphics.newImageSheet( "Animations/thinkingside/thinkingside-0.png" ,sheetthinkingsideInfo0:getSheet())
sheetthinkingside1 = graphics.newImageSheet( "Animations/thinkingside/thinkingside-1.png" ,sheetthinkingsideInfo1:getSheet())


sequenceDatathinkingsideinit = {
				{ name="thinkingside0", sheet=sheetthinkingside0, start=1, count=126, time=3000, loopCount=1 },
                { name="thinkingside1", sheet=sheetthinkingside1, start=1, count=26, time=600, loopCount=1}
			
                }	

end




local sheetxanderbottomwaveInfo0 = require("Animations.xanderbottomwave.xanderbottomwave-0")
local sheetxanderbottomwaveInfo1 = require("Animations.xanderbottomwave.xanderbottomwave-1")



local sheetxanderbottomwave0 = graphics.newImageSheet( "Animations/xanderbottomwave/xanderbottomwave-0.png" ,sheetxanderbottomwaveInfo0:getSheet())
local sheetxanderbottomwave1 = graphics.newImageSheet( "Animations/xanderbottomwave/xanderbottomwave-1.png" ,sheetxanderbottomwaveInfo1:getSheet())


local sequenceDataxanderbottomwaveinit = {
				{ name="xanderbottomwave0", sheet=sheetxanderbottomwave0, start=1, count=83, time=1500, loopCount=1 },
                { name="xanderbottomwave1", sheet=sheetxanderbottomwave1, start=1, count=72, time=1400, loopCount=1}
			
                }

local sequenceDataxanderbottomwaveloop = {
                { name="xanderbottomwave1", sheet=sheetxanderbottomwave1, start=1, count=72, time=2000, loopCount=0,loopDirection = "bounce" }
			
                }

local function swapSheet2(event)
	if(event.phase=="ended" and count<=1)then
		myAnimation:setSequence( "xanderbottomwave"..count )
		print("Xander animation looping")
		myAnimation:play()
		count = count + 1
		print(count)
		if (count >=1) then
			count = 0
		end
	end
end
	
local function swapSheet1(event)
	if(event.phase=="began")then
	if XanderLoadGroup ~= nil then
		display.remove(XanderLoadGroup)
	end	
	elseif(event.phase=="ended" and count<=1)then
		myAnimation:setSequence( "xanderbottomwave"..count )
		print("Xander animation looping")		
		myAnimation:play()
		count = count + 1
		--print(count)
		if (count >=1) then
		count = 1
		myAnimation:removeSelf()
	 myAnimation = display.newSprite( sheetxanderbottomwave1, sequenceDataxanderbottomwaveloop)
	  myAnimation:scale(xanderScale,xanderScale)
	  myAnimation.anchorX = 1
	  myAnimation.anchorY = 1
	  myAnimation.x = display.contentWidth-- myAnimation.contentWidth
	  myAnimation.y = display.contentHeight-- myAnimation.contentHeight
	 myAnimation:play()
	 myAnimation:addEventListener("sprite",swapSheet2)
	 XanderGroup:insert(myAnimation)
	 
	local Speech = display.newImage("Graphics/HalfHours/halfhours_speechbubble.png")
	  Speech:rotate(180)
	  Speech.alpha = 0
	  Speech.anchorX = 0
	  Speech.anchorY = 0
	  speechGroup:insert(Speech)
		
		if gameEntered == true then
		txtSpeechString = mnuSpeechtextAfter
		Speech.x = display.contentWidth  - myAnimation.contentWidth - xInset/3
	    Speech.y = display.contentHeight- yInset*2
		else
		Speech.x = display.contentWidth  - myAnimation.contentWidth - xInset/3
		Speech.y = display.contentHeight- yInset/2
		txtSpeechString = mnuSpeechtextInit
		end
  	
  	
		local optionsSpeech =
	{
		text = "" ,
		y = Speech.y   - yInset/4,
		x = Speech.x,
		font = teachersPetFont,
		fontSize = fntSize,
		align = "center"
	}
	local txtSpeech = display.newText(optionsSpeech)
	txtSpeech.text = txtSpeechString 		
	txtSpeech.alpha = 0
	txtSpeech:setFillColor(1)	

    speechGroup:insert(txtSpeech)
	txtSpeech:toFront()
		
		local sX,sY = (txtSpeech.contentWidth+ xInset*1.5)/Speech.contentWidth,(txtSpeech.contentHeight+ yInset*1.5)/Speech.contentHeight
	Speech:scale(sX,sY)
	txtSpeech.x = Speech.x - Speech.contentWidth/2
	txtSpeech.y = Speech.y - Speech.contentHeight/2
	XanderGroup:insert(speechGroup)
		Speech:scale(0,0)
	
	 transition.to(Speech	 , { time= 500,xScale = sX , yScale = sY, alpha = 1, onComplete = function() 	 transition.to(txtSpeech	 , { time= 1000,fontSize = fntSize, fontSize = fntSize, alpha = 1}) end})
 
		end
	end
end

local backGroup 
local timeCountFull = 0
local timePrev = 0
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

local function insertCloud()

	if cloudCount < 3 then
	genProbability = math.random(1,1)
	else
	genProbability = math.random(1,500)
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
			if cloud ~= nil then
				cloudGroup:insert(cloud)
			end
			local cX,cY
			if firstTime == true then
			cX,cY = math.random(display.contentWidth/3,display.contentWidth/1.1), math.random(cloud.contentHeight/2,display.contentHeight/2.5)
			firstTime = false
			else
			cX,cY = -cloud.contentWidth/2, math.random(cloud.contentHeight/2,display.contentHeight/2.5)
			end
			cloud.x = cX
			cloud.y = cY
			scaleBy = math.random(0,120)/100
			cloud:scale(scaleBy,scaleBy)
			scaleBy = math.random(0,120)/100
			toAlpha = math.random(0,100)/100
			transitionTime = math.random(20000,100000)
			 cloudCount = cloudCount + 1
			 transition.to(cloud,{time = transitionTime, x= display.contentWidth + (cloud.contentWidth*scaleBy)/2,alpha = toAlpha,xScale = scaleBy, yScale = scaleBy,onComplete =
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


local function frameUpdate(event)
insertCloud()
end

function scene:create( event )
    local sceneGroup = self.view
	local phase = event.phase
	print("Menu entered oncreate")	
	math.randomseed( os.time() )
	
	--Use ratio between screen contentwidth and background image to scale background
	sceneGroup:insert(backGroupParent)
	
	local NavigationGroup = display.newGroup()
	
	gotoTapCnt = 0


 		
			local mnuBouHorlosie = display.newImage("Graphics/Home/halfuur.png")
	      BouHorlosie = mnuBouHorlosie.parent 
	      NavigationGroup:insert(mnuBouHorlosie)	
		  	
	local optionsBouHorlosie =
	{
		text = "Half Uur" ,
		y=mnuBouHorlosie.y + mnuBouHorlosie.contentHeight/2 + yInset*2.5,
		x = mnuBouHorlosie.x,
		font = teachersPetFont,
		fontSize = 50,
		align = "left"
	}
	local txtBouHorlosie = display.newText(optionsBouHorlosie)
	txtBouHorlosie:setFillColor(0)
	NavigationGroup:insert(txtBouHorlosie)
	
	local mnuUur = display.newImage("Graphics/Home/kwartuur.png")
	      mnuUur.x = mnuBouHorlosie.x + mnuUur.contentWidth + xInset*2
		  Uur = mnuUur.parent 
		  NavigationGroup:insert(mnuUur)
	
		local optionsUur =
	{
		text = "Kwartuur" ,
		y=mnuUur.y + mnuUur.contentHeight/2 + yInset*2.5,
		x = mnuUur.x,
		font = teachersPetFont,
		fontSize = 50,
		align = "left"
	}
	local txtUur = display.newText(optionsUur)
	      txtUur:setFillColor(0)
	      NavigationGroup:insert(txtUur)

	local mnuHoeLaat = display.newImage("Graphics/Home/stopdiehorlosie.png")
	      mnuHoeLaat.x = mnuUur.x + mnuHoeLaat.contentWidth + xInset*2
		  HoeLaat = mnuHoeLaat.parent
		  NavigationGroup:insert(mnuHoeLaat)
		  
	local optionsHoeLaat =
	{
		text = "Stop die horlosie" ,
		y=mnuHoeLaat.y + mnuHoeLaat.contentHeight/2 + yInset*2.5,
		x = mnuHoeLaat.x,
		font = teachersPetFont,
		fontSize = 50,
		align = "left"
	}
	local txtHoeLaat = display.newText(optionsHoeLaat)
	txtHoeLaat:setFillColor(0)
	NavigationGroup:insert(txtHoeLaat)
	

	
	local Xander = display.newImage("Graphics/Home/home-xander.png")
	      Xander:scale(0.4,0.4)
	      Xander.x = display.contentWidth - Xander.contentWidth/2
		  Xander.y = display.contentHeight - Xander.contentHeight/2
		  Xander.isVisible = false
			XanderGroup:insert(Xander)	

	NavigationGroup:scale(display.contentWidth/NavigationGroup.contentWidth/3*2.3,display.contentWidth/NavigationGroup.contentWidth/3*2.3)

	NavigationGroup.anchorX = 0.5
	NavigationGroup.x = display.contentWidth/4.5
	NavigationGroup.y = display.contentHeight/2 
	sceneGroup:insert(cloudGroup)
	sceneGroup:insert(XanderGroup)
	sceneGroup:insert(NavigationGroup)
	sceneGroup:insert(speechGroup)
	
	function BouHorlosie( event )
	    if event.phase == "began" then
				--transition image to shrink with a small delay then gotoScene		
				stopAudio = true		
				gotoTapCnt = gotoTapCnt + 1
				if gotoTapCnt == 1 then
				audio.play(mnuChoose)
				timer.performWithDelay(300, function() gotoTapCnt = 0  composer.gotoScene("halfHours", "fade", 500);	  composer.removeScene("menu") Runtime:removeEventListener( "enterFrame", frameUpdate ) end)
				end
				return true
			end
		end
		mnuBouHorlosie:addEventListener( "touch", BouHorlosie )
		
	function Uur( event )
		if event.phase == "began" then
				--transition image to shrink with a small delay then gotoScene			
			stopAudio = true 	
			gotoTapCnt = gotoTapCnt + 1
			if gotoTapCnt == 1 then
			audio.play(mnuChoose)
			timer.performWithDelay(300, function() gotoTapCnt = 0 composer.gotoScene("quarterHours", "fade", 500);  composer.removeScene("menu") Runtime:removeEventListener( "enterFrame", frameUpdate )  end)
			end
			return true
		end
	end
	mnuUur:addEventListener( "touch", Uur )
		
	function HoeLaat( event )
		if event.phase == "began" then
				--transition image to shrink with a small delay then gotoScene	
				stopAudio = true
				gotoTapCnt = gotoTapCnt + 1
				if gotoTapCnt == 1 then
				audio.play(mnuChoose)
				timer.performWithDelay(300, function() gotoTapCnt = 0 composer.gotoScene("stopClock", "fade", 500);   composer.removeScene("menu") Runtime:removeEventListener( "enterFrame", frameUpdate ) end)
				end
			return true
		end
	end
	mnuHoeLaat:addEventListener( "touch", HoeLaat )
	sceneGroup:insert(setupMusicIcon())


	
end



function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
	
    if phase == "will" then

    elseif phase == "did" then
	jingleChoose = math.random(1,2)
	-- audio.reserveChannels( 1 )
	-- audio.setVolume( 0.2, { channel=1 } )
	tmrAudioPlay = timer.performWithDelay(1500,playIntroSound)

	Runtime:addEventListener( "enterFrame", frameUpdate )
	
	print("Menu entered did on scene show")	
	myAnimation = display.newSprite( sheetxanderbottomwave0, sequenceDataxanderbottomwaveinit )
	  myAnimation:scale(xanderScale,xanderScale)
	  myAnimation.anchorX = 1
	  myAnimation.anchorY = 1
	  myAnimation.x = display.contentWidth-- myAnimation.contentWidth
	  myAnimation.y = display.contentHeight-- myAnimation.contentHeight
	 myAnimation:play()
	 myAnimation:addEventListener("sprite",swapSheet1)
	 XanderGroup:insert(myAnimation)
	 print("Menu done with show part")	
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
	timer.cancel(tmrAudioPlay)
	 transition.cancel()
	cloudGroup:removeSelf()
	myAnimation:removeSelf()
	speechGroup:removeSelf()

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene