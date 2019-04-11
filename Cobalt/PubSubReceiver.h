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

@protocol PubSubDelegate <NSObject>

@required

- (void)didReceiveMessage:(nullable NSDictionary *)message
                onChannel:(nonnull NSString *)channel;

@end

/**
 * A protocol to implement to be notified when a PubSubReceiver viewController is nil (deallocated or not correctly initialized)
 * or a PubSubReceiver is not subscribed to any channel any more
 */
@protocol InternalPubSubDelegate <NSObject>

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
@interface PubSubReceiver : NSObject

///////////////////////////////////////////////////////////////////////////

#pragma mark PROPERTIES

///////////////////////////////////////////////////////////////////////////

/**
 * The dictionary which keeps track of subscribed channels and their linked callback
 */
@property (strong, nonatomic, nonnull) NSMutableArray *channels;

/**
 * The delegate to which send messages
 */
@property (weak, nonatomic, readonly) id<PubSubDelegate> delegate;

/**
 * The delegate to notify when the viewController is nil (deallocated or not correctly initialized)
 * or the PubSubReceiver is not subscribed to any channel any more
 */
@property (weak, nonatomic) id <InternalPubSubDelegate> internalDelegate;

///////////////////////////////////////////////////////////////////////////

#pragma mark - INIT

///////////////////////////////////////////////////////////////////////////

/**
 * @discussion Creates and returns a PubSubReceiver for the PubSubDelegate registered to the specified channel.
 * @param delegate the PubSubDelegate to which send messages.
 * @param channel the channel from which the messages will come from.
 * @return A new PubSubReceiver for the specified CobaltViewController registered to the specified channel.
 */
- (instancetype)initWithDelegate:(nonnull id<PubSubDelegate>)delegate
                      forChannel:(nonnull NSString *)channel
             andInternalDelegate:(nonnull id <InternalPubSubDelegate>)internalDelegate;

///////////////////////////////////////////////////////////////////////////

#pragma mark - METHODS

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
