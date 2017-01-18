 //
//  PwdEdite.m
//  MiningCircle
//
//  Created by zhanglily on 15/9/1.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "PwdEdite.h"
#include "Encrypt.h"
#include "base64.h"
@implementation PwdEdite
+(NSDictionary *)ecoding:(NSDictionary *)params
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil ];
    NSDictionary *baseDict = [[NSMutableDictionary alloc]init];
    if(data != nil)
    {
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        const char *pData = [str UTF8String];
        int len = (int)strlen((const char *)pData);
        unsigned char *pOut = qlmalloc(len*2+20);
        if (pOut != NULL){
            FrameEncrypt((const char *)pData, len, (char *)pOut);
            NSString *baseStr = [NSString stringWithCString:(const char *)pOut encoding:NSUTF8StringEncoding];
            baseDict = [NSDictionary dictionaryWithObjectsAndKeys:baseStr,@"e", nil];
            free(pOut);
            return baseDict;
        }
        return baseDict;
        

    }
    else
    {
        return baseDict;
    }
}

+(NSDictionary *)decoding:(NSDictionary *)params
{
    NSDictionary *dic = [[NSMutableDictionary alloc] init];
    NSArray *keyArr = [params allKeys];
    NSString *aaa = [keyArr firstObject];
    if([aaa isEqualToString:@"e"])
    {
    NSString *paramesStr = [params objectForKey:@"e"];
    const char *pData = [paramesStr UTF8String];
    
    
    int len = (int)strlen((const char *)pData);
    if (len <= 0)
        return dic;
    unsigned char *pOutBase64 = qlmalloc(len*2+20);
    if (pOutBase64 == NULL)
        return dic;
    int lenDec = base64_decode(pData, pOutBase64);
    unsigned char *pOut2 = qlmalloc(lenDec*2+20);
    if (pOut2 == NULL)
        return dic;
    char *pRes = (char *)FrameDecrypt((const char*)pOutBase64, lenDec, (char *)pOut2);
    if (pRes != NULL){
        NSString *str1 = [NSString stringWithUTF8String:pRes];
        NSData *jsonData = [str1 dataUsingEncoding:NSUTF8StringEncoding];
        if(jsonData != nil)
        {
            dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                  options:NSJSONReadingMutableContainers
                                                    error:nil];
            
        }
    }
    free(pOut2);
    free(pOutBase64);
    return dic;
    }
    else
    {
        return dic;
    }
    
}
@end

