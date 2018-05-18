//
//  NHFileManager.m
//  NHXLSDemo
//
//  Created by neghao on 2018/3/19.
//  Copyright © 2018年 neghao. All rights reserved.
//

#import "NHFileManager.h"

@implementation NHFileModel

@end


@implementation NHFileManager

NSString *getDirectoryPath(NSSearchPathDirectory path, NSString *fileName,NSString *extension) {

         NSString *directory = nil;
    if (path == NSDocumentDirectory) {
        directory = @"Documents";
    } else if (path == NSLibraryDirectory) {
        directory = @"Library";
    } else if (path == NSCachesDirectory) {
        directory = @"Caches";
    }
    
    NSString *suffixPath = [NSString stringWithFormat:@"/%@/%@%@",directory,fileName,extension];
    
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:suffixPath];
    
#if TARGET_IPHONE_SIMULATOR  //模拟器
    char *username = getlogin();
    savePath = [NSString stringWithFormat:@"/Users/%s/Desktop/xls/%@%@",username,fileName,extension];
#endif
    
    return savePath;
}


- (NHFileModel *)createFileAtPath:(NSSearchPathDirectory)path
                         fileName:(NSString *)fileName
                        extension:(NSString *)extension
                         contents:(NSData *)data {
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *savePath = getDirectoryPath(path,fileName,extension);
    
    BOOL saveSuccess = [fileManager createFileAtPath:savePath contents:data attributes:nil];
    
    NHFileModel *fileModel;
    
    if (saveSuccess) {
        fileModel = [[NHFileModel alloc] init];
        fileModel.url = [NSURL URLWithString:savePath];
        fileModel.data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:savePath]];
        fileModel.name = fileName;
        fileModel.extension = extension;
    }
    
    return fileModel;
}


- (void)loadFileSearchPath:(NSSearchPathDirectory)path
                  fileName:(NSString *)fileName
                 extension:(NSString *)extension
                completion:(void (^)(NHFileModel *fileModel, NSError *error))completion {
    
    NSError *loadError;

    NSString *loadPath = getDirectoryPath(path, fileName, extension);
    NSURL *url = [[NSURL alloc] initFileURLWithPath:loadPath isDirectory:YES];
    NSString *content = [NSString stringWithContentsOfFile:loadPath encoding:NSUTF8StringEncoding error:&loadError];
    
    NHFileModel *fileModel = [[NHFileModel alloc] init];
    fileModel.url = url;
    fileModel.data = [[NSData alloc] initWithContentsOfURL:url];
    fileModel.content = content;
    fileModel.name = fileName;
    fileModel.extension = extension;
    fileModel.savePath = loadPath;
    
    if (completion) {
        completion(fileModel, loadError);
    }
}


@end
