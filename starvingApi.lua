--[[

	snnwer#1349
	snnwer on v3rmillion

  props to the original print thing, this just contains a heavily forked version of it, you still need the original bot.py from his thread

]]--

if (getgenv().library == nil) then
	getgenv().library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))();
end;

local player = {};

	player.self = game.Players.LocalPlayer;
	player.grid = (player.self).PlayerGui.MainGui.PaintFrame.GridHolder.Grid;

	player.notify = function(title, text)
		getgenv().library:MakeNotification({
			Name = title,
			Content = text,
			Time = 3
		});
	end;

local http = game:GetService("HttpService");

function json(url, port)
    port = port or "57554";

    local result;
   
	local success, err = pcall(function()
        result = http:JSONDecode(game:HttpGet("http://localhost:".. port .."/get?url="..url));
    end);

    if not success then player.notify("Error", "Got error: ".. err); return; end;

    return result;

end;

function arrange(style: string)
	local numbers = {};
    local count = 0;

	function handler()
		local number;
		if (style == "random") then
			local _number = math.random(1, 1024);
			if (table.find(numbers, _number)) then
				return handler();
			end;
			number = _number;
		elseif (style == "rows") then
			number = #numbers + 1;
		elseif (style == "reverserows") then
			number = 1025 - (#numbers + 1);
		end;

		table.insert(numbers, number);
	end;

	for i = 1, 1024 do
		handler();
	end;

	return numbers;
end;

local lib = {};

	local localplayer = player.self;
	lib.player = player;

	function lib:getImage(image, port)
		return json(image, port);
	end;

	function lib:copy(plr: string, a: number, t: number, n: bool, s: string)

        	p = game.Players[plr]

		t = t or 0.05;
		s = s or "random";

		if (n == nil) then n = true; end;

		s = string.lower(s);
		if (s ~= "random") and (s ~= "rows") and (s ~= "reverserows") then s = "random"; player.notify("Notice", "Valid style options are:\n - \"random\"\n - \"rows\"\n - \"reverserows\""); end;

		local target = {};

			target.self = p;
			target.grid = workspace.Plots:WaitForChild(p.Name).Easels:WaitForChild(tostring(a)).Canvas.SurfaceGui:WaitForChild("Grid");

		local start = os.time();
		if n then
			player.notify("Start", "Started at ".. os.date("%b. %d, %H:%M", start) .. ", approx. time: ".. math.round((1024/(1/t)) + os.time()-start) .."s");
			task.wait();
			player.notify("Start", "If it did not start painting for you, check F9");
		end;

		local order = arrange(s);

		for i, v in ipairs(order) do
			player.grid[tostring(v)].BackgroundColor3 = target.grid[tostring(v)].BackgroundColor3;
			if #target.grid[tostring(v)]:GetChildren() > 0 then
				for a,b in ipairs(target.grid[tostring(v)]:GetChildren()) do
					b:Clone().Parent = player.grid[tostring(v)];
				end;
			end;
			if t > 0 then task.wait(t); end;
		end;

		task.wait()
		if n then player.notify("Finish", "Finished at ".. os.date("%b. %d, %H:%M", os.time()) .. ", time taken: ".. os.time() - start .."s") end;
	end;

	function lib:import(i: string, t: number, n: bool, s: string, port: string)

		port = port or "57554"
		
		t = t or 0.05;
		s = s or "random";

		if (n == nil) then n = true; end;

		s = string.lower(s);
		if (s ~= "random") and (s ~= "rows") and (s ~= "reverserows") then s = "random"; player.notify("Notice", "Valid style options are:\n - \"random\"\n - \"rows\"\n - \"reverserows\""); end;

		local start = os.time();
	
		if n then
			player.notify("Start", "Started at ".. os.date("%b. %d, %H:%M", start) .. ", approx. time: ".. math.round((1024/(1/t)) + os.time()-start) .."s");
			player.notify("Start", "If it did not start painting for you, check F9", Color3.fromRGB(255, 100, 100));
		end;

		local pixels = lib:getImage(i, port);

		local order = arrange(s);
	
		for i, v in ipairs(order) do
			local pixel = pixels[v];
			local r, g, b = pixel[1], pixel[2], pixel[3];
			local f = pixels[1024];
			if ((v + 1) == 2) then player.grid[tostring(v)].BackgroundColor3 = Color3.fromRGB(f[1], f[2], f[3]); end;
			if not player.grid:FindFirstChild(tostring(v + 1)) then continue; end;
			player.grid[tostring(v + 1)].BackgroundColor3 = Color3.fromRGB(r,g,b);

			if t > 0 then task.wait(t); end;
		end;
		if n then player.notify("Finish", "Finished at ".. os.date("%b. %d, %H:%M", os.time()) .. ", time taken: ".. os.time() - start .."s") end;
	end;

return lib;
