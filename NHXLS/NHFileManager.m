//
//  NHFileManager.m
//  NHXLSDemo
//
//  Created by neghao on 2018/3/19.
//  Copyright © 2018年 neghao. All rights reserved.
//

#import "NHFileManager.h"

@implementation NHFileModel

- (NSData *)data {
    
    if (_data) {
        return _data;
    }
    
    if (_savePath) {
        return [[NSData alloc] initWithContentsOfFile:_savePath];
    }
    
    return [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:_savePath]];
}

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
    
    NSString *suffixPath = [NSString stringWithFormat:@"/%@/",directory];
    if (fileName && extension) {
         suffixPath = [NSString stringWithFormat:@"/%@/%@%@",directory,fileName,extension];
    }
    
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:suffixPath];
    
#if TARGET_IPHONE_SIMULATOR  //模拟器
//    char *username = getlogin();
//    savePath = [NSString stringWithFormat:@"/Users/%s/Desktop/xls/%@%@",username,fileName,extension];
    NSLog(@"模拟器");
#endif
    
    return savePath;
}

- (NHFileModel *)createFileAtPath:(NSSearchPathDirectory)path
                         fileName:(NSString *)fileName
                        extension:(NSString *)extension
                         contents:(NSData *)data {
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *savePath = getDirectoryPath(path, fileName,extension);
    
    if (data) {
        [fileManager createFileAtPath:savePath contents:data attributes:nil];
    } else {
#if TARGET_IPHONE_SIMULATOR  //模拟器
//        [fileManager createFileAtPath:savePath contents:data attributes:nil];
#endif
    }
    
    NHFileModel *fileModel;
    
    if (savePath) {
        fileModel = [[NHFileModel alloc] init];
        fileModel.url = [NSURL fileURLWithPath:savePath isDirectory:YES];;
        fileModel.data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:savePath]];
        fileModel.name = fileName;
        fileModel.savePath = savePath;
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

- (void)loadFileWithFileModel:(NHFileModel *)fileModel completion:(void (^)(NHFileModel *, NSError *))completion {
    
}

- (BOOL)removeAllXLSFiles {
    
    NSString *suffixPath = [NSString stringWithFormat:@"/Documents"];
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:suffixPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *direnum = [fileManager enumeratorAtPath:savePath];
    NSError *error;
    
    while ([direnum nextObject]) {
        @autoreleasepool {
            NSString *filename = [direnum nextObject];
            if ([[filename pathExtension] isEqualToString:@"xls"]) {
                NSString *filePath = [NSString stringWithFormat:@"%@/%@",savePath,filename];
                [fileManager removeItemAtPath:filePath error:&error];
            }
        }
    }
    
    if (error) {
        return NO;
    }
    
    return YES;
}

- (BOOL)removeXLSFileWithFilePath:(NSSearchPathDirectory)path fileName:(NSString *)fileName {
    
    NSString *directory = nil;
    if (path == NSDocumentDirectory) {
        directory = @"Documents";
    } else if (path == NSLibraryDirectory) {
        directory = @"Library";
    } else if (path == NSCachesDirectory) {
        directory = @"Caches";
    }
    
    NSString *suffixPath = [NSString stringWithFormat:@"/%@/%@",directory,fileName];
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:suffixPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL result = [fileManager removeItemAtPath:savePath error:&error];
    
    return result;
}


@end
