//
//  BookCell.m
//  BookBrowser
//
//  Created by Sebastián Varela on 15/02/14.
//  Copyright (c) 2014 Sebastián Varela. All rights reserved.
//

#import "BookCell.h"

@interface BookCell ()
@property (weak, nonatomic) IBOutlet UIButton *coverImageButton;
@end

@implementation BookCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setCoverImage:(UIImage *)coverImage
{
	[self.coverImageButton setImage:coverImage forState:UIControlStateNormal];
}

@end
