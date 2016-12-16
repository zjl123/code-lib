//
//  CRC16.h
//  MiningCircle
//
//  Created by zhanglily on 15/8/24.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#ifndef __MiningCircle__CRC16__
#define __MiningCircle__CRC16__

#include <stdio.h>


int doCRC16(const char *array, int len);

int doCRC16offset(const char *array, int off, int len);

#endif /* defined(__MiningCircle__CRC16__) */
