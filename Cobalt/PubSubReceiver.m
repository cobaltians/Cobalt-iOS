//
//  PubSubReceiver.m
//  Cobalt
//
//  Created by Kristal on 29/07/2015.
//  Copyright (c) 2015 Kristal. All rights reserved.
//

#import "PubSubReceiver.h"

@implementation PubSubReceiver

/////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark INIT

/////////////////////////////////////////////////////////////////////////////////////////////////

- (instancetype)initWithWebView:(WebViewType)webView
             fromViewController:(nonnull CobaltViewController *)viewController
                     forChannel:(nonnull NSString *)channel
                    andDelegate:(nonnull id <PubSubReceiverDelegate>)delegate {
    if (self = [super init]) {
        _webView = webView;
        _viewController = viewController;
        channels = [NSMutableArray arrayWithObject:channel];
        _delegate = delegate;
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark HELPERS

/////////////////////////////////////////////////////////////////////////////////////////////////

- (void)subscribeToChannel:(nonnull NSString *)channel {
    NSAssert(channel, @"Cannot subscribe on a nil channel.");
    
    if ([channels indexOfObject:channel] == NSNotFound) {
        [channels addObject:channel];
    }
}

- (void)unsubscribeFromChannel:(nonnull NSString *)channel {
    NSAssert(channel, @"Cannot unsubscribe a nil channel.");
    
    [channels removeObject:channel];
    
    if (! channels.count
        && _delegate) {
        [_delegate receiverReadyForRemove:self];
    }
}

- (void)didReceiveMessage:(nullable NSDictionary *)message
                onChannel:(nonnull NSString *)channel {
    if (! _viewController) {
        NSLog(@"PubSubReceiver didReceiveMessage:onChannel: - viewController is nil. \
              It may be caused by its deallocation or the PubSubReceiver was not correctly initialized... \
              Please check if the PubSubReceiver has been initialized with initWithViewController: or initWithViewController:andCallback:forChannel: methods.");
    
        if (_delegate) {
            [_delegate receiverReadyForRemove:self];
            return;
        }
    }

    NSAssert(channel, @"Cannot send message to nil channel");
    
    if ([channels indexOfObject:channel] == NSNotFound) {
        NSLog(@"PubSubReceiver didReceiveMessage:onChannel: - %@ of %@ has not subscribed to %@ channel yet or has already unsubscribed.",
              _webView == 0 ? @"WebView" : @"WebLayer",
              [_viewController class],
              channel);
        return;
    }
    
    switch (_webView) {
        case WEB_VIEW:
            [_viewController sendMessage:@{kJSType: JSTypePubsub,
                                           kJSChannel: channel,
                                           kJSMessage: message}];
            break;
        case WEB_LAYER:
            [_viewController sendMessageToWebLayer:@{kJSType: JSTypePubsub,
                                                     kJSChannel: channel,
                                                     kJSMessage: message}];
            break;
    }
}

- (BOOL)isEqual:(id)object {
    return object != nil && [object isKindOfClass:[PubSubReceiver class]]
    && _webView == ((PubSubReceiver *) object).webView
    && ((_viewController == nil && ((PubSubReceiver *) object).viewController == nil) || (_viewController != nil && [_viewController isEqual:((PubSubReceiver *) object).viewController]));
}

@end
