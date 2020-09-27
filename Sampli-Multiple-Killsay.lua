--default menu
Menu.Spacing()
Menu.Separator()
Menu.Spacing()
Menu.Text("Multi Killsay Lua");
Menu.Checkbox("Enable MultiKillsay", "EnableMultiKillsay", true);
Menu.Checkbox("Random Message Order", "RandomMessageOrder", false);

FileSys.CreateDirectory(GetAppData() .. "\\INTERIUM\\CSGO\\FilesForLUA\\");
FileSys.CreateDirectory(GetAppData() .. "\\INTERIUM\\CSGO\\FilesForLUA\\sampli\\");
FileSys.CreateDirectory(GetAppData() .. "\\INTERIUM\\CSGO\\FilesForLUA\\sampli\\Multi Killsay\\");

local doesFileExist = FileSys.GetVarStringFromFile(GetAppData() .. "\\INTERIUM\\CSGO\\FilesForLUA\\sampli\\Multi Killsay\\settings.ini", "fileExists", "DoNotChange");
if (doesFileExist == "") then
    URLDownloadToFile("https://cdn.discordapp.com/attachments/652243470651752450/759679092089552896/settings.ini", GetAppData() .. "\\INTERIUM\\CSGO\\FilesForLUA\\sampli\\Multi Killsay\\settings.ini");
end
local messageCount = FileSys.GetVarStringFromFile(GetAppData() .. "\\INTERIUM\\CSGO\\FilesForLUA\\sampli\\Multi Killsay\\settings.ini", "messages", "TotalMessages");

local killMessages = {}
local messageNum = 1

function addKillMessages()
    if(messageCount == "" or tonumber(messageCount) < 1) then
        return
    end
    for i=1,tonumber(messageCount),1 do
        local varName = "message" .. i;
        local messageVar = FileSys.GetVarStringFromFile(GetAppData() .. "\\INTERIUM\\CSGO\\FilesForLUA\\sampli\\Multi Killsay\\settings.ini", varName, "MessageVariables");
        killMessages[i] = messageVar;
    end
end

addKillMessages()

function incrementMessageNum()
    if messageNum == tonumber(messageCount) then
        messageNum = 1
    else
        messageNum = messageNum + 1
    end
end

Hack.RegisterCallback("FireEventClientSideThink", function(Event)
    if(Event:GetName() == "player_death" and Menu.GetBool("EnableMultiKillsay")) then
        local clientUID = Event:GetInt("userid", 0);
        local victimUID = Event:GetInt("attacker", 0);

        local victimPlayer = IEngine.GetPlayerForUserID(victimUID);    
        if (clientUID ~= victimUID) then
            if(Menu.GetBool("RandomMessageOrder")) then
                local messageToSay = tostring(killMessages[math.random(#killMessages)])
                IEngine.ExecuteClientCmd("say " .. messageToSay);
            else
                local messageToSay = tostring(killMessages[messageNum])
                IEngine.ExecuteClientCmd("say " .. messageToSay);
                incrementMessageNum()
            end
        end
    end
end)
