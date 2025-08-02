local locals = {
	network_should_sleep = false,
	original_position = CFrame.new(1, 1, 1),
	should_starhook_destroy = false,
	old_ticks = {
		assist_stutter_tick = tick(),
		clone_chams_tick = tick(),
		auto_shoot_tick = tick(),
		network_desync_tick = tick()
	},
	assist = {
		is_targetting = false,
		target = nil,
	},
	target_aim = {
		predicted_position = Vector3.new(1, 1, 1),
		is_targetting = false,
		target = nil
	},
	silent_aim = {
		predicted_position = Vector3.new(1, 1, 1),
		is_targetting = false,
		target = nil
	},
	gun = {
		current_tool = nil,
		current_tool_bullet_tp = nil,
		recently_shot = false,
		recently_hit = false,
		previous_ammo = 0,
		previous_ammo_bullet_tp = 0
	}
};

local drawings = {};
local signals = {};
local instances = {
	target_ui = {}
};
local blood_splatters = {};
local ui = {
	window = nil,
	tabs = {}
}

local connections = {
	gun = {}
};

--// addon library
local script_addon = {
    events = {}
};

--// screengui
local screen_gui = Instance.new("ScreenGui");
screen_gui.Name = "https://starhook.club";
screen_gui.IgnoreGuiInset = true;
screen_gui.DisplayOrder = 99999;
screen_gui.ResetOnSpawn = false;
screen_gui.Enabled = false;
screen_gui.Parent = core_gui;

local screen_gui_2 = Instance.new("ScreenGui");
screen_gui_2.Name = "https://starhook.club";
screen_gui_2.IgnoreGuiInset = true;
screen_gui_2.DisplayOrder = 99999;
screen_gui_2.ResetOnSpawn = false;
screen_gui_2.Enabled = false;
screen_gui_2.Parent = core_gui;

--// old fflags
local old_psr;
local old_pssmbs;
--// "S2PhysicsSenderRate", "PhysicsSenderMaxBandwidthBps", "DataSenderMaxJoinBandwidthBps"

if (getfflag) then
	local old = getfflag;

	getfflag = function(fflag)
		local success, result = pcall(function()
			return old(fflag);
		end);

		return result;
	end;

	old_psr = getfflag("S2PhysicsSenderRate");
	old_pssmbs = getfflag("PhysicsSenderMaxBandwidthBps");
end;

--// utility
local utility = {}; do
	utility.get_xmr_price = LPH_NO_VIRTUALIZE(function()
		local data = game:HttpGet("https://api.coincap.io/v2/assets/monero");
		local table_data = http_service:JSONDecode(data);

		return math.floor(table_data.priceUsd) or 0;
	end);

	utility.world_to_screen = LPH_NO_VIRTUALIZE(function(position)
		local position, on_screen = camera:WorldToViewportPoint(position);

		return {position = Vector2.new(position.X, position.Y), on_screen = on_screen};
	end);

	utility.get_ping = LPH_NO_VIRTUALIZE(function()
		return stats.Network.ServerStatsItem["Data Ping"]:GetValue();
	end);

	utility.has_character = LPH_NO_VIRTUALIZE(function(player)
		return (player and player.Character and player.Character:FindFirstChild("Humanoid")) and true or false;
	end);

	utility.new_connection = function(type, callback) --// by all matters do NOT no virtualize this
		local connection = type:Connect(callback);

		table.insert(connections, connection);

		return connection;
	end;

	utility.create_connection = function(signal_name) --// by all matters do NOT no virtualize this
		local connection = signal.new(signal_name);
		return connection;
	end;

	utility.is_in_air = LPH_NO_VIRTUALIZE(function(player)
		if (not (utility.has_character(player))) then return false end;

		local root_part = player.Character.HumanoidRootPart;

		return root_part.Velocity.Y ~= 0; --// my old one was so fucking broken and weird so ill js use velocity check
	end);

	utility.is_friends_with = LPH_NO_VIRTUALIZE(function(player)
		return player:IsFriendsWith(local_player.UserId) and true or false;
	end);

	utility.is_player_behind_a_wall = LPH_NO_VIRTUALIZE(function(player)
		local amount = camera:GetPartsObscuringTarget({local_player.Character.HumanoidRootPart.Position, player.Character.HumanoidRootPart.Position}, {local_player.Character, player.Character});
		return #amount ~= 0;
	end);
	

	utility.drawing_new = function(type, properties)
		local drawing_object = Drawing.new(type);

		for property, value in properties do
			drawing_object[property] = value;
		end;

		return drawing_object;
	end;

	utility.instance_new = function(type, properties)
		local instance = Instance.new(type);

		for property, value in properties do
			instance[property] = value;
		end;

		return instance;
	end;

	utility.generate_random_string = function(length)
		local characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		local random_string = "";

		for i = 1, length do
			local random_index = math.random(1, #characters);
			random_string = random_string .. string.sub(characters, random_index, random_index);
		end;

		return random_string;
	end;

	utility.is_player_black = LPH_NO_VIRTUALIZE(function(player)
		if (not (utility.has_character(player))) then return false end;

		local head = player.Character.Head;
		local hue = Color3.toHSV(head.Color);

		return hue >= 0 and hue <= 0.1;
	end);

	utility.play_sound = LPH_NO_VIRTUALIZE(function(volume, sound_id)
		local sound = Instance.new("Sound");
		sound.Parent = workspace;
		sound.SoundId = sound_id;
		sound.Volume = volume;

		sound:Play();

		utility.new_connection(sound.Ended, function()
			sound:Destroy();
		end);
	end);

	utility.clone_character = function(player, transparency, color, material, delete_hrp)
		local delete_hrp = delete_hrp or true;

		player.Character.Archivable = true;
		local new_character = player.Character:Clone();
		new_character.Parent = workspace;
		player.Character.Archivable = false;
		
		local parts = new_character:GetChildren();
		
		for i = 1, #parts do
			local part = parts[i];
				
			if (part.ClassName == "MeshPart") then
				part.Anchored = true;
				part.CanCollide = false;
				part.Color = color;
				part.Material = Enum.Material[material];
				part.Transparency = transparency;
			else
				if part.Name ~= "HumanoidRootPart" and delete_hrp then
					part:Destroy();
				end;
			end;
			
			if part.Name == "Head" then
				local decal = part:FindFirstChild("face");
				
				if decal then decal:Destroy() end;
			end;
		end;

		return new_character;
	end;

	utility.create_beam = LPH_NO_VIRTUALIZE(function(from, to, color_1, color_2, duration, fade_enabled, fade_duration)
		local tween;
		local total_time = 0;

		local main_part = utility.instance_new("Part", {
			Parent = workspace,
			Size = Vector3.new(0, 0, 0),
			Massless = true,
			Transparency = 1,
			CanCollide = false,
			Position = from,
			Anchored = true
		});

		local part0 = utility.instance_new("Part", {
			Parent = main_part,
			Size = Vector3.new(0, 0, 0),
			Massless = true,
			Transparency = 1,
			CanCollide = false,
			Position = from,
			Anchored = true
		});

		local part1 = utility.instance_new("Part", {
			Parent = main_part,
			Size = Vector3.new(0, 0, 0),
			Massless = true,
			Transparency = 1,
			CanCollide = false,
			Position = to,
			Anchored = true
		});

		local attachment0 = utility.instance_new("Attachment", {
			Parent = part0
		});

		local attachment1 = utility.instance_new("Attachment", {
			Parent = part1
		});

		local beam = utility.instance_new("Beam", {
			Texture = "rbxassetid://446111271",
			TextureMode = Enum.TextureMode.Wrap,
			TextureLength = 10,
			LightEmission = 1,
			LightInfluence = 1,
			FaceCamera = true,
			ZOffset = -1,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(1, 1),
			}),
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, color_1),
				ColorSequenceKeypoint.new(1, color_2),
			}),
			Attachment0 = attachment0,
			Attachment1 = attachment1,
			Enabled = true,
			Parent = main_part
		});


		if fade_enabled then
			tween = utility.new_connection(run_service.Heartbeat, function(delta_time) --// credits to xander
				total_time += delta_time;
				beam.Transparency = NumberSequence.new(tween_service:GetValue((total_time / fade_duration), Enum.EasingStyle.Quad, Enum.EasingDirection.In));
			end)
		end;

		task.delay(duration, function()
			main_part:Destroy();

			if (tween) then
				tween:Disconnect();
			end;
		end);
	end);

	utility.create_impact = function(color, size, fade_enabled, fade_duration, duration, position)
		local impact = utility.instance_new("Part", {
			CanCollide = false;
			Material = Enum.Material.Neon;
			Size = Vector3.new(size, size, size);
			Color = color;
			Position = position;
			Anchored = true;
			Parent = workspace
		});

		local outline = utility.instance_new("SelectionBox", { --// credits to xander
			LineThickness = 0.01;
			Color3 = color;
			SurfaceTransparency = 1;
			Adornee = impact;
			Visible = true;
			Parent = impact
		});

		if (fade_enabled) then
			local tween_info = TweenInfo.new(duration);
			local tween = tween_service:Create(impact, tween_info, {Transparency = 1});
			local tween_outline = tween_service:Create(outline, tween_info, {Transparency = 1});

			tween:Play();
			tween_outline:Play();
		end;

		task.delay(duration, function()
			impact:Destroy()		
		end);
	end;
end;

--// math functions
local custom_math = {}; do
	custom_math.random_vector3 = LPH_NO_VIRTUALIZE(function(randomization)
		return Vector3.new(math.random(-randomization, randomization), math.random(-randomization, randomization), math.random(-randomization, randomization));
	end);

	custom_math.recalculate_velocity = LPH_NO_VIRTUALIZE(function(part, update_time) --// this is pasted
		local current_position = part.Position;
		local current_time = tick();
		task.wait(1 / update_time);
		local new_position = part.Position;
		local new_time = tick();
		local distance_traveled = (new_position - current_position);
		local time_interval = (new_time - current_time);
		local velocity = (distance_traveled / time_interval);
		current_position = new_position;
		current_time = new_time;
		return velocity;
	end);

	custom_math.cframe_to_offset = function(origin, target)
		local actual_origin = origin * CFrame.new(0, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0);
		return actual_origin:ToObjectSpace(target):inverse();
	end;

	custom_math.is_mouse_over_frame = function(frame)
		local mouse_pos = user_input_service:GetMouseLocation();
		local absolute_position = frame.AbsolutePosition;
		local absolute_size = frame.AbsoluteSize;

		local xBound = (mouse_pos.X >= absolute_position.X and mouse_pos.X < absolute_position.X + absolute_size.X);
		local yBound = (mouse_pos.Y >= absolute_position.Y and mouse_pos.Y < absolute_position.Y + absolute_size.Y);
		return (xBound and yBound);
	end;
end;

--// custom dahood functions
local dahood = {}; do
	dahood.has_blood_splatter = LPH_NO_VIRTUALIZE(function(player)
		if (not utility.has_character(player)) then return false end;
	
		local descendants = player.Character:GetDescendants();
		for i = 1, #descendants do
			local instance = descendants[i];
	
			if ((instance.Name == "BloodSplatter" or instance.Name == "BloodParticles" or instance.Name == "BloodParticle") and not table.find(blood_splatters, instance)) then
				table.insert(blood_splatters, instance);
				return true, instance.Parent;
			end;
		end;
	
		return false;
	end);	
	
	dahood.get_armor = LPH_NO_VIRTUALIZE(function(player)
		if (not utility.has_character(player)) then return 100 end;

		local body_effects = player.Character:FindFirstChild("BodyEffects");

		if not body_effects then
			return 100;
		end;

		return body_effects.Armor.Value;
	end);

	dahood.is_on_vehicle = LPH_NO_VIRTUALIZE(function(player)
		return player.Character:FindFirstChild("[CarHitBox]") ~= nil;
	end);

	dahood.is_knocked = LPH_NO_VIRTUALIZE(function(player) --// TODO: rewrite this
		local value;

		if game.GameId == 1958807588 then --// hood modded
			value = player.Information.KO.Value;
		else --// real dahood
			local bodyeffects = player.Character:FindFirstChild("BodyEffects");
			value = bodyeffects and bodyeffects["K.O"].Value or false;
		end;

		return value;
	end);

	dahood.get_gun = LPH_NO_VIRTUALIZE(function(player) --// TODO: ADD MORE SUPPORT FOR DIFFERENT HOOD GAMES
		local info;

		--// character check
		if (not (utility.has_character(player))) then return end;

		local tool = player.Character:FindFirstChildWhichIsA("Tool");

		--// tool check
		if (not (tool)) then return end;

		--// main code
		local descendants = tool:GetDescendants();

		for i = 1, #descendants do
			local object = descendants[i];

			if (object.Name:lower():find("ammo") and not object.Name:lower():find("max") and (object.ClassName == "IntValue" or object.ClassName == "NumberValue")) then
				info = {};
				info.ammo = object;
				info.tool = tool;
			end;
		end;

		return info;
	end);

	dahood.is_grabbed = LPH_NO_VIRTUALIZE(function(player)
		return player.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil;
	end);
end;

--// combat functions
local combat = {}; do
	combat.get_closest_body_part = LPH_NO_VIRTUALIZE(function(player)
		local closest_body_part;
		local mouse_position = user_input_service:GetMouseLocation();
		local radius = math.huge;

		local children = player.Character:GetChildren();

		for i = 1, #children do
			local part = children[i];
			if (part.ClassName ~= "MeshPart") then continue end;

			local part_position = utility.world_to_screen(part.Position);
			local distance = (mouse_position - part_position.position).Magnitude;

			if (distance <= radius) then
				radius = distance;
				closest_body_part = part;
			end;
		end;

		return closest_body_part;
	end);

	combat.get_closest_player = LPH_NO_VIRTUALIZE(function(fov_enabled, fov_radius, checks_enabled, check_values)
		--// locals
		local mouse_position = user_input_service:GetMouseLocation();
		local radius = fov_enabled and (fov_radius * 3) or math.huge;
		local closest_player;

		--// main loop
		local players = players:GetPlayers();
		for i = 1 , #players do
			local player = players[i];
			if (player == local_player) then continue end;

			if (not (utility.has_character(player))) then continue end;

			local root_part = player.Character:FindFirstChild("HumanoidRootPart");

			if (not (root_part)) then continue end;

			local root_position = utility.world_to_screen(root_part.Position);

			if (not (root_position.on_screen)) then continue end;

			if (checks_enabled and (
				table.find(check_values, "Vehicle") and dahood.is_on_vehicle(player) or
				table.find(check_values, "Knocked") and dahood.is_knocked(player) or
				table.find(check_values, "Grabbed") and dahood.is_grabbed(player) or
				table.find(check_values, "Friend") and utility.is_friends_with(player) or
				table.find(check_values, "Wall") and utility.is_player_behind_a_wall(player)
			)) then continue end;

			local distance = (mouse_position - root_position.position).Magnitude;

			if (distance <= radius) then
				radius = distance;
				closest_player = player;
			end;
		end;

		return closest_player;
	end);

	combat.resolve = function(player, method, update_time)
		if (not utility.has_character(player)) then return Vector3.new(0, 0, 0) end;

		local actual_update_time = update_time or 100;
		local velocity;

		if (method == "Recalculate") then
			velocity = custom_math.recalculate_velocity(player.Character.HumanoidRootPart, actual_update_time);
		elseif (method == "MoveDirection") then
			velocity = (player.Character.Humanoid.MoveDirection * player.Character.Humanoid.WalkSpeed);
		end;

		return velocity;
	end;
	
	combat.get_random_body_part = function(player)
		local children = player.Character:GetChildren();
		local mesh_parts = {};

		for i = 1, #children do
			local object = children[i];
			if (object.ClassName ~= "MeshPart") then continue end;

			table.insert(mesh_parts, object);
		end;

		return mesh_parts[math.random(1, #mesh_parts)];
	end;
end;

--// assist functions
local assist = {}; do
	assist.get_predicted_position = function()
		--// locals
		local target = locals.assist.target;

		--// settings
		local aim_part = flags["legit_assist_part"];
		local prediction = flags["legit_assist_prediction"];
		local shake_enabled = flags["legit_assist_shake_enabled"];
		local shake_amount = flags["legit_assist_shake_amount"];
		local anti_ground_shots_enabled = flags["legit_assist_anti_ground_shots"];
		local to_take_off = flags["legit_assist_anti_ground_shots_to_take_off"] / 10; --// will convert 2 to 0.2 as an example
		local use_air_aim_part = flags["legit_assist_use_air_hit_part"];
		local air_aim_part = flags["legit_assist_air_part"];
		local resolver_enabled = flags["legit_assist_resolver"];
		local resolver_method = flags["legit_assist_resolver_method"];
		local resolve_update_time = flags["legit_assist_resolver_update_time"];

		--// instances
		local root_part = target.Character.HumanoidRootPart;
		local aim_part_instance = target.Character:FindFirstChild(aim_part);

		--// vars
		local velocity = resolver_enabled and combat.resolve(target, resolver_method, resolve_update_time) or root_part.Velocity;

		--// velocity modifactions
		if (anti_ground_shots_enabled and (utility.is_in_air(target))) then
			velocity = Vector3.new(velocity.X, math.abs(velocity.Y * to_take_off), velocity.Z);
		end;

		--// aim part modifactions
		if (use_air_aim_part and (utility.is_in_air(target))) then
			aim_part_instance = target.Character:FindFirstChild(air_aim_part);
		end;

		--// main
		local predicted_position = (aim_part_instance.Position + velocity * prediction);

		--// position modifactions
		if (shake_enabled) then
			predicted_position = predicted_position + custom_math.random_vector3(shake_amount);
		end;

		--// end
		return predicted_position;
	end;

	assist.move_mouse = function(position, smoothing)
		local mouse_position = user_input_service:GetMouseLocation();

		mousemoverel((position.X - mouse_position.X) / smoothing, (position.Y - mouse_position.Y) / smoothing);
	end;
end;
--// silent aim functions
local silent_aim = {} do
	silent_aim.get_predicted_position = function()
		--// locals
		local target = locals.silent_aim.target;

		--// settings
		local aim_part = flags["legit_silent_aim_part"];
		local closest_body_part_enabled = flags["legit_silent_closest_body_part"];
		local prediction = flags["legit_silent_prediction"];
		local anti_ground_shots_enabled = flags["legit_silent_anti_ground_shots"];
		local to_take_off = flags["legit_silent_anti_ground_shots_to_take_off"] / 10;
		local use_air_aim_part = flags["legit_silent_use_air_hit_part"];
		local air_aim_part = flags["legit_silent_air_aim_part"];
		local resolver_enabled = flags["legit_silent_resolver"];
		local resolver_method = flags["legit_silent_resolver_method"];
		local update_time = flags["legit_silent_resolver_update_time"];

		--// instances
		local root_part = target.Character.HumanoidRootPart;
		local aim_part_instance = closest_body_part_enabled and combat.get_closest_body_part(target) or target.Character:FindFirstChild(aim_part);

		--// vars
		local velocity = resolver_enabled and combat.resolve(target, resolver_method, update_time) or root_part.Velocity;

		--// velocity modifactions
		if (anti_ground_shots_enabled and (utility.is_in_air(target))) then
			velocity = Vector3.new(velocity.X, math.abs(velocity.Y * to_take_off), velocity.Z);
		end;

		--// aim part modifactions
		if (use_air_aim_part and (utility.is_in_air(target))) then
			aim_part_instance = target.Character:FindFirstChild(air_aim_part);
		end;

		--// main
		local predicted_position = (aim_part_instance.Position + velocity * prediction);

		--// end
		return game.PlaceId == hood_customs and predicted_position + Vector3.new(25, 100, 25) or predicted_position
	end;
end;

--// target aim functions
local target_aim = {}; do
	target_aim.get_predicted_position = function()
		--// locals
		local target = locals.target_aim.target;

		--// settings
		local aim_part = flags["rage_target_aim_aim_part"];
		local closest_body_part_enabled = flags["rage_target_aim_closest_body_part"];
		local prediction = flags["rage_target_aim_prediction"];
		local resolver_enabled = flags["rage_target_aim_resolver_enabled"];
		local resolver_method = flags["rage_target_aim_resolver_method"];
		local anti_ground_shots_enabled = flags["rage_target_aim_anti_ground_shots"];
		local dampening_factor = flags["rage_target_aim_dampening_factor"];
		local use_air_aim_part = flags["rage_target_aim_use_air_hit_part"];
		local air_aim_part = flags["rage_target_aim_air_aim_part"];
		local use_air_offset = flags["rage_target_aim_use_air_offset"];
		local air_offset = flags["rage_target_aim_air_offset"] / 100; --// will convert 4 to 0.04 as am example
		local update_time = flags["rage_target_aim_update_time"];
		local random_body_part_enabled = flags["rage_target_aim_randomized_body_part"];
		--local movement_simulation = flags["rage_target_aim_movement_simulation"];

		--// instances
		local root_part = target.Character.HumanoidRootPart;
		local aim_part_instance = closest_body_part_enabled and combat.get_closest_body_part(target) or target.Character:FindFirstChild(aim_part);

		--// random body part
		if (random_body_part_enabled) then
			aim_part_instance = combat.get_random_body_part(target);
		end;

		--// vars
		local velocity = resolver_enabled and combat.resolve(target, resolver_method, update_time) or root_part.Velocity;
		local is_in_air = utility.is_in_air(target);


        if (anti_ground_shots_enabled and is_in_air) then
            local going_down = velocity:Dot(Vector3.new(0, -1, 0));
            if going_down > 0.05 then
                velocity *= Vector3.new(1, dampening_factor, 1);
            end;
        end;

		--// aim part modifactions
		if (use_air_aim_part and (is_in_air)) then
			aim_part_instance = target.Character:FindFirstChild(air_aim_part);
		end;

		--// main
		local predicted_position = (aim_part_instance.Position + velocity * prediction);
		
		--// offsets
		if (use_air_offset and (is_in_air)) then
			predicted_position = predicted_position + Vector3.new(0, air_offset, 0);
		end;
	
		--// end
		return game.PlaceId == hood_customs and predicted_position + Vector3.new(25, 100, 25) or predicted_position;
	end;
end;

--[[ if (utility.is_player_black(local_player)) then
    local_player:Kick("Script tampering detected");
    return;
end; --]]

--// hit effects
local hit_effects = {}; do
	hit_effects.confetti = function(position) --// credits to xander
		local part = utility.instance_new("Part", {
			Position = position,
			Anchored = true,
			Transparency = 1,
			CanCollide = false,
			Parent = workspace
		});

		for i = 1, 5 do
			local particle1 = utility.instance_new("ParticleEmitter", {
				Acceleration = Vector3.new(0,-10,0);
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,1,0.886275)),ColorSequenceKeypoint.new(1,Color3.new(0,1,0.886275))};
				Lifetime = NumberRange.new(1,2);
				Rate = 0;
				RotSpeed = NumberRange.new(260,260);
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.1,0),NumberSequenceKeypoint.new(1,0.1,0)};
				Speed = NumberRange.new(15,15);
				SpreadAngle = Vector2.new(360,360);
				Texture = "http://www.roblox.com/asset/?id=241685484";
				Parent = part
			});
			local particle2 = utility.instance_new("ParticleEmitter", {
				Acceleration = Vector3.new(0,-10,0);
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,0.0980392,1)),ColorSequenceKeypoint.new(1,Color3.new(0,0,1))};
				Lifetime = NumberRange.new(1,2);
				Rate = 0;
				RotSpeed = NumberRange.new(260,260);
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.1,0),NumberSequenceKeypoint.new(1,0.1,0)};
				Speed = NumberRange.new(15,15);
				SpreadAngle = Vector2.new(360,360);
				Texture = "http://www.roblox.com/asset/?id=241685484]";
				Parent = part
			});
			local particle3 = utility.instance_new("ParticleEmitter", {
				Acceleration = Vector3.new(0,-10,0);
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.901961,1,0)),ColorSequenceKeypoint.new(1,Color3.new(1,0.933333,0))};
				Lifetime = NumberRange.new(1,2);
				Rate = 0;
				RotSpeed = NumberRange.new(260,260);
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.1,0),NumberSequenceKeypoint.new(1,0.1,0)};
				Speed = NumberRange.new(15,15);
				SpreadAngle = Vector2.new(360,360);
				Texture = "http://www.roblox.com/asset/?id=24168548";
				Parent = part
			});
			local particle4 = utility.instance_new("ParticleEmitter", {
				Acceleration = Vector3.new(0,-10,0);
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.180392,1,0)),ColorSequenceKeypoint.new(1,Color3.new(0.180392,1,0))};
				Lifetime = NumberRange.new(1,2);
				Rate = 0;
				RotSpeed = NumberRange.new(260,260);
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.1,0),NumberSequenceKeypoint.new(1,0.1,0)};
				Speed = NumberRange.new(15,15);
				SpreadAngle = Vector2.new(360,360);
				Texture = "http://www.roblox.com/asset/?id=241685484";
				Parent = part
			});
			local particle5 = utility.instance_new("ParticleEmitter", {
				Acceleration = Vector3.new(0,-10,0);
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,0,0)),ColorSequenceKeypoint.new(1,Color3.new(1,0,0))};
				Lifetime = NumberRange.new(1,2);
				Rate = 0;
				RotSpeed = NumberRange.new(260,260);
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.1,0),NumberSequenceKeypoint.new(1,0.1,0)};
				Speed = NumberRange.new(15,15);
				SpreadAngle = Vector2.new(360,360);
				Texture = "http://www.roblox.com/asset/?id=241685484";
				Parent = part
			});	
		end;

		local objects = part:GetChildren();

		for i = 1, #objects do
			local object = objects[i];

			if (object.ClassName ~= "ParticleEmitter") then continue end;

			object:Emit(1);
		end;

		task.delay(3, function()
			part:Destroy();
		end);
	end;
	
	hit_effects.bubble = function(position, color) --// credits to xander once again
		local part = utility.instance_new("Part", {
			Position = position,
			Anchored = true,
			Transparency = 1,
			CanCollide = false,
			Parent = workspace
		});
        
        local particle1 = utility.instance_new("ParticleEmitter", {
            Color = ColorSequence.new{ColorSequenceKeypoint.new(0,color),ColorSequenceKeypoint.new(1,color)};
            Lifetime = NumberRange.new(0.5,0.5);
            LightEmission = 1;
            LockedToPart = true;
            Orientation = Enum.ParticleOrientation.VelocityPerpendicular;
            Rate = 0;
            Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,10,0)};
            Speed = NumberRange.new(1.5,1.5);
            Texture = "rbxassetid://1084991215";
            Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.0996047,0,0),NumberSequenceKeypoint.new(0.602372,0,0),NumberSequenceKeypoint.new(1,1,0)};
            ZOffset = 1;
            Parent = part
        });
        local particle2 = utility.instance_new("ParticleEmitter", {
            Color = ColorSequence.new{ColorSequenceKeypoint.new(0,color),ColorSequenceKeypoint.new(1,color)};
            Lifetime = NumberRange.new(0.5,0.5);
            LightEmission = 1;
            LockedToPart = true;
            Rate = 0;
            Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,10,0)};
            Speed = NumberRange.new(0,0);
            Texture = "rbxassetid://1084991215";
            Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.0996047,0,0),NumberSequenceKeypoint.new(0.601581,0,0),NumberSequenceKeypoint.new(1,1,0)};
            ZOffset = 1;
            Parent = part
        });
        local particle3 = utility.instance_new("ParticleEmitter", {
            Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))};
            Lifetime = NumberRange.new(0.2,0.5);
            LockedToPart = true;
            Orientation = Enum.ParticleOrientation.VelocityParallel;
            Rate = 0;
            Rotation = NumberRange.new(-90,90);
            Size = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,8.5,1.5)};
            Speed = NumberRange.new(0.1,0.1);
            SpreadAngle = Vector2.new(180,180);
            Texture = "http://www.roblox.com/asset/?id=6820680001";
            Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.200791,0,0),NumberSequenceKeypoint.new(0.699605,0,0),NumberSequenceKeypoint.new(1,1,0)};
            ZOffset = 1.5;
            Parent = part
        });

		particle1:Emit(1);
		particle2:Emit(1);
        particle3:Emit(1);

		task.delay(1, function()
			part:Destroy();
		end);
	end;
end;

local features = {}; do
	features.local_material = function(state, material)
		local children = local_player.Character:GetDescendants();
		for i = 1, #children do
			local child = children[i];
			if (child.ClassName == "MeshPart") then
				child.Material = Enum.Material[state and material or "Plastic"];
			end;
		end;
	end;

	features.get_text = function(original_text)
        local args = {
            ["display_name"] = local_player.DisplayName,
            ["name"] = local_player.Name,
			["target_name"] = locals.target_aim.is_targetting and locals.target_aim.target.Name or "None"
        };

        for arg, name in args do
            original_text = original_text:gsub("%${" .. arg .. "}", name);
        end;

        return original_text
    end;

	features.update_c_sync_char = function(desynced_pos, color)
		if not instances.c_sync_chams then return end;
		if not utility.has_character(local_player) then return end;
		
		local parts = instances.c_sync_chams:GetChildren();
		local hrp = local_player.Character:FindFirstChild("HumanoidRootPart");
		
		if not hrp then return end;
		
		for i = 1, #parts do
			local part = parts[i];
			local actual_part = local_player.Character:FindFirstChild(part.Name);
			
			if not actual_part then continue end;
			if part.Name == "HumanoidRootPart" then continue end;
			
			if part.ClassName == "MeshPart" then
				part.CFrame = actual_part.CFrame;
				part.Anchored = true;
				part.CanCollide = false;
				part.Color = color;
			end;
		end;

		instances.c_sync_chams:SetPrimaryPartCFrame(desynced_pos);
	end;
end;

--// drawing objects
do
    --// assist
    do
        --// assist fov
        drawings["assist_fov_outside"] = utility.drawing_new("Circle", {
            Visible = false,
            Color = default_color,
            ZIndex = 9e9
        });

        drawings["assist_fov_inside"] = utility.drawing_new("Circle", {
            Visible = false,
            Filled = true,
            Color = default_color,
            ZIndex = 9e9
        });
    end;

    --// silent aim
    do
        --// silent fov
        drawings["silent_fov_outside"] = utility.drawing_new("Circle", {
            Visible = false,
            Color = default_color,
            ZIndex = 9e9
        });

        drawings["silent_fov_inside"] = utility.drawing_new("Circle", {
            Visible = false,
            Filled = true,
            Color = default_color,
            ZIndex = 9e9
        });

        --// target tracer
        drawings["silent_tracer"] = utility.drawing_new("Line", {
            Visible = false,
            Color = default_color,
            Thickness = 2
        });
    end;

    --// target aim
    do
        drawings["target_fov_outside"] = utility.drawing_new("Circle", {
            Visible = false,
            Color = default_color,
            ZIndex = 9e9
        });

        drawings["target_fov_inside"] = utility.drawing_new("Circle", {
            Visible = false,
            Filled = true,
            Color = default_color,
            ZIndex = 9e9
        });

        drawings["target_tracer"] = utility.drawing_new("Line", {
            Visible = false,
            Color = default_color,
            Thickness = 2
        });

		drawings["target_dot"] = utility.drawing_new("Circle", {
			Filled = true
		});
    end;

	--// c sync
	do
		drawings["c_sync_dot"] = utility.drawing_new("Circle", {
			Visible = false,
			Filled = true
		});

		drawings["c_sync_tracer"] = utility.drawing_new("Line", {
			Visible = false,
			Color = default_color,
			Thickness = 2
		})
	end;
end;

--// signals
do
	signals["target_target_changed"] = utility.create_connection("target_target_changed");
end;

--// instances
do
    --// target aim
    do
        instances["target_chams"] = utility.instance_new("Highlight", {
            FillColor = default_color,
            OutlineColor = default_color,
            OutlineTransparency = 0.5,
            FillTransparency = 0.5
        });
	end;
	
	--// local shit
	do
		instances["local_chams"] = utility.instance_new("Highlight", {
            FillColor = default_color,
            OutlineColor = Color3.new(0, 0, 0),
            OutlineTransparency = 0.5,
            FillTransparency = 0.5
        });

		instances["local_text"] = utility.instance_new("TextLabel", { 
			Name = "https://starhook.club",
			Parent = screen_gui_2,
			Text = '<font color="rgb(207, 227, 0)">starhook</font><font color="rgb(255, 255, 255)">.club</font>',
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextStrokeTransparency = 0.5,
			Font = Enum.Font.SourceSans,
			TextSize = 20,
			RichText = true
		});
	end;

    do
        instances["target_ui"]["frame"] = utility.instance_new("Frame", {
            Parent = screen_gui;
            BackgroundColor3 = Color3.fromRGB(13, 13, 13);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0.405395985, 0, 0.644607842, 0);
            Size = UDim2.new(0, 337, 0, 132);
        });

        instances["target_ui"]["ui_corner"] = utility.instance_new("UICorner", {
            Parent = instances["target_ui"]["frame"];
        });

        instances["target_ui"]["ui_stroke"] = utility.instance_new("UIStroke", {
            Parent = instances["target_ui"]["frame"];
            Color = Color3.fromRGB(50, 50, 50);
        });

        instances["target_ui"]["image"] = utility.instance_new("Frame", {
            Name = "Image";
            Parent = instances["target_ui"]["frame"];
            BackgroundColor3 = Color3.fromRGB(20, 20, 20);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0.0326409489, 0, 0.121212125, 0);
            Size = UDim2.new(0, 100, 0, 100);
        });

        instances["target_ui"]["main_image"] = utility.instance_new("ImageLabel", {
            Name = "MainImage";
            Parent = instances["target_ui"]["image"];
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1.0;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Size = UDim2.new(0, 100, 0, 100);
            Image = "rbxthumb://type=AvatarHeadShot&id=5038007184&w=420&h=420";
        });

        instances["target_ui"]["ui_corner_2"] = utility.instance_new("UICorner", {
            Parent = instances["target_ui"]["main_image"];
        });

        instances["target_ui"]["ui_corner_3"] = utility.instance_new("UICorner", {
            Parent = instances["target_ui"]["image"];
        });

        instances["target_ui"]["ui_stroke_2"] = utility.instance_new("UIStroke", {
            Parent = instances["target_ui"]["image"];
            Color = Color3.fromRGB(35, 35, 35);
        });

        instances["target_ui"]["info"] = utility.instance_new("Frame", {
            Name = "Info";
            Parent = instances["target_ui"]["frame"];
            BackgroundColor3 = Color3.fromRGB(20, 20, 20);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0.370919883, 0, 0.121212125, 0);
            Size = UDim2.new(0, 202, 0, 100);
        });

        instances["target_ui"]["ui_corner_4"] = utility.instance_new("UICorner", {
            Parent = instances["target_ui"]["info"];
        });

        instances["target_ui"]["ui_stroke_3"] = utility.instance_new("UIStroke", {
            Parent = instances["target_ui"]["info"];
            Color = Color3.fromRGB(35, 35, 35);
        });

        instances["target_ui"]["logo"] = utility.instance_new("ImageLabel", {
            Name = "Logo";
            Parent = instances["target_ui"]["info"];
            BackgroundColor3 = Color3.fromRGB(207, 227, 0);
            BackgroundTransparency = 1.0;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0.801597357, 0, -0.00666687032, 0);
            Size = UDim2.new(0, 40, 0, 40);
            Image = "http://www.roblox.com/asset/?id=18305816180";
        });

        instances["target_ui"]["player_name"] = utility.instance_new("TextLabel", {
            Name = "PlayerName";
            Parent = instances["target_ui"]["info"];
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1.0;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0.0597032607, 0, 0, 0);
            Size = UDim2.new(0, 115, 0, 39);
            Font = Enum.Font.Roboto;
            Text = "Linemaster";
            TextColor3 = Color3.fromRGB(255, 255, 255);
            TextScaled = true;
            TextSize = 27.0;
            TextStrokeTransparency = 0.0;
            TextWrapped = true;
        });

        instances["target_ui"]["health"] = utility.instance_new("Frame", {
            Name = "Health";
            Parent = instances["target_ui"]["info"];
            BackgroundColor3 = Color3.fromRGB(35, 35, 35);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0.0297029708, 0, 0.469999999, 0);
            Size = UDim2.new(0, 143, 0, 13);
        });

        instances["target_ui"]["ui_corner_5"] = utility.instance_new("UICorner", {
            Parent = instances["target_ui"]["health"];
        });

        instances["target_ui"]["health_inline"] = utility.instance_new("Frame", {
            Name = "HealthInline";
            Parent = instances["target_ui"]["health"];
            BackgroundColor3 = Color3.fromRGB(207, 227, 0);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(-0.00526097417, 0, 0.0769230798, 0);
            Size = UDim2.new(0, 143, 0, 12);
        });

        instances["target_ui"]["ui_corner_6"] = utility.instance_new("UICorner", {
            Parent = instances["target_ui"]["health_inline"];
        });

        instances["target_ui"]["armor"] = utility.instance_new("Frame", {
            Name = "Armor";
            Parent = instances["target_ui"]["info"];
            BackgroundColor3 = Color3.fromRGB(35, 35, 35);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0.0299999993, 0, 0.699999988, 0);
            Size = UDim2.new(0, 143, 0, 13);
        });

        instances["target_ui"]["ui_corner_7"] = utility.instance_new("UICorner", {
            Parent = instances["target_ui"]["armor"];
        });

        instances["target_ui"]["armor_inline"] = utility.instance_new("Frame", {
            Name = "ArmorInline";
            Parent = instances["target_ui"]["armor"];
            BackgroundColor3 = Color3.fromRGB(0, 140, 227);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(-0.00526097417, 0, 0.0769230798, 0);
            Size = UDim2.new(0, 143, 0, 12);
        });

        instances["target_ui"]["ui_corner_8"] = utility.instance_new("UICorner", {
            Parent = instances["target_ui"]["armor_inline"];
        });
    end;

	--// c sync
	do
		local cloned_char = utility.clone_character(local_player, 0.7, default_color, "Neon", false);
		cloned_char.PrimaryPart = cloned_char.HumanoidRootPart;
		cloned_char.HumanoidRootPart.CanCollide = false;
		instances["c_sync_chams"] = cloned_char
	end;
end;

--// connections
do
    --// addon library
    do
        script_addon.events["gun_activated"] = utility.create_connection("gun_activated");
    end;

	local dragging = false;

	--// target ui dragging
	utility.new_connection(user_input_service.InputBegan, function(input, is_typing)
		if (not (input.UserInputType == Enum.UserInputType.MouseButton1)) then return end;
		if (not (custom_math.is_mouse_over_frame(instances["target_ui"]["frame"]))) then return end;
		if ((flags["rage_target_aim_ui_mode"] ~= "Static")) then return end;

		dragging = true;
	end);

	utility.new_connection(user_input_service.InputEnded, function(input, is_typing)
		if (not (input.UserInputType == Enum.UserInputType.MouseButton1)) then return end;
		
		dragging = false;
	end);

	utility.new_connection(user_input_service.InputChanged, function(input)
		if (not (input.UserInputType == Enum.UserInputType.MouseMovement)) then return end;
		if (not (dragging)) then return end;

		local mouse_pos = user_input_service:GetMouseLocation();

		local tween_info = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
		local frame = instances["target_ui"]["frame"];

		local tween = tween_service:Create(frame, tween_info, {Position = UDim2.fromOffset(mouse_pos.X, mouse_pos.Y)});

		tween:Play();
	end);

    do
        --// assist connections
        utility.new_connection(run_service.RenderStepped, function()
            local assist_enabled = flags["legit_assist_enabled"];
            local stutter_enabled = flags["legit_assist_stutter_enabled"];
            local stutter_amount = flags["legit_assist_stutter_amount"];
            local actual_stutter_amount = (stutter_amount / 15);
            local fov_enabled = flags["legit_assist_settings_use_field_of_view"];
			
            if (assist_enabled and (locals.assist.is_targetting and locals.assist.target) and ((not stutter_enabled) or stutter_enabled and (tick() - locals.old_ticks.assist_stutter_tick >= actual_stutter_amount))) then
                local assist_type = flags["legit_assist_type"];
                local smoothing = flags["legit_assist_smoothing_amount"];
                local actual_smoothing = (1 / smoothing);
                local smoothing_enabled = flags["legit_assist_smoothing_enabled"];

                local position = assist.get_predicted_position();

                if (assist_type) == "Camera" then
                    camera.CFrame = smoothing_enabled and camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, position), actual_smoothing) or CFrame.new(camera.CFrame.Position, position); --// also please note that i wanted to use tweenservice but i hate tweenservice
                elseif (assist_type) == "Mouse" then
                    local screen_position = utility.world_to_screen(position);
                    local actual_smoothing_mouse = smoothing_enabled and smoothing or 7;
                    assist.move_mouse(screen_position.position, actual_smoothing_mouse);
                end;

                locals.old_ticks.assist_stutter_tick = tick();
            end;

            if (assist_enabled and fov_enabled) then
                local fov_radius = (flags["legit_assist_settings_field_of_view_radius"] * 3);
                local fov_color = flags["legit_assist_settings_field_of_view_color"];
                local fov_transparency = flags["legit_assist_settings_field_of_view_transparency"];

                --// outside fov
                drawings.assist_fov_outside.Visible = true;
                drawings.assist_fov_outside.Radius = fov_radius;
                drawings.assist_fov_outside.Color = fov_color;
                drawings.assist_fov_outside.Position = user_input_service:GetMouseLocation();

                --// inside
                drawings.assist_fov_inside.Visible = true;
                drawings.assist_fov_inside.Radius = fov_radius;
                drawings.assist_fov_inside.Color = fov_color;
                drawings.assist_fov_inside.Transparency = fov_transparency;
                drawings.assist_fov_inside.Position = user_input_service:GetMouseLocation();
            else
                if drawings.assist_fov_inside then
                    drawings.assist_fov_outside.Visible = false;
                    drawings.assist_fov_inside.Visible = false;
                end;
            end;
        end);
    end;

    --// silent aim connections
    do
        utility.new_connection(run_service.RenderStepped, function()
            --// settings
            local silent_enabled = flags["legit_silent_enabled"];
            local tracer_enabled = flags["legit_silent_aim_tracer_enabled"];
            local fov_enabled = flags["legit_silent_use_field_of_view"];
            local fov_visualize_enabled = flags["legit_silent_visualize_field_of_view"];
            local fov_radius = flags["legit_silent_field_of_view_radius"];
            local checks_enabled = flags["legit_silent_use_checks"];
            local check_values = flags["legit_silent_checks"];

            if (silent_enabled) then
                local new_target = combat.get_closest_player(fov_enabled, fov_radius, checks_enabled, check_values);

                if new_target ~= locals.silent_aim.target then
                    locals.silent_aim.target = new_target or nil;
                end;

                locals.silent_aim.is_targetting = new_target and true or false;
            end;

            if (silent_enabled and (locals.silent_aim.is_targetting and locals.silent_aim.target)) then
                locals.silent_aim.predicted_position = silent_aim.get_predicted_position();
            end;

            if (silent_enabled and (fov_enabled and fov_visualize_enabled)) then
                --// settings
                local fov_color = flags["legit_silent_field_of_view_color"];
				local fov_transparency = flags["legit_silent_field_of_view_transparency"];

                --// outside
                drawings.silent_fov_outside.Visible = true;
                drawings.silent_fov_outside.Radius = fov_radius * 3;
                drawings.silent_fov_outside.Color = fov_color;
                drawings.silent_fov_outside.Position = user_input_service:GetMouseLocation();

                --// inside
                drawings.silent_fov_inside.Visible = true;
                drawings.silent_fov_inside.Radius = fov_radius * 3;
                drawings.silent_fov_inside.Color = fov_color;
                drawings.silent_fov_inside.Transparency = fov_transparency;
                drawings.silent_fov_inside.Position = user_input_service:GetMouseLocation();
            else
                if drawings.silent_fov_inside.Visible then
                    drawings.silent_fov_outside.Visible = false;
                    drawings.silent_fov_inside.Visible = false;
                end;
            end;

            if (silent_enabled and (tracer_enabled) and (locals.silent_aim.is_targetting and locals.silent_aim.target)) then
                local mouse_position = user_input_service:GetMouseLocation();
                local predicted_position = utility.world_to_screen(game.PlaceId == hood_customs and locals.silent_aim.predicted_position - Vector3.new(25, 100, 25) or locals.silent_aim.predicted_position);
                local tracer_color = flags["legit_silent_aim_tracer_color"];
                local tracer_thickness = flags["legit_silent_aim_tracer_thickness"];
				local tracer_transparency = flags["legit_silent_aim_tracer_transparency"];

                drawings.silent_tracer.Visible = predicted_position.on_screen;
                drawings.silent_tracer.From = mouse_position;
                drawings.silent_tracer.To = predicted_position.position;
                drawings.silent_tracer.Color = tracer_color;
                drawings.silent_tracer.Transparency = tracer_transparency;
                drawings.silent_tracer.Thickness = tracer_thickness;
            else
                if drawings.silent_tracer.Visible then
                    drawings.silent_tracer.Visible = false;
                end;
            end;
        end);
    end;

    --// rage connections
    do
        --// target aim connections
        do
            utility.new_connection(run_service.Heartbeat, function()
                local target_aim_enabled = flags["rage_target_aim_enabled"];
                local fov_enabled = flags["rage_target_aim_use_field_of_view"];
                local fov_radius = flags["rage_target_aim_field_of_view_radius"];
                local visualize_fov = flags["rage_target_aim_visualize_field_of_view"];
                local visuals_enabled = flags["rage_target_aim_visuals_enabled"];
                local tracer_enabled = flags["rage_target_aim_tracer_enabled"];
                local chams_enabled = flags["rage_target_aim_chams_enabled"];
				local fov_transparency = flags["rage_target_aim_field_of_view_transparency"];
				local dot_enabled = flags["rage_target_aim_dot_enabled"];
				local auto_shoot_enabled = flags["rage_target_aim_auto_shoot"];		
				local look_at_enabled = flags["rage_target_aim_look_at"];
				local ui_enabled = flags["rage_target_aim_visuals_ui_enabled"];
				local ui_type = flags["rage_target_aim_ui_mode"];

				local target = locals.target_aim.target;
				local is_targetting = locals.target_aim.is_targetting;

                if (target_aim_enabled and (is_targetting and target)) then
                    locals.target_aim.predicted_position = target_aim.get_predicted_position();
                end;
				
                if (target_aim_enabled and (fov_enabled and visualize_fov)) then
                    --// settings
                    local fov_color = flags["rage_target_aim_field_of_view_color"];

                    --// outside
                    drawings.target_fov_outside.Visible = true;
                    drawings.target_fov_outside.Radius = fov_radius * 3;
                    drawings.target_fov_outside.Color = fov_color;
                    drawings.target_fov_outside.Position = user_input_service:GetMouseLocation();

                    --// inside
                    drawings.target_fov_inside.Visible = true;
                    drawings.target_fov_inside.Radius = fov_radius * 3;
                    drawings.target_fov_inside.Color = fov_color;
                    drawings.target_fov_inside.Transparency = fov_transparency;
                    drawings.target_fov_inside.Position = user_input_service:GetMouseLocation();
                else
                    if drawings.target_fov_outside.Visible then
                        drawings.target_fov_outside.Visible = false;
                        drawings.target_fov_inside.Visible = false;
                    end;
                end;

				if (target_aim_enabled and (visuals_enabled and ui_enabled) and (is_targetting and target and utility.has_character(target))) then
					local screen_pos = utility.world_to_screen(target.Character.HumanoidRootPart.Position);
					
					if (ui_type == "Follow") then
						local tween_info = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0);
						local tween = tween_service:Create(instances["target_ui"]["frame"], tween_info, {Position = UDim2.fromOffset(screen_pos.position.X, screen_pos.position.Y)});
						tween:Play();
					end;
				
					local health_inline = instances["target_ui"]["health_inline"];
					local armor_inline = instances["target_ui"]["armor_inline"];

					local health_percent = target.Character.Humanoid.Health / target.Character.Humanoid.MaxHealth;
					health_inline.Size = UDim2.new(health_percent, 0, 1, 0);

					local armor_percent = dahood.get_armor(target) / 100;
					armor_inline.Size = UDim2.new(armor_percent, 0, 1, 0);
				end;

				if (target_aim_enabled and (visuals_enabled and dot_enabled) and (is_targetting and target) and utility.has_character(target)) then
                    local predicted_position = utility.world_to_screen(game.PlaceId == hood_customs and locals.target_aim.predicted_position - Vector3.new(25, 100, 25) or locals.target_aim.predicted_position);
                    local dot_color = flags["rage_target_aim_dot_color"];
					local dot_size = flags["rage_target_aim_dot_size"];

                    drawings.target_dot.Visible = predicted_position.on_screen;
                    drawings.target_dot.Position = predicted_position.position;
                    drawings.target_dot.Color = dot_color;
                    drawings.target_dot.Radius = dot_size;
                else
                    if drawings.target_dot.Visible then
                        drawings.target_dot.Visible = false;
                    end;
                end;

                if (target_aim_enabled and (visuals_enabled and tracer_enabled) and (is_targetting and target) and utility.has_character(target)) then
                    local mouse_position = user_input_service:GetMouseLocation();
                    local predicted_position = utility.world_to_screen(game.PlaceId == hood_customs and locals.target_aim.predicted_position - Vector3.new(25, 100, 25) or locals.target_aim.predicted_position);
                    local tracer_color = flags["rage_target_aim_tracer_color"];
                    local tracer_thickness = flags["rage_target_aim_tracer_thickness"];

                    drawings.target_tracer.Visible = predicted_position.on_screen;
                    drawings.target_tracer.From = mouse_position;
                    drawings.target_tracer.To = predicted_position.position;
                    drawings.target_tracer.Color = tracer_color;
                    drawings.target_tracer.Thickness = tracer_thickness;
                else
                    if drawings.target_tracer.Visible then
                        drawings.target_tracer.Visible = false;
                    end;
                end;

                if (target_aim_enabled and (visuals_enabled and chams_enabled) and (is_targetting and target) and utility.has_character(target)) then
                    local fill_color = flags["rage_target_aim_chams_fill_color"];
                    local outline_color = flags["rage_target_aim_chams_outline_color"];

                    instances.target_chams.Parent = target.Character;
                    instances.target_chams.OutlineColor = outline_color;
                    instances.target_chams.FillColor = fill_color;
                else
                    instances.target_chams.Parent = nil;
                end;

				if ((target_aim_enabled and look_at_enabled) and (is_targetting and target and utility.has_character(target))) then
                    local_player.Character.HumanoidRootPart.CFrame = CFrame.new(local_player.Character.HumanoidRootPart.CFrame.Position, Vector3.new(target.Character.HumanoidRootPart.CFrame.X, local_player.Character.HumanoidRootPart.CFrame.Position.Y, target.Character.HumanoidRootPart.CFrame.Z));
                end;

				if (target_aim_enabled and auto_shoot_enabled and (is_targetting and target) and utility.has_character(target) and locals.gun.current_tool and (tick() - locals.old_ticks.auto_shoot_tick >= 0.1)) then
					local is_behind_wall = utility.is_player_behind_a_wall(target);
					local is_knocked = dahood.is_knocked(target);

					if (not is_behind_wall or is_knocked) then
						locals.gun.current_tool:Activate();
					end;

					locals.old_ticks.auto_shoot_tick = tick();
				end;
			end);

            utility.new_connection(run_service.Heartbeat, function()
                local target_aim_enabled = flags["rage_target_aim_enabled"];
                local target_aim_teleport_enabled = flags["rage_target_aim_teleport_enabled"];
                local target_aim_teleport_keybind_active = flags["rage_target_aim_teleport_keybind"];
                local target_aim_teleport_destroy_cheaters_bypass = flags["rage_target_aim_bypass_destroy_cheaters"];
				local target = locals.target_aim.target;
				local is_targetting = locals.target_aim.is_targetting;

                if ((target_aim_enabled and target_aim_teleport_enabled and target_aim_teleport_keybind_active) and (is_targetting and target and utility.has_character(target)) and (not target_aim_teleport_destroy_cheaters_bypass or target_aim_teleport_destroy_cheaters_bypass and target.Character.HumanoidRootPart.CFrame.Position.Y >= -10000)) then
                    local target_aim_teleport_type = flags["rage_target_aim_teleport_type"];
                    local target_aim_teleport_randomization = flags["rage_target_aim_teleport_randomization"];
                    local target_aim_teleport_strafe_speed = flags["rage_target_aim_teleport_strafe_speed"];
                    local target_aim_teleport_strafe_distance = flags["rage_target_aim_teleport_strafe_distance"];
                    local target_aim_teleport_strafe_height = flags["rage_target_aim_teleport_strafe_height"];

                    local cframe;

                    if (target_aim_teleport_type == "Random") then
                        cframe = target.Character.HumanoidRootPart.CFrame + custom_math.random_vector3(target_aim_teleport_randomization);
                    elseif (target_aim_teleport_type == "Strafe") then
                        local current_time = tick();
                        cframe = CFrame.new(target.Character.HumanoidRootPart.Position) * CFrame.Angles(0, 2 * math.pi * current_time * target_aim_teleport_strafe_speed % (2 * math.pi), 0) * CFrame.new(0, target_aim_teleport_strafe_height, target_aim_teleport_strafe_distance);
                    end;

                    local_player.Character.HumanoidRootPart.CFrame = cframe;
                end;
            end);

			--// target changed connection
			utility.new_connection(signals.target_target_changed, function(target, is_targetting)
				local spectate_enabled = flags["rage_target_aim_spectate"];
				local notify_enabled = flags["rage_target_aim_notify"];
				local notify_duration = flags["rage_target_aim_notify_duration"];
				local ui_enabled = flags["rage_target_aim_visuals_ui_enabled"];

				if (spectate_enabled and (target and is_targetting)) then
					camera.CameraSubject = target.Character.Humanoid;
				else
					camera.CameraSubject = local_player.Character.Humanoid;
				end;

				if (notify_enabled) then
					local message = is_targetting and string.format("Targeting %s", target.DisplayName) or "Untargeting";
					library:Notification(message, notify_duration);
				end;

				if (ui_enabled) then
					screen_gui.Enabled = is_targetting;
					instances["target_ui"]["player_name"].Text = is_targetting and target.DisplayName or "None";
					instances["target_ui"]["main_image"].Image = is_targetting and players:GetUserThumbnailAsync(target.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) or "rbxassetid://111122112";
				end;
			end);
        end;

        --// misc rage
        do
            utility.new_connection(run_service.Heartbeat, function(delta_time)
                local cframe_speed_enabled = flags["rage_cframe_speed_enabled"];
                local cframe_speed_keybind = flags["rage_cframe_speed_keybind"];
                local no_jump_cooldown = flags["rage_misc_movement_no_jump_cooldown"];
				local cframe_fly_enabled = flags["rage_cframe_fly_enabled"];
				local cframe_fly_keybind = flags["rage_cframe_fly_keybind"];
				local cframe_fly_speed = flags["rage_cframe_fly_amount"];

                if ((cframe_speed_enabled and cframe_speed_keybind) and utility.has_character(local_player)) then
                    local speed = flags["rage_cframe_speed_amount"];
                    local root_part = local_player.Character.HumanoidRootPart;
                    local humanoid = local_player.Character.Humanoid;

                    root_part.CFrame = root_part.CFrame + humanoid.MoveDirection * speed;
                end;

				if (cframe_fly_enabled and cframe_fly_keybind and utility.has_character(local_player)) then --// credits to xander
					local move_direction = local_player.Character.Humanoid.MoveDirection;
					local hrp = local_player.Character.HumanoidRootPart;

					local add = Vector3.new(0, (user_input_service:IsKeyDown(Enum.KeyCode.Space) and cframe_fly_speed /  8 or user_input_service:IsKeyDown(Enum.KeyCode.LeftShift) and -cframe_fly_speed / 8) or 0, 0);

					hrp.CFrame = hrp.CFrame + (move_direction * delta_time) * cframe_fly_speed * 10;
					hrp.CFrame = hrp.CFrame + add;
					hrp.Velocity = (hrp.Velocity * Vector3.new(1, 0, 1)) + Vector3.new(0, 1.9, 0);
				end;

                if (no_jump_cooldown and utility.has_character(local_player)) then
                    local_player.Character.Humanoid.UseJumpPower = false;
                end;
            end);
        end;

		--// visuals
		do
			utility.new_connection(run_service.Heartbeat, function()
				local clone_chams_enabled = flags["visuals_clone_chams_enabled"];
				local clone_chams_duration = flags["visuals_clone_chams_duration"]
				local local_player_chams_enabled = flags["visuals_player_chams_enabled"];
				local local_player_chams_fill_color = flags["visuals_player_chams_fill_color"];
				local local_player_chams_outline_color = flags["visuals_player_chams_outline_color"];

				if (clone_chams_enabled and (tick() - locals.old_ticks.clone_chams_tick >= clone_chams_duration)) then
					locals.old_ticks.clone_chams_tick = tick();

					local players_apply = {
						["Local Player"] = local_player,
						["Target Aim Target"] = locals.target_aim.target
					};
				
					local to_apply_table = flags["visuals_clone_chams_to_apply"]

					for i = 1, #to_apply_table do
						local to_apply = to_apply_table[i];
						local player = players_apply[to_apply];
						if (player) then
							local color = flags["visuals_clone_chams_color"];
							local transparency = flags["visuals_clone_chams_transparency"];

							local model = utility.clone_character(player, transparency, color, "ForceField", true<);
							
							task.delay(clone_chams_duration, function()
								model:Destroy();
							end);
						end;
					end;
				end;

				if (local_player_chams_enabled and utility.has_character(local_player)) then
					instances.local_chams.Parent = local_player.Character
					instances.local_chams.FillColor = local_player_chams_fill_color;
					instances.local_chams.OutlineColor = local_player_chams_outline_color;
				else
					instances.local_chams.Parent = nil
				end;
			end);

			utility.new_connection(run_service.Heartbeat, function()
				local enabled = flags["visuals_text_enabled"];
				local color = flags["visuals_text_color"]:ToHex();
				local cursor_offset_y = flags["visuals_text_cursor_offset"];
				local custom_text = flags["visuals_cursor_custom_text_text"];
				local custom_text_enabled = flags["visuals_text_custom_text"];

				if (enabled) then
					screen_gui_2.Enabled = true;
					local text_label = instances["local_text"];
					local mouse_position = user_input_service:GetMouseLocation();
					local actual_color = `#{color}`;
					local text_color = actual_color ~= "#nil" and actual_color or "#cfe300";

					local text = custom_text_enabled and '<font color="' .. text_color .. '">' .. features.get_text(custom_text) .. '</font>' or '<font color="' .. text_color .. '">starhook</font><font color="rgb(255, 255, 255)">.club</font>';
					text_label.Text = text;
					text_label.Position = UDim2.new(0, mouse_position.X, 0, mouse_position.Y + cursor_offset_y);
				else
					screen_gui_2.Enabled = false;
				end;
			end);
		end;

		--// anti aim
		do
			--// velocity spoofer
			utility.new_connection(run_service.Heartbeat, function()
				local enabled = flags["anti_aim_velocity_spoofer_enabled"];
				local keybind = flags["anti_aim_velocity_spoofer_keybind"];

				if (enabled and keybind and utility.has_character(local_player)) then
					local type = flags["anti_aim_velocity_spoofer_type"];

					local hrp = local_player.Character.HumanoidRootPart
					local old_velocity = hrp.Velocity;
					
					local new_velocity;

					if (type == "Local Strafe") then
						local strafe_speed = flags["anti_aim_velocity_spoofer_strafe_speed"];
						local strafe_distance = flags["anti_aim_velocity_spoofer_strafe_distance"] * 10;
                        local current_time = tick();

						new_velocity = Vector3.new(math.cos(2 * math.pi * current_time * strafe_speed % (2 * math.pi)) * strafe_distance, 0, math.sin(2 * math.pi * current_time * strafe_speed % (2 * math.pi)) * strafe_distance)
					elseif (type == "Static") then
						local x = flags["anti_aim_velocity_spoofer_static_x"];
						local y = flags["anti_aim_velocity_spoofer_static_y"];
						local z = flags["anti_aim_velocity_spoofer_static_z"];
						
						new_velocity = Vector3.new(x, y, z);
					elseif (type == "Random") then
						local randomization = flags["anti_aim_velocity_spoofer_randomization"];

						new_velocity = custom_math.random_vector3(randomization * 1000); 
					end;

					hrp.Velocity = new_velocity;
					run_service.RenderStepped:Wait();
					hrp.Velocity = old_velocity;
				end;
			end);

			--// network desync
			utility.new_connection(run_service.Heartbeat, function()
				local enabled = flags["anti_aim_network_desync_enabled"];
				local amount = flags["anti_aim_network_desync_amount"];

				if (enabled and ((tick() - locals.old_ticks.network_desync_tick) >= (amount / 1000))) then
					locals.network_should_sleep = not locals.network_should_sleep;
					sethiddenproperty(local_player.Character.HumanoidRootPart, "NetworkIsSleeping", locals.network_should_sleep);
					locals.old_ticks.network_desync_tick = tick();
				end;
			end);

			--// csynchoronioastions 🔥
			utility.new_connection(run_service.Heartbeat, function()
				local enabled = flags["anti_aim_c_sync_enabled"];
				local keybind = flags["anti_aim_c_sync_keybind"];
				local c_sync_type = flags["anti_aim_c_sync_type"];
				local static_x = flags["anti_aim_c_sync_static_x"];
				local static_y = flags["anti_aim_c_sync_static_y"];
				local static_z = flags["anti_aim_c_sync_static_z"];
				local randomization = flags["anti_aim_c_sync_randomization"];
				local visualize_enabled = flags["anti_aim_c_sync_visualize_enabled"];
				local visualize_types = flags["anti_aim_c_sync_visualize_types"];
				local visualize_color = flags["anti_aim_c_sync_visualize_color"];
				local visualize_dot_size = flags["anti_aim_c_sync_dot_size"];

				--// starhook classics
				local classics_enabled = flags["anti_aim_starhook_classics_enabled"];
				local classics_keybind = flags["anti_aim_starhook_classics_keybind"];
				local classics_types = flags["anti_aim_starhook_classics"];

				if ((enabled or classics_enabled) and (keybind or classics_keybind) and (not (classics_keybind and classics_enabled and classics_types == "supercoolboi34 Destroyer") or (classics_keybind and classics_enabled and classics_types == "supercoolboi34 Destroyer"))) then
					local hrp = local_player.Character.HumanoidRootPart;

					local spoofed_cframe = hrp.CFrame;

					local is_targetting = (locals.target_aim.is_targetting and locals.target_aim.target);

					local types = {
						["Static Local"] = hrp.CFrame + Vector3.new(static_x, static_y, static_z),
						["Static Target"] = is_targetting and locals.target_aim.target.Character.HumanoidRootPart.CFrame + Vector3.new(static_x, static_y, static_z) or hrp.CFrame,
						["Local Random"] = hrp.CFrame + custom_math.random_vector3(randomization),
						["Target Random"] = is_targetting and locals.target_aim.target.Character.HumanoidRootPart.CFrame + custom_math.random_vector3(randomization) or hrp.CFrame,
						["Destroy Cheaters"] = hrp.CFrame + Vector3.new(0 / 0, 1, math.huge),
						["supercoolboi34 Destroyer"] = locals.should_starhook_destroy and hrp.CFrame + Vector3.new(0 / 0, 1, math.huge) or hrp.CFrame
					};
					
					local desync_type = (classics_enabled and classics_keybind and (classics_types == "Destroy Cheaters" and types["Destroy Cheaters"] or classics_types == "supercoolboi34 Destroyer" and types["supercoolboi34 Destroyer"] or types[classics_types])) or (enabled and keybind and types[c_sync_type]);
					

					locals.original_position = hrp.CFrame;

					if (visualize_enabled and table.find(visualize_types, "Tracer") and typeof(desync_type) == "CFrame") then
						local hrp_pos = utility.world_to_screen(hrp.Position);
						local desynced_pos = utility.world_to_screen(desync_type.Position);

						drawings.c_sync_tracer.Visible = true;
						drawings.c_sync_tracer.From = Vector2.new(hrp_pos.position.X, hrp_pos.position.Y);
						drawings.c_sync_tracer.To = Vector2.new(desynced_pos.position.X, desynced_pos.position.Y);
						drawings.c_sync_tracer.Color = visualize_color;
					else
						drawings.c_sync_tracer.Visible = false;
					end;

					if (visualize_enabled and table.find(visualize_types, "Dot") and typeof(desync_type) == "CFrame") then
						local desynced_pos = utility.world_to_screen(desync_type.Position);

						drawings.c_sync_dot.Visible = true;
						drawings.c_sync_dot.Color = visualize_color;
						drawings.c_sync_dot.Position = desynced_pos.position;
						drawings.c_sync_dot.Radius = visualize_dot_size;
					else
						drawings.c_sync_dot.Visible = false;
					end;

					if (visualize_enabled and table.find(visualize_types, "Character") and typeof(desync_type) == "CFrame") then
						instances.c_sync_chams.Parent = workspace;
						features.update_c_sync_char(desync_type, visualize_color);
					else
						if instances.c_sync_chams.Parent ~= nil then
							instances.c_sync_chams.Parent = nil;
						end;
					end;
					
					hrp.CFrame = desync_type;

					run_service.RenderStepped:Wait();
					hrp.CFrame = locals.original_position;
				else
					if instances.c_sync_chams.Parent ~= nil then
						instances.c_sync_chams.Parent = nil;
					end;
					drawings.c_sync_tracer.Visible = false;
					drawings.c_sync_dot.Visible = false;
				end;
			end);

			task.spawn(function()
				while task.wait(0.1) do
					locals.should_starhook_destroy = not locals.should_starhook_destroy;
				end;
			end);

			--// invis desync
			--[[utility.new_connection(run_service.Heartbeat, function()
				local classics_enabled = flags["anti_aim_starhook_classics_enabled"];
				local classics_keybind = flags["anti_aim_starhook_classics_keybind"];
				local classics_types = flags["anti_aim_starhook_classics"];

				if ((classics_enabled and classics_keybind) and classics_types == "Revert Desync") then

				end;
			end);--]]
		end;
    end;

	--// rocket tp

	if (table.find(dahood_ids, game.PlaceId)) then
		utility.new_connection(workspace.Ignored.ChildAdded, function(object)
			if (flags["rage_target_aim_enabled"] and flags["rage_target_aim_rocket_tp_enabled"] and (locals.target_aim.is_targetting and locals.target_aim.target) and utility.has_character(locals.target_aim.target) and (object.Name == "Model" or object.Name == "GrenadeLauncherAmmo")) then
				local is_grenade_launcher = object.Name == "GrenadeLauncherAmmo";
				local target = locals.target_aim.target;

				local part = is_grenade_launcher and object:WaitForChild("Main") or object:WaitForChild("Launcher");
		
				part.CFrame = CFrame.new(1, 1, 1);

				if (not is_grenade_launcher) then
					part.BodyVelocity:Destroy();
					part.TouchInterest:Destroy();
				end;
		
				local connection = utility.new_connection(run_service.Heartbeat, function()
					if ((locals.target_aim.is_targetting and target) and utility.has_character(target)) then
						part.CFrame = target.Character.HumanoidRootPart.CFrame;
						part.Velocity = Vector3.new(0, 0.001, 0);
					end;
				end);

				utility.new_connection(object.Destroying, function()
					connection:Disconnect();
				end);
			end;
		end);
	end;

    --// gun connections
    do
		local get_closest_player = function(radius, position)
			local actual_radius = radius;
			local closest_player;

			local all_players = players:GetPlayers();

			for i = 1, #all_players do
				local player = all_players[i];

				if (player == local_player) then continue end;

				if (not (utility.has_character(player))) then continue end;

				local hrp = player.Character.HumanoidRootPart;
				local distance = (hrp.Position - position).Magnitude;

				if (distance <= actual_radius) then
					actual_radius = distance;
					closest_player = player;
				end;
			end;

			return closest_player;
		end;

        local add_character = function(character)
            --// main child added connection
            utility.new_connection(character.ChildAdded, function(object)
                local gun = dahood.get_gun(local_player);

                if (not (gun)) then return end;

                if object == gun.tool then
					connections.gun["activated"] = utility.new_connection(gun.tool.Activated, function()
                        script_addon.events["gun_activated"]:Fire();

                        if (flags["legit_silent_enabled"] and flags["legit_silent_anti_aim_viewer"] and (locals.silent_aim.is_targetting and locals.silent_aim.target)) then
                            remote:FireServer(mouse_argument, locals.silent_aim.predicted_position);
                        end;

						if (flags["legit_silent_enabled"] and not flags["legit_silent_anti_aim_viewer"] and (locals.silent_aim.is_targetting and locals.silent_aim.target)) then
                            remote:FireServer(mouse_argument, locals.silent_aim.predicted_position);
						end;
			
						if (flags["rage_target_aim_enabled"] and (locals.target_aim.is_targetting and locals.target_aim.target)) then
							remote:FireServer(mouse_argument, locals.target_aim.predicted_position);
						end;
                    end);


                    connections.gun["shot"] = utility.new_connection(gun.ammo.Changed, function()
                        local new_ammo = gun.ammo.Value;
                        if (new_ammo < locals.gun.previous_ammo) then
                            locals.gun.recently_shot = true;
                            task.wait();
                            locals.gun.recently_shot = false;
                        end;

                        locals.gun.previous_ammo = gun.ammo.Value;
                    end);
                end;

                locals.gun.current_tool = gun.tool;
            end);

            --// main child removed connection
            utility.new_connection(character.ChildRemoved, function(object)
                if object == locals.gun.current_tool then

					local gun_connections = connections.gun;
                    for i = 1, #gun_connections do
						local connection = gun_connections[i];
                        connection:Disconnect();
                    end;

					connections.gun = {};
					locals.gun.previous_ammo = 999;
					locals.gun.current_tool = nil;
                end;
            end);
        end;

        utility.new_connection(local_player.CharacterAdded, function(character)
            add_character(character);

			character:WaitForChild("Humanoid");
			
			local material = flags["visuals_player_material_type"];
			local material_enabled = flags["visuals_player_material_enabled"];

			features.local_material(material_enabled, material);
        end);

        add_character(local_player.Character);

        --// main bullets
        if (bullet_path) then
            child_added = utility.new_connection(bullet_path.ChildAdded, function(object)
                if object.name == bullet_name and locals.gun.recently_shot then
                    local gun_beam = object:WaitForChild(bullet_beam_name);
                    local start_pos, end_pos = object.Position, gun_beam.Attachment1.WorldPosition;

                    local bullet_tracers_enabled = flags["visuals_bullet_tracers_enabled"];
                    local bullet_impacts_enabled = flags["visuals_bullet_impacts_enabled"];
                    local hit_detection_enabled = flags["visuals_hit_detection_enabled"];

                    if (bullet_tracers_enabled) then
                        gun_beam:Destroy();
                        local gradient_color_1 = flags["visuals_bullet_tracers_color_gradient_1"];
                        local gradient_color_2 = flags["visuals_bullet_tracers_color_gradient_2"];
                        local duration = flags["visuals_bullet_tracers_duration"];
                        local fade_enabled = flags["visuals_bullet_tracers_fade_enabled"];
                        local fade_duration = flags["visuals_bullet_tracers_fade_duration"];
                        
                        utility.create_beam(start_pos, end_pos, gradient_color_1, gradient_color_2, duration, fade_enabled, fade_duration);
                    end;

                    if (bullet_impacts_enabled) then
                        local color_picker = flags["visuals_bullet_impacts_color"];
                        local size = flags["visuals_bullet_impacts_size"];
                        local duration = flags["visuals_bullet_impacts_duration"];
                        local fade_enabled = flags["visuals_bullet_impacts_fade_enabled"];
                        local fade_duration = flags["visuals_bullet_impacts_fade_duration"];
                        local color = color_picker;

                        utility.create_impact(color, size, fade_enabled, fade_duration, duration, end_pos);
                    end;

                    if (hit_detection_enabled) then
                        local player = get_closest_player(10, end_pos);
						
                        task.wait();

						local has_blood_splatter, part = dahood.has_blood_splatter(player);

                        if (not (has_blood_splatter)) then return end;

						local hit_sounds_enabled = flags["visuals_hit_detection_sounds_enabled"];
						local sound_to_play = flags["visuals_hit_detection_sounds_which_sound"];
						local sound_volume = flags["visuals_hit_detection_sounds_volume"];
						local chams_enabled = flags["visuals_hit_detection_chams_enabled"];
						local chams_color = flags["visuals_hit_detection_chams_color"];
						local chams_transparency = flags["visuals_hit_detection_chams_transparency"];
						local chams_duration = flags["visuals_hit_detection_chams_duration"];
						local effects_enabled = flags["visuals_hit_detection_effects_enabled"];
						local effects_color = flags["visuals_hit_detection_effects_color"];
						local effects_which = flags["visuals_hit_detection_effects_which_effect"];
						local notifications_enabled = flags["visuals_hit_detection_notification"];
						local notifications_duration = flags["visuals_hit_detection_notification_duration"];

						if (hit_sounds_enabled) then
							local sound = hitsounds[sound_to_play];
							utility.play_sound(sound_volume, sound);
						end;

						if (chams_enabled) then
							local new_character = utility.clone_character(player, chams_transparency, chams_color, "Neon");

							task.delay(chams_duration, function()
								new_character:Destroy();
							end);
						end;

						if (effects_enabled) then

							if (effects_which == "Bubble") then
								hit_effects.bubble(player.Character.HumanoidRootPart.Position, effects_color);
							elseif (effects_which == "Confetti") then
								hit_effects.confetti(player.Character.HumanoidRootPart.Position)
							end;

						end;

						if (notifications_enabled) then
							library:Notification(string.format("Hit %s in %s", player.DisplayName, part.Name), notifications_duration);
						end;
					end;
                end;
            end);
        end;
    end;
end;

if (ESP) then
	local esp = {}; do
		esp.players = {};
	
		esp.add_player = function(player)
			local new_esp = {
				box_outline = utility.drawing_new("Square", {
					Thickness = 3,
					Filled = false,
					Visible = false
				}),
				box_inline = utility.drawing_new("Square", {
					Thickness = 1,
					Filled = false,
					Visible = false
				}),
				name = utility.drawing_new("Text", {
					Outline = true,
					Center = true,
					Size = 13,
					Visible = false
				}),
				head_dot_outline = utility.drawing_new("Circle", {
					Radius = 10,
					Thickness = 3,
					Visible = false,
					Color = Color3.new(0, 0, 0)
				}),
				head_dot_inline = utility.drawing_new("Circle", {
					Radius = 10,
					Thickness = 1,
					Visible = false
				}),
				health_bar_outline = utility.drawing_new("Line", {
					Thickness = 3,
					Visible = false,
					Color = Color3.new(0, 0, 0)
				}),
				health_bar_inline = utility.drawing_new("Line", {
					Thickness = 1,
					Visible = false
				}),
				health_text = utility.drawing_new("Text", {
					Color = Color3.new(1, 1, 1),
					Size = 12,
					Outline = true,
					Center = true
				}),
				armor_bar_outline = utility.drawing_new("Line", {
					Thickness = 3,
					Visible = false,
					Color = Color3.new(0, 0, 0)
				}),
				armor_bar_inline = utility.drawing_new("Line", {
					Thickness = 1,
					Visible = false
				})
			};
			
			esp.players[player] = new_esp;
		end;
		
		esp.remove_player = function(player)			
			for _, drawing in esp.players[player] do
				drawing:Remove();
			end;

			esp.players[player] = nil;
		end;
		
		utility.new_connection(players.PlayerAdded, function(player)
			esp.add_player(player);
		end);
		
		utility.new_connection(players.PlayerRemoving, function(player)
			esp.remove_player(player);
		end);
		
		local all_players = players:GetPlayers();
		
		for i = 1, #all_players do
			local player = all_players[i];
			
			if (player == local_player) then continue end;
			
			esp.add_player(player);
		end;
		
		utility.new_connection(run_service.Heartbeat, function()
			--// Settings
			local esp_enabled = flags["visuals_esp_enabled"];
			local boxes_enabled = flags["visuals_esp_boxes_enabled"];
			local boxes_color = flags["visuals_esp_boxes_color"];
			local names_enabled = flags["visuals_esp_names_enabled"];
			local names_color = flags["visuals_esp_names_color"];
			local head_dots_enabled = flags["visuals_esp_head_dots_enabled"];
			local head_dots_color = flags["visuals_esp_head_dots_color"];
			local head_dots_sides = flags["visuals_esp_head_dots_sides"];
			local head_dots_size = flags["visuals_esp_head_dots_size"];
			local health_bar_enabled = flags["visuals_esp_health_bar_enabled"];
			local health_bar_health_based_color = flags["visuals_esp_health_bar_health_based_color"];
			local health_bar_color = flags["visuals_esp_health_bar_color"]
			local health_text_enabled = flags["visuals_esp_health_text_enabled"];
			local health_text_color = flags["visuals_esp_health_text_color"];
			local health_text_health_based_color = flags["visuals_esp_health_text_health_based_color"];
			local armor_bar_enabled = flags["visuals_esp_armor_bar_enabled"];
			local armor_bar_color = flags["visuals_esp_armor_bar_color"];
			local boxes_target_color_enabled = flags["visuals_esp_boxes_target_color_enabled"];
			local boxes_target_color = flags["visuals_esp_boxes_target_color"];

			local players = esp.players;
	
			for player, esp in players do
				if (not (utility.has_character(player))) then continue end;
				
				local character = player.Character;
				local hrp = character:FindFirstChild("HumanoidRootPart");
				local head = character:FindFirstChild("Head");
	
				if (not (hrp)) then continue end;
				if (not (head)) then continue end;
	
				local screen_pos = utility.world_to_screen(hrp.Position);
				local screen_pos_head = utility.world_to_screen(head.Position);
	
				local adjust_x = screen_pos.position.X - (esp.box_inline.Size.X / 2);
				local adjust_y = screen_pos.position.Y - (esp.box_inline.Size.Y / 2);
	
				local scale = 1000 / (camera.CFrame.Position - hrp.Position).Magnitude;
				
				local box_position = Vector2.new(adjust_x, adjust_y);
				local box_size = Vector2.new(3 * scale, 4.5 * scale);
				
				local outline_offset = -2;
				local box_outline_size = Vector2.new(box_size.X + outline_offset, box_size.Y + outline_offset);
				local box_outline_position = Vector2.new(adjust_x - (outline_offset / 2), adjust_y - (outline_offset / 2));
				
				local target = locals.target_aim.target;
				local is_targetting = locals.target_aim.is_targetting;

				if (esp_enabled and boxes_enabled and screen_pos.on_screen) then
					esp.box_outline.Size = box_outline_size;
					esp.box_outline.Position = box_outline_position;
					esp.box_inline.Size = box_size;
					esp.box_inline.Position = box_position;
					esp.box_inline.Color = (boxes_target_color_enabled and is_targetting and target == player) and boxes_target_color or boxes_color;
					esp.box_inline.Visible = true;
					esp.box_outline.Visible = true;
				else
					esp.box_inline.Visible = false;
					esp.box_outline.Visible = false;
				end;
				
				if (esp_enabled and names_enabled and screen_pos.on_screen) then
					esp.name.Visible = true;
					esp.name.Text = player.DisplayName;
					esp.name.Position = Vector2.new(box_size.X / 2 + box_position.X, box_position.Y - 16);
					esp.name.Color = names_color;
				else
					esp.name.Visible = false;
				end;
	
				local head_dot_size = head_dots_size;
				local head_dot_outline_size = head_dot_size + -1;
				
				if (esp_enabled and head_dots_enabled and screen_pos_head.on_screen) then
					esp.head_dot_inline.Position = screen_pos_head.position;
					esp.head_dot_inline.Radius = head_dot_size;
					esp.head_dot_inline.NumSides = head_dots_sides;
					esp.head_dot_inline.Color = head_dots_color;
					esp.head_dot_inline.Visible = true;
				
					esp.head_dot_outline.Position = screen_pos_head.position;
					esp.head_dot_outline.Radius = head_dot_outline_size;
					esp.head_dot_outline.NumSides = head_dots_sides;
					esp.head_dot_outline.Visible = true;
				else
					esp.head_dot_outline.Visible = false;
					esp.head_dot_inline.Visible = false;
				end;

				local health_percentage = player.Character.Humanoid.Health / player.Character.Humanoid.MaxHealth;
				local health_bar_height = health_percentage * box_size.Y + 1;
				
				if (esp_enabled and health_bar_enabled and screen_pos.on_screen) then
					esp.health_bar_outline.Visible = true;
					esp.health_bar_inline.Visible = true;
				
					esp.health_bar_outline.From = Vector2.new(box_position.X - 5, box_position.Y + box_size.Y + 1);
					esp.health_bar_outline.To = Vector2.new(esp.health_bar_outline.From.X, esp.health_bar_outline.From.Y - box_size.Y - 2);
					esp.health_bar_inline.From = Vector2.new(box_position.X - 5, box_position.Y + box_size.Y) ;
					esp.health_bar_inline.To = Vector2.new(box_position.X - 5, box_position.Y + box_size.Y - health_bar_height);

					if (health_bar_health_based_color) then
						esp.health_bar_inline.Color = Color3.new(1, 0, 0):Lerp(Color3.new(0, 1, 0), health_percentage);
					else
						esp.health_bar_inline.Color = health_bar_color;
					end;
				else
					esp.health_bar_outline.Visible = false;
					esp.health_bar_inline.Visible = false;
				end;
				
				if (esp_enabled and health_text_enabled and screen_pos.on_screen) then
					esp.health_text.Visible = true;
					esp.health_text.Text = tostring(math.floor(player.Character.Humanoid.Health));
					esp.health_text.Position = Vector2.new(box_position.X - 5 - esp.health_text.TextBounds.X, box_position.Y + box_size.Y - health_bar_height)

					if (health_text_health_based_color) then
						esp.health_text.Color = Color3.new(1, 0, 0):Lerp(Color3.new(0, 1, 0), health_percentage);
					else
						esp.health_text.Color = health_text_color;
					end;
				else
					esp.health_text.Visible = false;
				end;

				if (esp_enabled and armor_bar_enabled and screen_pos.on_screen) then
					local armor_percentage = dahood.get_armor(player) / 100;
					local max_bar_width = box_size.X - 2;
					local armor_bar_width = math.clamp(armor_percentage * max_bar_width, 0, max_bar_width);
				
					esp.armor_bar_outline.Visible = true;
					esp.armor_bar_inline.Visible = true;
					
					esp.armor_bar_outline.From = Vector2.new(box_position.X, box_position.Y + box_size.Y + 4);
					esp.armor_bar_outline.To = Vector2.new(box_position.X + max_bar_width, box_position.Y + box_size.Y + 4);
				
					esp.armor_bar_inline.From = Vector2.new(box_position.X + 1, box_position.Y + box_size.Y + 4);
					esp.armor_bar_inline.To = Vector2.new(box_position.X + 1 + armor_bar_width, box_position.Y + box_size.Y + 4);
				
					esp.armor_bar_inline.Color = armor_bar_color;
				else
					esp.armor_bar_outline.Visible = false;
					esp.armor_bar_inline.Visible = false;
				end;
			end;
		end);
	end;
end;

--// hooks
do
	if (hookmetamethod) then
		local __namecall; __namecall = hookmetamethod(game, "__namecall", LPH_NO_VIRTUALIZE(function(self, ...)
			local method, args = tostring(getnamecallmethod()), {...};
	
			if (not checkcaller() and method == "FireServer" and (typeof(args[1]) == "string" and typeof(args[2]) == "Vector3")) then
				if (flags["legit_silent_enabled"] and not flags["legit_silent_anti_aim_viewer"] and (locals.silent_aim.is_targetting and locals.silent_aim.target)) then
					args[2] = locals.silent_aim.predicted_position;
				end;
	
				if (flags["rage_target_aim_enabled"] and (locals.target_aim.is_targetting and locals.target_aim.target)) then
					args[2] = locals.target_aim.predicted_position;
				end;
	
				return __namecall(self, unpack(args));
			end;
	
			return __namecall(self, ...);
		end));
	
		local __newindex; __newindex = hookmetamethod(game, "__newindex", LPH_NO_VIRTUALIZE(function(self, property, value)
			local calling_script = getcallingscript();
	
			if (not (checkcaller()) and (flags["rage_exploits_enabled"] and flags["rage_exploits_no_recoil"]) and (calling_script == "Framework" or calling_script == "F") and (self == camera and property == "CFrame")) then
				return;
			end;
	
			return __newindex(self, property, value);
		end));

		local __index; __index = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(self, property)
			if (not checkcaller() and ((((flags["anti_aim_c_sync_enabled"] or (flags["anti_aim_starhook_classics_enabled"] and (flags["anti_aim_starhook_classics"] == "Destroy Cheaters" or flags["anti_aim_starhook_classics"] == "supercoolboi34 Destroyer"))) and (flags["anti_aim_c_sync_keybind"] or flags["anti_aim_starhook_classics_keybind"]))) and property == "CFrame" and self == local_player.Character.HumanoidRootPart)) then
				return locals.original_position;
			end;

			return __index(self, property);
		end));
	end;
end;

do
	--// Example
	local window = library:New({
		Size = UDim2.new(0, 600, 0, 500)
	});

	local watermark = library:Watermark({Name = ""});

	window:Seperator({Name = "Combat"});
	ui.tabs["legit"] = window:Page({Name = "Legit", Icon = "http://www.roblox.com/asset/?id=6023426921"});
	ui.tabs["rage"] = window:Page({Name = "Rage", "http://www.roblox.com/asset/?id=6023426921"});
	window:Seperator({Name = "Visuals"});
	ui.tabs["world"] = window:Page({Name = "World", Icon = "http://www.roblox.com/asset/?id=6034684930"});
	ui.tabs["view"] = window:Page({Name = "View", Icon = "http://www.roblox.com/asset/?id=6031075931"});
	window:Seperator({Name = "Player"});
	ui.tabs["movement"] = window:Page({Name = "Movement", Icon = "http://www.roblox.com/asset/?id=6034754445"});
	ui.tabs["anti_aim"] = window:Page({Name = "Anti Aim", Icon = "http://www.roblox.com/asset/?id=14760676189"});
	window:Seperator({Name = "Settings"});
	ui.tabs["settings"] = window:Page({Name = "Settings", Icon = "http://www.roblox.com/asset/?id=6031280882"});

	--// legit
	do
		--// sections
		local legit_main_assist = ui.tabs["legit"]:Section({Name = "Assist", Side = "Left", Size = 420});
		local legit_silent_aim = ui.tabs["legit"]:Section({Name = "Silent Aim", Side = "Right", Size = 420});

		--// main assist
		do
			--// main assist section
			do
				local main_toggle = legit_main_assist:Toggle({Name = "Enabled", Flag = "legit_assist_enabled"});
				local main_toggle_option_list = main_toggle:OptionList({});
				main_toggle_option_list:List({Name = "Type", Flag = "legit_assist_type", Options = {"Camera", "Mouse"}, Default = "Camera"});
				main_toggle_option_list:List({Name = "Aim Part", Flag = "legit_assist_part", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "HumanoidRootPart"});

				legit_main_assist:Keybind({Flag = "legit_assist_key", Name = "Target Bind", Default = Enum.KeyCode.E, Mode = "Toggle", Callback = function()
					local assist_enabled = flags["legit_assist_enabled"];
					local fov_enabled = flags["legit_assist_settings_use_field_of_view"];
					local fov_radius = flags["legit_assist_settings_field_of_view_radius"];
					local checks_enabled = flags["legit_assist_checks_enabled"];
					local check_values = flags["legit_assist_checks"];
					local auto_switch_enabled = flags["legit_assist_auto_switch"];

					if (not (assist_enabled)) then return end;

					local new_target = combat.get_closest_player(fov_enabled, fov_radius, checks_enabled, check_values);

					locals.assist.is_targetting = (new_target and not locals.assist.is_targetting or false);

					if (auto_switch_enabled and new_target and not locals.assist.is_targetting) then
						locals.assist.is_targetting = true;
					end;

					locals.assist.target = (locals.assist.is_targetting and new_target or nil);
				end});

				local mouse_tp_toggle = legit_main_assist:Toggle({Name = "Mouse TP", Flag = "legit_assist_mouse_tp_enabled"});


				local option_list_mouse_tp = mouse_tp_toggle:OptionList({});

				option_list_mouse_tp:Keybind({Flag = "legit_assist_mouse_tp_key", Name = "Keybind", Default = Enum.KeyCode.C, Mode = "Toggle", Callback = function()
					local assist_enabled = flags["legit_assist_enabled"];
					local mouse_tp_enabled = flags["legit_assist_mouse_tp_enabled"];
		
					if (not (assist_enabled or mouse_tp_enabled or (locals.assist.is_targetting and locals.assist.target))) then return end;

					local predicted_position = assist.get_predicted_position();
					local screen_predicted_position = utility.world_to_screen(predicted_position);
					assist.move_mouse(screen_predicted_position.position, 5);
				end});

				local smoothing_toggle = legit_main_assist:Toggle({Name = "Smoothing", Flag = "legit_assist_smoothing_enabled"});
				local smoothing_option_list = smoothing_toggle:OptionList({});
				smoothing_option_list:Slider({Name = "Smoothing Amount", Flag = "legit_assist_smoothing_amount", Default = 1, Minimum = 1, Maximum = 100, Decimals = 0.01, Ending = "%"});


				legit_main_assist:Toggle({Name = "Auto Switch", Flag = "legit_assist_auto_switch"});

				local air_aimpart_toggle = legit_main_assist:Toggle({Name = "Air Aim Part", Flag = "legit_assist_use_air_hit_part"});
				local air_aimpart_option_list = air_aimpart_toggle:OptionList({});
				air_aimpart_option_list:List({Name = "Air Aim Part", Flag = "legit_assist_air_part", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "LowerTorso"});

				local resolver_toggle = legit_main_assist:Toggle({Name = "Resolver", Flag = "legit_assist_resolver"});
				local resolve_option_list = resolver_toggle:OptionList({});
				resolve_option_list:List({Name = "Method", Flag = "legit_assist_resolver_method", Options = {"Recalculate", "MoveDirection"}, Default = "Recalculate"});
				resolve_option_list:Slider({Name = "Update Time", Flag = "legit_assist_resolver_update_time", Default = 100, Minimum = 1, Maximum = 200, Decimals = 0.001, Ending = "ms"});

				local anti_ground_toggle = legit_main_assist:Toggle({Name = "Anti Ground Shots", Flag = "legit_assist_anti_ground_shots"});
				local anti_ground_option_list = anti_ground_toggle:OptionList({});
				anti_ground_option_list:Slider({Name = "To Take Off", Flag = "legit_assist_anti_ground_shots_to_take_off", Default = 2, Minimum = 0.1, Maximum = 10, Decimals = 0.01, Ending = "'"});

				local stutter_toggle = legit_main_assist:Toggle({Name = "Stutter", Flag = "legit_assist_stutter_enabled"});
				local stutter_option_list = stutter_toggle:OptionList({});
				stutter_option_list:Slider({Name = "Amount", Flag = "legit_assist_stutter_amount", Default = 1, Minimum = 1, Maximum = 10, Decimals = 0.01, Ending = "s"});

				local shake_toggle = legit_main_assist:Toggle({Name = "Shake", Flag = "legit_assist_shake_enabled"});
				local shake_option_list = shake_toggle:OptionList({});
				shake_option_list:Slider({Name = "Amount", Flag = "legit_assist_shake_amount", Default = 0.01, Minimum = 0.01, Maximum = 10, Decimals = 0.001, Ending = "'"});

				local checks_toggle = legit_main_assist:Toggle({Name = "Checks", Flag = "legit_assist_checks_enabled"});
				local checks_option_list = checks_toggle:OptionList({});
				checks_option_list:List({Name = "Checks", Flag = "legit_assist_checks", Options = {"Knocked", "Grabbed", "Friend", "Wall", "Vehicle"}, Default = {"Knocked"}, Max = 5});

				local fov_toggle = legit_main_assist:Toggle({Name = "Use Field Of View", Flag = "legit_assist_settings_use_field_of_view"});
				local fov_option_list = fov_toggle:OptionList({});

				fov_option_list:Colorpicker({Name = "Color", Flag = "legit_assist_settings_field_of_view_color", Default = default_color});
				fov_option_list:Slider({Name = "Radius", Flag = "legit_assist_settings_field_of_view_radius", Default = 1, Minimum = 1, Maximum = 200, Decimals = 0.01, Ending = "%"});
				fov_option_list:Slider({Name = "Transparency", Flag = "legit_assist_settings_field_of_view_transparency", Default = 0, Minimum = 0, Maximum = 1, Decimals = 0.01, Ending = "%"});

				legit_main_assist:Textbox({Name = "Prediction", Flag = "legit_assist_prediction", Default = "0.134", PlaceHolder = "Prediction"});
			end;

			--// silent aim section
			do
				legit_silent_aim:Toggle({Name = "Enabled", Flag = "legit_silent_enabled"});
				legit_silent_aim:Toggle({Name = "Closest Body Part", Flag = "legit_silent_closest_body_part"});
				legit_silent_aim:Toggle({Name = "Anti Aim Viewer", Flag = "legit_silent_anti_aim_viewer"});
				
				local resolver_toggle = legit_silent_aim:Toggle({Name = "Resolver", Flag = "legit_silent_resolver"});
				local resolver_option_list = resolver_toggle:OptionList({});
				resolver_option_list:List({Name = "Method", Flag = "legit_silent_resolver_method", Options = {"Recalculate", "MoveDirection"}, Default = "Recalculate"});
				resolver_option_list:Slider({Name = "Update Time", Flag = "legit_silent_resolver_update_time", Default = 100, Minimum = 1, Maximum = 200, Decimals = 0.001, Ending = "ms"});
				
				local fov_toggle = legit_silent_aim:Toggle({Name = "Field Of View", Flag = "legit_silent_use_field_of_view"});
				local fov_option_list = fov_toggle:OptionList({});
				fov_option_list:Toggle({Name = "Visualize", Flag = "legit_silent_visualize_field_of_view"});
				fov_option_list:Colorpicker({Name = "Color", Flag = "legit_silent_field_of_view_color", Default = default_color});
				fov_option_list:Slider({Name = "Transparency", Flag = "legit_silent_field_of_view_transparency", Default = 0, Minimum = 0, Maximum = 1, Decimals = 0.01, Ending = "%"});
				fov_option_list:Slider({Name = "Radius", Flag = "legit_silent_field_of_view_radius", Default = 1, Minimum = 1, Maximum = 200, Decimals = 0.01, Ending = "%"});
				
				local line_toggle = legit_silent_aim:Toggle({Name = "Line", Flag = "legit_silent_aim_tracer_enabled"});
				local line_option_list = line_toggle:OptionList({});
				line_option_list:Colorpicker({Name = "Color", Flag = "legit_silent_aim_tracer_color", Default = default_color});
				line_option_list:Slider({Name = "Line Thickness", Flag = "legit_silent_aim_tracer_thickness", Default = 2, Minimum = 1, Maximum = 5, Decimals = 0.01, Ending = "%"});
				line_option_list:Slider({Name = "Transparency", Flag = "legit_silent_aim_tracer_transparency", Default = 1, Minimum = 0, Maximum = 1, Decimals = 0.01, Ending = "%"});

				local checks_toggle = legit_silent_aim:Toggle({Name = "Checks", Flag = "legit_silent_use_checks"});
				local checks_option_list = checks_toggle:OptionList({});
				checks_option_list:List({Name = "Values", Flag = "legit_silent_checks", Options = {"Knocked", "Grabbed", "Friend", "Wall", "Vehicle"}, Default = {"Knocked"}, Max = 5});

				local airpart_toggle = legit_silent_aim:Toggle({Name = "Use Air Aim Part", Flag = "legit_silent_use_air_hit_part"});
				local airpart_option_list = airpart_toggle:OptionList({});
				airpart_option_list:List({Name = "Air Aim Part", Flag = "legit_silent_air_aim_part", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "HumanoidRootPart"});

				
				local antiground_toggle = legit_silent_aim:Toggle({Name = "Anti Ground Shots", Flag = "legit_silent_anti_ground_shots"});
				local antiground_option_list = antiground_toggle:OptionList({});
				antiground_option_list:Slider({Name = "To Take Off", Flag = "legit_silent_anti_ground_shots_to_take_off", Default = 2, Minimum = 0.1, Maximum = 10, Decimals = 0.01, Ending = "'"});
				
				legit_silent_aim:List({Name = "Aim Part", Flag = "legit_silent_aim_part", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "HumanoidRootPart"});
				legit_silent_aim:Textbox({Name = "Prediction", Flag = "legit_silent_prediction", Default = "0.134", PlaceHolder = "Prediction"});
			end;
		end;
	end;

	--// rage 
	do
		--// sections
		local rage_main_target_aim = ui.tabs["rage"]:Section({Name = "Target Aim", Side = "Left", Size = 427});
		local rage_target_aim_visuals = ui.tabs["rage"]:Section({Name = "Target Aim Visuals", Side = "Right", Size = 245});
		local rage_target_aim_teleport = ui.tabs["rage"]:Section({Name = "Target Aim Teleport", Side = "Right",  Size = 175});

		do
			local main_toggle = rage_main_target_aim:Toggle({Name = "Enabled", Flag = "rage_target_aim_enabled", Callback = function(state)
				if state then return end;

				screen_gui.Enabled = false;
			end});
			local main_toggle_option_list = main_toggle:OptionList({});
			main_toggle_option_list:Toggle({Name = "Notify", Flag = "rage_target_aim_notify"});
			main_toggle_option_list:Slider({Name = "Notify Duration", Flag = "rage_target_aim_notify_duration", Default = 2, Minimum = 1, Maximum = 10, Decimals = 0.01, Ending = "s"});
			main_toggle_option_list:Toggle({Name = "Auto Shoot", Flag = "rage_target_aim_auto_shoot"});
			main_toggle_option_list:Toggle({Name = "Look At", Flag = "rage_target_aim_look_at"});
			main_toggle_option_list:Toggle({Name = "Randomized BodyPart", Flag = "rage_target_aim_randomized_body_part"});
			--main_toggle_option_list:Toggle({Name = "Movement Simulation", Flag = "rage_target_aim_movement_simulation"});
			
			rage_main_target_aim:Keybind({Flag = "rage_target_aim_key", Default = Enum.KeyCode.E, Mode = "Toggle", Callback = function(key)
				local target_aim_enabled = flags["rage_target_aim_enabled"];
				local checks_enabled = flags["rage_target_aim_use_checks"];
				local check_values = flags["rage_target_aim_checks"];
				local fov_enabled = flags["rage_target_aim_use_field_of_view"];
				local fov_radius = flags["rage_target_aim_field_of_view_radius"];
				local auto_switch = flags["rage_target_aim_auto_switch"];

				if (not (target_aim_enabled)) then return end;

				local new_target = combat.get_closest_player(fov_enabled, fov_radius, checks_enabled, check_values);

				locals.target_aim.is_targetting = (new_target and not locals.target_aim.is_targetting or false);

				if (auto_switch and new_target and not locals.target_aim.is_targetting and locals.target_aim.target ~= new_target) then
					locals.target_aim.is_targetting = true;
				end;

				locals.target_aim.target = (locals.target_aim.is_targetting and new_target or nil);

				signals.target_target_changed:Fire(locals.target_aim.target, locals.target_aim.is_targetting);
			end});

			if (not table.find(dahood_ids, game.PlaceId)) then
				rage_main_target_aim:Toggle({Name = "Bullet Tp", Flag = "rage_target_aim_bullet_tp_enabled"});
			else
				rage_main_target_aim:Toggle({Name = "Rocket Tp", Flag = "rage_target_aim_rocket_tp_enabled"});
			end;
			
			rage_main_target_aim:Toggle({Name = "Spectate", Flag = "rage_target_aim_spectate"});
			rage_main_target_aim:Toggle({Name = "Auto Switch", Flag = "rage_target_aim_auto_switch"});
			rage_main_target_aim:Toggle({Name = "Closest Body Part", Flag = "rage_target_aim_closest_body_part"});

			local air_part_toggle = rage_main_target_aim:Toggle({Name = "Use Air Aim Part", Flag = "rage_target_aim_use_air_hit_part"});
			local air_part_option_list = air_part_toggle:OptionList({});
			air_part_option_list:List({Name = "Aim Part", Flag = "rage_target_aim_air_aim_part", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "HumanoidRootPart"});
			local air_offset_toggle = rage_main_target_aim:Toggle({Name = "Air Offset", Flag = "rage_target_aim_use_air_offset"});
			local air_offset_option_list = air_offset_toggle:OptionList({});
			air_offset_option_list:Slider({Name = "Offset", Flag = "rage_target_aim_air_offset", Default = 4, Minimum = -10, Maximum = 10, Decimals = 0.001, Ending = "'"});
			local resolver_toggle = rage_main_target_aim:Toggle({Name = "Resolver", Flag = "rage_target_aim_resolver_enabled"});
			local resolver_option_list = resolver_toggle:OptionList({});
			resolver_option_list:List({Name = "Method", Flag = "rage_target_aim_resolver_method", Options = {"Recalculate", "MoveDirection"}, Default = "Recalculate"});
			resolver_option_list:Slider({Name = "Update Time", Flag = "rage_target_aim_update_time", Default = 100, Minimum = 1, Maximum = 200, Decimals = 0.001, Ending = "ms"});
			local checks_toggle = rage_main_target_aim:Toggle({Name = "Checks", Flag = "rage_target_aim_use_checks"});
			local checks_option_list = checks_toggle:OptionList({});
			checks_option_list:List({Name = "Checks", Flag = "rage_target_aim_checks", Options = {"Knocked", "Grabbed", "Friend", "Wall", "Vehicle"}, Default = {"Knocked"}, Max = 5});
			local anti_ground_toggle = rage_main_target_aim:Toggle({Name = "Anti Ground Shots", Flag = "rage_target_aim_anti_ground_shots"});
			local anti_ground_option_list = anti_ground_toggle:OptionList({});
			--// anti_ground_option_list:Slider({Name = "To Take Off", Flag = "rage_target_aim_anti_ground_shots_to_take_off", Default = 2, Minimum = 0.1, Maximum = 20, Decimals = 0.01, Ending = "'"});
			anti_ground_option_list:Slider({Name = "Dampening Factor", Flag = "rage_target_aim_dampening_factor", Default = 0.7, Minimum = 0, Maximum = 1, Decimals = 0.01, Ending = ""});
			local fov_toggle = rage_main_target_aim:Toggle({Name = "Field Of View", Flag = "rage_target_aim_use_field_of_view"});
			local fov_option_list = fov_toggle:OptionList({});
			fov_option_list:Toggle({Name = "Visualize", Flag = "rage_target_aim_visualize_field_of_view"});
			fov_option_list:Colorpicker({Name = "Color", Flag = "rage_target_aim_field_of_view_color", Default = default_color, Transparency = 0});
			fov_option_list:Slider({Name = "Transparency", Flag = "rage_target_aim_field_of_view_transparency", Default = 0, Minimum = 0, Maximum = 1, Decimals = 0.01, Ending = "%"});
			fov_option_list:Slider({Name = "Radius", Flag = "rage_target_aim_field_of_view_radius", Default = 1, Minimum = 1, Maximum = 200, Decimals = 0.01, Ending = "%"});

			rage_main_target_aim:Textbox({Name = "Prediction", Flag = "rage_target_aim_prediction", Default = "0.134", PlaceHolder = "Prediction"});
			rage_main_target_aim:List({Name = "Aim Part", Flag = "rage_target_aim_aim_part", Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "HumanoidRootPart"});
		end;

		--// target aim visuals
		do
			local main_toggle = rage_target_aim_visuals:Toggle({Name = "Enabled", Flag = "rage_target_aim_visuals_enabled"});
			local option_list_toggle = main_toggle:OptionList({});

			option_list_toggle:Toggle({Name = "UI", Flag = "rage_target_aim_visuals_ui_enabled", Callback = function(state)
				if state then return end;

				screen_gui.Enabled = false;
			end});

			option_list_toggle:List({Name = "UI Mode", Flag = "rage_target_aim_ui_mode", Options = {"Follow", "Static"}, Default = "Static"});

			rage_target_aim_visuals:Toggle({Name = "Line", Flag = "rage_target_aim_tracer_enabled"});
			local dot = rage_target_aim_visuals:Toggle({Name = "Dot", Flag = "rage_target_aim_dot_enabled"});
			local dot_option_list = dot:OptionList({});
			dot_option_list:Colorpicker({Name = "Color", Flag = "rage_target_aim_dot_color", Default = default_color, Transparency = 0});
			dot_option_list:Slider({Name = "Size", Flag = "rage_target_aim_dot_size", Default = 6, Minimum = 1, Maximum = 20, Decimals = 0.01, Ending = "%"});

			rage_target_aim_visuals:Toggle({Name = "Chams", Flag = "rage_target_aim_chams_enabled"});
			
			rage_target_aim_visuals:Colorpicker({Name = "Line Color", Info = "Target Aim Line Color", Flag = "rage_target_aim_tracer_color", Default = default_color, Transparency = 1});				

			rage_target_aim_visuals:Colorpicker({Name = "Chams Fill Color", Info = "Target Aim Chams Fill Color", Flag = "rage_target_aim_chams_fill_color", Default = default_color, Transparency = 0.5});
			rage_target_aim_visuals:Colorpicker({Name = "Chams Outline Color", Info = "Target Aim Chams Outline Color", Flag = "rage_target_aim_chams_outline_color", Default = Color3.fromRGB(0, 0, 0), Transparency = 0});


			rage_target_aim_visuals:Slider({Name = "Line Thickness", Flag = "rage_target_aim_tracer_thickness", Default = 2, Minimum = 1, Maximum = 5, Decimals = 0.01, Ending = "%"});
		end;

		--// target aim teleport
		do
			local main_toggle = rage_target_aim_teleport:Toggle({Name = "Enabled", Flag = "rage_target_aim_teleport_enabled"});
			rage_target_aim_teleport:Toggle({Name = "Bypass Destroy Cheaters", Flag = "rage_target_aim_bypass_destroy_cheaters"})	
		
			local main_toggle_optionlist = main_toggle:OptionList({});
			rage_target_aim_teleport:Keybind({Flag = "rage_target_aim_teleport_keybind", Default = Enum.KeyCode.B, KeybindName = "Target Aim Teleport", Mode = "Toggle"});
			
			rage_target_aim_teleport:List({Name = "Type", Flag = "rage_target_aim_teleport_type", Options = {"Random", "Strafe"}, Default = "Random"});
			main_toggle_optionlist:Slider({Name = "Randomization", Flag = "rage_target_aim_teleport_randomization", Default = 1, Minimum = 1, Maximum = 20, Decimals = 0.01, Ending = "%"});
			main_toggle_optionlist:Slider({Name = "Strafe Distance", Flag = "rage_target_aim_teleport_strafe_distance", Default = 1, Minimum = 1, Maximum = 20, Decimals = 0.01, Ending = "%"});
			main_toggle_optionlist:Slider({Name = "Strafe Speed", Flag = "rage_target_aim_teleport_strafe_speed", Default = 1, Minimum = 1, Maximum = 10, Decimals = 0.01, Ending = "%"});
			main_toggle_optionlist:Slider({Name = "Strafe", Flag = "rage_target_aim_teleport_strafe_height", Default = 1, Minimum = 1, Maximum = 20, Decimals = 0.01, Ending = "%"});

		end;
	end;
	
	--// movement
	do
		local cframe_speed = ui.tabs["movement"]:Section({Name = "CFrame speed", Side = "Left", Size = 125});
		local cframe_fly = ui.tabs["movement"]:Section({Name = "Fly", Side = "Left", Size = 125});
		local misc = ui.tabs["movement"]:Section({Name = "Misc", Side = "Right", Size = 100});
		
		--// speed
		do
			local main_toggle = cframe_speed:Toggle({Name = "Enabled", Flag = "rage_cframe_speed_enabled"});
			cframe_speed:Keybind({Flag = "rage_cframe_speed_keybind", Name = "Keybind", Default = Enum.KeyCode.X, Mode = "Toggle"});
			cframe_speed:Slider({Name = "Amount", Flag = "rage_cframe_speed_amount", Default = 0.3, Minimum = 0.1, Maximum = 10, Decimals = 0.01, Ending = "%"});
		end;

		--// fly
		do
			local main_toggle = cframe_fly:Toggle({Name = "Enabled", Flag = "rage_cframe_fly_enabled"});
			cframe_fly:Keybind({Flag = "rage_cframe_fly_keybind", Name = "Keybind", Default = Enum.KeyCode.C, Mode = "Toggle"});
			cframe_fly:Slider({Name = "Speed", Flag = "rage_cframe_fly_amount", Default = 1, Minimum = 1, Maximum = 30, Decimals = 0.01, Ending = "%"});
		end;

		--// misc
		do
			misc:Toggle({Name = "No Jump Cooldown", Flag = "rage_misc_movement_no_jump_cooldown", Callback = function(state)
				if (not (utility.has_character(local_player))) then return end;

                local_player.Character.Humanoid.UseJumpPower = true;
			end});

			misc:Toggle({Name = "No Seats", Callback = function(state)
				local descendants = game:GetDescendants();

				for i = 1, #descendants do
					local object = descendants[i];

					if (object.ClassName ~= "Seat") then continue end;

					object.CanTouch = not state and true or false;
				end;
			end});
		end;
	end;

	--// visuals
	do
		--// world
		do
			local visuals_bullet_tracers = ui.tabs["world"]:Section({Name = "Bullet Tracers", Side = "Left", Size = 210});
			local visuals_bullet_impacts = ui.tabs["world"]:Section({Name = "Bullet Impacts", Side = "Right", Size = 210});
			local visuals_hit_detection = ui.tabs["world"]:Section({Name = "Hit Detection", Side = "Left"});
			local visuals_clone_chams = ui.tabs["world"]:Section({Name = "Clone Chams", Side = "Right"});

			--// bullet tracers
			do
				local main_toggle = visuals_bullet_tracers:Toggle({Name = "Enabled", Flag = "visuals_bullet_tracers_enabled"});
				visuals_bullet_tracers:Toggle({Name = "Fade", Flag = "visuals_bullet_tracers_fade_enabled"});

				visuals_bullet_tracers:Colorpicker({Name = "Bullet Tracers Gradient Start", Flag = "visuals_bullet_tracers_color_gradient_1", Default = default_color, Transparency = 0});
				visuals_bullet_tracers:Colorpicker({Name = "Bullet Tracers Gradient End", Flag = "visuals_bullet_tracers_color_gradient_2", Default = default_color, Transparency = 0});

				visuals_bullet_tracers:Slider({Name = "Fade Duration", Flag = "visuals_bullet_tracers_fade_duration", Default = 2, Minimum = 0.5, Maximum = 5, Decimals = 0.001, Ending = "s"});
				visuals_bullet_tracers:Slider({Name = "Duration", Flag = "visuals_bullet_tracers_duration", Default = 2, Minimum = 0.5, Maximum = 5, Decimals = 0.001, Ending = "s"});
			end;

			--// bullet impact
			do
				local main_toggle = visuals_bullet_impacts:Toggle({Name = "Enabled", Flag = "visuals_bullet_impacts_enabled"});

				local main_toggle_option_list = main_toggle:OptionList({});
				main_toggle_option_list:Colorpicker({Name = "Bullet Impacts Color", Flag = "visuals_bullet_impacts_color", Default = default_color, Transparency = 0});	


				visuals_bullet_impacts:Toggle({Name = "Fade", Flag = "visuals_bullet_impacts_fade_enabled"});
				visuals_bullet_impacts:Slider({Name = "Size", Flag = "visuals_bullet_impacts_size", Default = 0.5, Minimum = 0.1, Maximum = 10, Decimals = 0.001, Ending = "'"});
				visuals_bullet_impacts:Slider({Name = "Fade Duration", Flag = "visuals_bullet_impacts_fade_duration", Default = 2, Minimum = 0.5, Maximum = 5, Decimals = 0.001, Ending = "s"});
				visuals_bullet_impacts:Slider({Name = "Duration", Flag = "visuals_bullet_impacts_duration", Default = 2, Minimum = 0.5, Maximum = 5, Decimals = 0.001, Ending = "s"});
			end;

			--// hit detection
			do
				local sounds = {};

				for i,v in hitsounds do
					table.insert(sounds, i);
				end;

				visuals_hit_detection:Toggle({Name = "Enabled", Flag = "visuals_hit_detection_enabled"});
				local sounds_toggle = visuals_hit_detection:Toggle({Name = "Sounds", Flag = "visuals_hit_detection_sounds_enabled"});
	
				local sounds_toggle_option_list = sounds_toggle:OptionList({});
				sounds_toggle_option_list:List({Name = "Sound", Flag = "visuals_hit_detection_sounds_which_sound", Options = sounds, Default = sounds[1]});
				sounds_toggle_option_list:Slider({Name = "Volume", Flag = "visuals_hit_detection_sounds_volume", Default = 5, Minimum = 0.1, Maximum = 10, Decimals = 0.01, Ending = "%"});

				local chams_toggle = visuals_hit_detection:Toggle({Name = "Chams", Flag = "visuals_hit_detection_chams_enabled"});
				
				local chams_option_list = chams_toggle:OptionList({});
				chams_option_list:Colorpicker({Name = "Color", Flag = "visuals_hit_detection_chams_color", Default = default_color});
				chams_option_list:Slider({Name = "Transparency", Flag = "visuals_hit_detection_chams_transparency", Default = 0.7, Minimum = 0, Maximum = 1, Decimals = 0.001, Ending = "%"});
				chams_option_list:Slider({Name = "Duration", Flag = "visuals_hit_detection_chams_duration", Default = 2, Minimum = 0, Maximum = 10, Decimals = 0.001, Ending = "s"});
				
				local effect = visuals_hit_detection:Toggle({Name = "Effects", Flag = "visuals_hit_detection_effects_enabled"});
				
				local effect_option_list = effect:OptionList({});
				effect_option_list:Colorpicker({Name = "Color", Flag = "visuals_hit_detection_effects_color", Default = default_color});
				effect_option_list:List({Name = "Which Effect", Flag = "visuals_hit_detection_effects_which_effect", Options = {"Bubble", "Confetti"}, Default = "Bubble"});

				visuals_hit_detection:Toggle({Name = "Notification", Flag = "visuals_hit_detection_notification"});
				visuals_hit_detection:Slider({Name = "Notification Duration", Flag = "visuals_hit_detection_notification_duration", Default = 2, Minimum = 0, Maximum = 10, Decimals = 0.001, Ending = "s"});
			end;
			
			--// clons chams
			do
				visuals_clone_chams:Toggle({Name = "Enabled", Flag = "visuals_clone_chams_enabled"});
				visuals_clone_chams:Colorpicker({Name = "Color", Flag = "visuals_clone_chams_color", Default = default_color});
				visuals_clone_chams:Slider({Name = "Duration", Flag = "visuals_clone_chams_duration", Default = 0.1, Minimum = 0.1, Maximum = 10, Decimals = 0.001, Ending = "s"});
				visuals_clone_chams:List({Name = "To Apply", Flag = "visuals_clone_chams_to_apply", Options = {"Local Player", "Target Aim Target"}, Default = {"Local Player"}, Max = 2});
			end;
		end;

		--// misc
		do
			local world_section = ui.tabs["view"]:Section({Name = "World", Side = "Left", Size = 210});
			local lplr_section = ui.tabs["view"]:Section({Name = "Local Player", Side = "Left", Size = 210});
			local cursor_text = ui.tabs["view"]:Section({Name = "Text", Side = "Right", Size = 210});

			--// world
			do
				local fog = world_section:Toggle({Name = "Fog", Flag = "visuals_world_fog", Callback = function(state)
					if state then
						lighting.FogColor = flags["visuals_world_fog_color"];
						lighting.FogStart = flags["visuals_world_fog_start"];
						lighting.FogEnd = flags["visuals_world_fog_end"];
					else
						lighting.FogColor = world.FogColor;
						lighting.FogStart = world.FogStart;
						lighting.FogEnd = world.FogEnd;
					end;
				end});
				
				local fog_option_list = fog:OptionList({});
				fog_option_list:Colorpicker({Name = "Color", Flag = "visuals_world_fog_color", Default = default_color, Callback = function(color)
					if flags["visuals_world_fog"] then
						lighting.FogColor = color;
					end;
				end});
				fog_option_list:Slider({Name = "Start", Flag = "visuals_world_fog_start", Default = 150, Minimum = 100, Maximum = 10000, Decimals = 1, Ending = "%", Callback = function(number)
					if flags["visuals_world_fog"] then
						lighting.FogStart = number;
					end;
				end});
				fog_option_list:Slider({Name = "End", Flag = "visuals_world_fog_end", Default = 550, Minimum = 100, Maximum = 10000, Decimals = 1, Ending = "%", Callback = function(number)
					if flags["visuals_world_fog"] then
						lighting.FogEnd = number;
					end;
				end});

				local ambient = world_section:Toggle({Name = "Ambient", Flag = "visuals_world_ambient", Callback = function(state)
					if state then
						lighting.Ambient = flags["visuals_world_ambient_color"];
					else
						lighting.Ambient = world.Ambient;
					end;
				end});
				
				local ambient_option_list = ambient:OptionList({});
				ambient_option_list:Colorpicker({Name = "Color", Flag = "visuals_world_ambient_color", Default = default_color, Callback = function(color)
					if flags["visuals_world_ambient"] then
						lighting.Ambient = color;
					end;
				end});

				local clock_time_toggle = world_section:Toggle({Name = "Clock Time", Flag = "visuals_world_clock_time", Callback = function(state)
					if state then
						lighting.ClockTime = flags["visuals_world_clock_time_time"];
					else
						lighting.ClockTime = world.ClockTime;
					end;
				end});
				local clock_time_option_list = clock_time_toggle:OptionList({});
				clock_time_option_list:Slider({Name = "Time", Flag = "visuals_world_clock_time_time", Default = 14, Minimum = 0, Maximum = 24, Decimals = 1, Callback = function(number)
					if flags["visuals_world_clock_time"] then
						lighting.ClockTime = number;
					end;
				end});

				local brightness_toggle = world_section:Toggle({Name = "Brightness", Flag = "visuals_world_brightness", Callback = function(state)
					if state then
						lighting.Brightness = flags["visuals_world_brightness_level"];
					else
						lighting.Brightness = world.Brightness;
					end;
				end});
				local brightness_option_list = brightness_toggle:OptionList({});
				brightness_option_list:Slider({Name = "Level", Flag = "visuals_world_brightness_level", Default = 0.1, Minimum = 0, Maximum = 10, Decimals = 1, Callback = function(number)
					if flags["visuals_world_brightness"] then
						lighting.Brightness = number;
					end;
				end});

				local exposure = world_section:Toggle({Name = "Exposure", Flag = "visuals_world_exposure", Callback = function(state)
					if state then
						lighting.ExposureCompensation = flags["visuals_world_exposure_compensation"];
					else
						lighting.ExposureCompensation = world.ExposureCompensation;
					end;
				end});
				local exposure_option_list = exposure:OptionList({});
				exposure_option_list:Slider({Name = "Compensation", Flag = "visuals_world_exposure_compensation", Default = 0, Minimum = -10, Maximum = 10, Decimals = 1, Callback = function(number)
					if flags["visuals_world_exposure"] then
						lighting.ExposureCompensation = number;
					end;
				end});

				local color_shift_top = world_section:Toggle({Name = "Color Shift Top", Flag = "visuals_world_color_shift_top", Callback = function(state)
					if state then
						lighting.ColorShift_Top = flags["visuals_world_color_shift_top_color"];
					else
						lighting.ColorShift_Top = world.ColorShift_Top;
					end;
				end});
				local color_shift_top_option_list = color_shift_top:OptionList({});
				color_shift_top_option_list:Colorpicker({Name = "Color", Flag = "visuals_world_color_shift_top_color", Default = default_color, Callback = function(color)
					if flags["visuals_world_color_shift_top"] then
						lighting.ColorShift_Top = color;
					end;
				end});

				local collor_shift_bottom = world_section:Toggle({Name = "Color Shift Bottom", Flag = "visuals_world_color_shift_bottom", Callback = function(state)
					if state then
						lighting.ColorShift_Bottom = flags["visuals_world_color_shift_bottom_color"];
					else
						lighting.ColorShift_Bottom = world.ColorShift_Bottom;
					end;
				end});
				local color_shift_bottom_option_list = collor_shift_bottom:OptionList({});
				color_shift_bottom_option_list:Colorpicker({Name = "Color", Flag = "visuals_world_color_shift_bottom_color", Default = default_color, Callback = function(color)
					if flags["visuals_world_color_shift_bottom"] then
						lighting.ColorShift_Bottom = color;
					end;
				end});
			end;

			--// local player section
			do
				lplr_section:Toggle({Name = "Chams", Flag = "visuals_player_chams_enabled"});
				lplr_section:Toggle({Name = "Material", Flag = "visuals_player_material_enabled", Callback = function(state)
					local material = flags["visuals_player_material_type"];
					features.local_material(state, material);
				end});
				lplr_section:Colorpicker({Name = "Outline Color", Flag = "visuals_player_chams_outline_color", Default = Color3.new(0, 0, 0)});
				lplr_section:Colorpicker({Name = "Fill Color", Flag = "visuals_player_chams_fill_color", Default = default_color});
				lplr_section:List({Name = "Material", Flag = "visuals_player_material_type", Options = {"ForceField", "Neon"}, Default = "ForceField", Callback = function(material)
					local state = flags["visuals_player_material_enabled"];
					features.local_material(state, material);
				end});
			end;

			if (ESP) then
				local esp_section = ui.tabs["view"]:Section({Name = "ESP", Side = "Right", Size = 210});
				--// esp section
				do
					esp_section:Toggle({Name = "Enabled", Flag = "visuals_esp_enabled"});
					local boxes_toggle = esp_section:Toggle({Name = "Boxes", Flag = "visuals_esp_boxes_enabled"});
					local boxes_option_list = boxes_toggle:OptionList({});
					boxes_option_list:Colorpicker({Name = "Color", Flag = "visuals_esp_boxes_color", Default = Color3.new(1, 1, 1)});
					boxes_option_list:Toggle({Name = "Target Color", Flag = "visuals_esp_boxes_target_color_enabled"});
					boxes_option_list:Colorpicker({Name = "Target Color", Flag = "visuals_esp_boxes_target_color", Default = Color3.new(1, 0, 0)});
		
					local names_toggle = esp_section:Toggle({Name = "Names", Flag = "visuals_esp_names_enabled"});
					local names_option_list = names_toggle:OptionList({});
					names_option_list:Colorpicker({Name = "Color", Flag = "visuals_esp_names_color", Default = Color3.new(1, 1, 1)});
		
					local head_dots_toggle = esp_section:Toggle({Name = "Head Dots", Flag = "visuals_esp_head_dots_enabled"});
					local head_dots_option_list = head_dots_toggle:OptionList({});
					head_dots_option_list:Colorpicker({Name = "Color", Flag = "visuals_esp_head_dots_color", Default = Color3.new(1, 1, 1)});
					head_dots_option_list:Slider({Name = "Sides", Flag = "visuals_esp_head_dots_sides", Default = 6, Minimum = 1, Maximum = 100, Decimals = 1, Ending = "'"});
					head_dots_option_list:Slider({Name = "Size", Flag = "visuals_esp_head_dots_size", Default = 10, Minimum = 1, Maximum = 20, Decimals = 0.0001, Ending = "'"});
					local health_bar_toggle = esp_section:Toggle({Name = "Health Bar", Flag = "visuals_esp_health_bar_enabled"});
					local health_bar_option_list = health_bar_toggle:OptionList({});
					health_bar_option_list:Toggle({Name = "Health Based Color", Flag = "visuals_esp_health_bar_health_based_color"});
					health_bar_option_list:Colorpicker({Name = "Health Color", Flag = "visuals_esp_health_bar_color", Default = Color3.new(1, 1, 1)});
					local health_text_toggle = esp_section:Toggle({Name = "Health Text", Flag = "visuals_esp_health_text_enabled"});
					local health_text_option_list = health_text_toggle:OptionList({});
					health_text_option_list:Toggle({Name = "Health Based Color", Flag = "visuals_esp_health_text_health_based_color"});
					health_text_option_list:Colorpicker({Name = "Color", Flag = "visuals_esp_health_text_color", Default = Color3.new(1, 1, 1)});
					local armor_bar_toggle = esp_section:Toggle({Name = "Armor Bar", Flag = "visuals_esp_armor_bar_enabled"});
					local armor_bar_option_list = armor_bar_toggle:OptionList({});
					armor_bar_option_list:Colorpicker({Name = "Armor Color", Flag = "visuals_esp_armor_bar_color", Default = Color3.new(1, 1, 1)});
				end;
			end;
	
			--// cursor text
			do
				cursor_text:Toggle({Name = "Enabled", Flag = "visuals_text_enabled"});
				cursor_text:Toggle({Name = "Custom Text", Flag = "visuals_text_custom_text"});
				cursor_text:Colorpicker({Name = "Text Color", Flag = "visuals_text_color", Default = default_color});
				cursor_text:Slider({Name = "Cursor Offset", Flag = "visuals_text_cursor_offset", Default = 49, Minimum = 1, Maximum = 100, Decimals = 0.0001, Ending = "%"});
				cursor_text:Textbox({Flag = "visuals_cursor_custom_text_text", Placeholder = "[${target_name}]"});
			end;
		end;
	end;

	--// anti aim
	do
		local velocity_spoofer = ui.tabs["anti_aim"]:Section({Name = "Velocity Spoofer", Side = "Left", Size = 160});
		local network_desync = ui.tabs["anti_aim"]:Section({Name = "Network Desync", Side = "Right", Size = 110});
		local c_sync = ui.tabs["anti_aim"]:Section({Name = "C-Sync", Side = "Right", Size = 300});
		local fflag = ui.tabs["anti_aim"]:Section({Name = "FFlag Desync", Side = "Left", Size = 95});
		local starhook_classics = ui.tabs["anti_aim"]:Section({Name = "Starhook Classics", Side = "Left", Size = 150});

		--// velocity spoofer
		do
			local nest = velocity_spoofer:Nest({Size = 120});
			nest:Toggle({Name = "Enabled", Flag = "anti_aim_velocity_spoofer_enabled"});
			nest:Keybind({Flag = "anti_aim_velocity_spoofer_keybind", Name = "Keybind", Default = Enum.KeyCode.C, Mode = "Toggle"});
			nest:List({Name = "Type", Flag = "anti_aim_velocity_spoofer_type", Options = {"Local Strafe", "Random", "Static"}, Default = {"Local Strafe"}});
			nest:Slider({Name = "Strafe Distance", Flag = "anti_aim_velocity_spoofer_strafe_distance", Default = 1, Minimum = 1, Maximum = 20, Decimals = 0.01, Ending = "%"});
			nest:Slider({Name = "Strafe Speed", Flag = "anti_aim_velocity_spoofer_strafe_speed", Default = 1, Minimum = 1, Maximum = 10, Decimals = 0.01, Ending = "%"});
			nest:Slider({Name = "Static X", Flag = "anti_aim_velocity_spoofer_static_x", Default = 1, Minimum = 1, Maximum = 100, Decimals = 0.01, Ending = "'"});
			nest:Slider({Name = "Static Y", Flag = "anti_aim_velocity_spoofer_static_y", Default = 1, Minimum = 1, Maximum = 100, Decimals = 0.01, Ending = "'"});
			nest:Slider({Name = "Static Z", Flag = "anti_aim_velocity_spoofer_static_z", Default = 1, Minimum = 1, Maximum = 100, Decimals = 0.01, Ending = "'"});
			nest:Slider({Name = "Randomization", Flag = "anti_aim_velocity_spoofer_randomization", Default = 1, Minimum = 1, Maximum = 100, Decimals = 0.01, Ending = "%"});
		end;

		--// network desync
		do
			network_desync:Toggle({Name = "Enabled", Flag = "anti_aim_network_desync_enabled"});
			network_desync:Slider({Name = "Amount", Flag = "anti_aim_network_desync_amount", Default = 7.5, Minimum = 0, Maximum = 10, Decimals = 0.01, Ending = "%"});
		end;

		--// c sync
		do
			local main_toggle = c_sync:Toggle({Name = "Enabled", Flag = "anti_aim_c_sync_enabled"});
			local main_toggle_option_list = main_toggle:OptionList({});

			main_toggle_option_list:Toggle({Name = "Visualize", Flag = "anti_aim_c_sync_visualize_enabled"});
			main_toggle_option_list:List({Name = "Visualize Types", Flag = "anti_aim_c_sync_visualize_types", Options = {"Tracer", "Dot", "Character"}, Default = {"Tracer"}, Max = 3});
			main_toggle_option_list:Colorpicker({Name = "Visualize Color", Flag = "anti_aim_c_sync_visualize_color", Default = default_color});
			main_toggle_option_list:Slider({Name = "Visualize Dot Size", Flag = "anti_aim_c_sync_dot_size", Default = 16, Minimum = 1, Maximum = 20, Decimals = 0.01, Ending = "%"});

			c_sync:Keybind({Flag = "anti_aim_c_sync_keybind", Name = "Keybind", Default = Enum.KeyCode.N, Mode = "Toggle"});
			c_sync:List({Name = "Type", Flag = "anti_aim_c_sync_type", Options = {"Static Local", "Static Target", "Local Random", "Target Random"}, Default = "Local Offset"});
			c_sync:Slider({Name = "Randomization", Flag = "anti_aim_c_sync_randomization", Default = 1, Minimum = 1, Maximum = 100, Decimals = 0.01, Ending = "%"});
			c_sync:Slider({Name = "Static X", Flag = "anti_aim_c_sync_static_x", Default = 1, Minimum = 0, Maximum = 100, Decimals = 0.01, Ending = "'"});
			c_sync:Slider({Name = "Static Y", Flag = "anti_aim_c_sync_static_y", Default = 1, Minimum = 0, Maximum = 100, Decimals = 0.01, Ending = "'"});
			c_sync:Slider({Name = "Static Z", Flag = "anti_aim_c_sync_static_z", Default = 1, Minimum = 0, Maximum = 100, Decimals = 0.01, Ending = "'"});
		end;

		--// fflags desync
		do
			fflag:Toggle({Name = "Enabled", Flag = "anti_aim_fflag_desync_enabled", Callback = function(state)
				if (state) then
					setfflag("S2PhysicsSenderRate", tostring(flags["anti_aim_fflag_amount"]));
				else
					setfflag("S2PhysicsSenderRate", tostring(old_psr));
				end;
			end});
			fflag:Slider({Name = "Amount", Flag = "anti_aim_fflag_amount", Default = 2, Minimum = 0, Maximum = 15, Decimals = 0.01, Ending = "%", Callback = function(value)
				if (flags["anti_aim_fflag_desync_enabled"]) then
					setfflag("S2PhysicsSenderRate", tostring(value));
				end;
			end});
		end;

		--// destroy cheaters
		do
			starhook_classics:Toggle({Name = "Enabled", Flag = "anti_aim_starhook_classics_enabled"});
			starhook_classics:Keybind({Flag = "anti_aim_starhook_classics_keybind", Name = "Keybind", Default = Enum.KeyCode.Y, Mode = "Toggle"});
			starhook_classics:List({Name = "Classics", Flag = "anti_aim_starhook_classics", Options = {"Destroy Cheaters", "supercoolboi34 Destroyer"}, Default = "Destroy Cheaters"});
		end;
	end;

	--// settings
	do --// credits to finobe wtv im way too lazy
		local cfgs = ui.tabs["settings"]:Section({Name = "Config", Side = "Left", Size = 427});
		local window = ui.tabs["settings"]:Section({Name = "Window", Side = "Right", Size = 427});

		local cfg_list = cfgs:List({Name = "Config List", Flag = "setting_configuration_list", Options = {}});
		cfgs:Textbox({Flag = "settings_configuration_name", Placeholder = "Config name"});

		local current_list = {};

		if not isfolder("starhook") then 
		    makefolder("starhook");
		end;

		if not isfolder("starhook/configs") then 
		    makefolder("starhook/configs");
		end;

		local function update_config_list()
		    local list = {};
		
		    for idx, file in listfiles("starhook/configs") do
		        local file_name = file:gsub("starhook/configs\\", ""):gsub(".cfg", ""):gsub("starhook/configs/", "");
		        list[#list + 1] = file_name;
		    end;
		
		    local is_new = #list ~= #current_list;
		
		    if not is_new then
		        for idx = 1, #list do
		            if list[idx] ~= current_list[idx] then
		                is_new = true;
		                break;
		            end;
		        end;
		    end;
		
		    if is_new then
		        current_list = list;
		        cfg_list:Refresh(current_list);
		    end;
		end;

		cfgs:Button({Name = "Create", Callback = function()
		    local config_name = flags.settings_configuration_name;
		    if config_name == "" or isfile("starhook/configs/" .. config_name .. ".cfg") then
		        return;
		    end;
		    writefile("starhook/configs/" .. config_name .. ".cfg", Library:GetConfig());
		    update_config_list();
		end});

		cfgs:Button({Name = "Save", Callback = function()
		    local selected_config = flags.setting_configuration_list;
		    if selected_config then
		        writefile("starhook/configs/" .. selected_config .. ".cfg", Library:GetConfig());
		    end;
		end});

		cfgs:Button({Name = "Load", Callback = function()
		    local selected_config = flags.setting_configuration_list;
		    if selected_config then
		        Library:LoadConfig(readfile("starhook/configs/" .. selected_config .. ".cfg"));
		    end;
		end});

		cfgs:Button({Name = "Delete", Callback = function()
		    local selected_config = flags.setting_configuration_list;
		    if selected_config then
		        delfile("starhook/configs/" .. selected_config .. ".cfg");
		    end;
		    update_config_list();
		end});

		cfgs:Button({Name = "Refresh", Callback = function()
		    update_config_list();
		end});

		update_config_list();

		--// ui settings
		window:Keybind({Name = "UI Toggle", Flag = "ui_toggle", Default = Enum.KeyCode.Insert, UseKey = true, Callback = function(key)
			Library.UIKey = key;
		end});

		window:Toggle({Name = "Watermark", Flag = "ui_watermark", Callback = function(state)
			watermark:SetVisible(state);
		end});

		window:Colorpicker({Name = "Menu Accent", Flag = "MenuAccent", Default = default_color, Callback = function(state)
			library:ChangeAccent(state);
		end});
	end;
end;