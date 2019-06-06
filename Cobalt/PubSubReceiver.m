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

#pragma mark - INIT

/////////////////////////////////////////////////////////////////////////////////////////////////

- (instancetype)initWithDelegate:(nonnull id<PubSubDelegate>)delegate
                      forChannel:(nonnull NSString *)channel
             andInternalDelegate:(nonnull id <InternalPubSubDelegate>)internalDelegate {
    if (self = [super init]) {
        _delegate = delegate;
        _channels = [NSMutableArray arrayWithObject:channel];
        _internalDelegate = internalDelegate;
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - METHODS

/////////////////////////////////////////////////////////////////////////////////////////////////

- (void)subscribeToChannel:(nonnull NSString *)channel {
    NSAssert(channel, @"Cannot subscribe on a nil channel.");
    
    if ([_channels indexOfObject:channel] == NSNotFound) {
        [_channels addObject:channel];
    }
}

- (void)unsubscribeFromChannel:(nonnull NSString *)channel {
    NSAssert(channel, @"Cannot unsubscribe a nil channel.");
    
    [_channels removeObject:channel];
    
    if (! _channels.count
        && _internalDelegate) {
        [_internalDelegate receiverReadyForRemove:self];
    }
}

- (void)didReceiveMessage:(nullable NSDictionary *)message
                onChannel:(nonnull NSString *)channel {
    if (! _delegate) {
        NSLog(@"PubSubReceiver didReceiveMessage:onChannel: - delegate is nil. \
              It may be caused by its deallocation or the PubSubReceiver was not correctly initialized... \
              Please check if the PubSubReceiver has been initialized with initWithDelegate:forChannel:andInternalDelegate: method.");
    
        if (_internalDelegate) {
            [_internalDelegate receiverReadyForRemove:self];
            return;
        }
    }

    NSAssert(channel, @"Cannot send message to nil channel");
    
    [_delegate didReceiveMessage:message
                       onChannel:channel];
}

@end
