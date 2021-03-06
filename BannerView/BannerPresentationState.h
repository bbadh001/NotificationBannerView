//
//  BannerPresentationState.h
//  BannerView
//
//  Created by Brent Badhwar on 4/25/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#ifndef BannerPresentationState_h
#define BannerPresentationState_h

typedef enum BannerPresentationState {
    BannerPresentationStatePresenting,
    BannerPresentationStateHidden,
    BannerPresentationStateAnimatingPresentation,
    BannerPresentationStateAnimatingDismissal,
    BannerPresentationStateTouched
} BannerPresentationState;


#endif /* BannerPresentationState_h */
