//
//  AvalCell.h
//  FDC
//
//  Created by Felipe Ricieri on 15/10/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "KDViewController.h"

@interface AvalCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *labTitle;
@property (nonatomic, strong) IBOutlet UILabel *labSubtitle;
@property (nonatomic, strong) IBOutlet UILabel *labLabel;
@property (nonatomic, strong) IBOutlet UILabel *labValue;

@property (nonatomic, strong) IBOutlet UIImageView *imgArrow;
@property (nonatomic, strong) IBOutlet UIImageView *imgTick;
@property (nonatomic, strong) IBOutlet UIImageView *imgBall;

@end
