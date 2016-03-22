#ifndef __DICTIONARY_H__
#define __DICTIONARY_H__

//unicode32和gb18030的映射表用到
typedef struct unicode_gb18030_entry
{
	unsigned int u_code;
	unsigned int gb_code;
	unsigned char num;
}U32_GB_ENTRY;

//某个值位于某个范围
#define VALUE_BETWEEN(low_range,value,high_range)  (((low_range)<=(value)) && ((value)<=(high_range)))

//两个char构成的unsigned short
#define CHAR_TO_USHORT(c1,c2)  (( (c1&0xFFU) << 8 ) | (c2&0xFFU))
//获取unsigned short 的高字节
#define USHORT_HI(s) ((s>>8)&0xFFU)
//获取unsigned short 的低字节
#define USHORT_LO(s) ((s)&0xFFU)


//四个char构成的unsigned short
#define CHAR_TO_UINT(c1,c2,c3,c4)  ( ((c1&0xFFU) << 24) |  ((c2&0xFFU) << 16) | ((c3&0xFFU) << 8) | (c4&0xFFU) )//某个值位于某个范围
#define VALUE_BETWEEN(low_range,value,high_range)  (((low_range)<=(value)) && ((value)<=(high_range)))

//两个char构成的unsigned short
#define CHAR_TO_USHORT(c1,c2)  (( (c1&0xFFU) << 8 ) | (c2&0xFFU))
//获取unsigned short 的高字节
#define USHORT_HI(s) ((s>>8)&0xFFU)
//获取unsigned short 的低字节
#define USHORT_LO(s) ((s)&0xFFU)


//四个char构成的unsigned short
#define CHAR_TO_UINT(c1,c2,c3,c4)  ( ((c1&0xFFU) << 24) |  ((c2&0xFFU) << 16) | ((c3&0xFFU) << 8) | (c4&0xFFU) )

//unicode BMP（0-0xFFFF)和gb18030的映射，有两部分，一部分映射到2字节的gb，一部分是4自己的gb
const static int MAX_UNICODE32_BMP_GB18030_2_BYTE_ENTRY = 10470;
const static int MAX_UNICODE32_BMP_GB18030_4_BYTE_ENTRY = 4126;


/*下面定义了3个数据表格：
a. unicode 和  2字节的gb映射部分需要两个表格，分别是
	按照unicode 排序和	-> 表格1
	按照 gb 排序		-> 表格2
b. unicode 和 4字节的gb映射部分，需要一个表格
	因为两个都是递增的一一映射，所以只需要一个表格	-> 表格3
*/

extern U32_GB_ENTRY table_un_order[MAX_UNICODE32_BMP_GB18030_2_BYTE_ENTRY];// unicode order
extern U32_GB_ENTRY table_gb_order[MAX_UNICODE32_BMP_GB18030_2_BYTE_ENTRY];// gb18030 order

extern U32_GB_ENTRY table_bo_order[MAX_UNICODE32_BMP_GB18030_4_BYTE_ENTRY];// both order


//unicode32转换为gb18030，gb_code可能是1，2，4字节表示,函数返回值是对应的字节数
int unicode32_gb(unsigned int u_code, unsigned int *gb_code);
int gb_unicode32(unsigned int gb_code, unsigned int *u_code);

//unicode 和 utf8 之间的转换
//输入、输出的unicode范围是0-0x10FFFF，utf8_char_array 是1-4字节
int unicode32_to_utf8(unsigned int unicode, unsigned char *utf8_char_array);
int utf8_to_unicode32(const unsigned char *utf8_char_array, unsigned int *unicode);


int __put_int_bytes_to_char_buf(unsigned int v,unsigned int bytes_in_v, unsigned char *char_buf,unsigned int char_buf_pos, unsigned int char_buf_size);

int string_unicode32_to_gb(const unsigned int *u, unsigned int u_size, unsigned char * g, unsigned int g_size);
int string_gb_to_unicode32(const unsigned char *g, int g_size, unsigned int *u, int u_size);


int string_unicode32_to_utf8(const unsigned int *u32, unsigned int u32_size, unsigned char * u8, unsigned int u8_size);
int string_utf8_to_unicode32(const unsigned char * u8, unsigned int u8_size, unsigned int *u32, unsigned int u32_size);



#endif