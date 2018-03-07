//
//  NHXLS.h
//  NHXLSDemo
//
//  Created by neghao on 2018/3/7.
//  Copyright © 2018年 neghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NHXLS : NSObject

/**
 单元格的标题，数组内的每一个元素即为一个标题，从左至右排序
 */
@property (nonatomic, copy, readonly)NSArray *tableTitles;

/**
 单元格的内容，数组内的每一个元素即为一项目内容，从左至右排序
 */
@property (nonatomic, copy, readonly)NSArray *tableContents;

/**
 文件保存路径，默认在`Documents`目录下
 */
@property (nonatomic, copy)NSString *xlsFilePath;

/**
 xlf文件名,不传则以当前时间戳为文件名
 */
@property (nonatomic, copy)NSString *xlsFileName;


/**
 创建xls文件

 @param tableTitles 每一个元素即为单元格标题
 @param tableContents 每一个元素即为单元格内容
 @param filePath 保存路径
 @param fileName xlf文件名,不传则以当前时间戳为文件名
 @param operateComplete 操作完成
 */
+ (NHXLS *)createXLSWithTableTitles:(NSArray *)tableTitles
                      tableContents:(NSArray *)tableContents
                           filePath:(NSString *)filePath
                           fileName:(NSString *)fileName
                    operateComplete:(void(^)(BOOL saveSuccess, NSString *xlsFilePath, NSError* error))operateComplete;


/**
 删除xls文件

 @param filePath 文件路径
 @return 删除结果，error为空时则成功
 */
- (NSError *)deleteXLSWithFilePath:(NSString *)filePath;

@end
