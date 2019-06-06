//
//  CobaltAlert.m
//  Cobalt
//
//  Created by Sébastien Vitard on 04/08/16.
//  Copyright © 2016 Cobaltians. All rights reserved.
//

#import "CobaltAlert.h"

#import "Cobalt.h"

@implementation CobaltAlert

////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark LIFECYCLE

////////////////////////////////////////////////////////////////////////////////////////////////

- (instancetype)initWithData:(NSDictionary *)data
                 andDelegate:(nonnull id<CobaltAlertDelegate>)delegate
          fromViewController:(nonnull UIViewController *)viewController {
    if (self = [super init]) {
        _viewController = viewController;
        _delegate = delegate;
        
        if (data == nil
            || ! [data isKindOfClass:[NSDictionary class]]) {
#if DEBUG_COBALT
            NSLog(@"CobaltAlert - initWithData:andDelegate:fromViewController: data field missing or not an object.");
#endif
            return nil;
        }

        _identifier = [data objectForKey:kJSAlertId];
        if (_identifier == nil
            || ! [_identifier isKindOfClass:[NSNumber class]]) {
#if DEBUG_COBALT
            NSLog(@"CobaltAlert - initWithData:andDelegate:fromViewController: alertId field missing or not a number.");
#endif
            return nil;
        }
        
        id title = [data objectForKey:kJSAlertTitle];
        id message = [data objectForKey:kJSAlertMessage];
        id buttons = [data objectForKey:kJSAlertButtons];
        
        if (title == nil
            || ! [title isKindOfClass:[NSString class]]) {
            title = @"";
        }
        if (message == nil
            || ! [message isKindOfClass:[NSString class]]) {
            message = @"";
        }
        if (buttons == nil
            || ! [buttons isKindOfClass:[NSArray class]]) {
            buttons = [NSArray array];
        }
        NSUInteger buttonsCount = ((NSArray *) buttons).count;
        
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        if ([systemVersion compare:@"8.0"
                           options:NSNumericSearch] != NSOrderedAscending) {
            _alertController = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
            
            if (buttonsCount) {
                for (int i = 0 ; i < buttonsCount ; i++) {
                    UIAlertAction *action = [UIAlertAction actionWithTitle:[buttons objectAtIndex:i]
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction *action) {
                                                                           if (_delegate != nil) {
                                                                               [_delegate alert:self
                                                                                 withIdentifier:_identifier
                                                                           clickedButtonAtIndex:[NSNumber numberWithInt:i]];
                                                                           }
#if DEBUG_COBALT
                                                                           else {
                                                                               NSLog(@"CobaltAlert - an identifier was set but delegate is missing.");
                                                                           }
#endif
                                                                   }];
                    [_alertController addAction:action];
                }
            }
            else {
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"OK",
                                                                                                                @"Localizable",
                                                                                                                [Cobalt bundleResources],
                                                                                                                @"OK")
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction *action) {
                                                                             if (_delegate != nil) {
                                                                                 [_delegate alert:self
                                                                                   withIdentifier:_identifier
                                                                             clickedButtonAtIndex:0];
                                                                             }
#if DEBUG_COBALT
                                                                             else {
                                                                                 NSLog(@"CobaltAlert - an identifier was set but delegate is missing.");
                                                                             }
#endif
                                                                         }];
                [_alertController addAction:cancelAction];
            }
        }
        else {
            if (buttonsCount) {
                _alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
                
                for (int i = 0 ; i < buttonsCount ; i++) {
                    [_alertView addButtonWithTitle:[buttons objectAtIndex:i]];
                }
            }
            else {
                _alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"OK",
                                                                                                   @"Localizable",
                                                                                                   [Cobalt bundleResources],
                                                                                                   @"OK")
                                              otherButtonTitles:nil];
            }
        }
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark METHODS

////////////////////////////////////////////////////////////////////////////////////////////////

- (void)show {
    if (_alertController != nil) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            if (_viewController != nil) {
                [_viewController presentViewController:_alertController
                                              animated:YES
                                            completion:nil];
            }
#if DEBUG_COBALT
            else {
               NSLog(@"CobaltAlert - show: unable to show alert, viewController is missing.");
            }
#endif
        }];
    }
    else if (_alertView != nil) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            [_alertView show];
        }];
    }
#if DEBUG_COBALT
    else {
        NSLog(@"CobaltAlert - show: unable to show alert, none are set. Check your init call.");
    }
#endif
}

////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark ALERTVIEW DELEGATE

////////////////////////////////////////////////////////////////////////////////////////////////

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_delegate != nil) {
        [_delegate alert:self
          withIdentifier:_identifier
    clickedButtonAtIndex:[NSNumber numberWithInteger:buttonIndex]];
    }
#if DEBUG_COBALT
    else {
        NSLog(@"CobaltAlert - an identifier was set but delegate is missing.");
    }
#endif
}

@end
