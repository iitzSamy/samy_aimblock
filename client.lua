local config = lib.load('cfg')

local function RotDirect(rotation)
    local rx, ry, rz = math.rad(rotation.x), math.rad(rotation.y), math.rad(rotation.z)
    local cosRx = math.cos(rx)
    
    return vector3(
        -math.sin(rz) * cosRx,
        math.cos(rz) * cosRx,
        math.sin(rx)
    )
end

local function D3DText(coords, text)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z + 0.05)
    if not onScreen then return end
    SetTextScale(config.IconScale, config.IconScale)
    SetTextFont(0)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(2, 0, 0, 0, 255)
    SetTextCentre(1)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
end

local function GetRayCast(weaponPos, distance)
    local flag = 1
    local camRot = GetGameplayCamRot()
    local camPos = GetGameplayCamCoord()
    local direction = RotDirect(camRot)
    local destinationW = weaponPos + (direction * distance)
    local destinationC = camPos + (direction * 1000.0)
    
    local _, hitW, coordsW, _, entityW = GetShapeTestResult(
        StartShapeTestRay(weaponPos, destinationW, flag, -1, 1)
    )
    
    local _, hitC, coordsC, _, entityC = GetShapeTestResult(
        StartShapeTestRay(camPos, destinationC, flag, -1, 1)
    )
    
    return hitW, coordsW, entityW, hitC, coordsC, entityC
end

local function AimCheck()
    CreateThread(function()
        while cache.weapon do
            local delay = 300
            if GetIsTaskActive(cache.ped, 4) then
                local weapon = GetCurrentPedWeaponEntityIndex(cache.ped)
                local weaponcoord = GetEntityCoords(weapon)
                local hitW, coordsW, entityW, hitC, coordsC, entityC = GetRayCast(weaponcoord, config.MaxDistance)
                if hitW > 0 and entityW > 0 and #(coordsW - coordsC) > 1 then
                    delay = 2
                    D3DText(coordsW, config.Icon)
                    DisablePlayerFiring(cache.ped, true)
                    DisableControlAction(0, 106, true) 
                else
                    delay = 50
                end
            end
            Wait(delay)
        end
    end)
end

lib.onCache('weapon', function(val)
    if val then AimCheck() end
end)
