//
//  PubSubWebReceiver.m
//  Cobalt
//
//  Created by Sébastien Vitard - Pro on 04/04/2019.
//  Copyright © 2019 Cobaltians. All rights reserved.
//

#import "PubSubWebReceiver.h"

@implementation PubSubWebReceiver

///////////////////////////////////////////////////////////////////////////

#pragma mark - INIT

///////////////////////////////////////////////////////////////////////////

- (instancetype)initWithWebView:(WebViewType)webView
             fromViewController:(nonnull CobaltViewController *)viewController
                     forChannel:(nonnull NSString *)channel
            andInternalDelegate:(nonnull id <InternalPubSubDelegate>)internalDelegate {
    if (self = [super init]) {
        _webView = webView;
        _viewController = viewController;
        self.channels = [NSMutableArray arrayWithObject:channel];
        self.internalDelegate = internalDelegate;
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - METHODS

/////////////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMessage:(nullable NSDictionary *)message
                onChannel:(nonnull NSString *)channel {
    if (! _viewController) {
        NSLog(@"PubSubWebReceiver didReceiveMessage:onChannel: - viewController is nil. \
              It may be caused by its deallocation or the PubSubWebReceiver was not correctly initialized... \
              Please check if the PubSubWebReceiver has been initialized with initWithWebView:fromViewController:forChannel:andInternalDelegate: methods.");
        
        if (self.internalDelegate) {
            [self.internalDelegate receiverReadyForRemove:self];
            return;
        }
    }
    
    NSAssert(channel, @"Cannot send message to nil channel");
    
    if ([self.channels indexOfObject:channel] == NSNotFound) {
        NSLog(@"PubSubWebReceiver didReceiveMessage:onChannel: - %@ of %@ has not subscribed to %@ channel yet or has already unsubscribed.",
              _webView == 0 ? @"WebView" : @"WebLayer",
              [_viewController class],
              channel);
        return;
    }
    
    NSMutableDictionary *cobaltMessage = [NSMutableDictionary dictionaryWithDictionary:@{kJSType: JSTypePubsub,
                                                                                         kJSChannel: channel}];
    if (message != nil)
    {
        [cobaltMessage setObject:message
                          forKey:kJSMessage];
    }
    
    switch (_webView) {
        case WEB_VIEW:
            [_viewController sendMessage:cobaltMessage];
            break;
        case WEB_LAYER:
            [_viewController sendMessageToWebLayer:cobaltMessage];
            break;
    }
}

@end
