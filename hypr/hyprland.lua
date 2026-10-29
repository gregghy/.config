-- Hyprland Lua config (migrated from hyprland.conf)
-- https://wiki.hypr.land/Configuring/Start/

------------------
---- MONITORS ----
------------------

hl.monitor({ output = "eDP-1", mode = "2256x1504@165", position = "0x0", scale = 1.566667 })
-- hl.monitor({ output = "DP-1", mode = "1920x1080@144", position = "0x0", scale = 1.0 })
hl.monitor({ output = "DP-2", mode = "3840x2160@60", position = "0x0", scale = 1.0 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.5 })

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start hyprland-session.target")
	hl.exec_cmd("waybar")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("swayosd-server")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("GDK_SCALE", "2")
hl.env("XCURSOR_SIZE", "24")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	-- disable anime girl wallpaper
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},

	-- unscale XWayland
	xwayland = {
		force_zero_scaling = true,
	},

	input = {
		kb_layout = "us, it",
		kb_variant = "",
		kb_model = "",
		kb_options = "grp:win_space_toggle",
		kb_rules = "",

		follow_mouse = 1,

		touchpad = {
			natural_scroll = false,
		},

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
	},

	general = {
		gaps_in = 5,
		gaps_out = 5,
		border_size = 1,

		layout = "dwindle",
	},

	decoration = {
		rounding = 10,

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true, -- you probably want this
	},

	cursor = {
		inactive_timeout = 0.1,
	},
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

---------------
---- INPUT ----
---------------

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "ALT" -- Sets Alt as main modifier

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("kitty --class yazi -e yazi"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("wofi --show drun"))
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("baomao-ask"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd('grim -g "$(slurp)" ~/Screenshots/_$(date +%F_%T).png'))
hl.bind("alt + shift + S", hl.dsp.exec_cmd('grim ~/Screenshots/_$(date +%F_%T).png && notify-send "Screenshot" "saved to ~/Screenshots/"'))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenrecord"))
hl.bind("CTRL + " .. mainMod .. " + D", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenrecord output"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("kitty --class herdr -e herdr"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("kitty --class nchat --config /home/gregghy/.config/kitty/kitty.conf --config /home/gregghy/.config/kitty/nchat.conf -e nchat"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swayosd-client --brightness -5"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("swayosd-client --brightness +5"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness +5"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness -5"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume +5"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -5"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("mpc toggle"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("mpc prev"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("mpc next"))
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("mpc stop"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))
hl.bind("CTRL + ALT + N", hl.dsp.exec_cmd("~/.config/hypr/scripts/nightlight"))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + CTRL + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
	-- Ignore maximize requests from all apps (prevents e.g. kitty from
	-- restoring a saved "maximized" state and covering other windows)
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fixed workspaces: 1 term, 2 web, 3 herdr, 4 files, 5 chat, 6 notes.
-- Named for waybar; they exist only while occupied or focused.
local function named_ws(id, name)
	hl.workspace_rule({ workspace = tostring(id), default_name = name })
end

named_ws(1, "term")
named_ws(2, "web")
named_ws(3, "herdr")
named_ws(4, "files")
named_ws(5, "chat")
named_ws(6, "notes")

-- Route apps to their workspace (match is regex, anchored).
local function route(class, ws)
	hl.window_rule({
		name = "route-" .. class,
		match = { class = "^" .. class .. "$" },
		workspace = tostring(ws),
	})
end

route("zen", 2)
route("firefox", 2)
route("herdr", 3)
route("yazi", 4)
route("nchat", 5)
route("obsidian", 6)

-- Float system TUIs launched from waybar (impala, wiremix).
hl.window_rule({
	name = "float-system-tuis",
	match = { class = "^(impala|wiremix|bluetui|rmpc)$" },
	float = true,
	center = true,
})

-- baomao's console: a floating pill centered over the desktop
hl.window_rule({
	name = "baomao-ask",
	match = { class = "^sh\\.baomao\\.ask$" },
	float = true,
	center = true,
	border_size = 0,
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})
