//
//  HMRefreshBasicView.m
//  HMRefreshTableView
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import "HMRefreshBasicView.h"

@interface HMImageView ()

@property (nonatomic, assign, readwrite) ARROW_DIRECTION direction;

@end

@implementation HMImageView

- (void)changeDirection:(ARROW_DIRECTION)direction {
    if (self.direction == direction) {
        return;
    }
    if (direction == ARROW_DIRECTION_UP) {
        self.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        self.transform = CGAffineTransformMakeRotation(0);
    }
    self.direction = direction;
}

@end

@implementation HMRefreshBasicView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#E0E0E0"];
        
        self.statuSLabel = [[UILabel alloc] init];
        self.statuSLabel.backgroundColor = [UIColor clearColor];
        self.statuSLabel.textAlignment = NSTextAlignmentCenter;
        self.statuSLabel.font = [UIFont systemFontOfSize:12];
        self.statuSLabel.textColor = [UIColor colorWithHexString:@"#7B7B7B"];
        [self addSubview:self.statuSLabel];
        
        self.activityView = [[UIActivityIndicatorView alloc] init];
        self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:self.activityView];
        
        self.arrowImageView = [[HMImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
        self.arrowImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.arrowImageView];
        
        /// layout
        self.statuSLabel.sd_layout
        .centerXEqualToView(self)
        .centerYEqualToView(self)
        .widthIs(200)
        .heightIs(30);
        
        self.activityView.sd_layout
        .leftSpaceToView(self, 25.0f)
        .centerYEqualToView(self)
        .widthIs(30.f)
        .heightIs(30.f);
        
        self.arrowImageView.sd_layout
        .centerXEqualToView(self.activityView)
        .centerYEqualToView(self.activityView)
        .widthIs(15.f)
        .heightIs(30.f);
    }
    return self;
}

- (void)draggingBegan:(UIScrollView *)scrollView {
    
}

- (void)draggingChanged:(UIScrollView *)scrollView {
    
}

- (void)draggingEnded:(UIScrollView *)scrollView {
    
}

- (void)refreshFinishi {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
