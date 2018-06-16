//
//  NHFileManager.h
//  NHXLSDemo
//
//  Created by neghao on 2018/3/19.
//  Copyright © 2018年 neghao. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NHFileModel : NSObject
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *extension;
@property (nonatomic, copy) NSString *savePath;
//@property (nonatomic, copy) NSError *error;

@end

@interface NHFileManager : NSObject


/**
 创建文件

 @param path 主目录
 @param fileName 文件名
 @param extension 后缀
 @param data 文件数据
 @return 成功则返回 NHFileModel ，否则为空
 */
- (NHFileModel *)createFileAtPath:(NSSearchPathDirectory)path
                         fileName:(NSString *)fileName
                        extension:(NSString *)extension
                         contents:(nullable NSData *)data;



/**
 加载文件
 
 @param path 加载的主目录：目前只支持：NSDocumentDirectory NSLibraryDirectory NSCachesDirectory
 @param fileName 文件名
 @param extension 文件后缀，不需要加.
 @param completion 加载完成回调
 */
- (void)loadFileSearchPath:(NSSearchPathDirectory)path
                  fileName:(NSString *)fileName
                 extension:(NSString *)extension
                completion:(void (^_Nullable)(NHFileModel *fileModel, NSError *error))completion;

- (void)loadFileWithFileModel:(NHFileModel *)fileModel
                   completion:(void (^)(NHFileModel *fileModel, NSError *error))completion;

- (BOOL)removeAllXLSFiles;

- (BOOL)removeXLSFileWithFilePath:(NSSearchPathDirectory)path fileName:(NSString *)fileName;



@end

