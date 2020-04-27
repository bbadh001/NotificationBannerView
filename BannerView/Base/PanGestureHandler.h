//
//  PanGestureHandler.h
//  BannerView
//
//  Created by Brent Badhwar on 4/26/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PanGestureHandlerDelegate <NSObject>

@end

@interface PanGestureHandler : NSObject

@property (nonatomic, weak) id <PanGestureHandlerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
