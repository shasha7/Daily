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
    }
    return self;
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
    RACSubject *subject = [RACSubject subject];
    [subject sendNext:@"点击了订阅按钮"];
    self.subject = subject;
}

- (void)layoutSubviews {
    self.imageView.frame = CGRectMake(10, 10, 100, 60);
    
    self.label.frame = CGRectMake(120, 10, 100, 60);
    
    self.button.frame = CGRectMake(self.contentView.bounds.size.width - 60, 20, 50, 40);
}

@end
