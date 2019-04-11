//
//  PubSub.h
//  Cobalt
//
//  Created by Kristal on 06/01/15.
//  Copyright (c) 2015 Kristal. All rights reserved.
//

#import "PubSubReceiver.h"

/**
 * A plugin which allow UIWebViews contained in CobaltViewController to broadcast messages between them into channels.
 * Handles subscribe/unsubscribe to channel events and publish message event.
 * Broadcasts messages to UIWebViews which have subscribed to the channel where they are from.
 */
@interface PubSub : NSObject <PubSubReceiverDelegate> {
    /**
     * The array which keeps track of PubSubReceivers
     */
    NSMutableArray *receivers;
}

+ (instancetype)sharedInstance;
- (void)subscribeWebView:(WebViewType)webView
               toChannel:(NSString *)channel
      fromViewController:(UIViewController *)viewController;
- (void)unsubscribeWebView:(WebViewType)webView
               fromChannel:(NSString *)channel
         andViewController:(UIViewController *)viewController;
- (void)publishMessage:(NSDictionary *)message
             toChannel:(NSString *)channel;

@end
