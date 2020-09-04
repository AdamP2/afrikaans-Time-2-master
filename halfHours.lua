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
local dispGroup = display.newGroup()
local Rad_To_Deg = 180/math.pi
local DClock
local prevTime = -1
local Hours
local minutehand
local hourhand

local txtTime
local btnLBLAan
local btnLBLAf
local slideBar
local slideBtn
local TimeMode = "24 hour"
local hourChangeGroup = display.newGroup()
local speechWaveGroup = display.newGroup()
local dispGroup = display.newGroup()
local txtGroup = display.newGroup()

local starAnimation
local starFallAnimation
local beadsParent = display.newGroup()
local XanderWave
local playPraise = true
local tmrShowerPlay


local AniHourRotateAngle = 0
local AniHand
local AniAngleMatch
local rectLock
local tmrAniStart
local tmrAniEnd
local r 
local angleStepVal = 1
local aniPlaying = false

local minScale = 0.32
local hrScale   = 0.25

local sheetxanderbottomwaveInfo0 = require("Animations.xanderbottomwave2.xanderbottomwave-0")

local sheetxanderbottomwave0 = graphics.newImageSheet( "Animations/xanderbottomwave2/xanderbottomwave-0.png" ,sheetxanderbottomwaveInfo0:getSheet())

local sequencexanderbottomwave1 = {
				{ name="xanderbottomwave0", sheet=sheetxanderbottomwave0, start=1, count=62, time= 3000, loopCount=1,loopDirection = "bounce" }
				}


if ( string.sub(system.getInfo( "model" ), 1, 4 ) == "iPad") then
fntSize = 20
else
fntSize = 14
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
				
local function showSpeechWave(Type,variation)
		speechWaveGroup.alpha = 1
		if grp ~= nil then
		grp:removeSelf()
		end
		local grp = display.newGroup()
		local speechStop = display.newImage("Graphics/QuarterHours/quaterhour_speechbubble.png")


		grp:insert(speechStop)
		
		local playPraise = false
		  local txtBubble

		if (Type == "praise") then
			playPraise = true
			txtBubble = praiseText[variation]
		else
			txtBubble = "Daar is 12 ure\nin 'n nag, en nog\n12 ure in 'n nag."
		end
		 local options2 = 
	{ 
		text = txtBubble,   
		x = speechStop.x ,
		y = speechStop.y ,		
		font = teachersPetFont,   
		fontSize = fntSize,
		align = "center"  -- alignment parameter
	}

	local txtspeech = display.newText(options2)
	txtspeech:setFillColor(1)
	txtspeech.alpha = 0

	grp:insert(txtspeech)

	
	speechStop.x	=  xInset*3
	speechStop.y = display.contentHeight/1.25
	speechStop.x	=  xInset*3
	speechStop.y = display.contentHeight/1.25
	txtspeech.x = speechStop.x
	txtspeech.y = speechStop.y 
	speechWaveGroup:insert(grp)
		
	local sX,sY = (txtspeech.contentWidth+ xInset)/speechStop.contentWidth,(txtspeech.contentHeight+ yInset)/speechStop.contentHeight
	speechStop:scale(0,0)
	
		 if playPraise == true then
		 --audio.stop()
		   audio.play(audio.loadSound(praiseSound[variation]))
		 end	
		 
transition.to(speechStop,{time = 500, xScale = sX, yScale =sY})
transition.to(txtspeech,{time = 500, alpha = 1,onComplete = function() timer.performWithDelay(3000,
function()  
	grp:removeSelf()
 end) 
 end})
end

local function swapSheetXWave(event)
		if(event.phase=="bounce" )then


        elseif (event.phase=="ended" )then
		transition.to(speechWaveGroup,{time = 500,alpha = 0})
		 aniPlaying = false
		end
end	

 local function playXander(Type,variation)
  if aniPlaying == false then
	aniPlaying = true
 XanderWave.aplha = 1
 XanderWave:play()
 timer.performWithDelay(2000,function() showSpeechWave(Type,variation) end)
 end
 end

 local function setupXander()
		XanderWave = display.newSprite(sheetxanderbottomwave0,sequencexanderbottomwave1)
		XanderWave:scale(0.0045*display.contentHeight/XanderWave.contentHeight, 0.0045*display.contentHeight/XanderWave.contentHeight)
		XanderWave.anchorY = 1
		XanderWave.anchorX = 0
		XanderWave.y = display.contentHeight + yInset*1.5
		XanderWave.x = display.contentWidth/4

		XanderWave:addEventListener("sprite",swapSheetXWave)

 end



local greenarm = false

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
				
local function drawhands(angle)
   
   if (HandsGroup~= nil)  then 
	HandsGroup:remove(minutehand)
		HandsGroup:remove(ClockCenter)
			HandsGroup:remove(hourhand)
			HandsGroupParent:remove(HandsGroup)
   end
    HandsGroup = display.newGroup()
			
	local ClockCenter = display.newImage("Graphics/StopTheClock/stoptheclock_centerclock.png")		  
	ClockCenter.x = Aclock.x
	ClockCenter.y = Aclock.y
	ClockCenter:scale(0.55*scaleAdjust,0.55*scaleAdjust)
	

    minutehand = display.newImage("Graphics/StopTheClock/buildtheclock_bluearm@2x.png")	

    minutehand.anchorX = 0.5
    minutehand.anchorY = 0.9		  
	minutehand.x = ClockCenter.x
	minutehand.y = ClockCenter.y 
	minutehand:rotate(180)
	OrgX = ClockCenter.x
	OrgY = ClockCenter.y
	minutehand:scale(minScale*Aclock.contentWidth/minutehand.contentHeight,minScale*Aclock.contentWidth/minutehand.contentHeight )
	HandsGroup.minutehand = minutehand
	
	if greenarm == false then
		hourhand = display.newImage("Graphics/StopTheClock/buildtheclock_redarm@2x.png")	
	else
		hourhand = display.newImage("Graphics/QuarterHours/buildtheclock_greenhrarm.png")
	end
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
	hourhand:rotate(angle)

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
	print("Previous Time: ".. prevTime)
	if (prevTime == actualTimeVal) then -- make sure the player does not get the same hour value more than once consecutively
		getRandomHour()

	end
		prevTime = getHourTwelveRange()
return Hours
end



local function getHourAngle()
local hourangle 
 hourangle  =getHourTwelveRange()*30  + 15
 if hourangle > 360 then 
	hourangle = hourangle - 360
end
 return hourangle
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
	getRandomHour()
	ShowTime(Hours,30)
	print("Angle to match: "..getHourAngle())
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
		removeAllListeners(hourhand)
    elseif event.phase == "moved" then

		if (bMoved) then
			local x = event.x
			local y = event.y

			V2i = x - OrgX
			V2j = OrgY - y
			drawhands(calcAngle(V2i,V2j))
		
		V1i = V2i
		V1j = V2j				
         end		
				
	else	
		if (bMoved) then	
			display.currentStage:setFocus( nil )
			target.isFocus = false	

			
			local angleReleased = calcAngle(V2i,V2j)
			local dropTolerance = 30
			if math.abs(angleReleased - getHourAngle()) < dropTolerance or math.abs(angleReleased - getHourAngle()) > (360 -dropTolerance) then
						for i = 15,345,30 do
					if math.abs(i - angleReleased) < 15 then
					greenarm = true
					drawhands(getHourAngle())
					greenarm = false
					end
				end
							
				local rect = functions.lockScreen()
				dispGroup:insert(rect)
				timer.performWithDelay(2500, function() 		
				dispGroup:remove(rect)
				drawhands(getHourAngle())
				getRandomHour()
				ShowTime(Hours,30) 
				hourhand:addEventListener("touch",function()  Aclock:addEventListener("touch",rotatearm) hourhand:removeEventListener("touch",rotatearm) end)
				removeAllListeners(Aclock)	
				end)

				halfHourBeadCount = halfHourBeadCount + 1
				if (halfHourBeadCount == 5 ) then
				halfHourBeadCount = 0
				functions.resetBeads()
				halfHourStarCount = halfHourStarCount + 1
				functions.playStarAni(starAnimation,halfHourStarCount,180,getHourTwelveRange())
				if (halfHourStarCount == 3) then
				halfHourStarCount = 0
				halfHourGameComplete = true
				playPraise = false
				tmrShowerPlay = timer.performWithDelay(2000,function() functions.starShowerPlay("halfHours") end)
				end
				end
				if (playPraise) then
					local randomlyPraise = math.random(1,6)
					if (randomlyPraise == 1) then
					local rndm = math.random(1,3) 
					tmrPraise = timer.performWithDelay(xanderPraiseDelay,function() playXander("praise",rndm) end)
					end
				end
				audio.play(correctSound, {onComplete =function() functions.moveBeads(halfHourBeadCount,true,180,getHourTwelveRange())	end	} )	
				
			else
				system.vibrate()
				audio.play(incorrectSound)
				for i = 15,345,30 do
					if math.abs(i - angleReleased) < 15 then
					drawhands(i)
					end
				end
			end
			bMoved = false			
		end
    end  
    return false
end


local function newqCircle(rotangle)
	local qCircle = display.newImage("Graphics/HalfHours/halfCircle.png")
	qCircle.anchorX = 0
	qCircle.anchorY = 0.5
	qCircle.x = Aclock.x
	qCircle.y = Aclock.y
	qCircle:scale(0.88*Aclock.contentWidth/2/qCircle.contentWidth,0.95*Aclock.contentWidth/2/qCircle.contentWidth)
	qCircle.alpha = 0
	qCircle:rotate(rotangle)

return qCircle

end

local function playStartingAnimation()
--blockRect = functions.lockScreen()

	HandsGroup:toFront()
local hCircle = newqCircle(0)
dispGroup:insert(hCircle)
ShowTime(3,0)
functions.playNumSound(12-3,true)
tmrTransition = timer.performWithDelay(2000, 
function()
  transition.to( hCircle, { time=3000,alpha = 0.4 , transition=easing.inExpo,iterations = 1} )
    transition.to( minutehand, { time=3000,rotation= 180 , transition=easing.inExpo,iterations = 1,delta = true} )
  transition.to( hourhand, { time=3000,rotation= 15 , transition=easing.inExpo,iterations = 1,delta = true,onComplete =
	function()
		 ShowTime( 3,30)
		functions.playTimeSound(180, 3)
		 tmrTransition = timer.performWithDelay(2000,function()
		hCircle.alpha = 0
		Hours = 3	
		prevTime = 3
		getRandomHour()
		ShowTime(Hours,30)													
		halfHourGameComplete = false
		rectLock.isHitTestable = false
		rectLock:removeSelf()
		playMusic()
		end)
	end})
end)
end

												-- function()
													 -- ShowTime( 4,0)
													 -- functions.playNumSound(12- 4,true)
													 -- tmrTransition = timer.performWithDelay(2000,function()
													-- qCircleQPast.alpha = 0
													-- qCircleQTo.alpha = 0
													-- Hours = 4
													-- setupNext(0)
													-- qtrGameComplete = false
													-- blockRect.isHitTestable = false
													-- end)

local function frameUpdate(event)


AniHourRotateAngle = AniHourRotateAngle + angleStepVal
if (AniHourRotateAngle == 360) then
	AniHourRotateAngle = 0
end

local x = r*math.cos(AniHourRotateAngle/180*math.pi - math.pi/2) + Aclock.x
local y = r*math.sin( AniHourRotateAngle/180*math.pi - math.pi/2 ) + Aclock.y

hourhand:rotate(angleStepVal)
AniHand.x = x
AniHand.y = y
AniAngleMatch = getHourAngle()

if AniHourRotateAngle == AniAngleMatch then
	Runtime:removeEventListener( "enterFrame", frameUpdate )
	transition.to(AniHand, {time = 1000, alpha = 0})
	audio.play(correctSound, {onComplete = function() 	functions.playTimeSound(180, getHourTwelveRange()) end })
	greenarm = true
	drawhands(AniAngleMatch,0)
	greenarm = false

	tmrAniEnd = timer.performWithDelay(2000,
		 function()
		 	drawhands(AniAngleMatch,0)
			hourhand:addEventListener("touch",function()  Aclock:addEventListener("touch",rotatearm) hourhand:removeEventListener("touch",rotatearm) end)	
			 getRandomHour()
			ShowTime(Hours,30)
			rectLock:removeSelf()
			halfHourGameComplete = false
		 end)

end

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
	HandsGroup = drawhands(90)
	minutehand:rotate(180)
	hourhand:addEventListener("touch",function()  Aclock:addEventListener("touch",rotatearm) end)	
	sceneGroup:insert(HandsGroup)
	
	DClock = display.newImage("Graphics/Hours/hour_analogueclockcorrect.png")
	DClock:scale(0.3*display.contentWidth/DClock.contentWidth,0.3*display.contentWidth/DClock.contentWidth)
	DClock.y = display.contentHeight/2
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
			functions.playStarAni(starAnimation,halfHourStarCount)
			sceneGroup:insert(starAnimation)
		
			math.randomseed( os.time() )
			functions.removeSceneName = "halfHours"
			
			prevTime =3
			
			ShowTime(prevTime,0)
			sceneGroup:insert(HandsGroupParent)
			sceneGroup:insert(txtGroup)
			sceneGroup:insert(speechWaveGroup)
			sceneGroup:insert(dispGroup)
			if halfHourGameComplete == true then
				rectLock = functions.lockScreen()
				sceneGroup:insert(rectLock)
			end
			sceneGroup:insert(setupMusicIcon())
end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
	
	
    if phase == "will" then
		beadsParent = functions.drawbeads(halfHourBeadCount)
		sceneGroup:insert(beadsParent)

		ChangeHours()
		

    -- elseif phase == "did" then
			-- if halfHourGameComplete == true then
			    -- tmrAniStart = timer.performWithDelay(3000, function()
				-- AniHand = display.newImage("Graphics/hand.png")
				-- sceneGroup:insert(AniHand)
				-- AniHand.anchorY = 0
				-- AniHand:scale(0.1*display.contentHeight/AniHand.contentHeight,0.1*display.contentHeight/AniHand.contentHeight)
				-- AniHand.y = Aclock.y - hourhand.contentHeight + AniHand.contentHeight/4
				-- AniHand.x = Aclock.x
				-- r = hourhand.contentHeight - AniHand.contentHeight/4
				-- Runtime:addEventListener( "enterFrame", frameUpdate )
				-- end)
			-- end

		setupXander()
		sceneGroup:insert(XanderWave)
		playXander("Normal",0)
		if halfHourGameComplete == true then
		playStartingAnimation()
		else
		minutehand:rotate(180)
		end
    end  

end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
    elseif phase == "did" then
	audio.stop()
	
    end 
end

function scene:destroy( event )
    local sceneGroup = self.view
	rectLock = functions.lockScreen()
	if (rectLock~=nil) then
	rectLock:removeSelf()
	end
    transition.cancel()
	if tmrAniStart ~= nil then
		timer.cancel(tmrAniStart)
	end
	
	if tmrShowerPlay~= nil then
	timer.cancel(tmrShowerPlay)
	end
	if tmrTransition ~= nil then
	timer.cancel(tmrTransition)
	end
	if tmrAniEnd ~= nil then
	timer.cancel(tmrAniEnd)
	end
	Runtime:removeEventListener( "enterFrame", frameUpdate )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene