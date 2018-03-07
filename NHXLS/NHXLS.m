//
//  NHXLS.m
//  NHXLSDemo
//
//  Created by neghao on 2018/3/7.
//  Copyright © 2018年 neghao. All rights reserved.
//

#import "NHXLS.h"
#include <unistd.h>

@interface NHXLS ()
@property (nonatomic, copy)NSArray *tableTitles;
@property (nonatomic, copy)NSArray *tableContents;
@property (nonatomic, copy) void(^operateComplete)(BOOL saveSuccess, NSString *xlsFilePath, NSError* error);
@end

@implementation NHXLS

+ (NHXLS *)createXLSWithTableTitles:(NSArray *)tableTitles
                      tableContents:(NSArray *)tableContents
                           filePath:(NSString *)filePath
                           fileName:(NSString *)fileName
                    operateComplete:(void(^)(BOOL saveSuccess, NSString *xlsFilePath, NSError* error))operateComplete {
    
    NHXLS *xls = [[NHXLS alloc] init];
    xls.tableTitles = tableTitles;
    xls.tableContents = tableContents;
    xls.xlsFilePath = filePath;
    xls.operateComplete = operateComplete;
    xls.xlsFileName = fileName;
    
    [xls createXLSFile];
    
    return xls;
}


- (void)createXLSFile {
    
    NSMutableArray *xlsContentArr = [[NSMutableArray alloc] init];
    [xlsContentArr addObjectsFromArray:_tableTitles];
    [xlsContentArr addObjectsFromArray:_tableContents];
    
    /**
     * 判定单元格内容的个数是否与单元格标题个数保持匹配，否则数据会错乱: -1是除去标题栏本身
     * 但这里判定还不够准确
     */
    if (_tableContents.count % _tableTitles.count != 0) {
        if (_operateComplete) {
            _operateComplete(NO, _xlsFilePath, [NSError errorWithDomain:NSCocoaErrorDomain code:400 userInfo:@{NSLocalizedDescriptionKey : @"单元格标题与单元格内容的个数不匹配！"}]);
        }
        return;
    }
    
    NSString *xlsContentString = [xlsContentArr componentsJoinedByString:@"\t"];
    
    NSMutableString *xlsTempString = [xlsContentString mutableCopy];
    
    NSMutableArray *tableRange = [[NSMutableArray alloc] init];
    
    for (NSInteger k = 0; k < xlsTempString.length; k++) {

        NSRange range = [xlsTempString rangeOfString:@"\t" options:NSBackwardsSearch range:NSMakeRange(k, 1)];
        
        if (range.length == 1) {
            [tableRange addObject:@(range.location)];
        }
    }
    
    for (NSInteger j = 0; j < tableRange.count; j++) {
        if (j > 0) {
            if ((j % _tableTitles.count) == 0) {
                [xlsTempString replaceCharactersInRange:NSMakeRange([[tableRange objectAtIndex:j-1] integerValue], 1) withString:@"\n"];
            }
        }
    }
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSData *fileData = [xlsTempString dataUsingEncoding:NSUTF16StringEncoding];
    
    if (!_xlsFileName) {
        _xlsFileName = [self getDateTimeTOMilliSeconds];
    }
    NSString *suffixPath = [NSString stringWithFormat:@"/Documents/%@.xls",_xlsFileName];
    
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:suffixPath];
    
#ifdef TARGET_IPHONE_SIMULATOR
    char *username = getlogin();
    savePath = [NSString stringWithFormat:@"/Users/%s/Desktop/xls/%@.xls",username,_xlsFileName];;
#endif
    
    if (!_xlsFilePath) {
        _xlsFilePath = savePath;
    }
    
   BOOL saveSuccess = [fileManager createFileAtPath:_xlsFilePath contents:fileData attributes:nil];
    
    if (_operateComplete) {
        if (saveSuccess) {
            _operateComplete(saveSuccess, _xlsFilePath, nil);
        } else {
            _operateComplete(saveSuccess, nil, [NSError errorWithDomain:NSCocoaErrorDomain code:400 userInfo:@{NSLocalizedDescriptionKey : @"创建xls文件失败！"}]);
        }
    }

}

- (NSError *)deleteXLSWithFilePath:(NSString *)filePath {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error;
    
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:&error];
    } else {
       error = [error initWithDomain:NSCocoaErrorDomain code:404 userInfo:@{NSLocalizedDescriptionKey : @"文件路径错误！"}];
    }
    
    return error;
}

- (NSString *)getDateTimeTOMilliSeconds
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    
    long long totalMilliseconds = interval*1000;
    
    return [NSString stringWithFormat:@"%lld",totalMilliseconds];
}

@end
