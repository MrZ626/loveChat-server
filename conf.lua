function love.conf(w)
	w.title="P2P Mes"
	w.console=true
	w.appendidentity=true

	local M=w.modules
	M.timer,M.event=1,1
	M.window,M.keyboard,M.graphics,M.font,M.system=nil
	M.keyboard,M.touch,M.joystick,M.audio,M.sound=nil
	M.math,M.data,M.physics,M.thread,M.video=nil
end