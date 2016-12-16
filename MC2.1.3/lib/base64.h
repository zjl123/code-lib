//
//  base64.h
//  MiningCircle
//
//  Created by zhanglily on 15/8/24.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#ifndef __MiningCircle__base64__
#define __MiningCircle__base64__

#include <stdio.h>

char * base64_encode( const unsigned char * bindata, char * base64, int binlength );
int base64_decode( const char * base64, unsigned char * bindata );
#endif /* defined(__MiningCircle__base64__) */
