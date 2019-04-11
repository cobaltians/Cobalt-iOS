//
//  PubSub.m
//  Cobalt
//
//  Created by Kristal on 06/01/15.
//  Copyright (c) 2015 Kristal. All rights reserved.
//

#import "PubSub.h"
#import "PubSubWebReceiver.h"

@implementation PubSub

////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - INIT

////////////////////////////////////////////////////////////////////////////////////////

static PubSub *pubSubInstance = nil;

+ (nonnull instancetype)sharedInstance
{
    @synchronized(self)
    {
        if (pubSubInstance == nil)
        {
            pubSubInstance = [[self alloc] init];
        }
    }
    
    return pubSubInstance;
}

- (nonnull instancetype)init {
    if (self = [super init]) {
        receivers = [NSMutableArray array];
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////

#pragma mark HELPERS -

////////////////////////////////////////////////////////////////////////////////////////

/**
 * @discussion Broadcasts the specified message to PubSubReceivers which have subscribed to the specified channel.
 * @param message the message to broadcast to PubSubReceivers via the channel.
 * @param channel the channel to which broadcast the message.
 */
- (void)publishMessage:(NSDictionary *)message
             toChannel:(NSString *)channel {
    [receivers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(PubSubReceiver *)obj didReceiveMessage:message
                                       onChannel:channel];
    }];
}

/**
 * @discussion Subscribes the WebView from the specified viewController to messages sent via the specified channel.
 * @warning if no PubSubReceiver was created for the WebView from the specified viewController, creates it.
 * @param webView the WebView (WebView or WebLayer) the PubSubReceiver will have to send its messages to.
 * @param channel the channel the PubSubReceiver subscribes.
 * @param viewController the CobaltViewController the PubSubReceiver will have to use to send messages.
 */
- (void)subscribeWebView:(WebViewType)webView
               toChannel:(nonnull NSString *)channel
      fromViewController:(nonnull CobaltViewController *)viewController
{
    __block PubSubReceiver *receiver;
    
    [receivers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([viewController isEqual:((PubSubReceiver *) obj).viewController]
            && webView == ((PubSubReceiver *) obj).webView) {
            receiver = obj;
            *stop = YES;
        }
    }];
    
    if (receiver != nil) {
        [receiver subscribeToChannel:channel];
    }
    else {
        receiver = [[PubSubReceiver alloc] initWithWebView:webView
                                        fromViewController:viewController
                                                forChannel:channel
                                               andDelegate:self];
        [receivers addObject:receiver];
    }
}

/**
 * @discussion Unsubscribes the WebView from the specified viewController from messages sent via the specified channel.
 * @param webView the WebView (WebView or WebLayer) to unsubscribes from the channel.
 * @param channel the channel from which the messages come from.
 * @param viewController the CobaltViewController containing the UIWebView unsubscribes from the channel.
 */
- (void)unsubscribeWebView:(WebViewType)webView
               fromChannel:(NSString *)channel
         andViewController:(UIViewController *)viewController
{
    __block PubSubReceiver *receiver;
    
    [receivers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([viewController isEqual:((PubSubReceiver *) obj).viewController]
            && webView == ((PubSubReceiver *) obj).webView) {
            receiver = obj;
            *stop = YES;
        }
    }];
    
    if (receiver) {
        [receiver unsubscribeFromChannel:channel];
    }
}

- (void)subscribeBlock:(void (^)(NSDictionary* _Nonnull message))block
             toChannel:(NSString *)channel
{
    
}

- (void)unsubcribeBlock:(void (^)(NSDictionary* _Nonnull message))block
            fromChannel:(NSString *)channel
{
    
}

////////////////////////////////////////////////////////////////////////////////////////

#pragma mark PUBSUB RECEIVER DELEGATE -

////////////////////////////////////////////////////////////////////////////////////////

- (void)receiverReadyForRemove:(PubSubReceiver *)receiver {
    [receivers removeObject:receiver];
}

@end
