-- See https://wiki.hypr.land/Configuring/Basics/Binds/ for more

local mainMod = "SUPER"

-- Open the terminal
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty"))
-- Close the active window
hl.bind(mainMod .. " + W", hl.dsp.exec_raw("~/.config/hypr/scripts/closeApplication.sh"))
--  Lock the screen
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("swaylock"))
-- Show the logout window
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("wlogout -b 6 -T 400 -B 400 --protocol layer-shell"))
-- Exit Hyprland all together no (force quit Hyprland)
hl.bind(
	mainMod .. " + SHIFT + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
-- Allow a window to float
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
-- Show the graphicall app launcher
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("rofi -show drun"))
-- Toggle pseudo-split
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- Toggle split
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
-- Take a screenshot
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
-- Reload waybar
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("~/.config/waybar/scripts/launch.sh"))

-- todo change as you need
-- Open applications
hl.bind(mainMod .. " + 1", hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + 2", hl.dsp.no_op())
hl.bind(mainMod .. " + 3", hl.dsp.exec_cmd("chromium"))
hl.bind(mainMod .. " + 4", hl.dsp.exec_cmd("discord"))
hl.bind(mainMod .. " + 5", hl.dsp.exec_cmd("Telegram"))
hl.bind(mainMod .. " + 6", hl.dsp.exec_cmd("steam"))
hl.bind(mainMod .. " + 7", hl.dsp.no_op())
hl.bind(mainMod .. " + 8", hl.dsp.exec_cmd("/usr/bin/codium"))
hl.bind(mainMod .. " + 9", hl.dsp.exec_cmd("spotify-launcher"))
hl.bind(mainMod .. " + 0", hl.dsp.no_op())

-- Change Screen Temperature with wl-gammarelay
-- Reset temperature
hl.bind(
	mainMod .. " + CTRL + 0",
	hl.dsp.exec_cmd("busctl --user -- set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 6500")
)
-- Lower temperature
hl.bind(
	mainMod .. " + CTRL + Down",
	hl.dsp.exec_cmd("busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -500")
)
-- Raise the temperature
hl.bind(
	mainMod .. " + CTRL + Up",
	hl.dsp.exec_cmd("busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +500")
)

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("paximer -t"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("paximer -d 5"), { repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("paximer -i 5"), { repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pamixer --default-source -t"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 10%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { repeating = true })

-- Playerctl keys
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Changing workspaces and windows
-- cycle through the previous active workspace
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))
-- cycle through applications on same workspace
hl.bind("ALT + TAB", hl.dsp.window.cycle_next())
-- cycle through applications on same workspace backwards
hl.bind("ALT + SHIFT + TAB", hl.dsp.window.cycle_next({ next = "previous" }))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + F[1-12]
-- Move active window to a workspace with mainMod + SHIFT + F[1-12]
for i = 1, 12 do
	local key = i
	hl.bind(mainMod .. " + F" .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + F" .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- todo change as you need
-- Change background image
hl.bind(
	mainMod .. " + SHIFT + SPACE + 1",
	hl.dsp.exec_cmd("swaybg -m fill -i ~/.config/hypr/wallpapers/moon-over-mondstat.jpg")
)
hl.bind(mainMod .. " + SHIFT + SPACE + 2", hl.dsp.exec_cmd("swaybg -m fill -i ~/.config/hypr/wallpapers/sucrose.jpg"))
hl.bind(
	mainMod .. " + SHIFT + SPACE + 3",
	hl.dsp.exec_cmd("swaybg -m fill -i ~/.config/hypr/wallpapers/sayu-without-char.jpg")
)
hl.bind(mainMod .. " + SHIFT + SPACE + 4", hl.dsp.exec_cmd("swaybg -m fill -i ~/.config/hypr/wallpapers/xiao.jpg "))
