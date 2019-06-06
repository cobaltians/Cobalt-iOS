//
//  CobaltAlert.h
//  Cobalt
//
//  Created by Sébastien Vitard on 04/08/16.
//  Copyright © 2016 Cobaltians. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CobaltAlert;

@protocol CobaltAlertDelegate <NSObject>

@required

- (void)alert:(CobaltAlert *)alert
withIdentifier:(NSNumber *)identifier
clickedButtonAtIndex:(NSNumber *)index;

@end

@interface CobaltAlert : NSObject <UIAlertViewDelegate>

@property (strong, nonatomic) UIAlertController *alertController;
@property (strong, nonatomic) UIAlertView *alertView;
@property (strong, nonatomic) NSNumber *identifier;
@property (weak, nonatomic) id<CobaltAlertDelegate> delegate;
@property (weak, nonatomic) UIViewController *viewController;

- (instancetype)initWithData:(NSDictionary *)data
                 andDelegate:(nonnull id<CobaltAlertDelegate>)delegate
          fromViewController:(nonnull UIViewController *)viewController;

- (void)show;

@end
