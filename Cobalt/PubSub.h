//
//  PubSub.h
//  Cobalt
//
//  Created by Kristal on 06/01/15.
//  Copyright (c) 2015 Kristal. All rights reserved.
//

#import "PubSubWebReceiver.h"

/**
 * A plugin which allow UIWebViews contained in CobaltViewController to broadcast messages between them into channels.
 * Handles subscribe/unsubscribe to channel events and publish message event.
 * Broadcasts messages to UIWebViews which have subscribed to the channel where they are from.
 */
@interface PubSub : NSObject <InternalPubSubDelegate> {
    /**
     * The array which keeps track of PubSubReceivers
     */
    NSMutableArray *receivers;
}

+ (instancetype)sharedInstance;

- (void)subscribeWebView:(WebViewType)webView
               toChannel:(nonnull NSString *)channel
      fromViewController:(nonnull CobaltViewController *)viewController;
- (void)unsubscribeWebView:(WebViewType)webView
               fromChannel:(nonnull NSString *)channel
         andViewController:(nonnull CobaltViewController *)viewController;

- (void)subscribeDelegate:(nonnull id<PubSubDelegate>)delegate
                toChannel:(nonnull NSString *)channel;
- (void)unsubscribeDelegate:(nonnull id<PubSubDelegate>)delegate
                fromChannel:(nonnull NSString *)channel;

- (void)publishMessage:(nullable NSDictionary *)message
             toChannel:(nonnull NSString *)channel;

@end
