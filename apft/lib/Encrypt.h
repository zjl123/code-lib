//
//  Encrypt.h
//  MiningCircle
//
//  Created by zhanglily on 15/8/24.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#ifndef __MiningCircle__Encrypt__
#define __MiningCircle__Encrypt__

#include <stdio.h>

unsigned char * Encrypt(unsigned char *pData, int uKey, int off, int len);
char * FrameEncrypt(const char *pData, int len, char *pOut);
char * FrameDecrypt(const char *pData, int len, char *pOut);
void *qlmalloc(size_t size);
#endif /* defined(__MiningCircle__Encrypt__) */
