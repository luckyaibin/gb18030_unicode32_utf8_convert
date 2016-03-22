----------------------  所有信件 --------------
msgs = BASE_WINDOW:new();
function msgs:self_init_face()
	Idx:new(start)
	Button:new(self, 1)
	local pry = center_h(CONFIG.font_h, 0, 58);
	Button:new_img(0, 0, self.__h, 632, 149, 'wdhead/msgs_bg.png')
	self:add_h(149);
	Button:new_img(0, 0, self.__h, 632, 58, 'base/top_ui01.png')
	Button:new_text_title(0, center(L'信件中心',0,632), self.__h + pry,L'信件中心',0XFFF200, 0X000000)
	self.face_buttom = Button.j;

	self.__h = add_face_butm(1,CONTACT)
	Button:new_img(0, 145, self.__h + 13, 37, 13, 'base/page_up01.png', nil, nil,{pg=-1} );
	Button:new_img(0, 410, self.__h + 13, 37, 13, 'base/page_down01.png', nil, nil,{pg=1} );
	Button:new_nodraw(Idx:next(), 146, self.__h+2, 92, 58,  self.nextpagekey, draw_select, {pg=-1})
	Button:new_nodraw(Idx:next(), 396, self.__h+2, 92, 58,  self.nextpagekey, draw_select, {pg=1})

	Button:new_text(0, center_w(CONFIG.font_w, 0, 632), self.__h + center_h(CONFIG.font_h, 0, 58), 0, -1, self.source.page, 0X00FF00)

	self.face_size = Button.j;

	self.face_top_h = self.start_y;
	self.face_bot_h = 120;
	self.not_face_pos = {0, self.start_y, 632, CONFIG.ui_h - self.face_bot_h  - self.start_y}
end
function msgs:self_init()
	print('init msgs .....')
	Idx:new(start)
	Button:new(self)
	self.start_y = 207;
	self.__h = self.start_y;

	local line_start_y = self.__h;
	self:add_h(6);

	local __x, t ,atp, str, mtp;
	for i=1,4 do
		__x = (i-1) * 150 + 20;
		t = self.titlelist[i];
		Button:new_img(Idx:next(), __x, self.__h, 135, 58, 'base/btbg.png', self.typemsgkey, nil,  {tp = t[2]})
		Button:new_text_title(0, center_w(CONFIG.font_w * 2, __x, __x+135), center_h(CONFIG.font_h, self.__h, self.__h + 58), t[1], 0XF26521, 0X000000)
		if t[2] == self.source.type then
			Button.now.color = 0XFFF200;
			atp = t[3];
			str = wstr.cat(L'清空',t[1],L'信件');
			mtp = t[1];
			msgs.msgIdList={};
		end;
	end;
	self:add_h(65);

	Button:new_img(0, 0, self.__h, 632, 58, 'base/hd.png', on_key, nil,  param)
	Button:new_text(0, 40, self.__h + center_h(CONFIG.font_h, 0, 58), 0, -1, L'主题', 0XABA000)
	Button:new_text(0, 285, self.__h + center_h(CONFIG.font_h, 0, 58), 0, -1, L'日期', 0XABA000)
	--[[if self.source.union_id and self.source.union_id > 0 then
		Button:new_img(Idx:next(), 440, self.__h, 169, 58, 'base/btbg4.png', self.sendunionmsgkey, nil, param)
		Button:new_text_title(0, center(MSG[7], 440, 440+169), center_h(CONFIG.font_h, self.__h, self.__h + 60), MSG[7], 0XFFF200, 0X000000)
	end;]]
	self:add_h(62);

	local msize = (self.source.msgs and table.getn(self.source.msgs)) or 0;
	if msize > 0 then
		local mg, rect_bt, fill_bt, maxh;
		local f_h = center_h(CONFIG.font_h, 0, 74)
		for i=1, msize do
			mg = self.source.msgs[i];
			Button:new_rect(0, 2, self.__h, 626, 86, 0X588526)
			rect_bt = Button.now;
			Button:new_fill(0, 3, self.__h + 1, 624, 84, 0X000D05,150)
			fill_bt = Button.now;
			Button:new_nodraw(Idx:next(), 3, self.__h+1, 280,  82,  self.readmsg, draw_select, {msgid = mg.msg_id, msg_type= mg.msg_type, index =i}, move_key)
			nodraw_h = Button.now;
			self:add_h(2);
			table.insert(msgs.msgIdList,  mg.msg_id); --用于存放mail id
			if mg.msg_type ~=nil and mg.msg_type ==10005 and overview.gettask==1 then
				Button:new_p2draw2(0, 20, self.__h-65, 26, 41, CONFIG.bimg_over, 8, on_key, draw_select, param,move_key);
			end
			if mg.msg_type ==nil or (mg.msg_type ~=10005 and mg.msg_type~=100) then
				Button:new_img(Idx:next(), 543, self.__h, 74, 74, 'base/eq_bg.png', self.delmsg, nil,  {msgid = mg.msg_id})
				Button:new_img(0, Button.now.x + 17, self.__h + 17, 40, 40, 'base/cancle_q.png')
			end
			
			Button:new_text_area(0, 10, self.__h,280,CONFIG.font_h,0, mg.title,mg.is_read and 0XFFFFFF or 0X0076A3)
			maxh = Button.now.h;
			if Button.now.h == CONFIG.font_h then
				Button.now.y = Button.now.y + f_h - 3;
				Button.now._y = Button.now._y + f_h - 3;
			end;
			maxh = get_max(maxh, 74)
			Button:new_text_area(0, 300, self.__h + center_h(CONFIG.font_h, 0, maxh), 350, CONFIG.font_h, 0, wstr.sub(mg.msg_time,5), 0X0076A3)

			self:add_h(maxh + 10);

			rect_bt.h = self.__h - rect_bt.y - 6;
			fill_bt.h = rect_bt.h - 2;
			nodraw_h.h = fill_bt.h;
		end
	else
		if not self.source.once then
		Button:new_rect(0, 2, self.__h, 626, 86, 0X588526)
		Button:new_fill(0, 3, self.__h + 1, 624, 84, 0X000D05)
		Button:new_text_area(0, 10, self.__h + 10, 600, CONFIG.font_h, 0, L'你暂时还没有信件。', 0X00FFFF, on_key, draw_select, param)
		self:add_h(100);
		end
	end;
	
	if self.source.union_id and self.source.union_id > 0 then
		Button:new_img(Idx:next(), 10, self.__h, 169, 58, 'base/btbg4.png', self.sendunionmsgkey, nil, param)
		Button:new_text_title(0, center_w(CONFIG.font_w * 4, 10, 10+169), center_h(CONFIG.font_h, self.__h, self.__h + 60), L'群发邮件', 0XFFF200, 0X000000)
	end;
	Button:new_img(Idx:next(), 393, self.__h, 227, 58, 'base/btn_227.png', self.clearmsg, nil, {atp = atp, mtp =mtp})
	Button:new_text_title(0, center_w(CONFIG.font_w * 6, 393, 393+227), center_h(CONFIG.font_h, self.__h, self.__h + 60), str, 0XFFF200, 0X000000)
	self:add_h(150);

	self:add_h(add_lines(line_start_y, self.__h))

	self.buttonsize = Button.j;
	self.buttonmaxyid = Button.j;
	print('init msgs  ok .....')
end;
msgs.titlelist = {{L'系统', 100, -1}, {L'玩家', 101, -2}, {L'联盟', 102, -3}, {L'战报', 103, -4}}
function msgs:nextpagekey(b)  -- 上下页
	local page = self.source.page + b.param.pg;
	if page <= 0 then
		return;
	end;
	Url:new(Url:get('MsgSvc', 'getMsgByType', self.source.type, page, 0), BACK_MSGS)
	self.back_y = self.scrollbars_y;
end;
function msgs:sendunionmsgkey(b)  -- 群发消息
	local k = {}
	k.targertname = '';
	k.targertuid =0;
	k.msgtype = 2;

	-----------------------------------------
	--[[
	local k = {}
	k.msgtype = 3;
	k.targertuid = 10;
	k.name = 'hgx';
	k.un_name = 'h';
	k.targertname = 'huanggx';
	]]--
	---------------------------------------
	window:child(self, sendmsg, k)
end;
function msgs:typemsgkey(b)   --分类信件
	Url:new(Url:get('MsgSvc', 'getMsgByType', b.param.tp, 0, 0), BACK_MSGS)
end;
function msgs:resultkey(b)--直接查看结果
	CONFIG.index = b.param.index;
	if b.param.msg_type == nil or b.param.msg_type=='' then
		b.param.msg_type =-1;
	end

	if not rwflash then
		local l = Url:load_lua(lua_url_s['rwflash'])
		Url:getlua(l)
	end
	if not rwResult then
		print(lua_url_s['rwresult'])
		local l = Url:load_lua(lua_url_s['rwresult'])
		Url:getlua(l)
	end;

	Url:new(Url:get('MsgSvc', 'ReadMsgs', b.param.msgid), BACK_RESULT_NOW)
	b.color = 0XFFFFFF;
end
--[[function msgs:readmsg(b)  -- 读取信件
	CONFIG.index = b.param.index;
	if b.param.msg_type == nil or b.param.msg_type=='' then
		b.param.msg_type =-1;
	end
	Url:new(Url:get('MsgSvc', 'ReadMsgs', b.param.msgid), BACK_READMSG)
	b.color = 0XFFFFFF;
end;]]--
function msgs:readmsg(b)  -- 读取信件
	CONFIG.index = b.param.index;
	if b.param.msg_type == nil or b.param.msg_type=='' then
		b.param.msg_type =-1;
	end

	if not rwflash then
		local l = Url:load_lua(lua_url_s['rwflash'])
		Url:getlua(l)
	end
	if not rwResult then
		print(lua_url_s['rwresult'])
		local l = Url:load_lua(lua_url_s['rwresult'])
		Url:getlua(l)
	end;

	Url:new(Url:get('MsgSvc', 'ReadMsgs', b.param.msgid), BACK_READMSG)
	b.color = 0XFFFFFF;
end;
function msgs:delmsg(b)	 --删除信件
	Url:new(Url:get('MsgSvc', 'getMsgByType', self.source.type, self.source.page, b.param.msgid), BACK_MSGS)
	self.back_y = self.scrollbars_y;
end;
function msgs:clearmsg(b) --清除信件
	baseSysinfo(self, {infos = wstr.cat(L'确定要清空所有',b.param.mtp,L'信件吗?清除了以后无法再恢复'),
	left_url= Url:get('MsgSvc', 'getMsgByType', self.source.type, 0, b.param.atp), backid=BACK_MSGS})
end;
function msgs:on_response(data,url,code,attach)
	print('response msgs .....')
	local k = data._return;
	if attach == BACK_MSGS then
		self:refresh(k)
		if k.newmsgnum and overview.save_source then
			overview.source.baseuserinfo.newmessgaes = k.newmsgnum;
			overview:refresh()
			overview.back_y = overview.scrollbars_y;
		end;
	elseif attach == BACK_READMSG then
		if overview.gettask==1 then
			overview.gettask=0;
			self:refresh();
		end
		if k.error then
			baseSysinfo(self, k)
		elseif k.msgtype == 11 then  -- 战报
			window:child(self, rwflash, k)
		elseif k.msgtype == 10 then  --谍报
			window:child(self, showspy, k)
		else
			window:child(self, showmsg, k)
		end
		if overview.isRegister then
			overview.isRegister=nil;
			overview:refresh();
		end;
		
		
	elseif attach == BACK_RESULT_NOW then
		window:child(self, showrw, k)
	end;
end;
print('load msgs  ok')
-------------------------  查看普通信件 ------------------------
showmsg = BASE_WINDOW:new();
function showmsg:self_init()
	print('init showmsg .....')
	Idx:new(start)
	Button:new(self)
	self.start_y = 170
	self.__h = self.start_y;

	local line_start_y = self.__h;
	local starty = self.__h;
	Button:new_img(0, 2, self.__h, 622, 11, 'base/top_622.png');
	self:add_h(30);
	if self.source.headpic then
		Button:new_img(0, 270, self.__h - 20, 91, 113, 'head/'.. self.source.headpic ..'.png')
		self:add_h(120);
	end;

	local msg = self.source.msg;
	local str;
	if msg.from_uid ~= 0 then  -- 玩家信件
		local clname = 0X8DC63F;
		Button:new_text(0, center(msg.title, 0, 632), self.__h + 2, 0, -1, msg.title, 0X00FF00)
		self:add_h(CONFIG.font_h + 10)
		str = wstr.cat(msg.from_username,'  ', wstr.sub(msg.msg_time, 5))
		if msg.isShowTitle  then --称号时变颜色
			clname =0XE4018C;
		end
		--玩家是否是vip(1,2)
		if msg.vippid > 0 then
			Button:new_img(0, center(str, 0, 632) - 40, self.__h - 10, 40, 40, 'ov/'..msg.vippid..'.png')
		end
		Button:new_text(0, center(str, 0, 632), self.__h + 2, 0, -1, str, clname)
		self:add_h(CONFIG.font_h+10)
	else  -- 系统信件
		str = wstr.cat(L'系统  ', wstr.sub(msg.msg_time, 5))
		Button:new_text(0, center(str, 0, 632), self.__h + 2, 0, -1, str, 0X8EB4D4)
		self:add_h(CONFIG.font_h+10)
	end;

	local cnsize = (msg.content and table.getn(msg.content)) or 0;
	if cnsize > 0 then
		for i=1, cnsize do
			Button:new_text_area(0, 40, self.__h, 560, CONFIG.font_h, CONFIG.font_w * 2, msg.content[i], 0XA2D39C)
			self:add_h(Button.now.h + 5)
		end
		self:add_h(CONFIG.font_h + 5)
	end;

	if msg.from_uid ~= 0 then
		Button:new_img(Idx:next(), 248, self.__h, 135, 58, 'base/btbg.png', self.backmsgkey, nil,  param)
		Button:new_text_title(0, center_w(CONFIG.font_w * 2, 248, 248+135), center_h(CONFIG.font_h, self.__h, self.__h + 58), L'回复', 0XF26521, 0X000000)
		self:add_h(80)
	end;
	if msgs.msgIdList[CONFIG.index-1] then
		Button:new_img(Idx:next(), 60, self.__h, 135, 58, 'base/btbg_h.png', self.nextkey, nil,  {msg_type =self.source.msgtype , page = -1})
		Button:new_img(Idx:next(), Button.now.x + 24, self.__h+17, 87, 24, 'base/mail_up.png', self.nextkey, nil,  {msg_type =self.source.msgtype , page = -1})
	end
	--曹操书信时才显示W+的邀请按钮
	--[[if msg.isShow and CONFIG.isWallocregion then
		Button:new_img(Idx:next(), 256, self.__h-40, 120, 120, 'wplus/invite.png', menu.toWInviteFriend)
	end]]
	
	if msgs.msgIdList[CONFIG.index+1] then
		Button:new_img(Idx:next(), 445, self.__h, 135, 58, 'base/btbg_h.png', self.nextkey, nil,  {msg_type =self.source.msgtype , page = 1})
		Button:new_img(Idx:next(), Button.now.x + 24, self.__h+17, 87, 24, 'base/mail_down.png', self.nextkey, nil,  {msg_type =self.source.msgtype , page = 1})
	end
	self:add_h(60)
	self:add_h(addbor622(starty + 3, self.__h + 10))
	self:add_h(80);
	self:add_h(add_lines(line_start_y, self.__h))
	self.buttonsize = Button.j;
	self.buttonmaxyid = Button.j;
	print('init showmsg  ok .....')
end;

--头部和脚部的固定部分
function showmsg:self_init_face()
	Idx:new(start)
	Button:new(self, 1)
	local line_start_y = self.__h;
	local pry = center_h(CONFIG.font_h, 0, 0)
	for i=1,8 do
		Button:new_img_ex(0, (i-1)*79, self.__h+100,CONFIG.ui_w,self.start_y - 100, 'base/uibg.png')
	end
	Button:new_img(0, 0, self.__h, 632, 58, 'base/top_ui01.png')
	self:add_h(58);
	Button:new_img(0, 0, self.__h, 632, 58, 'base/hd.png')
	self:add_h(58);
	Button:new_img(0, 1, self.__h, 83, 48, 'base/b_7.png')
	Button:new_img(0, 543, self.__h, 83, 48, 'base/b_8.png')
	self:add_h(48);
	self.face_buttom = Button.j;

	self:add_h(add_lines(line_start_y, self.__h))

	self.face_buttom = Button.j;
	self.__h = add_face_butm(2)

	self.face_size = Button.j;
	self.face_top_h = self.start_y;
	self.face_bot_h = 120;
	self.not_face_pos = {0, self.start_y, 632, CONFIG.ui_h - self.face_bot_h  - self.start_y}

	if overview.save_source then
		overview.source.baseuserinfo.newmessgaes = self.source.newmsgnum;
		overview:refresh()
		overview.back_y = overview.scrollbars_y;
	end;
end;

function showmsg:backmsgkey(b)  -- 回复消息
	local p = self.parent;
	self:free()
	local k = {}
	k.msgtype = 1;
	k.targertuid = self.source.msg.from_uid;
	--k.name = 'hgx';
	--k.un_name = 'h';
	k.targertname = self.source.msg.from_username;
	window:child(p, sendmsg, k)
end;
function showmsg:nextkey(b) --上一封  下一封
	CONFIG.index = CONFIG.index+b.param.page;
	Url:new(Url:get('MsgSvc', 'ReadMsgs', msgs.msgIdList[CONFIG.index]), BACK_LAST_NEXT)
end
function showmsg:on_response(data,url,code,attach)
	print('response showmsg .....')
	local k = data._return;
	if attach == BACK_LAST_NEXT then
		if overview.gettask==1 then
			overview.gettask=0;
			self:refresh();
		end
		if k.error then
			baseSysinfo(self, k)
		elseif k.msgtype == 11 then  -- 战报
			window:child(self, rwflash, k)

			--window:child(self, showrw, k)
		elseif k.msgtype == 10 then  --谍报
			window:child(self, showspy, k)
		else
			--window:child(self, showmsg, k)
			self:refresh(k);
		end
		if overview.isRegister then
			overview.isRegister=nil;
			overview:refresh();
		end;
	end
end;
print('load showmsg  ok')
-----------------------  查看战报 ------------------
showrw = BASE_WINDOW:new();
function showrw:self_init()
	print('init showrw .....')
	Idx:new(start)
	Button:new(self)
	self.start_y = 207;
	self.__h = self.start_y;
	local line_start_y = self.__h;

	local pry = center_h(CONFIG.font_h, 0, 58)

	Button:new_img(0, 0, self.__h, 632, 58, 'base/hd.png')
	Button:new_text(0, center_w(CONFIG.font_w*4, 0, 632), self.__h + pry, 0, -1, L'战斗报告', 0X00FF00)
	self:add_h(60);

	local rect_bt, fill_bt;
	if self.source.leavings ~= '' then -- 战斗宣言
		Button:new_rect(0, 2, self.__h, 627, 86, 0X588526)
		rect_bt = Button.now;
		Button:new_fill(0, 3, self.__h + 1, 625, 84, 0X000D05)
		fill_bt = Button.now;
		self:add_h(2);
		Button:new_text(0, center_w(CONFIG.font_w*4, 0, 632), self.__h, 0, -1, L'战斗宣言', 0X8DC63F)
		self:add_h(CONFIG.font_h+10);
		Button:new_text_area(0, 150, self.__h, 400, CONFIG.font_h, 0, wstr.cat(self.source.oname, ': ', self.source.leavings), 0XFFFFFF)
		self:add_h(Button.now.h + 10)

		rect_bt.h = self.__h - rect_bt.y - 4;
		fill_bt.h = rect_bt.h - 2;
	end;

	if self.source.to_union then -- 发布到联盟
		self:add_h(-3);

		Button:new_img(0, 48, self.__h, 120, 65, 'base/b_15.png')
		Button:new_img(0, 464, self.__h, 120, 65, 'base/b_16.png')
		Button:new_img(Idx:next(), 168, self.__h + 1, 296, 58, 'base/hd_170.png', self.msgtounion, nil,  param)
		Button:new_text(0, center_w(CONFIG.font_w*6, 168, 168+296), self.__h + pry + 1, 0, -1, L'写入联盟讨论', 0XFFF200)
		self:add_h(62)
	end;

	Button:new_img(0, 2, self.__h, 622, 11, 'base/top_622.png')
	self:add_h(8)
	local starty = self.__h;

	Button:new_text(0, center_w(CONFIG.font_w*3, 0, 251), self.__h, 0, -1, L'攻击方', 0XFF0000)
	Button:new_text(0, center(self.source.oname, 0, 251), self.__h + CONFIG.font_h, 0, -1, self.source.oname, 0XFF0000)

	Button:new_img(0, 251, self.__h + center_h(34, 0, CONFIG.font_h*2), 52, 34, 'ot/pk.png')

	Button:new_text(0, center_w(CONFIG.font_w*3, 303, 632), self.__h, 0, -1, L'防守方', 0X00AEEF)
	Button:new_text(0, center(self.source.dname, 303, 632), self.__h + CONFIG.font_h, 0, -1, self.source.dname, 0X00AEEF)

	self:add_h(get_max(CONFIG.font_h *2, 34))
	self:add_h(addbor622(starty, self.__h))
	self:add_h(5);

	if self.source.mgift ~= '0' or self.source.cgift ~= '0' or self.source.dgift ~= '0' or self.source.pgid > 0
			or self.source.npc_id > 0 or self.source.box_id > 0 or self.source.equi_id > 0 then

		Button:new_img(0, 2, self.__h, 622, 11, 'base/top_622.png')
		self:add_h(8)
		starty = self.__h;



		Button:new_img(0, 48, self.__h, 120, 65, 'base/b_15.png')
		Button:new_img(0, 464, self.__h, 120, 65, 'base/b_16.png')
		Button:new_img(0, 168, self.__h + 1 - 5, 296, 58, 'base/hd_170.png')
		local str;
		if self.source.result == 1 then  str = L'获得';		else  str = L'失去';		end;
		Button:new_text(0, center_w(CONFIG.font_w*2, 0, 632), self.__h + pry + 1 - 5, 0, -1, str, 0X00FF00)
		self:add_h(62)

		if self.source.mgift ~= '0' or self.source.cgift ~= '0' or self.source.dgift ~= '0' then  --		资源
			local f_h = center_h(CONFIG.font_h, 0 , 30)
			Button:new_rect(0, 6, self.__h, 615, 55, 0X588526)
			self:add_h(4)
			Button:new_img(0, 78, self.__h, 42, 42, 'base/m.png')
			Button:new_text(0, 130, self.__h + f_h, 0, -1, self.source.mgift, 0XB99A6E)

			Button:new_img(0, 255, self.__h, 42, 42, 'base/c.png')
			Button:new_text(0, 307, self.__h + f_h, 0, -1, self.source.cgift, 0XB99A6E)

			Button:new_img(0, 452, self.__h, 42, 42, 'base/h.png')
			Button:new_text(0, 505, self.__h + f_h, 0, -1, self.source.dgift, 0XB99A6E)
			self:add_h(55)

		end
		self:add_h(3)
		self.ady = false;
		local __x = 30;
		if self.source.pgid > 0 then  --俘获了将领
			Button:new_img(0, __x, self.__h, 137, 167, 'genralhead/'..self.source.pgid..'.png')
			Button:new_text(0, __x, self.__h + 170, 0, -1, self.source.prisoner, 0X8DC63F)
			__x = self:get_x(__x);
		end;
		if self.source.npc_id > 0 then  --获得了 美女npc
			Button:new_img(0, __x, self.__h, 93, 93, 'harem/'..self.source.npc_id..'.png')
			Button:new_text(0, __x, self.__h + 100, 0, -1, self.source.npcdec, 0X8DC63F)
			__x = self:get_x(__x);
		end;

		if self.source.box_id > 0 and self.source.boxdec ~= '' then  --获得道具
			Button:new_img(0, __x, self.__h, 93, 93, 'item/'..self.source.box_id..'_.png')
			Button:new_text(0, __x, self.__h + 93, 0, -1, self.source.boxdec, 0X8DC63F)
			__x = self:get_x(__x);
		end;

		if self.source.equi_id > 0 then --掉装备
			Button:new_img(0, __x, self.__h + 10, 74, 74, 'base/eq_bg.png')
			Button:new_img(0, __x + 13, self.__h + 22, 46, 46, 'equi/'..self.source.equi_id..'.png')
			Button:new_text(0, __x, self.__h + 90, 0, -1, self.source.euipdec, 0X8DC63F)
			__x = self:get_x(__x);
		end;
		if self.ady then
			self:add_h(100 + CONFIG.font_h)
		end;
		
		if self.source.activeitem~=nil and self.source.activeitem~='' then--打移动城掉的东西
			Button:new_text_area(0, 10, self.__h, 550, CONFIG.font_h, 0, self.source.activeitem or '', 0Xffff00)
			self:add_h(Button.now.h + 10)
		end
		self:add_h(addbor622(starty, self.__h))
		self:add_h(5);
	end

	if self.source.ges ~= '' or (self.source.debris_m ~= '0' or self.source.debris_c ~= '0') then
		Button:new_img(0, 2, self.__h, 622, 11, 'base/top_622.png')
		self:add_h(8)
		starty = self.__h;
		if self.source.ges ~= '' then
			Button:new_text_area(0, 100, self.__h, 400, CONFIG.font_h, 0, self.source.ges , 0XFFFFFF)
			self:add_h(Button.now.h+20)
		end;
		if self.source.debris_m ~= '0' or self.source.debris_c ~= '0' then
			local str = wstr.cat(L'产生了一片含有: ', self.source.debris_m, L' 铁锭，和 ', self.source.debris_c, L' 木材，的废墟')
			Button:new_text_area(0, 100, self.__h, 400, CONFIG.font_h, 0, str , 0XFFFFFF)
			self:add_h(Button.now.h+20)
		end;

		self:add_h(addbor622(starty, self.__h))
		self:add_h(5);
	end

	local psize = (self.source.prisonerfs and table.getn(self.source.prisonerfs)) or 0;
	if psize > 0 then
		Button:new_img(0, 2, self.__h, 622, 11, 'base/top_622.png')
		self:add_h(8)
		local starty = self.__h;
		local str = L'俘虏了一批士兵';
		if self.source.result == 2 then
			str = wstr.cat(L'被', str)
		end;

		Button:new_text(0, 50, self.__h + pry, 0, -1, str, 0XFFFFFF)

		Button:new_img(Idx:next(), 480, self.__h, 135, 58, 'base/btbg.png', self.captureinfo, nil, param)
		Button:new_text_title(0, center_w(CONFIG.font_w * 2, 480, 480+135), center_h(CONFIG.font_h, self.__h, self.__h + 58), L'详细', 0XFFF200, 0X000000)
		self:add_h(60)

		self:add_h(addbor622(starty, self.__h))
		self:add_h(3);
	end;

	Button:new_img(0, 48, self.__h, 120, 65, 'base/b_15.png')
	Button:new_img(0, 168, self.__h + 1, 296, 58, 'base/hd_170.png')
	Button:new_text(0, center_w(CONFIG.font_w*2, 0, 632), self.__h + pry + 1, 0, -1, L'部队', 0X8EB4D4)
	Button:new_img(0, 464, self.__h, 120, 65, 'base/b_16.png')
	self:add_h(62)

	local teamsize = (self.source.ofleet and table.getn(self.source.ofleet)) or 0;
	local u, flsize, __x, __mod, fl, usernpc;
	local k = 1;
	for i=1, teamsize do
		u = self.source.ofleet[i];
		usernpc = u.userNpc;
		local str = wstr.cat(L'攻击方:', u.username)

		Button:new_rect(0, 3, self.__h, 623, 86, 0X6B3008)
		rect_bt = Button.now;
		Button:new_fill(0, 4, self.__h + 1, 621, 84, 0X120300)
		fill_bt = Button.now;
		self:add_h(5);
		Button:new_text(0, 30, self.__h, 0, -1, str, 0XFF0000)
		self:add_h(CONFIG.font_h+3)

		Button:new_text(0, 30, self.__h, 0, -1, wstr.cat(L'坐标:  [', u.pos, ']'), 0XFF0000)
		self:add_h(CONFIG.font_h+5)
		if self.source.MsgContent~=nil and self.source.MsgContent~='' then
			Button:new_text(0, 30, self.__h, 0, -1, self.source.MsgContent or '', 0XFFD800)
			self:add_h(CONFIG.font_h+5)
		end
		fill_bt.h = self.__h - fill_bt.y;

		Button:new_line(0 , 4, self.__h, 624, self.__h, 0X6B3008)
		self:add_h(1)
		Button:new_fill(0, 4, self.__h, 621, 84, 0X190000)
		fill_bt = Button.now;
		self:add_h(5)
		if u.general and u.general.name then
			if CONFIG.uid == u.uid then
				Button:new_img(0, 26, self.__h, 137, 167, 'genralhead/'.. u.general.id ..'.png')
			else
				Button:new_img(Idx:next(), 26, self.__h, 137, 167, 'genralhead/'.. u.general.id ..'.png', self.otherGenInfo, nil,  {uid=u.uid, gid = u.general.id})
			end
			--星级
			Button:new_text(0, 180, self.__h + 20, 0, -1, u.general.name, 0X00FF00)
			Button:new_text(0, 180, self.__h + 30 + CONFIG.font_h, 0, -1, wstr.cat(L'等级:', u.general.lvl), 0X8DC63F)
		else
			Button:new_img(0, 26, self.__h, 137, 167, 'genralhead/0.png')
		end;
		s_h = self.__h;
		s_h2 = self.__h + 170;
		if usernpc ~=nil and usernpc.commandaddnum~= nil and usernpc.commandaddnum >1 then
			Button:new_text(0, 265, s_h, 0, -1, wstr.cat(L'美女加成：统率(+',usernpc.commandaddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.attackaddnum~=nil and usernpc.attackaddnum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'攻击(+',usernpc.attackaddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.powernum~=nil and usernpc.powernum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'体力(+',usernpc.powernum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.speedaddnum~=nil and usernpc.speedaddnum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'速度(+',usernpc.speedaddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.defenceaddnum~=nil and usernpc.defenceaddnum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'防御(+',usernpc.defenceaddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.iq~= nil and usernpc.iq >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'智力(+',usernpc.iq or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.baddnum~=nil and usernpc.baddnum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'步兵(+',usernpc.baddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.qaddnum~=nil and usernpc.qaddnum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'骑兵(+',usernpc.qaddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.yaddnum~=nil and usernpc.yaddnum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'远程(+',usernpc.yaddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.jaddnum~=nil and usernpc.jaddnum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'机兵(+',usernpc.jaddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.daddnum~=nil and usernpc.daddnum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'城防(+',usernpc.daddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end

		--[[self:add_h(get_max(CONFIG.font_h*2+20, 200) + 3)
		if u.general.skId and u.general.skId>0 then --发动技能时要显示图标
			Button:new_img(Idx:next(), 25, self.__h , 42, 42,'generalskill/'..u.general.skId..'.png',self.showSkillkey, nil, {name = u.general.skill, desc =u.general.desc or ''})
			Button:new_text_title(0, 75, self.__h, u.general.skill, 0XFFF200, 0X500000, on_key, draw_select, param)
			self:add_h(50)
		end]]
		if u.general.skill then
			for _k,_v in pairs(u.general.skill)do
				if _v.skId and _v.skill then
					Button:new_img(Idx:next(), 26, s_h2, 42, 42,'generalskill/'.._v.skId..'.png',self.showSkillkey, nil, {name = _v.skill, desc =_v.desc or ''})
					Button:new_text_title(0, Button.now.x + Button.now.w + 10, s_h2, _v.skill, 0XFFF200, 0X500000, on_key, draw_select, param)
					s_h2 = s_h2 + 50;
				end
			end
		end
		self:add_h((s_h > s_h2 and s_h or s_h2) - self.__h);
		fill_bt.h = self.__h - fill_bt.y;

		Button:new_line(0 , 4, self.__h, 624, self.__h, 0X6B3008)
		Button:new_fill(0, 4, self.__h + 1, 621, 84, 0X1E0800)
		fill_bt = Button.now;
		self:add_h(6)

		flsize = table.getn(u.fleet)
		local oIsHF = 2;
		for i=1, flsize do
			fl = u.fleet[i];
			if fl.hf and fl.hf >0 then
				oIsHF = 3;
			end
			__mod = math.mod(i-1, 4)
			__x = __mod * 150 + 25;
			if i > 1 and __mod == 0 then
				self:add_h(130 + CONFIG.font_h * (oIsHF+1))
				fill_bt.h = self.__h - fill_bt.y;
				Button:new_line(0 , 4, self.__h, 624, self.__h, 0X6B3008)
				k = k + 1;
				Button:new_fill(0, 4, self.__h + 1, 621, 84, 0X1E0800)
				self:add_h(6)
				fill_bt = Button.now;
				if math.mod(k, 2) == 0 then
					Button.now.color = 0X190000;
				end;
			end;
			Button:new_img(0, __x, self.__h, 93, 93, 'item/'.. fl.id ..'_.png')
			Button:new_text(0, __x, self.__h + 93, 0, -1, fl.fname, 0XC7B299)
			Button:new_text(0, __x, self.__h + 93+CONFIG.font_h, 0, -1, my_format(fl.num), 0X988675)
			Button:new_text(0, __x, self.__h + 93+CONFIG.font_h*2, 0, -1, wstr.cat(L'-',my_format(fl.lose)), 0X726257)
			if fl.hf and fl.hf >0 then
				Button:new_text(0, __x, self.__h + 93+CONFIG.font_h*oIsHF, 0, -1, wstr.cat(L'+',my_format(fl.hf)), 0X00ff00)
			end
		end
		self:add_h(130 + CONFIG.font_h * (oIsHF+1))
		fill_bt.h = self.__h - fill_bt.y - 1;
		rect_bt.h = self.__h - rect_bt.y;
		self:add_h(6)
	end;


	local teamsize = (self.source.dfleet and table.getn(self.source.dfleet)) or 0;
	for i=1, teamsize do
		u = self.source.dfleet[i];
		usernpc = u.userNpc;
		Button:new_rect(0, 3, self.__h, 624, 86, 0X6B3008)
		rect_bt = Button.now;
		Button:new_fill(0, 4, self.__h + 1, 621, 84, 0X000000)
		fill_bt = Button.now;
		self:add_h(5);
		local str = wstr.cat(L'防守方:', u.username)
		Button:new_text(0, 30, self.__h, 0, -1, str, 0X00AEEF)
		self:add_h(CONFIG.font_h+3)
		Button:new_text(0, 30, self.__h, 0, -1, wstr.cat(L'坐标:  [', u.pos, ']'), 0X00AEEF)
		self:add_h(CONFIG.font_h+5)
		fill_bt.h = self.__h - fill_bt.y;

		Button:new_line(0 , 4, self.__h, 624, self.__h, 0X6B3008)
		self:add_h(1)
		Button:new_fill(0, 4, self.__h, 621, 84, 0X071323)
		fill_bt = Button.now;
		self:add_h(5);
		if u.general and u.general.name then
			if CONFIG.uid == u.uid then
				Button:new_img(0, 26, self.__h, 137, 167, 'genralhead/'.. u.general.id ..'.png')
			else
				Button:new_img(Idx:next(), 26, self.__h, 137, 167, 'genralhead/'.. u.general.id ..'.png', self.otherGenInfo, nil,  {uid=u.uid, gid = u.general.id})
			end

			--星级
			Button:new_text(0, 180, self.__h + 20, 0, -1, u.general.name, 0X00FF00)
			Button:new_text(0, 180, self.__h + 20 + CONFIG.font_h, 0, -1, wstr.cat(L'等级:', u.general.lvl), 0X8DC63F)
		else
			Button:new_img(0, 26, self.__h, 137, 167, 'genralhead/0.png')
		end;
		s_h = self.__h;
		s_h2 = self.__h + 170;
		if usernpc ~=nil and usernpc.commandaddnum~= nil and usernpc.commandaddnum >1 then
			Button:new_text(0, 265, s_h, 0, -1, wstr.cat(L'美女加成：统率(+',usernpc.commandaddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.attackaddnum~=nil and usernpc.attackaddnum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'攻击(+',usernpc.attackaddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.powernum~=nil and usernpc.powernum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'体力(+',usernpc.powernum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.speedaddnum~=nil and usernpc.speedaddnum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'速度(+',usernpc.speedaddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.defenceaddnum~=nil and usernpc.defenceaddnum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'防御(+',usernpc.defenceaddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.iq~= nil and usernpc.iq >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'智力(+',usernpc.iq or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.baddnum~=nil and usernpc.baddnum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'步兵(+',usernpc.baddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.qaddnum~=nil and usernpc.qaddnum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'骑兵(+',usernpc.qaddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.yaddnum~=nil and usernpc.yaddnum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'远程(+',usernpc.yaddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.jaddnum~=nil and usernpc.jaddnum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), s_h, 0, -1, wstr.cat(L'机兵(+',usernpc.jaddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end
		if usernpc ~=nil and usernpc.daddnum~=nil and usernpc.daddnum >1 then
			Button:new_text(0, 265+(CONFIG.font_w*4), self.__h, 0, -1, wstr.cat(L'城防(+',usernpc.daddnum or '','%)'), 0XFD4DB5)
			s_h = s_h + CONFIG.font_h;
		end

		--[[self:add_h(get_max(CONFIG.font_h*2+20, 200) + 3)
		if u.general.skId and u.general.skId >0 then
			Button:new_img(Idx:next(), 25, self.__h , 42, 42,'generalskill/'..u.general.skId..'.png',self.showSkillkey, nil, {name = u.general.skill, desc =u.general.desc or ''})
			Button:new_text_title(0, 75, self.__h, u.general.skill, 0XFFF200, 0X500000, on_key, draw_select, param)
			self:add_h(50)
		end]]
		if u.general.skill then
			for _k,_v in pairs(u.general.skill)do
				if _v.skId and _v.skill then
					Button:new_img(Idx:next(), 26, s_h2, 42, 42,'generalskill/'.._v.skId..'.png',self.showSkillkey, nil, {name = _v.skill, desc =_v.desc or ''})
					Button:new_text_title(0, Button.now.x + Button.now.w + 10, s_h2, _v.skill, 0XFFF200, 0X500000, on_key, draw_select, param)
					s_h2 = s_h2 + 50;
				end
			end
		end
		self:add_h((s_h > s_h2 and s_h or s_h2) - self.__h);
		fill_bt.h = self.__h - fill_bt.y;


		Button:new_line(0 , 4, self.__h, 624, self.__h, 0X6B3008)
		Button:new_fill(0, 4, self.__h + 1, 621, 84, 0X0F1B3C)
		fill_bt = Button.now;
		self:add_h(6)

		flsize = table.getn(u.fleet)
		k = 1;
		local dIsHF = 2;
		for i=1, flsize do
			fl = u.fleet[i];
			if fl.hf and fl.hf>0 then
				dIsHF =3;
			end
			__mod = math.mod(i-1, 4)
			__x = __mod * 150 + 25;
			if i > 1 and __mod == 0 then
				self:add_h(120 + CONFIG.font_h * (dIsHF+1))
				fill_bt.h = self.__h - fill_bt.y;
				Button:new_line(0 , 4, self.__h, 624, self.__h, 0X6B3008)
				k = k + 1;
				Button:new_fill(0, 4, self.__h + 1, 621, 84, 0X0F1B3C)
				self:add_h(6)
				fill_bt = Button.now;
				if math.mod(k, 2) == 0 then
					Button.now.color = 0X071323;
				end;
			end;
			Button:new_img(0, __x, self.__h, 93, 93, 'item/'.. fl.id ..'_.png')
			Button:new_text(0, __x, self.__h + 93, 0, -1, fl.fname, 0XC7B299)
			Button:new_text(0, __x, self.__h + 93+CONFIG.font_h, 0, -1, my_format(fl.num), 0X988675)
			Button:new_text(0, __x, self.__h + 93+CONFIG.font_h*2, 0, -1, wstr.cat(L'-',my_format(fl.lose)), 0X726257)
			if fl.hf and fl.hf >0 then
				Button:new_text(0, __x, self.__h + 93+CONFIG.font_h*dIsHF, 0, -1,wstr.cat(L'+',my_format(fl.hf)), 0X00ff00)
			end
		end
		self:add_h(120 + CONFIG.font_h * (dIsHF+1))
		fill_bt.h = self.__h - fill_bt.y - 1;
		rect_bt.h = self.__h - rect_bt.y;
		self:add_h(6)
	end;
	self:add_h(-5);
	Button:new_img(0, 48, self.__h, 120, 65, 'base/b_15.png')
	Button:new_img(Idx:next(), 168, self.__h + 1, 296, 58, 'base/hd_170.png', self.rwinfokey, nil,  param)
	Button:new_text(0, center_w(CONFIG.font_w*4, 0, 632), self.__h + pry + 1, 0, -1, L'战斗过程', 0XD9861B)
	Button:new_img(0, 464, self.__h, 120, 65, 'base/b_16.png')
	self:add_h(70)
	Button:new_img(Idx:next(), (CONFIG.ui_w - 169)/2, self.__h, 169, 58, 'base/btbg4.png', self.backToLastKey, nil, param)
	Button:new_text_title(0, center_w(CONFIG.font_w * 4,Button.now.x,Button.now.x + Button.now.w), center_h(CONFIG.font_h, self.__h, self.__h + 58), L'战斗画面', 0xFFF200, 0x000000)
	
	self:add_h(200)
	
	self:add_h(add_lines(line_start_y, self.__h))

	self.buttonsize = Button.j;
	self.buttonmaxyid = Button.j;
	print('init showrw  ok .....')
end;

--头部和脚部的固定部分
function showrw:self_init_face()
	Idx:new(start)
	Button:new(self, 1)
	local imgul ;
	if self.source.result == 1 then --胜利
		imgul = 'wdhead/war_win_bg.png';
	elseif self.source.result == 2 then --失败
		imgul = 'wdhead/war_lose_bg.png'
	else
		imgul = 'wdhead/dogfall_bg.png';
	end;
	Button:new_img(0, 0, self.__h, 632, 149, imgul)
	self:add_h(149);

	Button:new_img(0, 0, self.__h,632, 58, 'base/top_ui01.png')
	self:add_h(58);
	local line_start_y = self.__h;

	self.face_buttom = Button.j;
	self.__h = add_face_butm(2)

	self.face_size = Button.j;
	self.face_top_h = self.start_y;
	self.face_bot_h = 120;
	self.not_face_pos = {0, self.start_y, 632, CONFIG.ui_h - self.face_bot_h  - self.start_y}

	if overview.save_source then
		overview.source.baseuserinfo.newmessgaes = self.source.newmsgnum;
		overview:refresh()
		overview.back_y = overview.scrollbars_y;
	end;
end;

function showrw:otherGenInfo(b) -- 其他玩家将领信息
	if b.param.uid == CONFIG.uid then
		return;
	end;
	Url:new(Url:get('GeneralSvc', 'getOtGen', b.param.uid, b.param.gid), BACK_OTHER_GEN );
end;
function showrw:showSkillkey(b)--查看技能
	baseSysinfo(self, {infos = b.param.desc, selfhead=b.param.name,nohead=true});
end
function showrw:backToLastKey(bn)  --返回战报
	local p = self.parent;
	self:free();
	window:child(p, rwflash, self.source);
	end;
function showrw:get_x(__x)
	__x = __x + 210;
	self.ady = true;
	if __x >= 600  then
	self:add_h(150 + CONFIG.font_h)
	__x = 30;
	self.ady = false;
	end;

	return __x;
end;
function showrw:msgtounion(bn)
	Url:new(Url:get('ReportSvc', 'rwToUnion', self.source.rw_id), BACK_RW_TO_UNION)
end;
function showrw:rwinfokey(b)  -- 详细回合
	window:child(self, rwdetail, self.source)
end;
function showrw:captureinfo( b)  -- 俘虏
	window:child(self, rwcapture, self.source)
end;
function showrw:on_response(data,url,code,attach)
	print('response showrw .....')
	local k = data._return;
	if attach == BACK_RW_TO_UNION then
		window:child(self, sysinfo, k)
	elseif attach == BACK_OTHER_GEN  then
		if not k.general then
			window:child(self, sysinfo, {infos = L'将领信息已不存在'})
			return;
		end;
		window:child(self, othergen, k)
	end;
end;
print('load showrw  ok')
------------------------------  俘虏 ------------------------
rwcapture = BASE_WINDOW:new();
function rwcapture:self_init()
	print('init rwcapture .....')
	Idx:new(start)
	Button:new(self)
	self.start_y = 58
	self.__h = self.start_y;
	local starty = self.__h;

	Button:new_img(0, 2, self.__h, 622, 11, 'base/top_622.png');
	self:add_h(3)
	local line_start_y = self.__h;
	local pry = center_h(CONFIG.font_h, 0, 58)
	Button:new_img(0, 48, self.__h, 120, 65, 'base/b_15.png')
	Button:new_img(0, 168, self.__h + 1, 296, 58, 'base/hd_170.png')
	local str = L'俘虏的士兵';
	if self.source.result == 2 then
		wstr.cat(L'被', str)
	end;
	Button:new_text(0, center_w(CONFIG.font_w*4, 0, 632), self.__h + pry + 1, 0, -1, str, 0X8EB4D4)
	Button:new_img(0, 464, self.__h, 120, 65, 'base/b_16.png')
	self:add_h(62)

	local flsize = (self.source.prisonerfs and table.getn(self.source.prisonerfs)) or 0;
	local fl;
	local canres = self.source.canres;
	local cnx = center_w(CONFIG.font_w * 2, 480, 480+135);
	for i=1, flsize do
		fl = self.source.prisonerfs[i];
		if canres and fl.status == 0 then -- 能否招募
			Button:new_img(0, 65, self.__h, 93, 93, 'item/'.. fl.id ..'_.png')
			Button:new_text(0, 193, self.__h + 20, 0, -1, fl.name, 0X8EB4D4)
			Button:new_text(0, CONFIG.font_w*4 + 193, self.__h + 20, 0, -1, fl.num, 0X8EB4D4)

			Button:new_img(Idx:next(), 480, self.__h + 10, 135, 58, 'base/btbg.png', self.getshipskey, nil, {shid = fl.id})
			Button:new_text_title(0, cnx, self.__h + 10 + pry, L'招募', 0XFFF200, 0X000000)
			self:add_h(100)
		elseif not canres then
			Button:new_img(0, 65, self.__h, 93, 93, 'item/'.. fl.id ..'_.png')
			Button:new_text(0, 193, self.__h + 20, 0, -1, fl.name, 0X8EB4D4)
			Button:new_text(0, CONFIG.font_w*4 + 193, self.__h + 20, 0, -1, fl.num, 0X8EB4D4)
			self:add_h(100)
		end;

	end

	str = L'招募战俘数量与您战报中武将的智力有关.招募后不显示战俘信息.战报删除以后,俘虏的士兵将无法进行招募.';
	Button:new_text_area(0, 50, self.__h, 400, CONFIG.font_h, 0, str, 0X00FF00)
	self:add_h(Button.now.h + 8)

	self:add_h(addbor622(starty + 10, self.__h))
	self:add_h(100);
	self:add_h(add_lines(line_start_y - 10, self.__h))

	self.buttonsize = Button.j;
	self.buttonmaxyid = Button.j;
	print('init rwcapture  ok .....')
end;

--头部和脚部的固定部分
function rwcapture:self_init_face()
	Idx:new(start)
	Button:new(self, 1)
	local line_start_y = self.__h;
	local pry = center_h(CONFIG.font_h, 0, 0)

	Button:new_img(0, 0, self.__h,632, 58, 'base/top_ui01.png')
	self:add_h(58);
	self.face_buttom = Button.j;

	self:add_h(add_lines(line_start_y, self.__h))

	self.face_buttom = Button.j;
	self.__h = add_face_butm(2)

	self.face_size = Button.j;
	self.face_top_h = self.start_y;
	self.face_bot_h = 120;
	self.not_face_pos = {0, self.start_y, 632, CONFIG.ui_h - self.face_bot_h  - self.start_y}
end;

function rwcapture:getshipskey(b)  ---招募俘虏
	--add_url(get_full_url('ReportSvc', 'reShip', v.source.rw_id, b.param.shid),1, BACK_RE_SHIP);
	Url:new(Url:get('ReportSvc', 'reShip', self.source.rw_id, b.param.shid), BACK_RE_SHIP)
end;
function rwcapture:on_response(data,url,code,attach)
	print('response rwcapture .....')
	local k = data._return;
	if attach == BACK_RE_SHIP then
		baseSysinfo(self, k)

		self.source.prisonerfs = k.prisonerfs;
		self:refresh()
		self.back_y = self.scrollbars_y;

		showrw.source.prisonerfs = k.prisonerfs;
	end;
end;
print('load rwcapture  ok')
-------------------------------------- 战斗详细 ---------------
rwdetail = BASE_WINDOW:new();
function rwdetail:self_init()
	print('init rwdetail .....')
	Idx:new(start)
	Button:new(self)

	self.start_y = 58
	self.__h = self.start_y;

	local line_start_y = self.__h;
	local starty = self.__h;
	Button:new_img(0, 0, self.__h, 632, 11, 'base/top_632.png');

	self:add_h(5)
	local line_start_y = self.__h;
	local pry = center_h(CONFIG.font_h, 0, 58)
	local fsize = (self.source.pkdetail and table.getn(self.source.pkdetail)) or 0;
	if fsize > 0 then
		Button:new_img(0, 0, self.__h, 632, 58, 'base/hd.png')
		Button:new_text(0, center_w(CONFIG.font_w*9, 0, 632), self.__h + pry, 0, -1, L'双方武将进行了单挑', 0X00FF00)
		self:add_h(58);

		Button:new_img(0, 0, self.__h, 632, 229, 'wdhead/gen_war_bg.png')
		self:add_h(229);

		Button:new_img(0, 48, self.__h, 120, 65, 'base/b_15.png')
		Button:new_img(Idx:next(), 168, self.__h + 1, 296, 58, 'base/hd_170.png', self.genpk_key, nil,  param)
		Button:new_text(0, center_w(CONFIG.font_w*4, 0, 632), self.__h + pry + 1, 0, -1, L'单挑过程', 0XC4602B)
		Button:new_img(0, 464, self.__h, 120, 65, 'base/b_16.png')
		self:add_h(62)

		Button:new_text_area(0, 50, self.__h, 450, CONFIG.font_h, 0, self.source.pkdes, 0X00FF00)
		self:add_h(Button.now.h + 4)
	end

	fsize = (self.source.rwdetail and table.getn(self.source.rwdetail)) or o;
	local de, fl, rect_bt, fill_bt, haslost, dflsize, __x, __mod, k;
	for i=1, fsize do
		Button:new_img(0, 0, self.__h, 632, 58, 'base/hd.png')
		Button:new_text(0, center_w(CONFIG.font_w*4, 0, 632), self.__h + pry, 0, -1, wstr.cat(L'第', i, L'回合'), 0X00FF00)
		self:add_h(58);

		de = self.source.rwdetail[i][1];
		Button:new_rect(0, 4, self.__h, 620, 86, 0X6B3008)
		rect_bt = Button.now;
		Button:new_fill(0, 5, self.__h + 1, 618, 84, 0X120300)
		fill_bt = Button.now;
		self:add_h(5);

		Button:new_text(0, 30, self.__h, 0, -1, wstr.cat(L'攻击者: ', de.oname), 0XFF0000)
		self:add_h(CONFIG.font_h+5);
		fill_bt.h = self.__h - fill_bt.y;

		Button:new_line(0 , 4, self.__h, 622, self.__h, 0X6B3008)
		self:add_h(1)
		Button:new_fill(0, 5, self.__h, 618, 84, 0X190000)
		fill_bt = Button.now;
		self:add_h(5);
		Button:new_text(0, 30, self.__h, 0, -1, wstr.cat(L'攻', de.oaddtionatc), 0XF7941C)

		Button:new_text(0, 160, self.__h, 0, -1, wstr.cat(L'防', de.oaddtionshi), 0XF7941C)

		Button:new_text(0, 280, self.__h, 0, -1, wstr.cat(L'命', de.oaddtionamor), 0XF7941C)
		self:add_h(CONFIG.font_h+5);
		fill_bt.h = self.__h - fill_bt.y;

		Button:new_line(0 , 4, self.__h, 622, self.__h, 0X6B3008)
		Button:new_fill(0, 5, self.__h + 1, 618, 84, 0X1E0800)
		fill_bt = Button.now;
		self:add_h(6)

		haslost = false;
		dflsize = table.getn(de.oactor)
		k = 1;
		for j=1, dflsize do
			__mod = math.mod(j-1, 4)
			__x = __mod * 150 + 25;
			if j > 1 and __mod == 0 then
				self:add_h(130 + CONFIG.font_h * 2)
				if haslost then
					self:add_h(CONFIG.font_h)
				end;
				fill_bt.h = self.__h - fill_bt.y;

				Button:new_line(0 , 4, self.__h, 622, self.__h, 0X6B3008)
				k = k + 1;
				Button:new_fill(0, 5, self.__h + 1, 618, 84, 0X1E0800)
				fill_bt = Button.now;
				if math.mod(k, 2) == 0 then
					Button.now.color = 0X190000;
				end;
				self:add_h(6)

			end;
			fl = de.oactor[j];
			Button:new_img(Idx:next(), __x, self.__h, 93, 93, 'item/'.. fl.id ..'_.png', self.todetailkey, nil,  {tp=1, tg = fl.target})
			Button:new_text(0, __x, self.__h + 93, 0, -1, fl.fname, 0XC7B299)
			Button:new_text(0, __x, self.__h + 93+CONFIG.font_h, 0, -1, fl.num, 0X988675)
			if fl.losenum ~= '0' then
				Button:new_text(0, __x, self.__h + 93+CONFIG.font_h*2, 0, -1, '-'.. fl.losenum, 0X726257)
				haslost = true;
			end;

		end
		self:add_h(130 + CONFIG.font_h * 2 + 8)
		if haslost then
			self:add_h(CONFIG.font_h)
		end;

		fill_bt.h = self.__h - fill_bt.y - 7;
		rect_bt.h = self.__h - rect_bt.y - 6;
		--------------------------------     防御方
		Button:new_rect(0, 4, self.__h, 620, 86, 0X6B3008)
		rect_bt = Button.now;
		Button:new_fill(0, 5, self.__h + 1, 618, 84, 0X000000)
		fill_bt = Button.now;
		self:add_h(5);


		Button:new_text(0, 30, self.__h, 0, -1, wstr.cat(L'防御者: ', de.dname), 0X00AEEF)
		self:add_h(CONFIG.font_h+5);
		fill_bt.h = self.__h - fill_bt.y;

		Button:new_line(0 , 4, self.__h, 622, self.__h, 0X6B3008)
		self:add_h(1)
		Button:new_fill(0, 5, self.__h, 618, 84, 0X071323)
		fill_bt = Button.now;
		self:add_h(5);
		Button:new_text(0, 30, self.__h, 0, -1, wstr.cat(L'攻', de.daddtionatc), 0X00FFFF)

		Button:new_text(0, 160, self.__h, 0, -1, wstr.cat(L'防', de.daddtionshi), 0X00FFFF)

		Button:new_text(0, 280, self.__h, 0, -1, wstr.cat(L'命', de.daddtionamor), 0X00FFFF)
		self:add_h(CONFIG.font_h+5);
		fill_bt.h = self.__h - fill_bt.y;

		Button:new_line(0 , 4, self.__h, 622, self.__h, 0X6B3008)
		Button:new_fill(0, 5, self.__h + 1, 618, 84, 0X0F1B3C)
		fill_bt = Button.now;
		self:add_h(6)

		haslost = false;
		dflsize = table.getn(de.dactor)
		k = 1;
		for j=1, dflsize do
			__mod = math.mod(j-1, 4)
			__x = __mod * 150 + 25;
			if j > 1 and __mod == 0 then
				self:add_h(130 + CONFIG.font_h * 2)
				if haslost then
					self:add_h(CONFIG.font_h)
				end;

				fill_bt.h = self.__h - fill_bt.y;

				Button:new_line(0 , 4, self.__h, 622, self.__h, 0X6B3008)
				k = k+ 1;
				Button:new_fill(0, 5, self.__h + 1, 618, 84, 0X0F1B3C)
				fill_bt = Button.now;
				if math.mod(k, 2) == 0 then
					Button.now.color = 0X071323;
				end;
				self:add_h(6)
			end;
			fl = de.dactor[j];
			Button:new_img(Idx:next(), __x, self.__h, 93, 93, 'item/'.. fl.id ..'_.png', self.todetailkey, nil,  {tp=1, tg = fl.target})
			Button:new_text(0, __x, self.__h + 93, 0, -1, fl.fname, 0XC7B299)
			Button:new_text(0, __x, self.__h + 93+CONFIG.font_h, 0, -1, fl.num, 0X988675)
			if fl.losenum ~= '0' then
				Button:new_text(0, __x, self.__h + 93+CONFIG.font_h*2, 0, -1, '-'.. fl.losenum, 0X726257)
				haslost = true;
			end;

		end
		self:add_h(130 + CONFIG.font_h * 2 + 8)
		if haslost then
			self:add_h(CONFIG.font_h)
		end;
		fill_bt.h = self.__h - fill_bt.y - 7;
		rect_bt.h = self.__h - rect_bt.y - 6;
	end

	self:add_h(addbor632(starty + 3, self.__h))
	self:add_h(100);
	self:add_h(add_lines(line_start_y - 10, self.__h))

	self.buttonsize = Button.j;
	self.buttonmaxyid = Button.j;
	print('init rwdetail  ok .....')
end;
--头部和脚部的固定部分
function rwdetail:self_init_face()
	Idx:new(start)
	Button:new(self, 1)
	local line_start_y = self.__h;
	local pry = center_h(CONFIG.font_h, 0, 0)

	Button:new_img(0, 0, self.__h, 632, 58, 'base/top_ui01.png')
	self:add_h(58);
	self.face_buttom = Button.j;

	self:add_h(add_lines(line_start_y, self.__h))

	self.face_buttom = Button.j;
	self.__h = add_face_butm(2)

	self.face_size = Button.j;
	self.face_top_h = self.start_y;
	self.face_bot_h = 120;
	self.not_face_pos = {0, self.start_y, 632, CONFIG.ui_h - self.face_bot_h  - self.start_y}
end;
--点击查看详情
function rwdetail:todetailkey(b)
	baseSysinfo(self, {kinfos = b.param.tg , ts=1 ,nohead=true});
end;
function rwdetail:genpk_key(b)  --将领pk
	window:child(self, rwgenpk, self.source)
end;
function rwdetail:on_response(data,url,code,attach)
	print('response rwdetail .....')
	local k = data._return;

end;
print('load rwdetail  ok')
-----------------------------  将领单挑
rwgenpk = BASE_WINDOW:new();
function rwgenpk:self_init()
	print('init rwgenpk .....')
	Idx:new(start)
	Button:new(self)
	self.start_y = 58
	self.__h = self.start_y;
	local starty = self.__h;

	Button:new_img(0, 0, self.__h, 632, 11, 'base/top_632.png');
	self:add_h(5)
	local line_start_y = self.__h;
	local pry = center_h(CONFIG.font_h, 0, 58)

	Button:new_img(0, 0, self.__h, 632, 58, 'base/hd.png')
	Button:new_text(0, center_w(CONFIG.font_w*4, 0, 632), self.__h + pry, 0, -1, L'单挑过程', 0X8EB4D4)
	self:add_h(65);

	Button:new_rect(0, 4, self.__h, 622, 86, 0X588526)
	self:add_h(10);
	rect_bt = Button.now;

	local pk = self.source.pk;
	Button:new_img(0, 20, self.__h, 137, 167, 'genralhead/'.. pk.ogid ..'.png')
	Button:new_text(0, 170, self.__h, 0, -1, L'攻方将领', 0X8EB4D4)
	Button:new_text(0, 170, self.__h + CONFIG.font_h, 0, -1, pk.ogname, 0X8EB4D4)
	Button:new_text(0, 170, self.__h + CONFIG.font_h*2, 0, -1, wstr.cat(L'体力:', pk.ogpower), 0X8EB4D4)

	Button:new_img(0, 340, self.__h, 137, 167, 'genralhead/'.. pk.dgid ..'.png')
	Button:new_text(0, 490, self.__h, 0, -1, L'守方将领', 0X8EB4D4)
	Button:new_text(0, 490, self.__h + CONFIG.font_h, 0, -1, pk.dgname, 0X8EB4D4)
	Button:new_text(0, 490, self.__h + CONFIG.font_h*2, 0, -1, wstr.cat(L'体力:', pk.dgpower), 0X8EB4D4)

	self:add_h(get_max(CONFIG.font_h*3, 180) + 10);
	rect_bt.h = self.__h - rect_bt.y;

	local pksize = (self.source.pkdetail and table.getn(self.source.pkdetail)) or 0;
	local pkdsize, pkd, str, cl;
	for i=1, pksize do
		Button:new_img(0, 0, self.__h, 632, 58, 'base/bg_351.png')
		Button:new_text(0, center_w(CONFIG.font_w*4, 0, 632), self.__h + pry, 0, -1, wstr.cat(L'第', i, L'回合'), 0X8EB4D4)
		self:add_h(65);

		pk = self.source.pkdetail[i];
		pkdsize = table.getn(pk)
		for i=1, pkdsize do
			pkd = pk[i];

			Button:new_img(0, 0, self.__h, 632, 58, 'base/bg_351.png')
			if pkd.att == 1 then --攻击方
				str = L'攻击方';
				cl = 0XFF0000;
			else
				str = L'防守方';
				cl = 0X00FF00;
			end;
			Button:new_text(0, 50, self.__h + pry, 0, -1, str, cl)
			Button:new_text(0, 130, self.__h + pry, 0, -1, pkd.ogname, cl)
			Button:new_text(0, 415, self.__h + pry, 0, -1, wstr.cat(L'伤害: ', pkd.harm), cl)
			self:add_h(58);
		end
	end
	self:add_h(4);
	Button:new_text_area(0, 50, self.__h, 450, CONFIG.font_h, 0, self.source.pkdes, 0X00FF00)
	self:add_h(Button.now.h + 4)

	self:add_h(addbor632(starty + 3, self.__h))
	self:add_h(100);
	self:add_h(add_lines(line_start_y - 10, self.__h))

	self.buttonsize = Button.j;
	self.buttonmaxyid = Button.j;
	print('init rwgenpk  ok .....')
end;

--头部和脚部的固定部分
function rwgenpk:self_init_face()
	Idx:new(start)
	Button:new(self, 1)
	local line_start_y = self.__h;
	local pry = center_h(CONFIG.font_h, 0, 0)

	Button:new_img(0, 0, self.__h, 632, 58, 'base/top_ui01.png')
	self:add_h(58);
	self.face_buttom = Button.j;

	self:add_h(add_lines(line_start_y, self.__h))

	self.face_buttom = Button.j;
	self.__h = add_face_butm(2)

	self.face_size = Button.j;
	self.face_top_h = self.start_y;
	self.face_bot_h = 120;
	self.not_face_pos = {0, self.start_y, 632, CONFIG.ui_h - self.face_bot_h  - self.start_y}
end;
function rwgenpk:on_response(data,url,code,attach)
	print('response rwgenpk .....')
	local k = data._return;

end;
print('load rwgenpk  ok')
--------------------------------  查看谍报 -------------------
showspy = BASE_WINDOW:new();
function showspy:self_init()
	print('init showspy .....')
	Idx:new(start)
	Button:new(self)
	self.start_y = 207;
	self.__h = self.start_y;
	local line_start_y = self.__h;

	Button:new_img(0, 2, self.__h, 622, 11, 'base/top_622.png');
	self:add_h(5)
	local line_start = self.__h;

	Button:new_text_area(0, 100, self.__h, 440, CONFIG.font_h, 0, self.source.spydec, 0X8DC63F)
	self:add_h(Button.now.h+10)

	Button:new_text(0, 100, self.__h, 0, -1, wstr.cat(L'地点:  ', self.source.pname), 0X8DC63F)
	Button:new_text(0, Button.now.x+Button.now.w, self.__h + 2, 0, -1, self.source.pos, 0X00AEEF)
	self:add_h(CONFIG.font_h)

	Button:new_text(0, 100, self.__h, 0, -1, L'时间:  ', 0X8DC63F)
	Button:new_text(0, Button.now.x+Button.now.w, self.__h, 0, -1, self.source.dat, 0X00AEEF)
	self:add_h(CONFIG.font_h)

	self:add_h(addbor622(line_start, self.__h))

	local pry = center_h(CONFIG.font_h, 0, 58)
	Button:new_img(0, 0, self.__h, 632, 58, 'base/hd.png')
	Button:new_text(0, center_w(CONFIG.font_w*4, 0, 632), self.__h + pry, 0, -1, L'后宫情况', 0X8DC63F)
	self:add_h(58);

	Button:new_img(0, 0, self.__h, 632, 58, 'base/bg_351.png')
	Button:new_text(0, 112, self.__h + pry, 0, -1, self.source.npcdec, 0XFFF799)
	self:add_h(58);

	Button:new_img(0, 0, self.__h, 632, 58, 'base/hd.png')
	Button:new_text(0, center_w(CONFIG.font_w*4, 0, 632), self.__h + pry, 0, -1, L'将领情况', 0X8DC63F)
	self:add_h(58);

	Button:new_img(0, 0, self.__h, 632, 58, 'base/bg_351.png')
	Button:new_text(0, 112, self.__h + pry, 0, -1, self.source.gdec, 0XFFF799)
	self:add_h(58);

	Button:new_img(0, 0, self.__h, 632, 58, 'base/hd.png')
	Button:new_text(0, center_w(CONFIG.font_w*4, 0, 632), self.__h + pry, 0, -1, L'资源情况', 0X8DC63F)
	self:add_h(58);

	Button:new_img(0, 0, self.__h, 632, 58, 'base/bg_351.png')
	Button:new_img(0, 136, self.__h+5, 42, 42, 'base/m.png')
	Button:new_text(0, 188, self.__h + pry, 0, -1, my_format(self.source.res.m), 0XFFF799)
	Button:new_img(0, 400, self.__h+5, 42, 42, 'base/c.png')
	Button:new_text(0, 452, self.__h + pry, 0, -1, my_format(self.source.res.c), 0XFFF799)
	self:add_h(58);

	Button:new_img(0, 0, self.__h, 632, 58, 'base/bg_351.png')
	Button:new_img(0, 136, self.__h+5, 42, 42, 'base/h.png')
	Button:new_text(0, 188, self.__h + pry, 0, -1, my_format(self.source.res.h), 0XFFF799)
	Button:new_img(0, 400, self.__h+5, 42, 42, 'base/p.png')
	Button:new_text(0, 452, self.__h + pry, 0, -1, my_format(self.source.res.p), 0XFFF799)
	self:add_h(58);



	local __x, __mod, fl;
	--军队情况
	local flsize = (self.source.fleet and table.getn(self.source.fleet)) or 0;
	if flsize > 0 then
		Button:new_img(0, 0, self.__h, 632, 58, 'base/hd.png')
		Button:new_text(0, center_w(CONFIG.font_w*4, 0, 632), self.__h + pry, 0, -1, L'军队情况', 0X8DC63F)
		self:add_h(58);

		Button:new_img(0, 0, self.__h, 632, 58, 'base/bg_351.png')
		for i=1,flsize do
			__mod = math.mod(i-1, 2)
			__x = __mod * 300 + 100;
			if i > 1 and __mod == 0 then
				self:add_h(58)
				Button:new_img(0, 0, self.__h, 632, 58, 'base/bg_351.png')
			end;
			fl = self.source.fleet[i];
			Button:new_text(0, __x, self.__h + pry, 0, -1, fl.name, 0X8DC63F)
			Button:new_text(0, __x + Button.now.w, self.__h + pry, 0, -1, my_format(fl.num), 0X38B549)
		end
		self:add_h(58)
	end;
	-- 城防情况
	local flsize = (self.source.defence and table.getn(self.source.defence)) or 0;
	if flsize > 0 then
		Button:new_img(0, 0, self.__h, 632, 58, 'base/hd.png')
		Button:new_text(0, center_w(CONFIG.font_w*4, 0, 632), self.__h + pry, 0, -1, L'城防情况', 0X8DC63F)
		self:add_h(58);

		Button:new_img(0, 0, self.__h, 632, 58, 'base/bg_351.png')
		for i=1,flsize do
			__mod = math.mod(i-1, 2)
			__x = __mod * 300 + 100;
			if i > 1 and __mod == 0 then
				self:add_h(58)
				Button:new_img(0, 0, self.__h, 632, 58, 'base/bg_351.png')
			end;
			fl = self.source.defence[i];
			Button:new_text(0, __x, self.__h + pry, 0, -1, fl.name, 0X8DC63F)
			Button:new_text(0, __x + Button.now.w, self.__h + pry, 0, -1, my_format(fl.num), 0X38B549)
		end
		self:add_h(58)
	end;

	local dsize = (self.source.citydefencefleet and table.getn(self.source.citydefencefleet) ) or 0;
	if dsize > 0 then
		Button:new_img(0, 0, self.__h, 632, 58, 'base/hd.png')
		Button:new_text(0, center_w(CONFIG.font_w*6, 0, 632), self.__h + pry, 0, -1, L'城墙驻兵情况', 0X8DC63F)
		--self:add_h(40);
		local fl;
		--self:add_h(-40)
		for i=1,dsize do
			__mod = math.mod(i-1, 2)
			if __mod == 0 then
				self:add_h(58)
				Button:new_img(0, 0, self.__h, 632, 58, 'base/bg_351.png')
			end
			__x = __mod * 300 + 100;

			fl = self.source.citydefencefleet[i]
			Button:new_text(0, __x, self.__h + pry, 0, -1, fl.name, 0X8DC63F)
			Button:new_text(0, __x + Button.now.w, self.__h + pry, 0, -1, my_format(fl.num), 0X38B549)
		end;
		self:add_h(58)
	end

	-- 建筑情况
	local flsize = (self.source.build and table.getn(self.source.build)) or 0;
	if flsize > 0 then
		Button:new_img(0, 0, self.__h, 632, 58, 'base/hd.png')
		Button:new_text(0, center_w(CONFIG.font_w*4, 0, 632), self.__h + pry, 0, -1, L'建筑情况', 0X8DC63F)
		self:add_h(58);

		Button:new_img(0, 0, self.__h, 632, 58, 'base/bg_351.png')
		for i=1,flsize do
			__mod = math.mod(i-1, 2)
			__x = __mod * 300 + 100;
			if i > 1 and __mod == 0 then
				self:add_h(58)
				Button:new_img(0, 0, self.__h, 632, 58, 'base/bg_351.png')
			end;
			fl = self.source.build[i];
			Button:new_text(0, __x, self.__h + pry, 0, -1, fl.name, 0XF7941C)
			Button:new_text(0, __x + Button.now.w, self.__h + pry, 0, -1, fl.num, 0X00AEEF)
		end
		self:add_h(58)
	end;

	local flsize = (self.source.tech and table.getn(self.source.tech)) or 0;
	if flsize > 0 then
		Button:new_img(0, 0, self.__h, 632, 58, 'base/hd.png')
		Button:new_text(0, center_w(CONFIG.font_w*4, 0, 632), self.__h + pry, 0, -1, L'科技情况', 0X8DC63F)
		self:add_h(58);

		Button:new_img(0, 0, self.__h, 632, 58, 'base/bg_351.png')
		for i=1,flsize do
			__mod = math.mod(i-1, 2)
			__x = __mod * 300 + 100;
			if i > 1 and __mod == 0 then
				self:add_h(58)
				Button:new_img(0, 0, self.__h, 632, 58, 'base/bg_351.png')
			end;
			fl = self.source.tech[i];
			Button:new_text(0, __x, self.__h + pry, 0, -1, fl.name, 0X00FFFF)
			Button:new_text(0, __x + Button.now.w, self.__h + pry, 0, -1, fl.num, 0X00AEEF)
		end
		self:add_h(58)
	end;

	self:add_h(100);
	self:add_h(add_lines(line_start_y, self.__h))

	self.buttonsize = Button.j;
	self.buttonmaxyid = Button.j;
	print('init showspy  ok .....')
end;
--头部和脚部的固定部分
function showspy:self_init_face()
	Idx:new(start)
	Button:new(self, 1)
	Button:new_img(0, 0, self.__h, 632, 149, 'wdhead/spymsg_bg.png')
	self:add_h(149);

	Button:new_img(0, 0, self.__h, 632, 58, 'base/top_ui01.png')
	self:add_h(58);

	local line_start_y = self.__h;

	self.face_buttom = Button.j;
	self.__h = add_face_butm(2)

	self.face_size = Button.j;
	self.face_top_h = self.start_y;
	self.face_bot_h = 120;
	self.not_face_pos = {0, self.start_y, 632, CONFIG.ui_h - self.face_bot_h  - self.start_y}

	if overview.save_source then
		overview.source.baseuserinfo.newmessgaes = self.source.newmsgnum;
		overview:refresh()
		overview.back_y = overview.scrollbars_y;
	end;
end;
function showspy:on_response(data,url,code,attach)
	print('response showspy .....')
	local k = data._return;

end;
print('load showspy  ok')
-------------------------------------- 其他玩家将领信息 -----
othergen = BASE_WINDOW:new();
function othergen:self_init_face()
	Idx:new(start)
	Button:new(self, 1)
	Button:new_img(0, 0, self.__h, 632, 149, 'wdhead/gen_bg.png')
	self:add_h(149);
	Button:new_img(0, 0, self.__h, 632, 58, 'base/top_ui01.png')
	self:add_h(58);

	self.face_buttom = Button.j;

	self.__h = add_face_butm(2)

	self.face_size = Button.j;

	self.face_top_h = self.start_y;
	self.face_bot_h = 120;
	self.not_face_pos = {0, self.start_y, 632, CONFIG.ui_h - self.face_bot_h  - self.start_y}
	end

function othergen:self_init()
	print('init othergen .....')
	Idx:new(start)
	Button:new(self)

	self.start_y = 207;
	self.__h = self.start_y;
	local line_start_y = self.__h;

	Button:new_img(0, 0, self.__h, 632, 58, 'base/hd.png')
	local str = L'武将装备';
	Button:new_text(0, center(str, 0, 632), self.__h + center_h(CONFIG.font_h, 0, 58), 0, -1, str, 0XFFF200)
	self:add_h(58);

	Button:new_img(0, 0, self.__h, 632, 11, 'base/top_632.png');
	local starty = self.__h + 4;
	self:add_h(8);

	local pry = center_h(CONFIG.font_h, 0, 58);
	local gen = self.source.general;
	local usernpc = self.source.usernpc;

	Button:new_img(0, 20, self.__h, 137, 167, 'genralhead/'..gen.gid..'.png')
	--武将星级
	local gs = gen.star;
	if gs > 0 then
		local qstar = math.floor(gs/2);
		local bstar = math.mod(gs,2);
		for i = 1, qstar do
			Button:new_img(0, 175 + (i-1)*11, self.__h, 11, 10, 'base/star.png');
		end;
		if bstar > 0 and gs <10 then
			Button:new_img(0, 175 + qstar*11, self.__h, 11, 10, 'base/star_half.png');
		end;
	end;


	self:add_h(18);
	local w;
	Button:new_text(0, 176, self.__h, 0, -1, gen.gname, 0XFFFFFF)
	--Button:new_text(0, 180, self.__h, 0, -1, L'状态:', 0XFFFF00)
	--Button:new_text(0, CONFIG.font_w * 2 + 182, self.__h, 0, -1, general.genstatus[gen.status + 1], 0X8DC63F)

	Button:new_text(0, 176, self.__h + CONFIG.font_h + 5, 0, -1, L'等级', 0XFFFF00)
	Button:new_text(0, CONFIG.font_w * 2 + 178, self.__h + CONFIG.font_h + 5, 0, -1, gen.lvl, 0XFFFFFF)

	--Button:new_text(0, 106, self.__h + CONFIG.font_h * 2 + 10, 0, -1, wstr.cat(L'升级需要经验:', gen.needExperience), 0X00A650,self.getuseitemskey, nil, param)
	self:add_h(get_max(180, CONFIG.font_h * 3));

	self:add_h(10);
	local unpc = gen.usernpc;
	local cgen = {
		{t=L"统率",col=0XFFF200,val=gen.command,max_val=nil,addnum=unpc and unpc.commandaddnum or nil},
		{t=L"攻击",col=0XFFF200,val=gen.attack,max_val=nil,addnum=unpc and unpc.attackaddnum or nil},
		{t=L"速度",col=0XFFF200,val=gen.speed,max_val=nil,addnum=unpc and unpc.speedaddnum or nil},
		{t=L"防御",col=0XFFF200,val=gen.defence,max_val=nil,addnum=unpc and unpc.defenceaddnum or nil},
		{t=L"智力",col=0XFFF200,val=gen.iq,max_val=nil,addnum=unpc and unpc.iq or nil},
	}
	local _x, __mod, t,s_x;
	for _k,_v in pairs(cgen) do
		__mod = math.mod(_k-1, 2)
		if _k > 1 and __mod == 0 then self:add_h(80);		end;
		_x = __mod * 300 + 30;
		Button:new_img(0, _x, self.__h, 135, 58, 'base/btbg.png', _v.onkey, nil,_v.param)
		s_x = Button.now.x+Button.now.w;
		Button:new_text_title(0, center(_v.t,Button.now.x,Button.now.x+Button.now.w), self.__h + pry,_v.t, _v.col, 0x000000)
		Button:new_text(0, s_x + 10, self.__h, 0, -1, _v.max_val and (_v.val.. '/'.. _v.max_val) or _v.val, 0XFFFFFF);
		if _v.addnum and _v.addnum > 1 then
			Button:new_text(0, s_x + 10, self.__h + CONFIG.font_h, 0, -1,wstr.cat('(+',_v.addnum,'%)'), 0XFD4DB5)
		end
	end;
	self:add_h(85);
	
	Button:new_text(0, 32, self.__h, 0, -1, L'兵种攻击加成:', 0XF26521, on_key, nil, param)
	self:add_h(CONFIG.font_h + 10);

	cgen = {
		{t=L"步兵",col=0X0082B3,val=gen.bpoints,addnum=unpc and unpc.baddnum or nil,points = gen.points > 0},
		{t=L"骑兵",col=0X0082B3,val=gen.qpoints,addnum=unpc and unpc.qaddnum or nil,points = gen.points > 0	},
		{t=L"远程",col=0X0082B3,val=gen.ypoints,addnum=unpc and unpc.yaddnum or nil,points = gen.points > 0	},
		{t=L"机兵",col=0X0082B3,val=gen.jpoints,addnum=unpc and unpc.jaddnum or nil,points = gen.points > 0	},
		{t=L"城防",col=0X0082B3,val=gen.dpoints,addnum=unpc and unpc.daddnum or nil,points = gen.points > 0	},
	}
	for _k,_v in pairs(cgen) do
		__mod = math.mod(_k-1, 2)
		if _k > 1 and __mod == 0 then self:add_h(80);		end;
		_x = __mod * 300 + 30;
		Button:new_img(0, _x, self.__h, 135, 58, 'base/btbg.png', _v.onkey, nil,_v.param)
		s_x = Button.now.x+Button.now.w;
		Button:new_text_title(0, center(_v.t,Button.now.x,Button.now.x+Button.now.w), self.__h + pry,_v.t, _v.col, 0x000000)
		Button:new_text(0, s_x + 15, self.__h, 0, -1,_v.val, 0XFFFFFF);
	end;
	cgen = nil;
	unpc = nil;
	self:add_h(85);
	--[[Button:new_img(0, 34, self.__h, 135, 58, 'base/btbg.png', self.getuseitemskey, nil, param)
	Button:new_text_title(0, center_w(CONFIG.font_w * 2, 34, 34+135), self.__h + pry, L'统率', 0XFFF200, 0X000000, on_key, draw_select, param)
	Button:new_text(0, 183, self.__h + pry, 0, -1, gen.command, 0XFFFFFF)
	w = Button.now.w;
	if usernpc ~=nil and usernpc.commandaddnum ~=nil and usernpc.commandaddnum >1 then
		Button:new_text(0, 183+w, self.__h + pry, 0, -1, wstr.cat('(+',usernpc.commandaddnum or '','%)'), 0XFD4DB5)
	end

	Button:new_img(0, 385, self.__h, 135, 58, 'base/btbg.png', self.getuseitemskey, nil, param)
	Button:new_text_title(0, center_w(CONFIG.font_w * 2, 385, 385+135), self.__h + pry, L'攻击', 0XFFF200, 0X000000, on_key, draw_select, param)
	Button:new_text(0, 544, self.__h + pry, 0, -1, gen.attack, 0XFFFFFF)
	w = Button.now.w;
	if usernpc ~=nil and usernpc.attackaddnum ~=nil and usernpc.attackaddnum >1 then
		Button:new_text(0, 544+w, self.__h + pry, 0, -1, wstr.cat('(+',usernpc.attackaddnum or '','%)'), 0XFD4DB5)
	end
	self:add_h(62);

	Button:new_img(0, 34, self.__h, 135, 58, 'base/btbg.png', self.getuseitemskey, nil, param)
	Button:new_text_title(0, center_w(CONFIG.font_w * 2, 34, 34+135), self.__h + pry, L'速度', 0XFFF200, 0X000000, on_key, draw_select, param)
	Button:new_text(0, 183, self.__h + pry, 0, -1, gen.speed, 0XFFFFFF)
	w = Button.now.w;
	if usernpc ~=nil and usernpc.speedaddnum ~=nil and usernpc.speedaddnum >1 then
		Button:new_text(0, 183+w, self.__h + pry, 0, -1, wstr.cat('(+',usernpc.speedaddnum or '','%)'), 0XFD4DB5)
	end

	Button:new_img(0, 385, self.__h, 135, 58, 'base/btbg.png', self.getuseitemskey, nil, param)
	Button:new_text_title(0, center_w(CONFIG.font_w * 2, 385, 385+135), self.__h + pry, L'防御', 0XFFF200, 0X000000, on_key, draw_select, param)
	Button:new_text(0, 544, self.__h + pry, 0, -1, gen.defence, 0XFFFFFF)
	w = Button.now.w;
	if usernpc ~=nil and usernpc.defenceaddnum ~=nil and usernpc.defenceaddnum >1 then
		Button:new_text(0, 544+w, self.__h + pry, 0, -1, wstr.cat('(+',usernpc.defenceaddnum or '','%)'), 0XFD4DB5)
	end
	self:add_h(62);

	Button:new_img(0, 34, self.__h, 135, 58, 'base/btbg.png', self.speedkey, nil, nil)
	Button:new_text_title(0, center_w(CONFIG.font_w * 2, 34, 34+135), self.__h + pry, L'智力', 0XFFF200, 0X000000, on_key, draw_select, param)
	Button:new_text(0, 183, self.__h + pry, 0, -1, gen.iq, 0XFFFFFF)
	w = Button.now.w;
	if usernpc ~=nil and usernpc.iq ~=nil and usernpc.iq >1 then
		Button:new_text(0, 183+w, self.__h + pry, 0, -1, wstr.cat('(+',usernpc.iq or '','%)'), 0XFD4DB5)
	end

	self:add_h(62);

	Button:new_text(0, 32, self.__h, 0, -1, L'兵种攻击加成:', 0XC4864E)
	self:add_h(CONFIG.font_h + 5);

	Button:new_img(0, 34, self.__h, 135, 58, 'base/btbg.png', self.getuseitemskey, nil, param)
	Button:new_text_title(0, center_w(CONFIG.font_w * 2, 34, 34+135), self.__h + pry, L'步兵', 0X0082B3, on_key, draw_select, param)
	Button:new_text(0, 183, self.__h + pry, 0, -1, gen.bpoints, 0XFFFFFF)
	w = Button.now.w;
	if usernpc ~=nil and usernpc.baddnum ~=nil and usernpc.baddnum >1 then
		Button:new_text(0, 183+w, self.__h + pry, 0, -1, wstr.cat('(+',usernpc.baddnum or '','%)'), 0XFD4DB5)
	end

	Button:new_img(0, 385, self.__h, 135, 58, 'base/btbg.png', self.getuseitemskey, nil, param)
	Button:new_text_title(0, center_w(CONFIG.font_w * 2, 385, 385+135), self.__h + pry, L'骑兵', 0X0082B3, on_key, draw_select, param)
	Button:new_text(0, 544, self.__h + pry, 0, -1, gen.qpoints, 0XFFFFFF)
	w = Button.now.w;
	if usernpc ~=nil and usernpc.qaddnum ~=nil and usernpc.qaddnum >1 then
		Button:new_text(0, 544+w, self.__h + pry, 0, -1, wstr.cat('(+',usernpc.qaddnum or '','%)'), 0XFD4DB5)
	end
	self:add_h(62);
	Button:new_img(0, 34, self.__h, 135, 58, 'base/btbg.png', self.getuseitemskey, nil, param)
	Button:new_text_title(0, center_w(CONFIG.font_w * 2, 34, 34+135), self.__h + pry, L'远程', 0X0082B3, on_key, draw_select, param)
	Button:new_text(0, 183, self.__h + pry, 0, -1, gen.ypoints, 0XFFFFFF)
	w = Button.now.w;
	if usernpc ~=nil and usernpc.yaddnum ~=nil and usernpc.yaddnum >1 then
		Button:new_text(0, 183+w, self.__h + pry, 0, -1, wstr.cat('(+',usernpc.yaddnum or '','%)'), 0XFD4DB5)
	end

	Button:new_img(0, 385, self.__h, 135, 58, 'base/btbg.png', self.getuseitemskey, nil, param)
	Button:new_text_title(0, center_w(CONFIG.font_w * 2, 385, 385+135), self.__h + pry, L'机兵', 0X0082B3, on_key, draw_select, param)
	Button:new_text(0, 544, self.__h + pry, 0, -1, gen.jpoints, 0XFFFFFF)
	w = Button.now.w;
	if usernpc ~=nil and usernpc.jaddnum ~=nil and usernpc.jaddnum >1 then
		Button:new_text(0, 544+w, self.__h + pry, 0, -1, wstr.cat('(+',usernpc.jaddnum or '','%)'), 0XFD4DB5)
	end
	self:add_h(62);
	Button:new_img(0, 34, self.__h, 135, 58, 'base/btbg.png', self.getuseitemskey, nil, param)
	Button:new_text_title(0, center_w(CONFIG.font_w * 2, 34, 34+135), self.__h + pry, L'城防', 0X0082B3, on_key, draw_select, param)
	Button:new_text(0, 183, self.__h + pry, 0, -1, gen.dpoints, 0XFFFFFF)
	w = Button.now.w;
	if usernpc ~=nil and usernpc.daddnum ~=nil and usernpc.daddnum >1 then
		Button:new_text(0, 183+w, self.__h + pry, 0, -1, wstr.cat('(+',usernpc.daddnum or '','%)'), 0XFD4DB5)
	end
	self:add_h(62);
	]]

	Button:new_img(0, 0, self.__h, 632, 577, 'ov/equibg.png')
	--头   1
	local eq = self.source.l1;
	if eq and eq.imgid then
		Button:new_img(0, 173 + 112, self.__h + 32, 46, 46, 'equi/'.. eq.imgid ..'.png', self.equikey, nil, {lid = 1})
	end;
	Button:new_nodraw(Idx:next(), 158 + 112, self.__h + 19, 73, 73,  self.equikey, draw_select, {lid = 1})

	--颈  2
	eq = self.source.l2;
	if eq and eq.imgid then
		Button:new_img(0, 173, self.__h + 34 + 93, 46, 46, 'equi/'.. eq.imgid ..'.png', self.equikey, nil, {lid = 2})
	end;
	Button:new_nodraw(Idx:next(), 158, self.__h + 19 + 94, 73, 73,  self.equikey, draw_select, {lid = 2})

	--胸  4
	eq = self.source.l4;
	if eq and eq.imgid then
		Button:new_img(0, 173 + 112, self.__h + 34 + 93, 46, 46, 'equi/'.. eq.imgid ..'.png', self.equikey, nil, {lid = 4})
	end;
	Button:new_nodraw(Idx:next(), 158 + 112, self.__h + 19 + 94, 73, 73,  self.equikey, draw_select, {lid = 4})

	--肩  3
	eq = self.source.l3;
	if eq and eq.imgid then
		Button:new_img(0, 173 + 112+112, self.__h + 34 + 93, 46, 46, 'equi/'.. eq.imgid ..'.png', self.equikey, nil, {lid = 3})
	end;
	Button:new_nodraw(Idx:next(), 158 + 112+112, self.__h + 19 + 94, 73, 73,  self.equikey, draw_select, {lid = 3})

	--手   5
	eq = self.source.l5;
	if eq and eq.imgid then
		Button:new_img(0, 173, self.__h + 34 + 95+91, 46, 46, 'equi/'.. eq.imgid ..'.png', self.equikey, nil, {lid = 5})
	end;
	Button:new_nodraw(Idx:next(), 158, self.__h + 19 + 94+94, 73, 73,  self.equikey, draw_select, {lid = 5})

	--腰   9
	eq = self.source.l9;
	if eq and eq.imgid then
		Button:new_img(0, 173 + 112, self.__h + 34 + 95+91, 46, 46, 'equi/'.. eq.imgid ..'.png', self.equikey, nil, {lid = 9})
	end;
	Button:new_nodraw(Idx:next(), 158 + 112, self.__h + 19 + 94+94, 73, 73,  self.equikey, draw_select, {lid = 9})

	--背  15
	eq = self.source.l15;
	if eq and eq.imgid then
		Button:new_img(0, 173 + 112+112, self.__h + 34 + 95+91, 46, 46, 'equi/'.. eq.imgid ..'.png', self.equikey, nil, {lid = 15})
	end;
	Button:new_nodraw(Idx:next(), 158 + 112+112, self.__h + 19 + 94+94, 73, 73,  self.equikey, draw_select, {lid = 15})

	--指  12
	eq = self.source.l12;
	if eq and eq.imgid then
		Button:new_img(0, 171, self.__h + 34 + 95+95+91, 46, 46, 'equi/'.. eq.imgid ..'.png', self.equikey, nil, {lid = 12})
	end;
	Button:new_nodraw(Idx:next(), 158, self.__h + 19 + 94+94+94, 73, 73,  self.equikey, draw_select, {lid = 12})

	--腿  10
	eq = self.source.l10;
	if eq and eq.imgid then
		Button:new_img(0, 173 + 112, self.__h + 34 + 95+95+91, 46, 46, 'equi/'.. eq.imgid ..'.png', self.equikey, nil, {lid = 10})
	end;
	Button:new_nodraw(Idx:next(), 158 + 112, self.__h +19 + 94+94+94, 73, 73,  self.equikey, draw_select, {lid = 10})

	--饰  13
	eq = self.source.l13;
	if eq and eq.imgid then
		Button:new_img(0, 174 + 112+112, self.__h +34 + 95+95+90, 46, 46, 'equi/'.. eq.imgid ..'.png', self.equikey, nil, {lid = 13})
	end;
	Button:new_nodraw(Idx:next(), 158 + 112+112, self.__h +19 + 94+94+94, 73, 73,  self.equikey, draw_select, {lid = 13})

	--鞋  11
	eq = self.source.l11;
	if eq and eq.imgid then
		Button:new_img(0, 173 + 112, self.__h +34 + 95+95+95+93, 46, 46, 'equi/'.. eq.imgid ..'.png', self.equikey, nil, {lid = 11})
	end;
	Button:new_nodraw(Idx:next(), 158 + 112, self.__h +19 + 94+94+94+94, 73, 73,  self.equikey, draw_select, {lid = 11})

	--主  6
	eq = self.source.l6;
	if eq and eq.imgid then
		Button:new_img(0, 144, self.__h +34 + 95+95+95+95+87, 46, 46, 'equi/'.. eq.imgid ..'.png', self.equikey, nil, {lid = 6})
	end;
	Button:new_nodraw(Idx:next(), 131, self.__h +19 + 94+94+94+94+94, 73, 73,  self.equikey, draw_select, {lid = 6})

	--副  7
	eq = self.source.l7;
	if eq and eq.imgid then
		Button:new_img(0, 144 + 94, self.__h +34 + 95+95+95+95+86, 46, 46, 'equi/'.. eq.imgid ..'.png', self.equikey, nil, {lid = 7})
	end
	Button:new_nodraw(Idx:next(), 131 + 93, self.__h +19 + 94+94+94+94+94, 73, 73,  self.equikey, draw_select, {lid = 7})

	--远  8
	eq = self.source.l8;
	if eq and eq.imgid then
		Button:new_img(0, 143 + 94+94, self.__h +34 + 95+95+95+95+86, 46, 46, 'equi/'.. eq.imgid ..'.png', self.equikey, nil, {lid = 8})
	end;
	Button:new_nodraw(Idx:next(), 131 + 93+93, self.__h +19 + 94+94+94+94+94, 73, 73,  self.equikey, draw_select, {lid = 8})

	--骑  14
	eq = self.source.l14;
	if eq and eq.imgid then
		Button:new_img(0, 143 + 94+94+94, self.__h +34 + 95+95+95+95+86, 46, 46, 'equi/'.. eq.imgid ..'.png', self.equikey, nil, {lid = 14})
	end;
	Button:new_nodraw(Idx:next(), 131 + 93+93+93, self.__h +19 + 94+94+94+94+94, 73, 73,  self.equikey, draw_select, {lid = 14})


	self:add_h(577);

	self:add_h(addbor632(starty, self.__h) + 10)

	self:add_h(80);
	self:add_h(add_lines(line_start_y, self.__h))

	self.buttonsize = Button.j;
	self.buttonmaxyid = Button.j;
	print('init othergen  ok .....')
	end;

function othergen:free_one()
	print('free_one othergen ......')
	end
function othergen:self_free()
	print('free othergen ......')
	end;
--function othergen:source_ok()	return self.source ~= nil;	end;
function othergen:on_response(data,url,code,attach)
	print('response othergen .....')
	local k = data._return;

	end;
--function othergen:set_source(k)	print('set source othergen .....')	self.source = k; end;
print('load othergen  ok')
