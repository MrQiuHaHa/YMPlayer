//
//  YMViewController.m
//  YMPlayer
//
//  Created by qiujr on 04/26/2020.
//  Copyright (c) 2020 qiujr. All rights reserved.
//

#import "YMViewController.h"
#import <YMPlayer/YMWisdomVideoPlayerVC.h>
#import <YMPlayer/YMPhotosBrowseVC.h>

@interface YMViewController ()

@end

@implementation YMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}
- (IBAction)jumpToPlayerPage:(id)sender {
    
    NSArray *videoArr = @[
       [NSURL URLWithString:@"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4"],
       [NSURL URLWithString:@"https://www.apple.com/105/media/us/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/peter/mac-peter-tpl-cc-us-2018_1280x720h.mp4"],
       [NSURL URLWithString:@"https://www.apple.com/105/media/us/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/grimes/mac-grimes-tpl-cc-us-2018_1280x720h.mp4"],
       [NSURL URLWithString:@"http://yamei-adr-oss.iauto360.cn/SOS_N_000000002_20190924_497cf6b6-df6a-44b8-9468-56d4d1b92fa8.mp4"]];
       NSArray *titleArr = @[@"iphone11介绍视频",@"我是第二个视频",@"我是第三个最后的视频",@"车智汇视频"];
    YMWisdomVideoPlayerVC *vc = [[YMWisdomVideoPlayerVC alloc] init];
    vc.assetURLs = videoArr;
    vc.assetTitles = titleArr;
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)jumpToWatchPhotos:(id)sender {
    
    YMPhotosBrowseVC *vc = [[YMPhotosBrowseVC alloc] init];
    vc.imagesArr = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588155491577&di=57daeb2661461e8a1a38e73d745f050a&imgtype=0&src=http%3A%2F%2Fwww.xinmanduo.com%2Fpic%2Fpoop8%2F30231421589.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588155491577&di=91830d7c519fa3952a37ea09ece71c92&imgtype=0&src=http%3A%2F%2F0245.org%2Fuploads%2F20160926%2F201609262202231398.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588155736210&di=8ac84207ce1664f40f7c9c1ad7b24c17&imgtype=0&src=http%3A%2F%2Fjy.sccnn.com%2Fzb_users%2Fupload%2F2017%2F04%2Fremoteimage2_20170414224417_81790.jpeg"];
    vc.currentIndex = 1;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
