
--http://www.fmddlmyy.cn/text30.html
--GB18030˫�ֽ��ַ�����λ�ռ����0x8140~0xFE7E��0x8180~0xFEFE��
--˫�ֽ��ַ�����λ��Ŀ��7938+16002=23940��
--0x8140~0xFE7E��0x8180~0xFEFEҲ��GBK��ȫ����λ�ռ䡣GBK����23940����λ�ж�����21886���ַ�������21003�����ֺ�883��ͼ�η���



--GB18030�Ƕ��ֽ��ַ����������ַ�������һ�����������ĸ��ֽڱ�ʾ��
--GB18030����λ�������£�
--�ֽ��� 	��λ�ռ� 	��λ�� 	�ַ���
--���ֽ� 	0x00~0x7F 	128 	128
--˫�ֽ� 	0x8140~0xFE7E��0x8180~0xFEFE 	23940 	21897
--���ֽ� 	0x81308130~0xFE39FE39 	1587600 	54531
--GB18030˫�ֽ��ַ�����λ�ռ����0x8140~0xFE7E��0x8180~0xFEFE��˫�ֽ��ַ�����λ��Ŀ��7938+16002=23940��
--0x8140~0xFE7E��0x8180~0xFEFEҲ��GBK��ȫ����λ�ռ䡣GBK����23940����λ�ж�����21886���ַ���



--http://blog.csdn.net/fmddlmyy/article/details/1510193
--Unicode�ǹ�����֯�ƶ��Ŀ��������������������ֺͷ��ŵ��ַ����뷽����
--Unicode������0-0x10FFFF��ӳ����Щ�ַ�������������1114112���ַ�������˵��1114112������λ����
--����ʵ�������Ѷ������λֻ��238605����
--��λ���ǿ��Է�����ַ������֡�UTF-8��UTF-16��UTF-32���ǽ�����ת�����������ݵı��뷽����

--Unicode�ַ������Լ�дΪUCS��Unicode Character Set�������ڵ�Unicode��׼��UCS-2��UCS-4��˵����UCS-2�������ֽڱ��룬
--UCS-4��4���ֽڱ��롣UCS-4�������λΪ0������ֽڷֳ�2^7=128��group��
--ÿ��group�ٸ��ݴθ��ֽڷ�Ϊ256��ƽ�棨plane����
--ÿ��ƽ����ݵ�3���ֽڷ�Ϊ256�� ��row����ÿ����256����λ��cell����
--group 0��ƽ��0������BMP��Basic Multilingual Plane������UCS-4��BMPȥ��ǰ����������ֽھ͵õ���UCS-2��
--[[
--�������λ��16���ƺ�2���ƣ�������ucs4�ı��뷶Χ
0x10 FFFF��Ӧ��:
0000 0000,0001 0000,1111 1111,1111 1111

ucs4����:
0000 0000,xxxx xxxx,xxxx xxxx,xxxx xxxx
0000 0001,xxxx xxxx,xxxx xxxx,xxxx xxxx
0000 0010,xxxx xxxx,xxxx xxxx,xxxx xxxx
...
0111 1111,xxxx xxxx,xxxx xxxx,xxxx xxxx
һ���� 128�����飬����Ϊgroup��

xxxx xxxx,0000 0000,xxxx xxxx,xxxx xxxx
xxxx xxxx,0000 0001,xxxx xxxx,xxxx xxxx
xxxx xxxx,0000 0010,xxxx xxxx,xxxx xxxx
...
xxxx xxxx,1111 1111,xxxx xxxx,xxxx xxxx
һ����256��������Ϊplane��ƽ�棩

xxxx xxxx,xxxx xxxx,0000 0000,xxxx xxxx
xxxx xxxx,xxxx xxxx,0000 0001,xxxx xxxx
xxxx xxxx,xxxx xxxx,0000 0010,xxxx xxxx
...
xxxx xxxx,xxxx xxxx,1111 1111,xxxx xxxx
һ����256��������Ϊrow���У�

��Ȼ��ʣ�µ����8bit����cell(��λ)



group 0��ƽ��0������BMP��Basic Multilingual Plane��
Ҳ����:
0000 0000,0000 0000,xxxx xxxx,xxxx xxxx

�� Unicode��׼�ƻ�ʹ��group 0(һ��128��group) ��17��ƽ��(ÿ��group��256��ƽ��):
 ��BMP��ƽ��0����ƽ��16��������0-0x10FFFF(Unicode�������λ��0x10ffff)����ʾ��11141112����λ

| group0 | 17��ƽ��|
0000 0000,0000 0000,0000 0000,0000 0000 BMP��ƽ��0

0000 0000,0000 0001,xxxx xxxx,xxxx xxxx BMP��ƽ��1

0000 0000,0000 0010,xxxx xxxx,xxxx xxxx BMP��ƽ��2
...
0000 0000,0001 0000,1111 1111,1111 1111 BMP��ƽ��16

����unicode�Ѷ������λֻ��23860�����ֲ���ƽ�� 0 1 2 14 15 16
ƽ��0��ƽ��1��ƽ��2��ƽ��14�Ϸֱ�����52080��3419��43253��337���ַ���
ƽ��0�϶�����27973�����֡�ƽ��2��43253���ַ����Ǻ��֡�

--]]

--�з���ת�����޷�����()������ת��16���ƺ�2����
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
--width�Ǵ�ӡ�Ŀ��,byte�����ݵ��ֽ���
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


--GB18030 �� GBK��1�ֽڱ��뷶Χ ��ASCIIһ��  	0x00~0x7F

--GB18030 �� GBK��2�ֽڱ��뷶Χ:
--��Ϊ���飺
--��һ�������:��λ�ֽ�:0x81-0xFE,��λ�ֽ� 0x40-0x7E -> (0xFE-0x81+1)*(0x7E-0x40+1)=126*63=7938
--�ڶ��������:��λ�ֽ�:0x81-0xFE,��λ�ֽ� 0x80-0xFE -> (0xFE-0x81+1)*(0xFE-0x80+1)=126*127=16002
--����˫�ֽ��ַ�����λ��Ŀ��7938+16002=23940����Ҳ��GBK��ȫ����λ�ռ䡣GBK����23940����λ�ж�����21886���ַ���(GB18030 ������21897���ַ�)
--��˵��Ϊ���飬������������λ�ֽ�:0x81-0xFE,��λ�ֽ� 0x40 <---- (������0x7F) ----> 0xFE
--����GB18030˫�ֽڲ�����Unicode��ӳ��û�й��ɣ�ֻ��ͨ�������ӳ�䡣����


--GB18030�����ֽ��ַ���λ�ռ��ǣ�
-- ��һ�ֽ���0x81~0xFE֮��
-- �ڶ��ֽ���0x30~0x39֮�� --���Ա�2�ֽڱ���ĵ��ֽ�:0x40-0x7E��
-- �����ֽ���0x81~0xFE֮��
-- �����ֽ���0x30~0x39֮��
--(0xFE - 0x81 + 1)*(0x39 - 0x30 + 1)*(0xFE - 0x81 + 1)*(0x39 - 0x30 + 1)=1587600

--GB18030��128+23940+1587600=1611668����λ��
--Unicode����λ��Ŀ��0x110000��1114112��������GB18030�����ԣ�GB18030���㹻�Ŀռ�ӳ��Unicode��������λ��
--GB18030��1611668����λĿǰ������128+21897+54531=76556���ַ���Unicode 5.0������99089���ַ���

--Unicode��BMPһ����65536����λ��
--���д�������0xD800-0xDFFF����2048����λ����2048����λ�ǲ��ܶ����ַ��ġ�
--GB18030�ĵ��ֽڲ���ӳ����128����λ��GB18030��˫�ֽڲ���ӳ����23940����λ��
--��ʣ��65536-2048-128-23940=39420����λ��
-- GB18030����λ 0x81308130 ~ 0x8439FE39 �� 50400 ����λӳ��ñ�׼���ֽں�˫�ֽڲ���û��ӳ�����39420��Unicode BMP��λ��
-- GB18030����λ 0x90308130 ~ 0xE339FE39 �� 1058400 ����λӳ��Unicode 16������ƽ�棨ƽ��1��ƽ��16����65536*16=1048576����λ��

--gb18030��4�ֽ�ת���ɶ�Ӧ��unicode��(plane1 to plane16),����Ҫ���ֻ��Ҫ����
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

--unicode��ת���ɶ�Ӧ��4�ֽ�gb18030(plane1 to plane16),����Ҫ���ֻ��Ҫ����
function unicode_to_gb18030_2005_4byte(usc4_codepoint)
	print(usc4_codepoint)
	--�����u0u1u2u3 ,u1u2u3,u2u3 ��ʾ���� u0+u1+u2+u3,u1+u2+u3,u2+u3
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
	-- ������תΪ UTF-16 ���룬������תΪ UTF-8
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

--����unicode16��ʽ���ַ���������gb18030���ַ�����16���Ʊ����ַ��������������
function __unicode16_to_gb18030(unicode16_str)
	local codePage = CP_GB18030
	local flags = 0
	--print('#unicode16_str:',#unicode16_str)
	local multi_len = alien.kernel32.WideCharToMultiByte(codePage, flags, unicode16_str, 1, nil, 0, nil, nil)

	local res_buffer = alien.buffer(multi_len)
	res = alien.kernel32.WideCharToMultiByte(codePage, flags, unicode16_str , 1, res_buffer, multi_len , nil, nil)

	--��gb18030��16����ֵ�ַ�����ƴ������
	local gb18030_code = '';
	--gb18030��intֵ����������
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


--�������0x81308130����0x81308130Ϊ��ʼ������
--GB18030����λ 0x81308130 ~ 0x8439FE39 �� 50400 ����λӳ��ñ�׼���ֽں�˫�ֽڲ���û��ӳ�����39420��Unicode BMP��λ��
function get_bigger_than8130813_index(gbcode)
	--print("gbcode��",gbcode)
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
			--����������
			if hi*0x100 + low < 0xD800 or hi*0x100 + low  > 0xDFFF then
				local unicode16 = string.char(low,hi);--���С�ˣ�
				local gb18030_str,gb18030_code,gb18030_code_int = __unicode16_to_gb18030(unicode16,hi,low);
				local t = {
				unicode16_int = hi*0x100 + low,--int��ʽ��unicodeֵ
				unicode16= hex(hi,2) .. hex(low,2),--�ַ�����ʽ��unicodeֵ
				
				gb18030_code=gb18030_code,
				gb18030_code_int = gb18030_code_int,
				gb18030_str = gb18030_str};
				table.insert(tbl,t);
			end
		end
	end

	---����unicode������д�������ļ���
	--file_1��2�ֽ�gb18030��unicode16��ӳ��
	--file_2��4�ֽ�gb18030��unicode16��ӳ��
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
	--print('4�ֽ�ӳ��BMP��������� max_index',max_index);
	file_1:close();
	file_2:close();
	
	---����gb18030������д�������ļ���
	--file_1��2�ֽ�gb18030��unicode16��ӳ��
	--file_2��4�ֽ�gb18030��unicode16��ӳ��
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
	--print('4�ֽ�ӳ��BMP��������� max_index',max_index);
	file_1:close();
	file_2:close();
	print(data);
end
--��ӡ0x0000 ~ 0xFFFF��unicode��gb18030ӳ���һ�����65536�У����У�
--1. û��ӳ�䵽0x81308130�����ϵ����26116�У�����
-- 128(���ֽڼ���unicode��һһӳ��) + 23940(˫�ֽں�unicode���޹���ӳ��)+ 2048(������0xD800-0xDFFF ��ӳ���κ��ַ�)
--2. ӳ�䵽 0x81308130 ���������39420��
--��ע�⡿GB18030��Unicode��16������ƽ�棨0x10000-0x10FFFF��һ��1048576����λ��˳��ӳ�䵽��0x90308130��ʼ����λ�ռ䣬�ǲ������������65536��ģ�ֻ��Ҫ���㷨ȥ����
unicode_to_gb_table_test();

do return end;

--[[
function gbk_to_utf8(gbk_str)
	local codePage = CP_GB18030
	local flags = 0
	local wide_le
	-- ������תΪ UTF-16 ���룬������תΪ UTF-8
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
	-- ������תΪ UTF-16 ���룬������תΪ gbk
	codePage = CP_GB18030
	local multi_len = alien.kernel32.WideCharToMultiByte(codePage, flags, buffer ,  wide_len, nil, 0, nil, nil)
	local res_buffer = alien.buffer(multi_len+2)
	res = alien.kernel32.WideCharToMultiByte(codePage, flags, buffer , wide_len, res_buffer, multi_len , nil, nil)
	return  res_buffer:tostring();
end



--��ӡgbk 0x8140~0xFE7E��0x8180~0xFEFE �϶���������ַ�
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
 

 


 
