
--http://www.fmddlmyy.cn/text30.html
--GB18030双字节字符的码位空间就是0x8140~0xFE7E和0x8180~0xFEFE，
--双字节字符的码位数目是7938+16002=23940。
--0x8140~0xFE7E和0x8180~0xFEFE也是GBK的全部码位空间。GBK在这23940个码位中定义了21886个字符。包括21003个汉字和883个图形符号



--GB18030是多字节字符集，它的字符可以用一个、两个或四个字节表示。
--GB18030的码位定义如下：
--字节数 	码位空间 	码位数 	字符数
--单字节 	0x00~0x7F 	128 	128
--双字节 	0x8140~0xFE7E和0x8180~0xFEFE 	23940 	21897
--四字节 	0x81308130~0xFE39FE39 	1587600 	54531
--GB18030双字节字符的码位空间就是0x8140~0xFE7E和0x8180~0xFEFE，双字节字符的码位数目是7938+16002=23940。
--0x8140~0xFE7E和0x8180~0xFEFE也是GBK的全部码位空间。GBK在这23940个码位中定义了21886个字符。



--http://blog.csdn.net/fmddlmyy/article/details/1510193
--Unicode是国际组织制定的可以容纳世界上所有文字和符号的字符编码方案。
--Unicode用数字0-0x10FFFF来映射这些字符，最多可以容纳1114112个字符，或者说有1114112个【码位】。
--【其实，现在已定义的码位只有238605个】
--码位就是可以分配给字符的数字。UTF-8、UTF-16、UTF-32都是将数字转换到程序数据的编码方案。

--Unicode字符集可以简写为UCS（Unicode Character Set）。早期的Unicode标准有UCS-2、UCS-4的说法。UCS-2用两个字节编码，
--UCS-4用4个字节编码。UCS-4根据最高位为0的最高字节分成2^7=128个group。
--每个group再根据次高字节分为256个平面（plane）。
--每个平面根据第3个字节分为256行 （row），每行有256个码位（cell）。
--group 0的平面0被称作BMP（Basic Multilingual Plane）。将UCS-4的BMP去掉前面的两个零字节就得到了UCS-2。
--[[
--这个是码位的16进制和2进制，并不是ucs4的编码范围
0x10 FFFF对应于:
0000 0000,0001 0000,1111 1111,1111 1111

ucs4划分:
0000 0000,xxxx xxxx,xxxx xxxx,xxxx xxxx
0000 0001,xxxx xxxx,xxxx xxxx,xxxx xxxx
0000 0010,xxxx xxxx,xxxx xxxx,xxxx xxxx
...
0111 1111,xxxx xxxx,xxxx xxxx,xxxx xxxx
一共是 128个分组，被称为group。

xxxx xxxx,0000 0000,xxxx xxxx,xxxx xxxx
xxxx xxxx,0000 0001,xxxx xxxx,xxxx xxxx
xxxx xxxx,0000 0010,xxxx xxxx,xxxx xxxx
...
xxxx xxxx,1111 1111,xxxx xxxx,xxxx xxxx
一共是256个，被称为plane（平面）

xxxx xxxx,xxxx xxxx,0000 0000,xxxx xxxx
xxxx xxxx,xxxx xxxx,0000 0001,xxxx xxxx
xxxx xxxx,xxxx xxxx,0000 0010,xxxx xxxx
...
xxxx xxxx,xxxx xxxx,1111 1111,xxxx xxxx
一共是256个，被称为row（行）

当然，剩下的最低8bit就是cell(码位)



group 0的平面0被称作BMP（Basic Multilingual Plane）
也就是:
0000 0000,0000 0000,xxxx xxxx,xxxx xxxx

而 Unicode标准计划使用group 0(一共128个group) 的17个平面(每个group是256个平面):
 从BMP（平面0）到平面16，即数字0-0x10FFFF(Unicode的最大码位是0x10ffff)。表示了11141112个码位

| group0 | 17个平面|
0000 0000,0000 0000,0000 0000,0000 0000 BMP的平面0

0000 0000,0000 0001,xxxx xxxx,xxxx xxxx BMP的平面1

0000 0000,0000 0010,xxxx xxxx,xxxx xxxx BMP的平面2
...
0000 0000,0001 0000,1111 1111,1111 1111 BMP的平面16

但是unicode已定义的码位只有23860个，分布在平面 0 1 2 14 15 16
平面0、平面1、平面2和平面14上分别定义了52080、3419、43253和337个字符。
平面0上定义了27973个汉字。平面2的43253个字符都是汉字。

--]]

--有符号转换成无符号数()，方便转换16进制和2进制
function __signed_to_unsigned(v,byte)
	local MOD = 2^(byte*8);
	local MAX_SIGNED = math.floor( (MOD - 1)/2 );
	--print(v,byte,MOD);
	if v >= MOD then
		error('too big for byte:'..byte);
	end
	if v < 0 then
		v = MOD + v;
	end
	return v;
end
--width是打印的宽度,byte是数据的字节数
function hex(v,width,byte)
	local radix = 16;
	byte = byte or 1;
	local hex_str = '';
	if v == 0 then
		hex_str = '0'
	else
		v = __signed_to_unsigned(v,byte);
		while v > 0 do
			local v_left = math.floor(v / radix);
			local n = v - v_left * radix;
			if n >= 10 then
				n =  string.char(65 + n - 10);
			end
			hex_str =  n .. hex_str;
			v = v_left;
		end
	end

	if width then
		if width > #hex_str then
			local fill_zero = string.rep('0',width-#hex_str);
			hex_str = fill_zero .. hex_str
		end
	end

	return hex_str;
end

function binary(v,width,byte)
	local radix = 2;
	byte = byte or 1;
	local hex_str = '';
	if v == 0 then
		hex_str = '0'
	else
		v = __signed_to_unsigned(v,byte);
		while v > 0 do
			local v_left = math.floor(v / radix);
			local n = v - v_left * radix;
			if n >= 10 then
				n =  string.char(65 + n - 10);
			end
			hex_str =  n .. hex_str;
			v = v_left;
		end
		--print(hex_str)

	end
	if width then
		if width > #hex_str then
			local fill_zero = string.rep('0',width-#hex_str);
			hex_str = fill_zero .. hex_str
		end
	end
	return hex_str;
end


--GB18030 和 GBK的1字节编码范围 和ASCII一样  	0x00~0x7F

--GB18030 和 GBK的2字节编码范围:
--分为两块：
--第一块的文字:高位字节:0x81-0xFE,低位字节 0x40-0x7E -> (0xFE-0x81+1)*(0x7E-0x40+1)=126*63=7938
--第二块的文字:高位字节:0x81-0xFE,低位字节 0x80-0xFE -> (0xFE-0x81+1)*(0xFE-0x80+1)=126*127=16002
--所以双字节字符的码位数目是7938+16002=23940。这也是GBK的全部码位空间。GBK在这23940个码位中定义了21886个字符。(GB18030 定义了21897个字符)
--不说分为两块，换个描述：高位字节:0x81-0xFE,低位字节 0x40 <---- (不包括0x7F) ----> 0xFE
--【【GB18030双字节部分与Unicode的映射没有规律，只能通过查表方法映射。】】


--GB18030的四字节字符码位空间是：
-- 第一字节在0x81~0xFE之间
-- 第二字节在0x30~0x39之间 --【对比2字节编码的低字节:0x40-0x7E】
-- 第三字节在0x81~0xFE之间
-- 第四字节在0x30~0x39之间
--(0xFE - 0x81 + 1)*(0x39 - 0x30 + 1)*(0xFE - 0x81 + 1)*(0x39 - 0x30 + 1)=1587600

--GB18030有128+23940+1587600=1611668个码位。
--Unicode的码位数目是0x110000（1114112），少于GB18030。所以，GB18030有足够的空间映射Unicode的所有码位。
--GB18030的1611668个码位目前定义了128+21897+54531=76556个字符。Unicode 5.0定义了99089个字符。

--Unicode的BMP一共有65536个码位。
--其中代理区（0xD800-0xDFFF）有2048个码位，这2048个码位是不能定义字符的。
--GB18030的单字节部分映射了128个码位，GB18030的双字节部分映射了23940个码位。
--还剩下65536-2048-128-23940=39420个码位。
-- GB18030用码位 0x81308130 ~ 0x8439FE39 共 50400 个码位映射该标准单字节和双字节部分没有映射过的39420个Unicode BMP码位。
-- GB18030用码位 0x90308130 ~ 0xE339FE39 共 1058400 个码位映射Unicode 16个辅助平面（平面1到平面16）的65536*16=1048576个码位。

--gb18030的4字节转换成对应的unicode码(plane1 to plane16),不需要查表，只需要计算
function gb18030_2005_4byte_to_unicode(char_4_byte)
	print(char_4_byte)
	local b0,b1,b2,b3 = string.byte(char_4_byte,1),string.byte(char_4_byte,2),string.byte(char_4_byte,3),string.byte(char_4_byte,4);
	print(b0,b1,b2,b3)
	local possible_b0 = -(0x90-0xE3) + 1;
	local possible_b1 = -(0x30-0x39) + 1;
	local possible_b2 = -(0x81-0xFE) + 1;
	local possible_b3 = -(0x30-0x39) + 1;
	local u0 = (b0 - 0x90)* possible_b1 * possible_b2 * possible_b3;
	local u1 = (b1 - 0x30)* possible_b2 * possible_b3;
	local u2 = (b2 - 0x81)*possible_b3;
	local u3 = (b3 - 0x30);
	print(u0,u1,u2,u3)
	local usc4_codepoint = u0+u1+u2+u3+0x00010000;
	return usc4_codepoint;
end

--unicode码转换成对应的4字节gb18030(plane1 to plane16),不需要查表，只需要计算
function unicode_to_gb18030_2005_4byte(usc4_codepoint)
	print(usc4_codepoint)
	--这里的u0u1u2u3 ,u1u2u3,u2u3 表示的是 u0+u1+u2+u3,u1+u2+u3,u2+u3
	local u0u1u2u3 = usc4_codepoint - 0x00010000;

	local possible_b0 = -(0x90-0xE3) + 1;
	local possible_b1 = -(0x30-0x39) + 1;
	local possible_b2 = -(0x81-0xFE) + 1;
	local possible_b3 = -(0x30-0x39) + 1;
	print(possible_b0,possible_b1,possible_b2,possible_b3)
	------------
	local b0 = math.floor(u0u1u2u3/(possible_b1 * possible_b2 * possible_b3)) ;
	local u1u2u3 = u0u1u2u3 - b0 * (possible_b1 * possible_b2 * possible_b3)

	local b1 = math.floor(u1u2u3/(possible_b2 * possible_b3));
	local u2u3 = u1u2u3 - b1 * ( possible_b2 * possible_b3);

	local b2 = math.floor(u2u3/(possible_b3))
	local u3 = u2u3 - b2*(possible_b3);

	local b3 = u3;

	------------
	local b0 = b0 + 0x90;
	local b1 = b1 + 0x30;
	local b2 = b2 + 0x81;
	local b3 = b3 + 0x30;
	print( hex(b0), hex(b1), hex(b2), hex(b3))
	local gb18030_codepoint = b0 * 0x01000000 + b1 * 0x00010000 + b2 * 0x00000100 + b3 * 0x00000001;
	return gb18030_codepoint;
end

local gb = string.char(0x95,0x32,0x82,0x36);
local gb = string.char(0x81,0x30,0xd3,0x30);
local usc4_hex = gb18030_2005_4byte_to_unicode(gb)
print('test plane 1 to 16:', hex(usc4_hex,nil,4));


local gb2 = unicode_to_gb18030_2005_4byte(usc4_hex);
print( hex(gb2,nil,4));

local alien = require 'alien'
WinProc_types = { ret = "long", abi = "stdcall"; "pointer", "uint", "uint", "long" }
alien.kernel32.MultiByteToWideChar:types{ abi="stdcall"; ret="int";
	"long" --[[CodePage]], "long" --[[dwFlags]], "pointer" --[[lpMultiByteStr]],
	"long" --[[cbMultiByte]], "pointer" --[[lpWideCharStr]], "int" --[[cchWideChar]]}

alien.kernel32.WideCharToMultiByte:types{ abi="stdcall"; ret="int";
	"long" --[[CodePage]], "long" --[[dwFlags]], "pointer" --[[lpWideCharStr]],
	"int" --[[cchWideChar]], "pointer" --[[lpMultiByteStr]], "int" --[[cbMultiByte]],
	"string" --[[lpDefaultChar]], "pointer" --[[lpUsedDefaultChar]]}

--[[
int WideCharToMultiByte(
  UINT CodePage,            // code page
  DWORD dwFlags,            // performance and mapping flags
  LPCWSTR lpWideCharStr,    // wide-character string
  int cchWideChar,          // number of chars in string
  LPSTR lpMultiByteStr,     // buffer for new string
  int cbMultiByte,          // size of buffer
  LPCSTR lpDefaultChar,     // default for unmappable chars
  LPBOOL lpUsedDefaultChar  // set when default char used
);

"void", "int", "double", "char", "string", "pointer", "ref int", "ref double", "ref char", "callback", "short", "byte", "long", and "float"
 byte is a signed char
 string is const char*
 pointer is void*
 callback is a generic function pointer
 ref char, ref int and ref double are by reference versions of the C types.

]]

CP_ACP  = 0
CP_UTF8 = 65001
CP_GB18030 = 54936
function MAKE_WIDE(str)
	local codePage = CP_ACP
	local flags = 0
	local wide_len = alien.kernel32.MultiByteToWideChar(codePage, flags, str, #str, nil, 0)
	local buffer = alien.buffer(2 * wide_len)
	local res = alien.kernel32.MultiByteToWideChar(codePage, flags, str, #str, buffer, wide_len)
	-- 上面已转为 UTF-16 编码，下面再转为 UTF-8
	codePage = CP_UTF8
	local multi_len = alien.kernel32.WideCharToMultiByte(codePage, flags, buffer ,  wide_len/2, nil, 0, nil, nil)
	local res_buffer = alien.buffer(multi_len)
	res = alien.kernel32.WideCharToMultiByte(codePage, flags, buffer , wide_len/2, res_buffer, multi_len, nil, nil)
	return res_buffer
end

function __gbk_to_unicode(gbk_str)

	local codePage = CP_GB18030
	local flags = 0
	local wide_len = alien.kernel32.MultiByteToWideChar(codePage, flags,gbk_str, #gbk_str, nil, 0)
	local buffer = alien.buffer( wide_len * 2 )
	local res = alien.kernel32.MultiByteToWideChar(codePage, flags, gbk_str, #gbk_str, buffer, wide_len)
	return buffer:tostring(2);
end

--输入unicode16形式的字符串，返回gb18030的字符串，16进制编码字符串，编码的数字
function __unicode16_to_gb18030(unicode16_str)
	local codePage = CP_GB18030
	local flags = 0
	--print('#unicode16_str:',#unicode16_str)
	local multi_len = alien.kernel32.WideCharToMultiByte(codePage, flags, unicode16_str, 1, nil, 0, nil, nil)

	local res_buffer = alien.buffer(multi_len)
	res = alien.kernel32.WideCharToMultiByte(codePage, flags, unicode16_str , 1, res_buffer, multi_len , nil, nil)

	--把gb18030的16进制值字符串，拼接起来
	local gb18030_code = '';
	--gb18030的int值，用来排序
	local gb18030_code_int = 0;
	--print('multi_len:',multi_len)
	for i=1,multi_len do
		local c = res_buffer[i];
		local c_int = c;
		if c_int < 0 then
			c_int = 256 + c;
		end
		gb18030_code_int = gb18030_code_int * 0x100 + c_int;
		gb18030_code = gb18030_code .. hex(c,2,1);
	end
	local gb18030_str =  res_buffer:tostring(multi_len);
	return gb18030_str,gb18030_code,gb18030_code_int;
end


--求出大于0x81308130的以0x81308130为开始的索引
--GB18030用码位 0x81308130 ~ 0x8439FE39 共 50400 个码位映射该标准单字节和双字节部分没有映射过的39420个Unicode BMP码位。
function get_bigger_than8130813_index(gbcode)
	--print("gbcode：",gbcode)
	local b0 = math.floor(gbcode / 0x01000000)
	gbcode = gbcode - b0 * 0x01000000;
	local b1 = math.floor(gbcode / 0x00010000)
	gbcode = gbcode - b1 * 0x00010000;
	local b2 = math.floor(gbcode / 0x00000100)
	gbcode = gbcode - b2 * 0x00000100;
	local b3 = math.floor(gbcode / 0x00000001)
	gbcode = gbcode - b3 * 0x00000001;
	--print('four bytes are:',b0,b1,b2,b3)
	local possible_b1 = 0x84 - 0x81 + 1;
	local possible_b2 = 0x39 - 0x30 + 1;
	local possible_b3 = 0xFE - 0x81 + 1;
	local possible_b4 = 0x39 - 0x30 + 1;
	
	local u0 = (b0 - 0x81)* possible_b1 * possible_b2 * possible_b3;
	local u1 = (b1 - 0x30)* possible_b2 * possible_b3;
	local u2 = (b2 - 0x81)*possible_b3;
	local u3 = (b3 - 0x30);
	
	local index = u0 + u1 + u2 + u3;
	return index;
end

function unicode_to_gb_table_test()
	local tbl = {};
	for hi=0,0xFF do
		for low=0,0xFF do
			--跳过代理区
			if hi*0x100 + low < 0xD800 or hi*0x100 + low  > 0xDFFF then
				local unicode16 = string.char(low,hi);--大端小端？
				local gb18030_str,gb18030_code,gb18030_code_int = __unicode16_to_gb18030(unicode16,hi,low);
				local t = {
				unicode16_int = hi*0x100 + low,--int形式的unicode值
				unicode16= hex(hi,2) .. hex(low,2),--字符串形式的unicode值
				
				gb18030_code=gb18030_code,
				gb18030_code_int = gb18030_code_int,
				gb18030_str = gb18030_str};
				table.insert(tbl,t);
			end
		end
	end

	---按照unicode来排序，写到两个文件里
	--file_1是2字节gb18030和unicode16的映射
	--file_2是4字节gb18030和unicode16的映射
	table.sort(tbl,function(a,b)
		if a.unicode16_int < b.unicode16_int then
			return true
		end
		end);
	local file_1 = io.open('gb18030_unicode16_data_1_sorted_by_unicode16.txt','wb');
	local file_2 = io.open('gb18030_unicode16_data_2_sorted_by_unicode16.txt','wb');
	local data = '';
	
	local max_index = 0;
	for k,v in pairs(tbl) do
		--print(k,'gbk code:',v.gb18030_code,'unicode16:',v.unicode16,v.gb18030_str)
		data = '{ gbk_code = '.. v.gb18030_code ..',' .. 'unicode16 = ' .. v.unicode16 ..' },\n';
		if v.gb18030_code_int >= 0x81308130 then
			local index = get_bigger_than8130813_index(v.gb18030_code_int)
			if index > max_index then
				max_index = index;
			end
			data = '{ gbk_code = 0x'.. v.gb18030_code ..',index = ' .. index .. ', unicode16 = 0x' .. v.unicode16 ..' },\n';

			file_2:write(data);
		else
			data = '{ gbk_code = 0x'.. v.gb18030_code ..',' .. 'unicode16 = 0x' .. v.unicode16 ..' },\n';
			file_1:write(data);
		end
	end
	--print('4字节映射BMP的最大索引 max_index',max_index);
	file_1:close();
	file_2:close();
	
	---按照gb18030来排序，写到两个文件里
	--file_1是2字节gb18030和unicode16的映射
	--file_2是4字节gb18030和unicode16的映射
	table.sort(tbl,function(a,b)
		if a.gb18030_code_int < b.gb18030_code_int then
			return true
		end
		end);
	local file_1 = io.open('gb18030_unicode16_data_1_sorted_by_gb18030.txt','wb');
	local file_2 = io.open('gb18030_unicode16_data_2_sorted_by_gb18030.txt','wb');
	local data = '';
	
	local max_index = 0;
	for k,v in pairs(tbl) do
		--print(k,'gbk code:',v.gb18030_code,'unicode16:',v.unicode16,v.gb18030_str)
		data = '{ gbk_code = '.. v.gb18030_code ..',' .. 'unicode16 = ' .. v.unicode16 ..' },\n';
		if v.gb18030_code_int >= 0x81308130 then
			local index = get_bigger_than8130813_index(v.gb18030_code_int)
			if index > max_index then
				max_index = index;
			end
			data = '{ gbk_code = 0x'.. v.gb18030_code ..',index = ' .. index .. ', unicode16 = 0x' .. v.unicode16 ..' },\n';

			file_2:write(data);
		else
			data = '{ gbk_code = 0x'.. v.gb18030_code ..',' .. 'unicode16 = 0x' .. v.unicode16 ..' },\n';
			file_1:write(data);
		end
	end
	--print('4字节映射BMP的最大索引 max_index',max_index);
	file_1:close();
	file_2:close();
	print(data);
end
--打印0x0000 ~ 0xFFFF的unicode和gb18030映射表，一共输出65536行，其中：
--1. 没有映射到0x81308130及以上的输出26116行：包括
-- 128(单字节兼容unicode的一一映射) + 23940(双字节和unicode的无规律映射)+ 2048(代理区0xD800-0xDFFF 不映射任何字符)
--2. 映射到 0x81308130 及以上输出39420行
--【注意】GB18030将Unicode的16个辅助平面（0x10000-0x10FFFF，一共1048576个码位）顺序映射到从0x90308130开始的码位空间，是不包括在上面的65536里的，只需要用算法去计算
unicode_to_gb_table_test();

do return end;

--[[
function gbk_to_utf8(gbk_str)
	local codePage = CP_GB18030
	local flags = 0
	local wide_le
	-- 上面已转为 UTF-16 编码，下面再转为 UTF-8
	codePage = CP_UTF8
	local multi_len = alien.kernel32.WideCharToMultiByte(codePage, flags, buffer ,  wide_len, nil, 0, nil, nil)
	local res_buffer = alien.buffer(multi_len * 4)
	res = alien.kernel32.WideCharToMultiByte(codePage, flags, buffer , wide_len, res_buffer, multi_len , nil, nil)
	return res_buffer:tostring();
end
--
function utf8_to_gbk(utf8_str)
	local codePage = CP_UTF8
	local flags = 0
	local wide_len = alien.kernel32.MultiByteToWideChar(codePage, flags, utf8_str, #utf8_str, nil, 0)
	local buffer = alien.buffer(wide_len + 2)
	local res = alien.kernel32.MultiByteToWideChar(codePage, flags, utf8_str, #utf8_str, buffer, wide_len)
	-- 上面已转为 UTF-16 编码，下面再转为 gbk
	codePage = CP_GB18030
	local multi_len = alien.kernel32.WideCharToMultiByte(codePage, flags, buffer ,  wide_len, nil, 0, nil, nil)
	local res_buffer = alien.buffer(multi_len+2)
	res = alien.kernel32.WideCharToMultiByte(codePage, flags, buffer , wide_len, res_buffer, multi_len , nil, nil)
	return  res_buffer:tostring();
end



--打印gbk 0x8140~0xFE7E和0x8180~0xFEFE 上定义的所有字符
local n = 0;
local t = {};

for i=0x81,0xFE do
	for j=0x40,0x7E do
		local char = string.char(i,j);
		n = n + 1;
		--print(n,char)
		local unc = __gbk_to_unicode(char);

		--print(' unc:',unc,'unc len:',string.len(unc) )
		unc1 = string.byte(unc,2);
		unc2 = string.byte(unc,1);
		uncall = unc1 * 0x100 + unc2;
		table.insert( t,{ int_v = i*0x100 + j,char_v = char,unicode = uncall});
	end
	for j=0x80,0xFE do
		local char = string.char(i,j);
		n = n + 1;
		--print(n,char)
		local unc = __gbk_to_unicode(char);

		--print(' unc:',unc,'unc len:',string.len(unc) )
		unc1 = string.byte(unc,2);
		unc2 = string.byte(unc,1);
		uncall = unc1 * 0x100 + unc2;
		table.insert( t,{ int_v = i*0x100 + j,char_v = char,unicode = uncall});
	end
end
--]]
 

 


 
