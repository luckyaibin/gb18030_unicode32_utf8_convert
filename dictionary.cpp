#include "dictionary.h"
#include<stdio.h>
#include <memory.h>
#include <string.h>

int unicode32_to_utf8(unsigned int unicode, unsigned char *utf8_char_array)
{
	if (unicode <= 0x0000007FU)
	{
		if (utf8_char_array)
		{
			*utf8_char_array = unicode;
		}
		return 1;
	}
	else if (0x00000080U <= unicode && unicode <= 0x000007FFU)//BMP
	{
		if (utf8_char_array)//110xxxxx 10xxxxxx
		{
			*(utf8_char_array + 0) = 0xC0 | ((unicode >> 6) & 0x1FU);
			*(utf8_char_array + 1) = 0x80 | ((unicode)& 0x3FU);
		}
		return 2;
	}
	else if (0x00000800U <= unicode && unicode <= 0x0000FFFFU)//BMP
	{
		if (utf8_char_array)//1110xxxx 10xxxxxx 10xxxxxx
		{
			*(utf8_char_array + 0) = 0xE0 | ((unicode >> 12) & 0xFU);
			*(utf8_char_array + 1) = 0x80 | ((unicode >> 6) & 0x3FU);
			*(utf8_char_array + 2) = 0x80 | ((unicode)& 0x3FU);
		}
		return 3;
	}
	else if (0x00010000U <= unicode && unicode <= 0x001FFFFF)//plane1-plane16（unicode的编码空间从U + 0000到 + 10FFFF，共有1, 112, 064个码位），这个已经超过了unicode的码位
	{
		if (utf8_char_array)//11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
		{
			*(utf8_char_array + 0) = 0xF0 | ((unicode >> 18) & 0x7U);
			*(utf8_char_array + 1) = 0x80 | ((unicode >> 12) & 0x3FU);
			*(utf8_char_array + 2) = 0x80 | ((unicode >> 6) & 0x3FU);
			*(utf8_char_array + 3) = 0x80 | ((unicode)& 0x3FU);
		}
		return 4;
	}
	/*else if (0x00200000U <= unicode16 && unicode16 <= 0x03FFFFFF)
	{

	return 5;
	}
	else if (0x04000000U <= unicode16 && unicode16 <= 0x7FFFFFFF)
	{

	return 6;
	}*/
	else
	{
		return -1;
	}
}

int utf8_to_unicode32(const unsigned char *utf8_char_array, unsigned int *unicode)
{
	const unsigned char * u = utf8_char_array;
	if (u[0] <= 0x7F)//0xxxxxxx
	{
		if (unicode)
		{
			*unicode = u[0];
		}
		return 1;
	}
	else if ((0xDF >= u[0] && u[0] >= 0xC0)	//110xxxxx 10xxxxxx
		&& (0x80 <= u[1] && u[1] <= 0xBF))
	{
		if (unicode)
		{
			unsigned char c1 = u[0];
			unsigned char c2 = u[1];
			c1 = c1 & 0x1F;
			c2 = c2 & 0x3F;

			*unicode = ((unsigned int)(c1) << 6) | c2;
		}
		return 2;
	}
	else if ((0xEF >= u[0] && u[0] >= 0xE0)	//1110xxxx 10xxxxxx 10xxxxxx
		&& (0x80 <= u[1] && u[1] <= 0xBF)
		&& (0x80 <= u[2] && u[2] <= 0xBF))
	{
		if (unicode)
		{
			unsigned char c1 = u[0];
			unsigned char c2 = u[1];
			unsigned char c3 = u[2];
			c1 = c1 & 0xF;
			c2 = c2 & 0x3F;
			c3 = c3 & 0x3F;

			*unicode = ((unsigned int)(c1) << 12) | ((unsigned int)(c2) << 6) | c3;
		}
		return 3;
	}
	else if ((0xF7 >= u[0] && u[0] >= 0xF0)	//11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
		&& (0x80 <= u[1] && u[1] <= 0xBF)
		&& (0x80 <= u[2] && u[2] <= 0xBF)
		&& (0x80 <= u[3] && u[3] <= 0xBF))
	{
		if (unicode)
		{
			unsigned char c1 = u[0];
			unsigned char c2 = u[1];
			unsigned char c3 = u[2];
			unsigned char c4 = u[3];
			c1 = c1 & 0x7;
			c2 = c2 & 0x3F;
			c3 = c3 & 0x3F;
			c4 = c4 & 0x3F;
			*unicode = ((unsigned int)(c1) << 18) | ((unsigned int)(c2) << 12) | ((unsigned int)(c3) << 6) | c4;
		}
		return 4;
	}
	else
	{
		return -1;
	}
}


int unicode32_gb(unsigned int u_code, unsigned int *gb_code)
{
	int ret_bytes = -1;
	if (u_code <= 0x7F)
	{
		*gb_code = u_code;
		ret_bytes = 1;
	}

	//上一步没有满足，那么先查第一个表
	if ((-1==ret_bytes)&& (u_code >= table_un_order[0].u_code)
		&& (u_code <= table_un_order[MAX_UNICODE32_BMP_GB18030_2_BYTE_ENTRY - 1].u_code
			+ table_un_order[MAX_UNICODE32_BMP_GB18030_2_BYTE_ENTRY - 1].num))//去unicode 和gb 2字节映射表去查找
	{
		unsigned short head = 0, tail = MAX_UNICODE32_BMP_GB18030_2_BYTE_ENTRY - 1;
		while (head <= tail)
		{
			unsigned int middle = (head + tail) / 2;

			unsigned int middle_unicode16 = table_un_order[middle].u_code;
			unsigned char middle_num = table_un_order[middle].num;
			//printf("head:%d,middle:%d,tail:%d \n", head, middle, tail);
			//printf("u_code:%0x,head_code:%0x,tail_code:%0x,middle_code:%0x ,num:%0x \n\n", u_code, table_un_order[head].u_code, table_un_order[tail].u_code, middle_unicode16, middle_num);
			
			if (middle_unicode16 <= u_code && u_code < middle_unicode16 + middle_num)
			{
				*gb_code = table_un_order[middle].gb_code + (u_code - middle_unicode16);
				ret_bytes = 2;
				break;
			}
			else if (u_code < middle_unicode16)
			{
				tail = middle - 1;
			}
			else
			{
				head = middle + 1;
			}
			
		}
	}
	//第一个表没查到，需要再查第二个表
	if ((-1 == ret_bytes) && (u_code >= table_bo_order[0].u_code)
		&& (u_code <= table_bo_order[MAX_UNICODE32_BMP_GB18030_4_BYTE_ENTRY - 1].u_code
		+ table_bo_order[MAX_UNICODE32_BMP_GB18030_4_BYTE_ENTRY - 1].num) )//去unicode 和gb 4字节映射表去查找
	{
		unsigned short head = 0, tail = MAX_UNICODE32_BMP_GB18030_4_BYTE_ENTRY - 1;
		while (head <= tail)
		{
			unsigned int middle = (head + tail) / 2;

			unsigned int middle_unicode16 = table_bo_order[middle].u_code;
			unsigned char middle_num = table_bo_order[middle].num;

			//printf("head:%d,middle:%d,tail:%d \n", head, middle, tail);
			//printf("u_code:%0x,head_code:%0x,tail_code:%0x,middle_code:%0x ,num:%0x \n\n", u_code, table_bo_order[head].u_code, table_bo_order[tail].u_code, middle_unicode16, middle_num);


			if (middle_unicode16 <= u_code && u_code < middle_unicode16 + middle_num)
			{
				*gb_code = table_bo_order[middle].gb_code + (u_code - middle_unicode16);
				ret_bytes = 4;
				break;
			}
			else if (u_code < middle_unicode16)
			{
				tail = middle - 1;
			}
			else
			{
				head = middle + 1;
			}
			//printf("head:%d,middle:%d,tail:%d \n", head, middle, tail);
		}
	}
	//unicode位于plane1 ~ plane16,通过计算的方式计算
	if ((-1 == ret_bytes) && (u_code >= 0x00010000U) && (u_code <= 0x10FFFFU))
	{
		//这里的u0u1u2u3, u1u2u3, u2u3 表示的是 u0 + u1 + u2 + u3, u1 + u2 + u3, u2 + u3
		unsigned int u0u1u2u3 = u_code - 0x00010000;

		int possible_b0 = -(0x90 - 0xE3) + 1;
		int possible_b1 = -(0x30 - 0x39) + 1;
		int possible_b2 = -(0x81 - 0xFE) + 1;
		int possible_b3 = -(0x30 - 0x39) + 1;


		unsigned char b0 = u0u1u2u3 / (possible_b1 * possible_b2 * possible_b3);
		unsigned int u1u2u3 = u0u1u2u3 - b0 * (possible_b1 * possible_b2 * possible_b3);

		unsigned char  b1 = u1u2u3 / (possible_b2 * possible_b3);
		unsigned int u2u3 = u1u2u3 - b1 * (possible_b2 * possible_b3);

		unsigned char  b2 = u2u3 / (possible_b3);
		unsigned int u3 = u2u3 - b2*(possible_b3);

		unsigned char  b3 = u3;


		unsigned int B0 = b0 + 0x90;
		unsigned int B1 = b1 + 0x30;
		unsigned int B2 = b2 + 0x81;
		unsigned int B3 = b3 + 0x30;

		*gb_code = B0 * 0x01000000 + B1 * 0x00010000 + B2 * 0x00000100 + B3 * 0x00000001;

		ret_bytes = 4;
	}
	return ret_bytes;
}

int gb_unicode32(unsigned int gb_code, unsigned int *u_code)
{
	int ret_bytes = -1;
	if (gb_code <= 0x7F)
	{
		*u_code = gb_code;
		ret_bytes = 1;
	}
	//查表的2byte
	if ((-1 == ret_bytes) && (gb_code >= table_gb_order[0].gb_code)
		&& (gb_code <= table_gb_order[MAX_UNICODE32_BMP_GB18030_2_BYTE_ENTRY - 1].gb_code + table_gb_order[MAX_UNICODE32_BMP_GB18030_2_BYTE_ENTRY - 1].num))
	{
		unsigned short head = 0, tail = MAX_UNICODE32_BMP_GB18030_2_BYTE_ENTRY - 1;
		while (head <= tail)
		{
			unsigned int middle = (head + tail) / 2;

			unsigned int middle_gb18030_code = table_gb_order[middle].gb_code;
			unsigned char middle_num = table_gb_order[middle].num;

			if (middle_gb18030_code <= gb_code && gb_code < middle_gb18030_code + middle_num)
			{
				*u_code = table_gb_order[middle].u_code + (gb_code - middle_gb18030_code);
				ret_bytes = 4;
				break;
			}
			else if (gb_code < middle_gb18030_code)
			{
				tail = middle - 1;
			}
			else
			{
				head = middle + 1;
			}
			//printf("head:%d,middle:%d,tail:%d \n", head, middle, tail);
		}
	}
	//查表的4byte
	if ((-1 == ret_bytes)&&(gb_code >= table_bo_order[0].gb_code)
		&& (gb_code <= table_bo_order[MAX_UNICODE32_BMP_GB18030_4_BYTE_ENTRY - 1].gb_code + table_bo_order[MAX_UNICODE32_BMP_GB18030_4_BYTE_ENTRY - 1].num))
	{
		unsigned short head = 0, tail = MAX_UNICODE32_BMP_GB18030_4_BYTE_ENTRY - 1;
		while (head <= tail)
		{
			unsigned int middle = (head + tail) / 2;

			unsigned int middle_gb18030_code = table_bo_order[middle].gb_code;
			unsigned char middle_num = table_bo_order[middle].num;

			if (middle_gb18030_code <= gb_code && gb_code < middle_gb18030_code + middle_num)
			{
				*u_code = table_bo_order[middle].u_code + (gb_code - middle_gb18030_code);
				ret_bytes = 4;
				break;
			}
			else if (gb_code < middle_gb18030_code)
			{
				tail = middle - 1;
			}
			else
			{
				head = middle + 1;
			}
			//printf("head:%d,middle:%d,tail:%d \n", head, middle, tail);
		}
	}
	//计算的方式
	if ((-1 == ret_bytes)&&(gb_code >= 0x90308130U) && (gb_code <= 0xE339FE39U))
	{

		unsigned char b0 = ((gb_code >> 24) & 0xFFU);
		unsigned char b1 = ((gb_code >> 16) & 0xFFU);
		unsigned char b2 = ((gb_code >> 8) & 0xFFU);
		unsigned char b3 = ((gb_code >> 0) & 0xFFU);
		int possible_b0 = -(0x90 - 0xE3) + 1;
		int possible_b1 = -(0x30 - 0x39) + 1;
		int possible_b2 = -(0x81 - 0xFE) + 1;
		int possible_b3 = -(0x30 - 0x39) + 1;
		int u0 = (b0 - 0x90)* possible_b1 * possible_b2 * possible_b3;
		int u1 = (b1 - 0x30)* possible_b2 * possible_b3;
		int u2 = (b2 - 0x81)*possible_b3;
		int u3 = (b3 - 0x30);

		*u_code = u0 + u1 + u2 + u3 + 0x00010000;
		ret_bytes = 4;
	}
	return ret_bytes;
}

//把v 里的 bytes_in_v 个字节写入到char_buf的char_buf_pos位置
int __put_int_bytes_to_char_buf(unsigned int v, unsigned int bytes_in_v, unsigned char *char_buf, unsigned int char_buf_pos, unsigned int char_buf_size)
{
	unsigned char c = 0;
	int i = bytes_in_v;
	for (; i > 0; i--)
	{
		c = (v >> (8 * (i - 1))) & 0xFFU;
		if (char_buf && char_buf_pos < char_buf_size)
		{
			char_buf[char_buf_pos] = c;
			char_buf_pos++;
		}
		else
		{
			break;
		}
	}
	return 	(bytes_in_v - i);	  //返回写入char_buf_pos的字节数
}

int string_unicode32_to_gb(const unsigned int *u, unsigned int u_size, unsigned char * g, unsigned int g_size)
{
	const static unsigned int INVALID_CHARS = (('\?' << 8) | '?');
	unsigned int g_curr_pos = 0;
	for (unsigned int i = 0; i < u_size; i++)
	{
		unsigned int u_code = u[i];
		unsigned int gb_code = 0;
		int gb_code_bytes = 0;
		gb_code_bytes = unicode32_gb(u_code, &gb_code);
		if (-1 == gb_code_bytes)
		{
			gb_code = INVALID_CHARS;
			gb_code_bytes = 2;
		}
		__put_int_bytes_to_char_buf(gb_code, gb_code_bytes, g, g_curr_pos, g_size);
		g_curr_pos = g_curr_pos + gb_code_bytes;
	}
	if (g && (g_curr_pos >= g_size))
	{
		g_curr_pos = g_size;
	}
	return g_curr_pos;
}

int string_gb_to_unicode32(const unsigned char *g, int g_size, unsigned int *u, int u_size)
{
	const unsigned char * ch = g;
	int ch_pos = 0;

	int u32_buf_pos = 0;
	int L = 0;
	for (; ch_pos < g_size;)
	{
		//1字节(映射到BMP)
		if (VALUE_BETWEEN(0, ch[ch_pos], 0x7F))
		{
			unsigned int gb18030_2bytes_in = ch[ch_pos];
			unsigned int asc_out = 0;

			L = gb_unicode32(gb18030_2bytes_in, (unsigned int*)&asc_out);
			if (u && u32_buf_pos < u_size)
			{
				if (L != -1)
				{
					u[u32_buf_pos] = asc_out;
				}
				else
				{
					u[u32_buf_pos] = '?';
				}
			}

			u32_buf_pos = u32_buf_pos + 1;
			ch_pos = ch_pos + 1;
		}
		//2字节(映射到BMP)
		else if ((ch_pos + 1 < g_size) &&
			(
			(VALUE_BETWEEN(0x81, ch[ch_pos], 0xFE) &&
			VALUE_BETWEEN(0x40, ch[ch_pos + 1], 0x7E)
			)
			||
			(VALUE_BETWEEN(0x81, ch[ch_pos], 0xFE) &&
			VALUE_BETWEEN(0x80, ch[ch_pos + 1], 0xFE)
			)
			)
			)
		{
			unsigned short gb18030_2bytes_in = CHAR_TO_USHORT(ch[ch_pos], ch[ch_pos + 1]);
			unsigned int utf16_out = 0;

			L = gb_unicode32(gb18030_2bytes_in, (unsigned int*)&utf16_out);
			if (u && u32_buf_pos < u_size)
			{
				if (L != -1)
				{
					u[u32_buf_pos] = utf16_out;
				}
				else
				{
					u[u32_buf_pos] = '?';
				}
			}

			u32_buf_pos = u32_buf_pos + 1;
			ch_pos = ch_pos + 2;
		}
		//4字节(映射到BMP)
		else if ((ch_pos + 3 < g_size) &&
			(
			(VALUE_BETWEEN(0x81, ch[ch_pos], 0x84) &&
			VALUE_BETWEEN(0x30, ch[ch_pos + 1], 0x39) &&
			VALUE_BETWEEN(0x81, ch[ch_pos + 2], 0xFE) &&
			VALUE_BETWEEN(0x30, ch[ch_pos + 3], 0x39)
			)
			)
			)
		{
			unsigned int gb18030_4bytes_in = CHAR_TO_UINT(ch[ch_pos], ch[ch_pos + 1], ch[ch_pos + 2], ch[ch_pos + 3]);
			unsigned int utf16_out = 0;
			L = gb_unicode32(gb18030_4bytes_in, (unsigned int*)&utf16_out);
			if (u && u32_buf_pos < u_size)
			{
				if (L != -1)
				{
					u[u32_buf_pos] = utf16_out;
				}
				else
				{
					u[u32_buf_pos] = '?';
				}
			}
			u32_buf_pos = u32_buf_pos + 1;
			ch_pos = ch_pos + 4;
		}
		//4字节(映射到plane1-plane16)
		else if ((ch_pos + 3 < g_size) &&
			(
			(VALUE_BETWEEN(0x90, ch[ch_pos], 0xE3) &&
			VALUE_BETWEEN(0x30, ch[ch_pos + 1], 0x39) &&
			VALUE_BETWEEN(0x81, ch[ch_pos + 2], 0xFE) &&
			VALUE_BETWEEN(0x30, ch[ch_pos + 3], 0x39)
			)
			)
			)
		{
			unsigned int gb18030_4bytes_in = CHAR_TO_UINT(ch[ch_pos], ch[ch_pos + 1], ch[ch_pos + 2], ch[ch_pos + 3]);
			unsigned int utf32_out = 0;
			L = gb_unicode32(gb18030_4bytes_in, &utf32_out);
			//注意，对于映射到4byte unicode 的情况，如果转换成unicode16，数据已经被破坏了（因为没法区分出是2个unicode16还是unicode32了）
			if (u && u32_buf_pos < u_size)
			{
				if (L != -1)
				{
					u[u32_buf_pos] = utf32_out;
				}
				else
				{
					u[u32_buf_pos] = '?';
				}
			}

			u32_buf_pos = u32_buf_pos + 2;
			ch_pos = ch_pos + 4;
		}
		else
		{
			break;
		}
	}
	if (u && (u32_buf_pos > u_size))
	{
		u32_buf_pos = u_size;
	}
	return  u32_buf_pos;
}

int string_unicode32_to_utf8(const unsigned int *u32, unsigned int u32_size, unsigned char * u8, unsigned int u8_size)
{
	unsigned int curr_u32_pos = 0;
	unsigned int curr_u8_pos = 0;
	
	unsigned char u8_buff[4] = { 0 };
	for (; curr_u32_pos < u32_size; curr_u32_pos++)
	{
		unsigned int curr_u32 = u32[curr_u32_pos];
		/////////////////////////////////
		if (curr_u32 <= 0x0000007FU)
		{
			if (u8)
			{
				u8[curr_u8_pos] = curr_u32;
			}
			curr_u8_pos = curr_u8_pos + 1;
		}
		else if (0x00000080U <= curr_u32 && curr_u32 <= 0x000007FFU)//BMP
		{
			if (u8)//110xxxxx 10xxxxxx
			{
				u8[curr_u8_pos + 0] = 0xC0 | ((curr_u32 >> 6) & 0x1FU);
				u8[curr_u8_pos + 1] = 0x80 | ((curr_u32)& 0x3FU);
			}
			curr_u8_pos = curr_u8_pos + 2;
		}
		else if (0x00000800U <= curr_u32 && curr_u32 <= 0x0000FFFFU)//BMP
		{
			if (u8)//1110xxxx 10xxxxxx 10xxxxxx
			{
				u8[curr_u8_pos + 0] = 0xE0 | ((curr_u32 >> 12) & 0xFU);
				u8[curr_u8_pos + 1] = 0x80 | ((curr_u32 >> 6) & 0x3FU);
				u8[curr_u8_pos + 2] = 0x80 | ((curr_u32)& 0x3FU);
			}
			curr_u8_pos = curr_u8_pos + 3;
		}
		else if (0x00010000U <= curr_u32 && curr_u32 <= 0x001FFFFF)//plane1-plane16（unicode的编码空间从U + 0000到 + 10FFFF，共有1, 112, 064个码位），这个已经超过了unicode的码位
		{
			if (u8)//11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
			{
				u8[curr_u8_pos + 0] = 0xF0 | ((curr_u32 >> 18) & 0x7U);
				u8[curr_u8_pos + 1] = 0x80 | ((curr_u32 >> 12) & 0x3FU);
				u8[curr_u8_pos + 2] = 0x80 | ((curr_u32 >> 6) & 0x3FU);
				u8[curr_u8_pos + 3] = 0x80 | ((curr_u32)& 0x3FU);
			}
			curr_u8_pos = curr_u8_pos + 4;
		}
		/*else if (0x00200000U <= unicode16 && unicode16 <= 0x03FFFFFF)
		{

		return 5;
		}
		else if (0x04000000U <= unicode16 && unicode16 <= 0x7FFFFFFF)
		{

		return 6;
		}*/
		else
		{
			u8[curr_u8_pos + 0] = '?';
			u8[curr_u8_pos + 1] = '?';
			curr_u8_pos = curr_u8_pos + 2;
		}
		////////////////////////////////
	}
	return curr_u8_pos;
}

int string_utf8_to_unicode32(const unsigned char * u8, unsigned int u8_size, unsigned int *u32, unsigned int u32_size)
{
	unsigned int curr_u8_pos = 0;
	unsigned int curr_u32_pos = 0;
	for (; curr_u8_pos < u8_size;)
	{
		if (u8[curr_u8_pos] <= 0x7F)//0xxxxxxx
		{
			if (u32)
			{
				u32[curr_u32_pos] = u8[curr_u8_pos];
			}
			curr_u8_pos = curr_u8_pos + 1;
			curr_u32_pos = curr_u32_pos + 1;
		}
		else if ((0xDF >= u8[curr_u8_pos + 0] && u8[curr_u8_pos + 0] >= 0xC0)	//110xxxxx 10xxxxxx
			&& (0x80 <= u8[curr_u8_pos + 1] && u8[curr_u8_pos + 1] <= 0xBF))
		{
			if (u32)
			{
				unsigned char c1 = u8[curr_u8_pos + 0];
				unsigned char c2 = u8[curr_u8_pos + 1];
				c1 = c1 & 0x1F;
				c2 = c2 & 0x3F;

				u32[curr_u32_pos] = ((unsigned int)(c1) << 6) | c2;
			}
			curr_u8_pos = curr_u8_pos + 2;
			curr_u32_pos = curr_u32_pos + 1;
		}
		else if ((0xEF >= u8[curr_u8_pos + 0] && u8[curr_u8_pos + 0] >= 0xE0)	//1110xxxx 10xxxxxx 10xxxxxx
			&& (0x80 <= u8[curr_u8_pos + 1] && u8[curr_u8_pos + 1] <= 0xBF)
			&& (0x80 <= u8[curr_u8_pos + 2] && u8[curr_u8_pos + 2] <= 0xBF))
		{
			if (u32)
			{
				unsigned char c1 = u8[curr_u8_pos + 0];
				unsigned char c2 = u8[curr_u8_pos + 1];
				unsigned char c3 = u8[curr_u8_pos + 2];
				c1 = c1 & 0xF;
				c2 = c2 & 0x3F;
				c3 = c3 & 0x3F;

				u32[curr_u32_pos] = ((unsigned int)(c1) << 12) | ((unsigned int)(c2) << 6) | c3;
			}
			curr_u8_pos = curr_u8_pos + 3;
			curr_u32_pos = curr_u32_pos + 1;
		}
		else if ((0xF7 >= u8[curr_u8_pos + 0] && u8[curr_u8_pos + 0] >= 0xF0)	//11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
			&& (0x80 <= u8[curr_u8_pos + 1] && u8[curr_u8_pos + 1] <= 0xBF)
			&& (0x80 <= u8[curr_u8_pos + 2] && u8[curr_u8_pos + 2] <= 0xBF)
			&& (0x80 <= u8[curr_u8_pos + 3] && u8[curr_u8_pos + 3] <= 0xBF))
		{
			if (u32)
			{
				unsigned char c1 = u8[curr_u8_pos + 0];
				unsigned char c2 = u8[curr_u8_pos + 1];
				unsigned char c3 = u8[curr_u8_pos + 2];
				unsigned char c4 = u8[curr_u8_pos + 3];
				c1 = c1 & 0x7;
				c2 = c2 & 0x3F;
				c3 = c3 & 0x3F;
				c4 = c4 & 0x3F;
				u32[curr_u32_pos]  = ((unsigned int)(c1) << 18) | ((unsigned int)(c2) << 12) | ((unsigned int)(c3) << 6) | c4;
			}
			curr_u8_pos = curr_u8_pos + 4;
			curr_u32_pos = curr_u32_pos + 1;
		}
		else
		{
			u32[curr_u32_pos] = ((unsigned int)('?') << 18) | ((unsigned int)('?') << 12) | ((unsigned int)('?') << 6) | '?';
			curr_u8_pos = curr_u8_pos + 4;
			curr_u32_pos = curr_u32_pos + 1;
		}
	}
	return curr_u32_pos;
}
