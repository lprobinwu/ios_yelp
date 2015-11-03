//
//  BusinessCell.h
//  Yelp
//
//  Created by Robin Wu on 10/30/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpBusiness.h"

@interface BusinessCell : UITableViewCell

@property (nonatomic, strong) YelpBusiness *business;

@end
