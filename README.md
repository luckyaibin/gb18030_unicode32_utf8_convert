# gb18030_unicode32_utf8_convert

对本代码的使用没有任何限制，你可以任意复制，修改，传播

gb18030互转unicode32，unicode32互转utf8编码（使用lua生成需要查询的数据表）

0. 因为gbk编码转utf8只有使用其他系统的库（windows下MultiByteToWideChar\WideCharToMultiByte),或者是其他庞大的库，因此自己造一个小轮子
1. 没有经过严格测试，仅仅是可以正常转换
2. 对于gb18030对应到unicodePUA部分可能导致一些gbk字符转码不正常（很少）
3. 一些unicode32和gb18030的标准看lua_generate_gb_unicode_table\gbk_unicode.lua里的注释和提到的链接
4. data.cpp里的数据是“压缩”过的：
  xxxx  yyyy Len 表示:
  
  xxxx    ->  yyyy
  xxxx+1  ->  yyyy+1
  xxxx+2  ->  yyyy+2
  ......
  xxxx+Len-1  ->  yyyy+Len-1

  就是从xxx->yyyy起，有Len个数据是递增且一一对应的，这样子就不行也要存储接下来的那些数据
5. 查询部分使用的是二分查找，对于 xxxx yyyy Len 这种表示法，要注意判断范围
