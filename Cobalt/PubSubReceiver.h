//
//  PubSubReceiver.h
//  Cobalt
//
//  Created by Kristal on 29/07/2015.
//  Copyright (c) 2015 Kristal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CobaltViewController.h"

@class PubSubReceiver;

/**
 * A protocol to implement to be notified when a PubSubReceiver viewController is nil (deallocated or not correctly initialized)
 * or a PubSubReceiver is not subscribed to any channel any more
 */
@protocol PubSubReceiverDelegate <NSObject>

@required

/**
 * @discussion Notifies when a PubSubReceiver viewController is nil (deallocated or not correctly initialized)
 * or a PubSubReceiver is not subscribed to any channel any more
 * @param receiver the PubSubReceiver
 */
- (void)receiverReadyForRemove:(PubSubReceiver *)receiver;

@end

/**
 * An object allowing an UIWebView contained in a CobaltViewController to subscribe/unsubscribe for messages sent via a channel and receive them.
 */
@interface PubSubReceiver : NSObject {
    /**
     * The dictionary which keeps track of subscribed channels and their linked callback
     */
    NSMutableArray *channels;
}

///////////////////////////////////////////////////////////////////////////

#pragma mark PROPERTIES

///////////////////////////////////////////////////////////////////////////

/**
 * The WebView (WebView or WebLayer) to which send messages
 */
@property (nonatomic, readonly) WebViewType webView;
/**
 * The CobaltViewController containing the UIWebView to which send messages
 */
@property (weak, nonatomic, readonly) CobaltViewController *viewController;
/**
 * The delegate to notify when the viewController is nil (deallocated or not correctly initialized)
 * or the PubSubReceiver is not subscribed to any channel any more
 */
@property (weak, nonatomic) id <PubSubReceiverDelegate> delegate;

///////////////////////////////////////////////////////////////////////////

#pragma mark METHODS

///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////

#pragma mark Init

///////////////////////////////////////////////////////////////////////////

/**
 * @discussion Creates and returns a PubSubReceiver for the WebView from the specified CobaltViewController registered to the specified channel.
 * @param webView the WebView to which send messages.
 * @param viewController the CobaltViewController containing the UIWebView to which send messages.
 * @param channel the channel from which the messages will come from.
 * @return A new PubSubReceiver for the specified CobaltViewController registered to the specified channel.
 */
- (instancetype)initWithWebView:(WebViewType)webView
             fromViewController:(nonnull CobaltViewController *)viewController
                     forChannel:(nonnull NSString *)channel
                    andDelegate:(nonnull id <PubSubReceiverDelegate>)delegate;

///////////////////////////////////////////////////////////////////////////

#pragma mark Helpers

///////////////////////////////////////////////////////////////////////////

/**
 * @discussion Subscribes to messages sent from the specified channel.
 * @param channel the channel from which the messages will come from.
 */
- (void)subscribeToChannel:(nonnull NSString *)channel;

/**
 * @discussion Unsubscribes from messages sent from the specified channel.
 * @warning if after the unsubscription, the PubSubReceiver is not subscribed to any channel and delegate is set, 
 * its receiverReadyForRemove: method will be called.
 * @param channel the channel from which the messages come from.
 */
- (void)unsubscribeFromChannel:(nonnull NSString *)channel;

/**
 * @discussion If the PubSubReceiver has subscribed to the specified channel, sends the specified message from this channel to the UIWebView contained in the viewController
 * @warning if viewController is nil at this time, due to deallocation or wrong initialization, 
 * and the delegate is set, its receiverReadyForRemove: method will be called.
 * @param message the message received from the channel.
 * @param channel the channel from which the messages come from.
 */
- (void)didReceiveMessage:(nullable NSDictionary *)message
                onChannel:(nonnull NSString *)channel;

@end
