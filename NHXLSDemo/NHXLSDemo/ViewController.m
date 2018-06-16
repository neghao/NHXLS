//
//  ViewController.m
//  NHXLSDemo
//
//  Created by neghao on 2018/3/7.
//  Copyright © 2018年 neghao. All rights reserved.
//

#import "ViewController.h"
#import "NHXLS.h"



#define kWeakSelf(type)   __weak typeof(type) weak##type = type;


@interface ViewController ()
@property (nonatomic, strong) NHFileModel *fileModel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *creatPath;
@end

@implementation ViewController {
    NHXLS *_nhXls;
    NSString *_filePath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}


- (IBAction)addXLS:(id)sender {
    [_loadingView  startAnimating];
    [self performSelector:@selector(createXLSFile) withObject:nil afterDelay:5];
}

- (IBAction)deleteXLS:(id)sender {
    NSLog(@"删除结果：%@",[_nhXls deleteXLSWithFilePath:_filePath].localizedDescription);
}

- (void)createXLSFile {
    
    //表格标题
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    [titles addObject:@"直播标题"];
    [titles addObject:@"直播详情"];
    [titles addObject:@"直播时间"];
    [titles addObject:@"发起人"];
    [titles addObject:@"直播地址"];
    
    NSMutableArray *tableContents = [[NSMutableArray alloc] init];
    //每列的具体的内容
    for (NSInteger i = 0; i < titles.count; i++) {
        NSMutableArray *contents = [[NSMutableArray alloc] init];
        [contents addObject:titles[i]];
        
            for (NSInteger n = 0; n < 10; n++) {
                NSString *index = [NSString stringWithFormat:@"%ld",n];
                
                switch (i) {
                    case 0://第一列
                        [contents addObject:[NSString stringWithFormat:@"来一场说开就开的直播%@",index]];
                        break;
                        
                    case 1://第二列
                        [contents addObject:[NSString stringWithFormat:@"2018的发展趋势%@",index]];
                        break;
                        
                    case 2://第三列
                        [contents addObject:[NSString stringWithFormat:@"2018-03-08"]];
                        break;
                        
                    case 3://第四列
                        [contents addObject:[NSString stringWithFormat:@"梦网%@号",index]];
                        break;
                        
                    case 4://第五列
                        [contents addObject:[NSString stringWithFormat:@"深圳市龙泰利科技大厦%@号",index]];
                        break;
                    default:
                        break;
                }
            }
        [tableContents addObject:contents];
    }
 
    kWeakSelf(self);

    
    _nhXls = [NHXLS createXLSWithRowContents:tableContents
                                  searchPath:NSDocumentDirectory
                                    fileName:@"xls导出"
                             operateComplete:^(BOOL saveSuccess, NHFileModel *model)
              {
                  weakself.fileModel = model;
                  NSLog(@"生成结果：%d---%@",saveSuccess,model.savePath);
                  weakself.creatPath.text = [NSString stringWithFormat:@"生成成功：%@",model.savePath];
                  [weakself.loadingView stopAnimating];
              }];

}

- (IBAction)openSystemShare:(UIBarButtonItem *)sender {
    [self openSystemShare:[UIImage imageNamed:@""] fileModel:_fileModel];
}

- (void)openSystemShare:(UIImage *)image fileModel:(NHFileModel *)fileModel {
    kWeakSelf(self);
    if (fileModel.url && fileModel.name && fileModel.data) {
        
    NSArray *items = @[ fileModel.url, fileModel.name, fileModel.data];

    NHSystemShare *systemShare = [[NHSystemShare alloc] initWithContentItems:items];
    
    [systemShare setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            /** 注意这个分享结果成功与失败没有什么参考意义，
                因为系统只判定你是点击跳转了，一起你跳转后是否分享它都不管了
             */
            NSLog(@"分享完成");
        }
        NSLog(@"activityType:%@ \nreturnedItems:%@ \nactivityError%@",activityType,returnedItems,activityError.localizedDescription);
    }];
    
    [systemShare presentShareControllerWithController:weakself animated:YES completion:nil];
    }
}

@end
