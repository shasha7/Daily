//
//  DBBroadcastCell.m
//  DouBan
//
//  Created by 王伟虎 on 2018/4/18.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "DBBroadcastCell.h"
#import "BroadcastCommunityModel.h"
#import "UIImageView+WebCache.h"

@interface DBBroadcastCell ()

@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;

@end

@implementation DBBroadcastCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        // 创建信号
        [self createSignal];
    }
    return self;
}

- (void)createSignal {
    RACSubject *subject = [RACSubject subject];
    self.subject = subject;
}

- (void)setupUI {
    self.picImageView = [[UIImageView alloc] init];
    self.picImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.picImageView];
    
    self.label = [[UILabel alloc] init];
    [self.contentView addSubview:self.label];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.backgroundColor = [UIColor purpleColor];
    [self.button addTarget:self action:@selector(subscribeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.button];
}

- (void)setModel:(BroadcastCommunityModel *)model {
    _model = model;

    self.label.text = model.theme_name;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.image_detail]];
    
    [self.button setTitle:@"订阅" forState:UIControlStateNormal];
}

- (void)subscribeBtnClick:(UIButton *)sender {
    [self.subject sendNext:nil];
}

- (void)layoutSubviews {
    self.imageView.frame = CGRectMake(10, 10, 100, 60);
    
    self.label.frame = CGRectMake(120, 10, 100, 60);
    
    self.button.frame = CGRectMake(self.contentView.bounds.size.width - 60, 20, 50, 40);
}

@end
