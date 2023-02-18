local QBCore = exports['qb-core']:GetCoreObject()
local Speed = 35.0
local Drive = 786603
local useDebug = false
--DO NOT TOUCH
local autopilot = false
local bCoords = nil
local LastVehicleHealth = nil
--

RegisterCommand(Config.StartCommand, function(source, args)
    local ev = 0
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player, false)
    print(QBCore.Debug(args))
    for i in pairs(Config.APVehicles) do
        local vehmodel = IsVehicleModel(vehicle, Config.APVehicles[i])
        if vehmodel then
            if IsPedInAnyVehicle(player) then
                if table.concat(args," ") == 'normal' then
                    Drive = Config.NormalDrive
                    Speed = Config.NormalSpeed
                elseif table.concat(args," ") == 'crazy'then
                    Drive = Config.CrazyDrive
                    Speed = Config.CrazySpeed
                end
                if DoesBlipExist(GetFirstBlipInfoId(8)) then
                    local blip = GetFirstBlipInfoId(8)
                    bCoords = GetBlipCoords(blip)
                    ClearPedTasks(player)
                    local veh = GetVehiclePedIsIn(player, false)
                    TaskVehicleDriveToCoord(player, veh, bCoords.x, bCoords.y, bCoords.z, tonumber(Speed), 0, veh, Drive, 25.0, true)
                    SetDriveTaskDrivingStyle(player, Drive)
                    LastVehicleHealth = GetVehicleBodyHealth(vehicle)

                    autopilot = true

                    QBCore.Functions.Notify(Config.Translate[1], 'success')
                else
                    QBCore.Functions.Notify(Config.Translate[2], 'error')
                end
            else
                QBCore.Functions.Notify(Config.Translate[3], 'error')
            end
        else
            ev = ev + 1
        end
    end
    if ev == 9 then
        QBCore.Functions.Notify(Config.Translate[8], 'error')
    end
end, false)

RegisterCommand(Config.StopCommand, function()
    if IsPedInAnyVehicle(PlayerPedId()) then
        ClearPedTasks(PlayerPedId())
        autopilot = false
        bCoords = nil
        called = false
        QBCore.Functions.Notify(Config.Translate[4], 'success')
    else
        QBCore.Functions.Notify(Config.Translate[3], 'error')
    end
end, false)

Citizen.CreateThread(function()
    local ped = PlayerPedId()

    local sleep = 1000
    local vehicle = GetVehiclePedIsIn(ped, false)
    local called = false
    while true do
        if autopilot and bCoords ~= nil then
            sleep = 1
            local coords = GetEntityCoords(ped)
            local x = coords.x - bCoords.x
            local y = coords.y - bCoords.y
            if x <= 0 then
                x = math.abs(x)
            end
            if y <= 0 then
                y = math.abs(y)
            end
            if useDebug then
                print("Coords: ".. coords, "| Bcoords: ".. bCoords)
                print("X: ".. x, "| Y: ".. y)
            end
            if x <= 30 and y <= 30 then
                if IsPedInAnyVehicle(PlayerPedId()) then
                    if not called then
                        ClearPedTasks(ped)
                        QBCore.Functions.Notify(Config.Translate[12], 'success')
                        TaskVehicleDriveToCoord(ped, vehicle, bCoords.x, bCoords.y, bCoords.z, 15.0, 0, vehicle, 8388614, 0.0, true)
                        called = true
                    end
                    if x < 10 and y < 10 then
                        QBCore.Functions.Notify(Config.Translate[7], 'success')
                        ClearPedTasks(PlayerPedId())
                        SetVehicleBrake(vehicle, true)
                        if Drive == '786603' then
                            Wait(1500)
                        else
                            Wait(3000)
                        end
                        SetVehicleBrake(vehicle, false)
                        called = false
                        autopilot = false
                        bCoords = nil
                        sleep = 1000
                    end
                end
            end

            if IsControlJustPressed(1, 72) then
                if IsPedInAnyVehicle(PlayerPedId()) then
                    ClearPedTasks(PlayerPedId())
                    QBCore.Functions.Notify(Config.Translate[9], 'success')
                    autopilot = false
                    bCoords = nil
                    sleep = 1000
                end
            end

            if not IsPedInAnyVehicle(PlayerPedId()) then
                ClearPedTasks(PlayerPedId())
                    autopilot = false
                    bCoords = nil
                    sleep = 1000
            end

            local health = GetVehicleBodyHealth(vehicle)
            if health < LastVehicleHealth then
                ClearPedTasks(PlayerPedId())
                SetVehicleAlarm(vehicle, true)
                StartVehicleAlarm(vehicle)
                SetVehicleAlarmTimeLeft(vehicle, math.random(3000,8000))
                autopilot = false
                bCoords = nil
                sleep = 1000
                QBCore.Functions.Notify(Config.Translate[10], 'success')
                Wait(3000)
                QBCore.Functions.Notify(Config.Translate[11], 'error')


            end

        end
        Wait(sleep)
    end
end)
