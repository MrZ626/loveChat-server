--[[
	S→C
		0:ping
		1:you quited

		9:system message
		10:user say
	C→S
		0:ping
		1:My name
		2:I want quit
		10:my message
]]
local enet=require"enet"

local sub,gsub,find,format,upper=string.sub,string.gsub,string.find,string.format,string.upper
local ins,rem=table.insert,table.remove
local byte,char=string.byte,string.char

local clients={}--[id]={[peer],[name],[time]}

local names={}--names
local host=enet.host_create("localhost:626")

local function sysBC(mes)
	mes="\009["..mes.."]"
	print(mes)
	for id,peer in next,clients do
		peer:send(mes)
	end
end
local function userBC(mes,name)
	mes="\010"..name..":"..mes
	print(mes)
	for id,peer in next,clients do
		peer:send(mes)
	end
end
function love.run()
	local sleep=love.timer.sleep
	local PUMP,POLL=love.event.pump,love.event.poll
	local event
	print("server started.")
	return function()
		PUMP()if POLL()=="quit"then return 1 end
		::REPEAT::event=host:service()
		if event then
			local id=event.peer:connect_id()
			if event.type=="receive"then
				local name=names[id]
				local data=event.data
				local head=byte(data,1)
				data=sub(data,2)
				if head==0 then
					event.peer:send("\000")
				elseif head==1 then
					names[id]=data
					print(id.."'s name:"..data)
					sysBC(data.." Joined.")
				elseif head==2 then
					clients[id],names[id]=nil
					sysBC(name.." Disconneted.")
					event.peer:send("\001")
				elseif head==10 then
					userBC(data,names[id])
				end
			elseif event.type=="connect"then
				print("User "..id.." connected")
				clients[id]=event.peer
				event.peer:send("\000")
			elseif event.type=="disconnect"then
				print("Successfully disconnected")
			end
			goto REPEAT
		end
		sleep(.0626)
	end
end