#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "dictionary.h"
#include <iostream>
#include <fstream>

void test_unicode32_gb()
{
	long long total_num = 0;
	long long not_exist_num = 0;
	for (unsigned int i = 0x0; i < 0xFFFF; i++)
	{
		unsigned int gb = 0;
		unsigned int u = 0;
		int gb_byte = unicode32_gb(i, &gb);
		if (-1 == gb_byte)
		{
			printf("stop %0x(%d).\n", i, i);
			not_exist_num = not_exist_num + 1;
		}
		else
		{
			gb_unicode32(gb, &u);
			if (u != i)
			{
				printf("stop %0x(%d).\n", i, i);
			}
			else
			{
				total_num = total_num + 1;
				//printf("gb:%0x,u:%0x == i:%0x(%d) \n", gb, u, i, i);
			}
			
		}
			
	}
	printf("num:%d\n", total_num);
}


void test_string_unicode32_and_gb()
{
	char * in_gb = "aabcv我是中国人。。a..";

	int unicode32_buff_size = string_gb_to_unicode32((unsigned char*)in_gb, strlen(in_gb), NULL, 0);
	int gb18030_buf_size = 0;
	unsigned int *UTF32_buff = NULL;
	unsigned char *GB18030_buff = NULL;
	if (unicode32_buff_size > 0)
	{
		UTF32_buff = new unsigned int[unicode32_buff_size];
		string_gb_to_unicode32((unsigned char*)in_gb, strlen(in_gb), UTF32_buff, unicode32_buff_size);

		gb18030_buf_size = string_unicode32_to_gb(UTF32_buff, unicode32_buff_size, NULL, 0);
		if (gb18030_buf_size > 0)
		{
			GB18030_buff = new unsigned char[gb18030_buf_size+1];
			GB18030_buff[gb18030_buf_size] = 0;

			string_unicode32_to_gb(UTF32_buff, unicode32_buff_size, GB18030_buff, gb18030_buf_size);
		}
	}
}

//没有管内存释放
void test_string_unicode32_and_utf8()
{
	//read gb file data
	FILE *fp_gb = fopen("my_gb_file.txt", "rb");
	if (!fp_gb)
	{
		return;
	}
	fseek(fp_gb, 0, SEEK_END);
	unsigned int fp_gb_size = ftell(fp_gb);
	fseek(fp_gb, 0, SEEK_SET);
	char * in_gb = new char[fp_gb_size];
	fread(in_gb, sizeof(char), fp_gb_size, fp_gb);
	

	////////////gb -> u32
	int unicode32_buff_size = string_gb_to_unicode32((unsigned char*)in_gb, fp_gb_size, NULL, 0);
	int gb18030_buf_size = 0;
	unsigned int *UTF32_buff = NULL;
	unsigned char *GB18030_buff = NULL;
	UTF32_buff = new unsigned int[unicode32_buff_size];
	string_gb_to_unicode32((unsigned char*)in_gb, fp_gb_size, UTF32_buff, unicode32_buff_size);

	delete (in_gb);

	////////////u32 -> u8
	int utf8_buf_size = string_unicode32_to_utf8(UTF32_buff, unicode32_buff_size, NULL, 0);
 
	unsigned char *utf8_buff = new unsigned char[utf8_buf_size+1];
	
	string_unicode32_to_utf8(UTF32_buff, unicode32_buff_size, utf8_buff, utf8_buf_size);
	//写入文件
	FILE *fp = fopen("my_utf8_file.txt", "wb");
	if (fp)
	{
		fwrite(utf8_buff,sizeof(unsigned char), utf8_buf_size, fp);
		fclose(fp);
	}

	///////////u8 -> u32
	unicode32_buff_size = string_utf8_to_unicode32(utf8_buff, utf8_buf_size, NULL, 0);
	UTF32_buff = new unsigned int[unicode32_buff_size];
	string_utf8_to_unicode32(utf8_buff, utf8_buf_size, UTF32_buff, unicode32_buff_size);

	delete utf8_buff;
	/////////u32->gb
	gb18030_buf_size = string_unicode32_to_gb(UTF32_buff, unicode32_buff_size, NULL, 0);
	 
	GB18030_buff = new unsigned char[gb18030_buf_size + 1];
	GB18030_buff[gb18030_buf_size] = 0;
	string_unicode32_to_gb(UTF32_buff, unicode32_buff_size, GB18030_buff, gb18030_buf_size);
	delete UTF32_buff;
	delete GB18030_buff;
	 
}
int main()
{
	//test_string_unicode32_and_gb();
	test_string_unicode32_and_utf8();
	//test_unicode32_gb();
	return 0;
}