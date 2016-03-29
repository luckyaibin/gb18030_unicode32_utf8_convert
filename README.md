# gb18030_unicode32_utf8_convert

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

| 0-0x7f          | 0x80-0xFFFF(unicode 的 BMP,Basic Multilingual Plane,plane0)     | 0x10000 - 0x10ffff                             |
|-----------------+-----------------------------------------------------------------+------------------------------------------------|
| ascii码，和gb的 | 有些映射gb的2字节，有些映射gb的4字节                            | 全部映射gb18030 的 4字节                       |
| 1字节编码一一   | 需要查表。                                                      | 这对应unicode标志的plane1-plane16 只需要做计算 |
| 对应            | 1. 对于unicode16和gb 2字节映射 部分，是没有规律的               |                                                |
|                 | （gbk很早就出来了）,顺序 也是乱的，所以针对gb转unicode32        |                                                |
|                 | 和unicode32转gb，各需要一个表                                   |                                                |
|                 | 2. 对于unicode16和gb 4字节映射部分，两者都是递增的一一映射      |                                                |
|                 | 所以不管gb->unicode32还是unicode32->gb，都只需要查同一个表      |                                                |
|-----------------+-----------------------------------------------------------------+------------------------------------------------|
|                 | BMP定义了52080个字符，其中包括27973个汉字                       | plane1定义了3419个字符，                       |
|                 |                                                                 | plane2定义了43253个字符（/全部是汉字/）        |
|                 |                                                                 | plane14上定义了337个字符                       |
|-----------------+-----------------------------------------------------------------+------------------------------------------------|
|                 | 1. 对于gb2字节编码：高位字节:0x81-0xFE,                         | GB18030用码位 0x90308130 ~ 0xE339FE39 共       |
|                 | 低位字节 0x40 <---- (不包括0x7F) ----> 0xFE                     | 1058400 个码位映射Unicode 16个辅助平面         |
|                 |                                                                 | （平面1到平面16）的65536*16=1048576个码位。    |
|                 | 2. 对于gb4字节编码，它的编码空间是:                             |                                                |
|                 | 第一字节在0x81~0xFE之间                                         |                                                |
|                 | 第二字节在0x30~0x39之间                                         |                                                |
|                 | 第三字节在0x81~0xFE之间                                         |                                                |
|                 | 第四字节在0x30~0x39之间,一共是 1587600 个码位                   |                                                |
|                 | 而BMP(plane0)只对应了1587600的一小部分(BMP是65535个码位,        |                                                |
|                 | 代理区（0xD800-0xDFFF）占了2048个码位，gb单字节映射了128个码位, |                                                |
|                 | 双字节映射了23940个，还剩下65535-128-2048-24940=39420个码位,    |                                                |
|                 | 这就是 gb4字节映射的字符数)                                     |                                                |
