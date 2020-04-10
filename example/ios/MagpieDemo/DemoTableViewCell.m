//
//  DemoTableViewCell.m
//  MagpieDemo
//
//  Created by 张达理 on 2020/1/10.
//  Copyright © 2020 张达理. All rights reserved.
//

#import "DemoTableViewCell.h"

@implementation DemoTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView * backgroundView = [UIView new];
        backgroundView.frame = CGRectMake(0, 15, [UIScreen mainScreen].bounds.size.width - 40, 70);
        backgroundView.backgroundColor = [UIColor colorWithRed:233.f/255 green:157.f/255 blue:66.f/255 alpha:1];
        backgroundView.layer.masksToBounds = YES;
        backgroundView.layer.cornerRadius = 6;
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.frame = backgroundView.bounds;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:20.f];
        [self.contentView addSubview:backgroundView];
        [backgroundView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
