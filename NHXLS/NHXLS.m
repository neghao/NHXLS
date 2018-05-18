//
//  NHXLS.m
//  NHXLSDemo
//
//  Created by neghao on 2018/3/7.
//  Copyright © 2018年 neghao. All rights reserved.
//

#import "NHXLS.h"
#include <unistd.h>
#import "DHWorkBook.h"


@interface NHXLS ()
@property (nonatomic, strong) NHFileManager *fileManager;
@property (nonatomic, copy)NSArray *tableTitles;
@property (nonatomic, copy)NSArray *tableContents;
@property (nonatomic, copy)NSString *xlsFilePath;
@property (nonatomic, assign) NSSearchPathDirectory searchPath;
@property (nonatomic, copy)NSString *xlsFileName;
@property (nonatomic, copy) void(^operateComplete)(BOOL saveSuccess, NHFileModel *model);
@end

@implementation NHXLS

+ (NHXLS *)createXLSWithTableTitles:(NSArray *)tableTitles
                      tableContents:(NSArray *)tableContents
                         searchPath:(NSSearchPathDirectory)searchPath
                           fileName:(NSString *)fileName
                    operateComplete:(void(^)(BOOL saveSuccess, NHFileModel *model))operateComplete {
    
    NHXLS *xls = [[NHXLS alloc] init];
    xls.tableTitles = tableTitles;
    xls.tableContents = tableContents;
    xls.searchPath = searchPath;
    xls.operateComplete = operateComplete;
    xls.xlsFileName = fileName;
    
    xls.fileManager = [[NHFileManager alloc] init];
    
    if (!xls.xlsFileName) {
        xls.xlsFileName = [xls getDateTimeTOMilliSeconds];
    }
    
    [xls createXlsLib];
    
    return xls;
}

- (NSString *)getSavePath {
    NSString *suffixPath = [NSString stringWithFormat:@"/Documents/%@.xls",_xlsFileName];
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:suffixPath];
    if (_xlsFilePath == nil) {
        _xlsFilePath = savePath;
    }
    return _xlsFilePath;
}

- (void)createXlsLib {
    
    DHCell *cell;
    DHWorkBook *dhWB = [DHWorkBook new];
    DHWorkSheet *dhWS = [dhWB workSheetWithName:_xlsFileName];
    
    //    [dhWS width:10000 col:0 format:NULL];
    for(unsigned short idx=0; idx<_tableContents.count; ++idx) {
        cell = [dhWS label:[NSString stringWithFormat:@"Row %d", idx+1] row:idx col:0];
        if(idx & 1) {
            // prove we can get the cell reference later
//            cell = [dhWS cell:idx col:0];
        }
        [cell horzAlign:HALIGN_LEFT];
//        [cell indent:INDENT_0+idx];
    }
    //    [dhWS merge:(NSRect){{10, 10}, {3, 3} }];
    //    NSData *now = [NSDate date];
    //    NSDate *then = [NSDate dateWithString:@"1899-01-01 12:00:00 +0000").
    
//    for(unsigned short idx=0; idx<10; ++idx) {
//        [dhWS number:3.1415f row:idx col:1 numberFormat:FMT_GENERAL+idx];
//    }
//
//    [dhWS width:10000 col:2 format:NULL];
//    for(unsigned short idx=0; idx<7; ++idx) {
//        cell = [dhWS label:@"Hello World" row:idx col:2];
//        [cell horzAlign:HALIGN_GENERAL+idx];
//    }
//
//    [dhWS width:0xFFFF col:3 format:NULL];
//    for(unsigned short idx=0; idx<4; ++idx) {
//        [dhWS height:24 row:idx format:NULL];
//        cell = [dhWS label:@"Hello World" row:idx col:3];
//        [cell vertAlign:VALIGN_TOP+idx];
//    }
    
    
    int fud = [dhWB writeFile:[self getSavePath]];
    
    NSLog(@"OK - bye! fud=%d---%@", fud,NSHomeDirectory());
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
            _operateComplete(NO, nil);
            NSLog(@"%s\n单元格标题与单元格内容的个数不匹配！",__func__);
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
    
    NSData *fileData = [xlsTempString dataUsingEncoding:NSUTF8StringEncoding];
    
    NHFileModel *fileModel = [_fileManager createFileAtPath:_searchPath fileName:_xlsFileName extension:@".xls" contents:fileData];
    
    if (_operateComplete) {
        if (fileModel) {
            _operateComplete(YES, fileModel);
        } else {
            _operateComplete(NO, fileModel);
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
