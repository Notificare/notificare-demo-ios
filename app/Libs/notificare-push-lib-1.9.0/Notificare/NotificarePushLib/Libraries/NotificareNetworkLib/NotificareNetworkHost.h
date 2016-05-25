//
//  NotificareNetworkHost.h
//  NotificarePushLib
//
//  Created by Aernout Peeters on 20-04-2016.
//  Copyright © 2016 Notificare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificareNetworkOperation.h"

@interface NotificareNetworkHost : NSObject

/*! @brief The host's domain name. Used when creating operations and to determine reachability status. */
@property (strong, nonatomic, readonly) NSString *hostName;

/*! @brief The port number that will be connected to. */
@property (nonatomic, readonly) NSUInteger portNumber;

/*! @brief BOOL value that determines if operations created should use SSL. */
@property (nonatomic) BOOL isSecure;

/*! @brief The base path used when creating operations. */
@property (strong, nonatomic) NSString *basePath;

/*! @brief Default username for operations created with this class. */
@property (strong, nonatomic) NSString *username;

/*! @brief Default password for operations created with this class. */
@property (strong, nonatomic) NSString *password;

/*! @brief Default value for operations created with this class, determining whether basic authorization should be used. */
@property (nonatomic) BOOL useBasicAuth;

/*! @brief Default caching policy for operations created with this class. */
@property (nonatomic) NSURLRequestCachePolicy defaultCachePolicy;

/*! @brief Denotes whether or not host is reachable. */
@property (nonatomic, readonly) BOOL isReachable;

/*! @brief The completion handler to call when you finish processing the events. Calling this completion handler lets the system know that your app’s user interface is updated and a new snapshot can be taken. */
@property (nonatomic, copy) void (^backgroundSessionCompletionHandler)(void);

/*!
 * @brief Creates a new NotificareNetworkHost instance with a host name.
 * @param hostName The host's domain name
 * @return The created NotificareNetworkHost instance
 */
- (instancetype)initWithHostName:(NSString *)hostName;

/*!
 * @brief Creates a new NotificareNetworkHost instance with a host name and port number.
 * @param hostName The host's domain name.
 * @param portNumber The port number that will be connected to.
 * @return The created NotificareNetworkHost instance.
 */
- (instancetype)initWithHostName:(NSString *)hostName portNumber:(NSUInteger)portNumber;

/*!
 * @brief Creates a new NotificareNetworkHost instance with a host name and SSL parameter.
 * @param hostName The host's domain name
 * @param isSecure BOOL value that determines if SSL will be used for operations created
 * @return The created NotificareNetworkHost instance
 */
- (instancetype)initWithHostName:(NSString *)hostName isSecure:(BOOL)isSecure;

/*!
 * @brief Creates a new NotificareNetworkHost instance with a host name, port number and SSL parameter.
 * @param hostName The host's domain name
 * @param portNumber The port number that will be connected to
 * @param isSecure BOOL value that determines if SSL will be used for operations created
 * @return The created NotificareNetworkHost instance
 */
- (instancetype)initWithHostName:(NSString *)hostName portNumber:(NSUInteger)portNumber isSecure:(BOOL)isSecure;

/*!
 * @brief Creates a background NSURLSession, so background requests can be executed.
 * @param identifier Unique NSString for used to create background session
 */
- (void)createBackgroundSessionWithIdentifier:(NSString *)identifier;

/*!
 * @brief Sets username, password and useBasicAuth properties.
 * @param username Default username for operations created with this class
 * @param password Default password for operations created with this class
 * @param useBasicAuth Default value for operations created with this class, determining whether basic authorization should be used
 */
- (void)setUsername:(NSString *)username password:(NSString *)password useBasicAuth:(BOOL)useBasicAuth;

/*!
 * @brief Creates a new NotificareNetworkOperation instance.
 * @param HTTPMethod HTTP method, i.e. @"POST"
 * @param path Path relative to hostName and basePath
 * @return The created NotificareNetworkOperation instance.
 */
- (NotificareNetworkOperation *)operationWithHTTPMethod:(NSString *)HTTPMethod withPath:(NSString *)path;

/*!
 * @brief Creates a new NotificareNetworkOperation instance.
 * @param HTTPMethod HTTP method, i.e. @"POST"
 * @param path Path relative to hostName and basePath
 * @param URLParams URL encoded parameters that will be added to the operation's URLString
 * @return The created NotificareNetworkOperation instance.
 */
- (NotificareNetworkOperation *)operationWithHTTPMethod:(NSString *)HTTPMethod withPath:(NSString *)path andWithURLParams:(NSDictionary<NSString *, NSString *> *)URLParams;

/*!
 * @brief Starts an operation if its state equals NotificareNetworkOperationStateReady. Make sure to call -buildRequest on the operation first.
 * @param operation The NotificareNetworkOperation object that should be executed
 */
- (void)startOperation:(NotificareNetworkOperation *)operation;

/*!
 * @brief Adds an operation to queue named "default". Will be executed when it's the first item in its queue and host is reachable.
 * @param The NotificareNetworkOperation object that will be queued
 */
- (void)enqueueOperation:(NotificareNetworkOperation *)operation;

/*!
 * @brief Adds an operation to a named queue. Will be executed when it's the first item in its queue and host is reachable.
 * @param The NotificareNetworkOperation object that will be queued
 * @param The name of the queue that will be used
 */
- (void)enqueueOperation:(NotificareNetworkOperation *)operation queue:(NSString *)queueName;

@end
