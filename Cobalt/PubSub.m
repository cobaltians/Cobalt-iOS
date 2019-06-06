//
//  PubSub.m
//  Cobalt
//
//  Created by Kristal on 06/01/15.
//  Copyright (c) 2015 Kristal. All rights reserved.
//

#import "PubSub.h"

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

#pragma mark - METHODS

////////////////////////////////////////////////////////////////////////////////////////

/**
 * @discussion Broadcasts the specified message to PubSubReceivers which have subscribed to the specified channel.
 * @param message the message to broadcast to PubSubReceivers via the channel.
 * @param channel the channel to which broadcast the message.
 */
- (void)publishMessage:(nullable NSDictionary *)message
             toChannel:(nonnull NSString *)channel {
    [receivers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([((PubSubReceiver *) obj).channels indexOfObject:channel] != NSNotFound) {
            [(PubSubReceiver *)obj didReceiveMessage:message
                                           onChannel:channel];
        }
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
    __block PubSubWebReceiver *receiver;
    
    [receivers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[PubSubWebReceiver class]]
            && [viewController isEqual:((PubSubWebReceiver *) obj).viewController]
            && webView == ((PubSubWebReceiver *) obj).webView) {
            receiver = obj;
            *stop = YES;
        }
    }];
    
    if (receiver != nil) {
        [receiver subscribeToChannel:channel];
    }
    else {
        receiver = [[PubSubWebReceiver alloc] initWithWebView:webView
                                           fromViewController:viewController
                                                   forChannel:channel
                                          andInternalDelegate:self];
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
               fromChannel:(nonnull NSString *)channel
         andViewController:(nonnull CobaltViewController *)viewController
{
    __block PubSubWebReceiver *receiver;
    
    [receivers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[PubSubWebReceiver class]]
            && [viewController isEqual:((PubSubWebReceiver *) obj).viewController]
            && webView == ((PubSubWebReceiver *) obj).webView) {
            receiver = obj;
            *stop = YES;
        }
    }];
    
    if (receiver) {
        [receiver unsubscribeFromChannel:channel];
    }
}

- (void)subscribeDelegate:(nonnull id<PubSubDelegate>)delegate
                toChannel:(nonnull NSString *)channel {
    __block PubSubReceiver *receiver;
    
    [receivers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([delegate isEqual:((PubSubReceiver *) obj).delegate]) {
            receiver = obj;
            *stop = YES;
        }
    }];
    
    if (receiver != nil) {
        [receiver subscribeToChannel:channel];
    }
    else {
        receiver = [[PubSubReceiver alloc] initWithDelegate:delegate
                                                 forChannel:channel
                                        andInternalDelegate:self];
        [receivers addObject:receiver];
    }
}

- (void)unsubscribeDelegate:(nonnull id<PubSubDelegate>)delegate
                fromChannel:(nonnull NSString *)channel {
    __block PubSubReceiver *receiver;
    
    [receivers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([delegate isEqual:((PubSubReceiver *) obj).delegate]) {
            receiver = obj;
            *stop = YES;
        }
    }];
    
    if (receiver) {
        [receiver unsubscribeFromChannel:channel];
    }
}

/*
- (void)subscribeBlock:(void (^)(NSDictionary* _Nonnull message))block
             toChannel:(NSString *)channel
{
    
}

- (void)unsubcribeBlock:(void (^)(NSDictionary* _Nonnull message))block
            fromChannel:(NSString *)channel
{
    
}
*/

////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - INTERNAL PUBSUB DELEGATE

////////////////////////////////////////////////////////////////////////////////////////

- (void)receiverReadyForRemove:(PubSubReceiver *)receiver {
    [receivers removeObject:receiver];
}

@end
