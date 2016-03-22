#ifndef __DICTIONARY_H__
#define __DICTIONARY_H__

//unicode32��gb18030��ӳ����õ�
typedef struct unicode_gb18030_entry
{
	unsigned int u_code;
	unsigned int gb_code;
	unsigned char num;
}U32_GB_ENTRY;

//ĳ��ֵλ��ĳ����Χ
#define VALUE_BETWEEN(low_range,value,high_range)  (((low_range)<=(value)) && ((value)<=(high_range)))

//����char���ɵ�unsigned short
#define CHAR_TO_USHORT(c1,c2)  (( (c1&0xFFU) << 8 ) | (c2&0xFFU))
//��ȡunsigned short �ĸ��ֽ�
#define USHORT_HI(s) ((s>>8)&0xFFU)
//��ȡunsigned short �ĵ��ֽ�
#define USHORT_LO(s) ((s)&0xFFU)


//�ĸ�char���ɵ�unsigned short
#define CHAR_TO_UINT(c1,c2,c3,c4)  ( ((c1&0xFFU) << 24) |  ((c2&0xFFU) << 16) | ((c3&0xFFU) << 8) | (c4&0xFFU) )//ĳ��ֵλ��ĳ����Χ
#define VALUE_BETWEEN(low_range,value,high_range)  (((low_range)<=(value)) && ((value)<=(high_range)))

//����char���ɵ�unsigned short
#define CHAR_TO_USHORT(c1,c2)  (( (c1&0xFFU) << 8 ) | (c2&0xFFU))
//��ȡunsigned short �ĸ��ֽ�
#define USHORT_HI(s) ((s>>8)&0xFFU)
//��ȡunsigned short �ĵ��ֽ�
#define USHORT_LO(s) ((s)&0xFFU)


//�ĸ�char���ɵ�unsigned short
#define CHAR_TO_UINT(c1,c2,c3,c4)  ( ((c1&0xFFU) << 24) |  ((c2&0xFFU) << 16) | ((c3&0xFFU) << 8) | (c4&0xFFU) )

//unicode BMP��0-0xFFFF)��gb18030��ӳ�䣬�������֣�һ����ӳ�䵽2�ֽڵ�gb��һ������4�Լ���gb
const static int MAX_UNICODE32_BMP_GB18030_2_BYTE_ENTRY = 10470;
const static int MAX_UNICODE32_BMP_GB18030_4_BYTE_ENTRY = 4126;


/*���涨����3�����ݱ��
a. unicode ��  2�ֽڵ�gbӳ�䲿����Ҫ������񣬷ֱ���
	����unicode �����	-> ���1
	���� gb ����		-> ���2
b. unicode �� 4�ֽڵ�gbӳ�䲿�֣���Ҫһ�����
	��Ϊ�������ǵ�����һһӳ�䣬����ֻ��Ҫһ�����	-> ���3
*/

extern U32_GB_ENTRY table_un_order[MAX_UNICODE32_BMP_GB18030_2_BYTE_ENTRY];// unicode order
extern U32_GB_ENTRY table_gb_order[MAX_UNICODE32_BMP_GB18030_2_BYTE_ENTRY];// gb18030 order

extern U32_GB_ENTRY table_bo_order[MAX_UNICODE32_BMP_GB18030_4_BYTE_ENTRY];// both order


//unicode32ת��Ϊgb18030��gb_code������1��2��4�ֽڱ�ʾ,��������ֵ�Ƕ�Ӧ���ֽ���
int unicode32_gb(unsigned int u_code, unsigned int *gb_code);
int gb_unicode32(unsigned int gb_code, unsigned int *u_code);

//unicode �� utf8 ֮���ת��
//���롢�����unicode��Χ��0-0x10FFFF��utf8_char_array ��1-4�ֽ�
int unicode32_to_utf8(unsigned int unicode, unsigned char *utf8_char_array);
int utf8_to_unicode32(const unsigned char *utf8_char_array, unsigned int *unicode);


int __put_int_bytes_to_char_buf(unsigned int v,unsigned int bytes_in_v, unsigned char *char_buf,unsigned int char_buf_pos, unsigned int char_buf_size);

int string_unicode32_to_gb(const unsigned int *u, unsigned int u_size, unsigned char * g, unsigned int g_size);
int string_gb_to_unicode32(const unsigned char *g, int g_size, unsigned int *u, int u_size);


int string_unicode32_to_utf8(const unsigned int *u32, unsigned int u32_size, unsigned char * u8, unsigned int u8_size);
int string_utf8_to_unicode32(const unsigned char * u8, unsigned int u8_size, unsigned int *u32, unsigned int u32_size);



#endif