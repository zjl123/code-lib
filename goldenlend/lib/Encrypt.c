//
//  Encrypt.c
//  MiningCircle
//
//  Created by zhanglily on 15/8/24.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#include <stdlib.h>
#include <string.h>
#include "Encrypt.h"
#include "base64.h"
#include "CRC16.h"


#define ENCRYPT_VER 0x3d9a32b7
#define QLFG_KEY 0x9a7b5c3d
#define FRAME_HEAD 0xabcd
#define FRAME_HEADEx 0xbcde


/////////////////////
/*
long ntohl(long n)
{
    long lBak = n, lRet = 0;
    
    for (int i = 0; i < 8; i++) {
        lRet = lRet << 8;
        lRet |= lBak & 0xff;
        lBak = lBak >> 8;
    }
    return lRet;
}

int ntohi(int n) {
    int nTmp1 = n, nTmp2 = n, nTmp3 = 0;
    nTmp3 = ( (nTmp1 >> 8) & 0x0000FF00) + ( (nTmp2 >> 24) & 0x000000FF); //16 high bits
    nTmp1 = n;
    nTmp2 = n;
    nTmp3 += ( (nTmp1 << 8) & 0x00FF0000) + ( (nTmp2 << 24) & 0xFF000000); //16 low bits
    return nTmp3;
}

short ntohs(short n) {
    short nTmp1 = n;
    return (short) ( ( (n >> 8) & 0x00FF) | ( (nTmp1 << 8) & 0xFF00));
}
 */
/////////////////////



unsigned char * Encrypt(unsigned char *pData, int uKey, int off, int len)
{
    for(int i=off; i<off+len; i++){
        int nData = ( ~( (uKey*(i-off)) ^ (ENCRYPT_VER/(((i-off)%7+1))) ) );
        
        pData[i] = (unsigned char)(pData[i] ^ nData);
    }
    return pData;
}

/*
 需要生成
 {“e”:pOut} >>>  http post
 */
char * FrameEncrypt(const char *pData, int len, char *pOut){
    
    char * pBuf = qlmalloc(len+10);
    if (pBuf == NULL)
        return NULL;
    memcpy((pBuf+8), pData, len);//len);
    Encrypt((unsigned char *)pBuf+8,QLFG_KEY,0,len);
    
    *((unsigned short *)pBuf) = ntohs(FRAME_HEAD);

    int nCRC16 = doCRC16(pBuf+8, len);
    *((unsigned int *)(pBuf+2)) = ntohl(nCRC16);
    

    *((unsigned short *)(pBuf+6)) = ntohs(len);
    
    base64_encode((unsigned char *)pBuf, pOut, len+8);
    
    free(pBuf);
    
    return pOut;
}

/*
 http <<< json.get("e").toBytes()=pData,  pData.len = len
 pOut 输出 json.cmd
 */
char * FrameDecrypt(const char *pData, int len, char *pOut){
 
    int nFrameHead = 0xffff&ntohs(*((unsigned short *)pData));

    if (nFrameHead != FRAME_HEAD){
        if (nFrameHead != FRAME_HEADEx)
            return  NULL;
    }
    
    int nCRC16 = ntohl(*((unsigned int *)(pData+2)));
    
    int nFrameLen,off = 0;
    if (nFrameHead == FRAME_HEAD){
        nFrameLen = 0xffff&ntohs(*((unsigned short *)(pData+6)));
    }else{
        nFrameLen = ntohl(*((unsigned int *)(pData+6)));
        off=2;
    }
    
    int nCRCData = doCRC16(pData+(8+off), nFrameLen);
    if (nCRCData == nCRC16){
        memcpy(pOut, pData+(8+off), nFrameLen);
        pOut[nFrameLen]=0;

        Encrypt((unsigned char *)pOut,QLFG_KEY,0,nFrameLen);
        return pOut;
    }
    return NULL;
}

void	*qlmalloc(size_t size){
    size = (size+3)/4*4;
    if (size >1024*1024 || size <=0)
        return  NULL;
    return malloc(size);
}



