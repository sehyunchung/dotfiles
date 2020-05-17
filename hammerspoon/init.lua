hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function() hs.reload() end)
hs.alert.show("Hammerspoon config reloaded!")

hs.hotkey.bind({"cmd"}, "i", function()
	local input_source = hs.keycodes.currentSourceID()
	print(input_source) end)

do -- input source changer
	local inputSource = {
		english = "com.apple.keylayout.US",
		korean = "com.apple.inputmethod.Korean.2SetKorean"
	}

	local changeInput = function()
		local current = hs.keycodes.currentSourceID()
		local nextInput = nil

		if current == inputSource.english then
			nextInput = inputSource.korean
		else
			nextInput = inputSource.english
		end
		hs.alert.show(nextInput)
		hs.keycodes.currentSourceID(nextInput)
	end

	hs.hotkey.bind({"shift"}, "space", changeInput)
end

require('modules.inputsource_pink')

