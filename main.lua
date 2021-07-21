local GetFontIdByFontName = RegisterFontId --Tested
local DrawRect = DrawRect
local SetTextScale = SetTextScale
local SetTextFont = SetTextFont 
local SetTextColour = SetTextColour
local SetTextDropshadow = SetTextDropshadow
local SetTextOutline = SetTextOutline
local SetTextCentre = SetTextCentre
local BeginTextCommandDisplayText = BeginTextCommandDisplayText
local AddTextComponentSubstringPlayerName = AddTextComponentSubstringPlayerName
local ClearDrawOrigin = ClearDrawOrigin
local GetGameTimer = GetGameTimer 
local function DrawText2D(text,scale,x,y,fontid,colorText)
	SetTextScale(scale, scale)
	SetTextFont(fontid)
	SetTextColour(colorText[1], colorText[2], colorText[3], colorText[4])
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x, y)
	ClearDrawOrigin()
end
local function GetTextWidth(text)
    BeginTextCommandGetWidth('STRING')
    AddTextComponentSubstringPlayerName(text)
    local width = EndTextCommandGetWidth(true);
    return width 
end 
local function DrawProgress(xper,text,size,width,height,fontid,x,y,colorValue,colorTrough,colorText)
    if colorTrough and colorTrough[4] > 0 then 
        DrawRect(
            x  --[[ number ]], 
            y   --[[ number ]], 
            0.105 + width --[[ number ]] , 
            height * 2.0 --[[ number ]], 
            colorTrough[1] --[[ integer ]], 
            colorTrough[2] --[[ integer ]], 
            colorTrough[3] --[[ integer ]], 
            colorTrough[4] --[[ integer ]]
        )
    end 
    DrawRect(
        x  + (((0.1+ width) * xper)/2) - (0.1+ width)/2    --[[ number ]], 
        y  --[[ number ]], 
        (0.1+ width) * xper   --[[ number ]], 
        height * 1.5 --[[ number ]], 
        colorValue[1] --[[ integer ]], 
        colorValue[2] --[[ integer ]], 
        colorValue[3] --[[ integer ]], 
        colorValue[4] --[[ integer ]]
    )
    if colorText and colorText[4] > 0 and string.len(text) > 0 then 
        DrawText2D(text,size,x ,y-((height * 1.5)/2)+0.00138888,fontid,colorText)
    end 
end 
local nowY = {}
local function CreateProgress(duration,text,cb,font,p1,p2,transparent,color1,color2,color3)
    local nowTime = GetGameTimer()
    local endTime = nowTime+duration
    local fontid = 0 -- GetFontIdByFontName("$Font2") 
    local colorValue = color1 or {255,255,255}
    local colorTrough = color2 or {0,0,0}
    local colorText = color3 or {255,255,255}
    local x, y 
    if font then 
        if type(font) == "number" then 
            fontid = font 
        elseif type(font) == "string" then 
            fontid = GetFontIdByFontName(font) 
        end 
    end 
    local size = 0.5
    local width = GetTextWidth(text)/3
    local height = GetRenderedCharacterHeight(size , fontid) 
    local safezone = GetSafeZoneSize()
   
    p1 = p1 or "C"
    p2 = p2 or "C"
    if p1 ~= "C" then 
        if type(p1) == 'number' then 
            x=p1
        else 
            SetScriptGfxAlign(string.byte(p1),string.byte(p2))
            x, _ = GetScriptGfxPosition(0.0, 0.0)
            ResetScriptGfxAlign()
        end 
    else 
            x = safezone/2
    end 
    if p2 ~= "C" then
        if type(p2) == 'number' then 
            y = p2
        else 
        SetScriptGfxAlign(string.byte(p1),string.byte(p2))
        _, y = GetScriptGfxPosition(0.0, 0.0)
        ResetScriptGfxAlign()
        end 
    else 
        y = safezone/2
    end 
    
    local safezone =  safezone - width
    if x > safezone then x = safezone-width/2 end 
    if y > safezone then y = safezone-height/2 end 
    if x < 1-safezone then x = 1-safezone+width/2 end 
    if y < 1-safezone then y = 1-safezone+height/2 end 
    local sp2 = tostring(p1..p2)
    if not nowY[sp2] then nowY[sp2] = 0 end 
    if sp2 == "T" then 
        if nowY[sp2] then 
            y = y + (nowY[sp2] * (height+ 0.005)*2.0) 
        end  
    else 
        if nowY[sp2] then 
            y = y - (nowY[sp2] * (height+ 0.005)*2.0) 
        end 
    end 
    nowY[sp2] = nowY[sp2] + 1
    
    local a = transparent and math.floor(255*transparent) or 255
    CreateThread(function()
        repeat Wait(0) 
            local ggt = GetGameTimer()
            local percent = 1 - ((endTime-ggt) / duration)
            DrawProgress(percent,text,size,width,height,fontid,x,y,{colorValue[1],colorValue[2],colorValue[3],a},{colorTrough[1],colorTrough[2],colorTrough[3],a},{colorText[1],colorText[2],colorText[3],colorText[4] or 255})
        until ggt >= endTime 
        if cb then cb(text) end 
        return 
    end)
end 
exports('CreateProgress', function(...)
  return CreateProgress(...)
end)