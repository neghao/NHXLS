//
//  ViewController.m
//  NHXLSDemo
//
//  Created by neghao on 2018/3/7.
//  Copyright © 2018年 neghao. All rights reserved.
//

#import "ViewController.h"
#import "NHXLS.h"

@interface ViewController ()

@end

@implementation ViewController {
    NHXLS *_nhXls;
    NSString *_filePath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)addXLS:(id)sender {
    [self createXLSFile];
}

- (IBAction)deleteXLS:(id)sender {
    NSLog(@"删除结果：%@",[_nhXls deleteXLSWithFilePath:_filePath].localizedDescription);
}

- (void)createXLSFile {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    
    [titles addObject:@"直播标题"];
    [titles addObject:@"直播详情"];
    [titles addObject:@"直播时间"];
    [titles addObject:@"发起人"];
    [titles addObject:@"直播地址"];
    
    NSMutableArray *contents = [[NSMutableArray alloc] init];

    for (NSInteger i = 0; i < 10; i++) {
        NSString *index = [NSString stringWithFormat:@"%ld",i];
        [contents addObject:[NSString stringWithFormat:@"来一场说开就开的直播%@",index]];
        [contents addObject:[NSString stringWithFormat:@"2018的发展趋势%@",index]];
        [contents addObject:[NSString stringWithFormat:@"2018-03-08"]];
        [contents addObject:[NSString stringWithFormat:@"梦网%@号",index]];
        [contents addObject:[NSString stringWithFormat:@"深圳市龙泰利科技大厦%@号",index]];
    }
    

    _nhXls = [NHXLS createXLSWithTableTitles:titles.copy
                               tableContents:contents.copy
                                    searchPath:NSDocumentDirectory
                                    fileName:nil
                             operateComplete:^(BOOL saveSuccess, NHFileModel *model) {
        
        _filePath  = model.savePath;
        NSLog(@"生成结果：%d---%@",saveSuccess,model.savePath);
    }];

}

@end
