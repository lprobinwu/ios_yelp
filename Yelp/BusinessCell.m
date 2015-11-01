//
//  BusinessCell.m
//  Yelp
//
//  Created by Robin Wu on 10/30/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"

@implementation BusinessCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    
    self.thumbImageView.layer.cornerRadius = 5;
    self.thumbImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setBusiness:(YelpBusiness *)business {
    _business = business;
    [self.thumbImageView setImageWithURL:self.business.imageUrl];
    self.nameLabel.text = self.business.name;
    [self.ratingImageView setImageWithURL:self.business.ratingImageUrl];
    self.ratingLabel.text = [NSString stringWithFormat:@"%@ Reviews", self.business.reviewCount];
    self.addressLabel.text = self.business.address;
    self.distanceLabel.text = self.business.distance;
    
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}

@end
