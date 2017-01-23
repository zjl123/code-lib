//
//  base64.c
//  MiningCircle
//
//  Created by zhanglily on 15/8/24.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#include "base64.h"
/**
 *  base64编码、解码实现
 *       C语言源代码
 *
 *   注意：请使用gcc编译
 *
 *             叶剑飞
 *
 *
 *
 *  使用说明：
 *      命令行参数说明：若有“-d”参数，则为base64解码，否则为base64编码。
 *                      若有“-o”参数，后接文件名，则输出到标准输出文件。
 *      输入来自标准输入stdin，输出为标准输出stdout。可重定向输入输出流。
 *
 *        base64编码：输入任意二进制流，读取到文件读完了为止（键盘输入则遇到文件结尾符为止）。
 *                    输出纯文本的base64编码。
 *
 *        base64解码：输入纯文本的base64编码，读取到文件读完了为止（键盘输入则遇到文件结尾符为止）。
 *                    输出原来的二进制流。
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdbool.h>
#ifndef byte
#define byte unsigned char
#endif

//void _encodeBase64(unsigned char *in, unsigned char *out)
//{
//    static const unsigned char encodeBase64Map[] =
//    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
//    out[0] = encodeBase64Map[(in[0] >> 2) & 0x3F];
//    out[1] = encodeBase64Map[((in[0] << 4) & 0x30) | ((in[1] >> 4) & 0x0F)];
//    out[2] = encodeBase64Map[((in[1] << 2) & 0x3C) | ((in[2] >> 6) & 0x03)];
//    out[3] = encodeBase64Map[in[2] & 0x3F];
//}


 #ifndef MAX_PATH
 #define MAX_PATH 256
 #endif
 
 const char * base64char = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789~^";
 char * base64_encode( const unsigned char * bindata, char * base64, int binlength )
 {
     int i, j;
     unsigned char current;
     
     for ( i = 0, j = 0 ; i < binlength ; i += 3 )
     {
         current = (bindata[i] >> 2) ;
         current &= (unsigned char)0x3F;
         base64[j++] = base64char[(int)current];
         
         current = ( (unsigned char)(bindata[i] << 4 ) ) & ( (unsigned char)0x30 ) ;
         if ( i + 1 >= binlength )
         {
             base64[j++] = base64char[(int)current];
             base64[j++] = '=';
             base64[j++] = '=';
             break;
         }
         current |= ( (unsigned char)(bindata[i+1] >> 4) ) & ( (unsigned char) 0x0F );
         base64[j++] = base64char[(int)current];
         
         current = ( (unsigned char)(bindata[i+1] << 2) ) & ( (unsigned char)0x3C ) ;
         if ( i + 2 >= binlength )
         {
             base64[j++] = base64char[(int)current];
             base64[j++] = '=';
             break;
         }
         current |= ( (unsigned char)(bindata[i+2] >> 6) ) & ( (unsigned char) 0x03 );
         base64[j++] = base64char[(int)current];
         
         current = ( (unsigned char)bindata[i+2] ) & ( (unsigned char)0x3F ) ;
         base64[j++] = base64char[(int)current];
     }
     base64[j] = '\0';
     return base64;
 }

 int base64_decode( const char * base64, unsigned char * bindata )
 {
     int i, j;
     unsigned char k;
     unsigned char temp[4];
     for ( i = 0, j = 0; base64[i] != '\0' ; i += 4 )
     {
         memset( temp, 0xFF, sizeof(temp) );
     for ( k = 0 ; k < 64 ; k ++ )
     {
     if ( base64char[k] == base64[i] )
         temp[0]= k;
     }
     for ( k = 0 ; k < 64 ; k ++ )
     {
     if ( base64char[k] == base64[i+1] )
         temp[1]= k;
     }
     for ( k = 0 ; k < 64 ; k ++ )
     {
     if ( base64char[k] == base64[i+2] )
         temp[2]= k;
     }
     for ( k = 0 ; k < 64 ; k ++ )
     {
     if ( base64char[k] == base64[i+3] )
         temp[3]= k;
     }
     
     bindata[j++] = ((unsigned char)(((unsigned char)(temp[0] << 2))&0xFC)) |
     ((unsigned char)((unsigned char)(temp[1]>>4)&0x03));
     if ( base64[i+2] == '=' )
     break;
     
     bindata[j++] = ((unsigned char)(((unsigned char)(temp[1] << 4))&0xF0)) |
     ((unsigned char)((unsigned char)(temp[2]>>2)&0x0F));
     if ( base64[i+3] == '=' )
     break;
     
     bindata[j++] = ((unsigned char)(((unsigned char)(temp[2] << 6))&0xF0)) |
     ((unsigned char)(temp[3]&0x3F));
     }
     return j;
 }


