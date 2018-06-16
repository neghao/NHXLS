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
@property (nonatomic, copy)NSArray<NSArray *> *tableContents;
@property (nonatomic, copy)NSString *xlsFilePath;
@property (nonatomic, assign) NSSearchPathDirectory searchPath;
@property (nonatomic, copy)NSString *xlsFileName;
@property (nonatomic, copy) void(^operateComplete)(BOOL saveSuccess, NHFileModel *model);
@end

@implementation NHXLS

+ (NHXLS *)createXLSWithRowContents:(NSArray <NSArray *>*)tableContents
                         searchPath:(NSSearchPathDirectory)searchPath
                           fileName:(NSString *)fileName
                    operateComplete:(void(^)(BOOL saveSuccess, NHFileModel *model))operateComplete {
    
    NHXLS *xls = [[NHXLS alloc] init];
    xls.tableContents = tableContents;
    xls.searchPath = searchPath;
    xls.operateComplete = operateComplete;
    xls.xlsFileName = fileName;
    
    xls.fileManager = [[NHFileManager alloc] init];
    
    if (!xls.xlsFileName) {
        xls.xlsFileName = [xls getDateTimeTOMilliSeconds];
    }
    
//    [xls createXLSFile];
    [xls createXlsLib];
    return xls;
}

//- (NSString *)getSavePath {
//    NSString *suffixPath = [NSString stringWithFormat:@"/Documents/%@.xls",_xlsFileName];
//    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:suffixPath];
//    if (_xlsFilePath == nil) {
//        _xlsFilePath = savePath;
//    }
//    return _xlsFilePath;
//}

- (void)createXlsLib {
    

    DHCell *cell;
  
    DHWorkBook *dhWB = [DHWorkBook new];
    DHWorkSheet *dhWS = [dhWB workSheetWithName:_xlsFileName];
       
    //    [dhWS width:10000 col:0 format:NULL];
    //    [dhWS merge:(NSRect){{10, 10}, {3, 3} }];
    //    NSData *now = [NSDate date];
    //    NSDate *then = [NSDate dateWithString:@"1899-01-01 12:00:00 +0000").
    //    [dhWS number:3.1415f row:idx col:1 numberFormat:FMT_GENERAL+idx];
    
    
    for(unsigned short idx = 0; idx < _tableContents.count; ++idx) {

        NSArray *rowArr = [_tableContents objectAtIndex:idx];

        for(unsigned short idx2 = 0; idx2 < rowArr.count; ++idx2) {

            NSString *title = [rowArr objectAtIndex:idx2];

            cell = [dhWS label:title row:idx2 col:idx];
            if(idx2 & 1) {
                cell = [dhWS cell:idx2 col:idx];
            }

            [cell vertAlign:VALIGN_CENTER];
            [cell horzAlign:HALIGN_CENTER];
            [cell indent:INDENT_0];
        }
    }

    
    NHFileModel *fileModel = [_fileManager createFileAtPath:NSDocumentDirectory
                                                   fileName:_xlsFileName
                                                  extension:@".xls"
                                                   contents:nil];
    
    int fud = [dhWB writeFile:fileModel.savePath];

    NSLog(@"OK - bye! fud=%d---%@", fud,fileModel.savePath);
    
    if (_operateComplete) {
        if (fileModel) {
            _operateComplete((fud == 0), fileModel);
        } else {
            _operateComplete((fud == 0), fileModel);
        }
    }
    
}



/**
 手机直接生成，微信和QQ上打不开
 */
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
