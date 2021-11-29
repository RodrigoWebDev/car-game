pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
--game

function _init()
	init_game()
	high_score = 0
end

function _update()
	cls()
	print("score="..score)
	print("high score="..high_score)
	fn_cars()
	fn_player()
	fn_items()
end

function _draw()
	draw_player()
	draw_cars()
	draw_items()
end

-- converts anything to string, even nested tables
function tostring(any)
    if type(any)=="function" then 
        return "function" 
    end
    if any==nil then 
        return "nil" 
    end
    if type(any)=="string" then
        return any
    end
    if type(any)=="boolean" then
        if any then return "true" end
        return "false"
    end
    if type(any)=="table" then
        local str = "{ "
        for k,v in pairs(any) do
            str=str..tostring(k).."->"..tostring(v).." "
        end
        return str.."}"
    end
    if type(any)=="number" then
        return ""..any
    end
    return "unkown" -- should never show
end
-->8
--cars

function init_cars()
	cars={}
	car_speed=2
	tm=40
	tm_max=40
end

function draw_cars()
	foreach(cars, draw_car)
end
	
function fn_cars()
	tm+=1
	
	if tm >= tm_max then
		tm = 0
		add(cars, {
			x=128,
			y=rnd(120)
		})
	end
	
	foreach(cars, update_cars)
end
	
function update_cars(i)
	update_car_speed(i)
	destroy_car(i)
	car_collides_player(i)
end

function draw_car(i)
	spr(1, i.x, i.y)
end

function update_car_speed(i)
	i.x-=car_speed
end

function destroy_car(i)
 if i.x < 0 then
 	del(cars,i)
 	if tm_max<=5 then
			tm_max=5
		else
 		tm_max-=1
 	end
 end
end

function car_collides_player(i)
	if player.y <= i.y+6 and
		player.y >= i.y-6 and
		i.x <= player.x+8 then
			if(score > high_score) then
				high_score = score
			end
			init_game()
	end
end
-->8
--player

function init_player()
	player={
		sprite=0,
		x=8,
		y=60,
	}
end

function draw_player()
	spr(
		player.sprite,
		player.x,
		player.y,
		1,
		1,
		player.flip_x
	)
end

function fn_player()
	move_player()	
end

function move_player()
	if btn(⬆️) then
		player.y-=1
	elseif btn(⬇️) then
		player.y+=1
	else
		player.sprite=0
	end
end
-->8
--functions

function init_game()
	init_player()
	init_cars()
	ini_item()
	score=0
end
-->8
--item

function ini_item()
	items={}
	item_speed=1.5
	item_tm=0
end

function draw_items()
	foreach(items, draw_item)
end

function fn_items()
	item_tm+=1
	
	if item_tm>=80 then
		item_tm=0
		add(items, {
			x=128,
			y=rnd(120)
		})
	end
	
	foreach(items, update_items)
end
	
function update_items(i)
	destroy_items(i)
	item_collides_player(i)
	update_item_speed(i)
end

function update_item_speed(i)
	i.x-=item_speed
end

function draw_item(i)
	spr(2, i.x, i.y)
end

function destroy_items(i)
 if i.y > 128 then
 	del(items,i)
 end
end

function item_collides_player(i)	
	if player.x+8 >= i.x   and
		player.x <= i.x+8 and 
		i.y >= player.y-8 then
			score+=1
			del(items,i)
	end
end
__gfx__
00000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00555500005555000088888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05555500005555500084848000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
899999aaabbbbbb80088488000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999bbbbbbbb0088488000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
95599559b55bb55b0084848000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05500550055005500088888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
