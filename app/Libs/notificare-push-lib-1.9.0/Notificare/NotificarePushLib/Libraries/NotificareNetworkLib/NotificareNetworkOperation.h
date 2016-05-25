//
//  NotificareNetworkOperation.h
//  NotificarePushLib
//
//  Created by Aernout Peeters on 20-04-2016.
//  Copyright © 2016 Notificare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 * @typedef NotificareNetworkOperationState
 * @brief List of NotificareNetworkOperationState types.
 */
typedef NS_ENUM(NSInteger, NotificareNetworkOperationState) {
    NotificareNetworkOperationStateConfig,
    NotificareNetworkOperationStateReady,
    NotificareNetworkOperationStateWaitingForReachability,
    NotificareNetworkOperationStateRunning,
    NotificareNetworkOperationStateCancelled,
    NotificareNetworkOperationStateError,
    NotificareNetworkOperationStateComplete
};

/*!
 * @typedef NotificareNetworkOperationTaskType
 * @brief List of NotificareNetworkOperationTaskType types.
 */
typedef NS_ENUM(NSInteger, NotificareNetworkOperationTaskType) {
    NotificareNetworkOperationTaskTypeData,
    NotificareNetworkOperationTaskTypeDownload,
    NotificareNetworkOperationTaskTypeUpload
};

/*!
 * @typedef NotificareNetworkResponseStatusCode
 * @brief List of NotificareNetworkResponseStatusCode types.
 */
typedef NS_ENUM(NSInteger, NotificareNetworkResponseStatusCode) {
    
    NotificareNetworkResponseStatusCodeContinue                         = 100,
    NotificareNetworkResponseStatusCodeSwitchingProtocols               = 101,
    NotificareNetworkResponseStatusCodeProcessing                       = 102,
    
    NotificareNetworkResponseStatusCodeOK                               = 200,
    NotificareNetworkResponseStatusCodeCreated                          = 201,
    NotificareNetworkResponseStatusCodeAccepted                         = 202,
    NotificareNetworkResponseStatusCodeNonAuthoritativeInformation      = 203,
    NotificareNetworkResponseStatusCodeNoContent                        = 204,
    NotificareNetworkResponseStatusCodeResetContent                     = 205,
    NotificareNetworkResponseStatusCodePartialContent                   = 206,
    NotificareNetworkResponseStatusCodeMultiStatus                      = 207,
    NotificareNetworkResponseStatusCodeAlreadyReported                  = 208,
    NotificareNetworkResponseStatusCodeIMUsed                           = 226,
    
    NotificareNetworkResponseStatusCodeMultipleChoices                  = 300,
    NotificareNetworkResponseStatusCodeMovedPermanently                 = 301,
    NotificareNetworkResponseStatusCodeFound                            = 302,
    NotificareNetworkResponseStatusCodeSeeOther                         = 303,
    NotificareNetworkResponseStatusCodeNotModified                      = 304,
    NotificareNetworkResponseStatusCodeUseProxy                         = 305,
    NotificareNetworkResponseStatusCodeSwitchProxy                      = 306,
    NotificareNetworkResponseStatusCodeTemporaryRedirect                = 307,
    NotificareNetworkResponseStatusCodePermanentRedirect                = 308,
    
    NotificareNetworkResponseStatusCodeBadRequest                       = 400,
    NotificareNetworkResponseStatusCodeUnauthorized                     = 401,
    NotificareNetworkResponseStatusCodePaymentRequired                  = 402,
    NotificareNetworkResponseStatusCodeForbidden                        = 403,
    NotificareNetworkResponseStatusCodeMethodNotAllowed                 = 405,
    NotificareNetworkResponseStatusCodeNotAcceptable                    = 406,
    NotificareNetworkResponseStatusCodeProxyAuthenticationRequired      = 407,
    NotificareNetworkResponseStatusCodeRequestTimeout                   = 408,
    NotificareNetworkResponseStatusCodeConflict                         = 409,
    NotificareNetworkResponseStatusCodeGone                             = 410,
    NotificareNetworkResponseStatusCodeLengthRequired                   = 411,
    NotificareNetworkResponseStatusCodePreconditionFailed               = 412,
    NotificareNetworkResponseStatusCodePayloadTooLarge                  = 413,
    NotificareNetworkResponseStatusCodeURITooLong                       = 414,
    NotificareNetworkResponseStatusCodeUnsupportedMediaType             = 415,
    NotificareNetworkResponseStatusCodeRangeNotSatisfiable              = 416,
    NotificareNetworkResponseStatusCodeExpectationFailed                = 417,
    NotificareNetworkResponseStatusCodeImATeapot                        = 418,
    NotificareNetworkResponseStatusCodeMisdirectedRequest               = 421,
    NotificareNetworkResponseStatusCodeUnprocessableEntity              = 422,
    NotificareNetworkResponseStatusCodeLocked                           = 423,
    NotificareNetworkResponseStatusCodeFailedDependency                 = 424,
    NotificareNetworkResponseStatusCodeUpgradeRequired                  = 426,
    NotificareNetworkResponseStatusCodePreconditionRequired             = 428,
    NotificareNetworkResponseStatusCodeTooManyRequests                  = 429,
    NotificareNetworkResponseStatusCodeRequestHeaderFieldsTooLarge      = 431,
    NotificareNetworkResponseStatusCodeUnavailableForLegalReasons       = 451,
    
    NotificareNetworkResponseStatusCodeInternalServerError              = 500,
    NotificareNetworkResponseStatusCodeNotImplemented                   = 501,
    NotificareNetworkResponseStatusCodeBadGateway                       = 502,
    NotificareNetworkResponseStatusCodeServiceUnavailable               = 503,
    NotificareNetworkResponseStatusCodeGatewayTimeout                   = 504,
    NotificareNetworkResponseStatusCodeHTTPVersionNotSupported          = 505,
    NotificareNetworkResponseStatusCodeVariantAlsoNegotiates            = 506,
    NotificareNetworkResponseStatusCodeInsufficientStorage              = 507,
    NotificareNetworkResponseStatusCodeLoopDetected                     = 508,
    NotificareNetworkResponseStatusCodeNotExtended                      = 510,
    NotificareNetworkResponseStatusCodeNetworkAuthenticationRequired    = 511
};



/*! @brief Model for multipart/form-data parts (attachments) on NotificareNetworkOperationTaskTypeData taskType operations. */
@interface NotificareNetworkAttachment : NSObject

/*! @brief Name parameter for multipart/form-data part. */
@property (strong, nonatomic) NSString *name;

/*! @brief File name parameter for multipart/form-data part. */
@property (strong, nonatomic) NSString *fileName;

/*! @brief Content type parameter for multipart/form-data part. */
@property (strong, nonatomic) NSString *contentType;

/*! @brief Content transfer encoding parameter for multipart/form-data part. Uses "binary" if set to nil. */
@property (strong, nonatomic) NSString *contentTransferEncoding;

/*! @brief Filed contents for multipart/form-data part. */
@property (strong, nonatomic) NSData *fileData;

@end



@interface NotificareNetworkOperation : NSObject

/*!
 * @brief HTTP method, i.e. @"POST".
 * Can only be set if state equals NotificareNetworkOperationStateConfig.
 */
@property (strong, nonatomic) NSString *HTTPMethod;

/*! @brief The full URL string including scheme, domain, path and query parameters. */
@property (strong, nonatomic, readonly) NSString *URLString;

/*! @brief BOOL value that is determined by the URLString's scheme. */
@property (nonatomic, readonly) BOOL isSecure;

/*! @brief Current NotificareNetworkOperationState value. */
@property (nonatomic, readonly) NotificareNetworkOperationState state;

/*!
 * @brief The task type. Defaults to NotificareNetworkOperationTaskTypeData.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 */
@property (nonatomic) NotificareNetworkOperationTaskType taskType;

/*!
 * @brief Determines whether a background session should be used.
 * @brief Only supported for NotificareNetworkOperationTaskTypeDownload and NotificareNetworkOperationTaskTypeUpload taskTypes.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 */
@property (nonatomic) BOOL useBackgroundSession;

/*!
 * @brief The NSURLRequestCachePolicy value that will be used when building the request.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 */
@property (nonatomic) NSURLRequestCachePolicy cachePolicy;

/*! @brief List of headers that will be added to the request when building. */
@property (copy, nonatomic, readonly) NSDictionary<NSString *, NSString *> *headers;

/*!
 * @brief The user name that will be used for authenticated requests.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 */
@property (strong, nonatomic) NSString *username;

/*!
 * @brief The password that will be used for authenticated requests.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 */
@property (strong, nonatomic) NSString *password;

/*!
 * @brief BOOL value determining whether or not basic authentication should be used.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 */
@property (nonatomic) BOOL useBasicAuth;

/*! Denotes whether or not authentication is used. */
@property (nonatomic, readonly) BOOL isAuthenticated;

/*!
 * @brief The payload or request body.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 */
@property (strong, nonatomic) NSData *requestBodyData;

/*!
 * @brief NSData object to be uploaded.
 * @brief Only usable if taskType equals NotificareNetworkOperationTaskTypeUpload.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 */
@property (strong, nonatomic) NSData *requestUploadData;

/*!
 * @brief NSURL file to be uploaded..
 * @brief Only usable if taskType equals NotificareNetworkOperationTaskTypeUpload.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 */
@property (strong, nonatomic) NSURL *requestUploadFile;

/*! @brief NSURL location NotificareNetworkOperationTaskTypeDownload taskType should move its downloaded file to. */
@property (strong, nonatomic) NSURL *downloadLocation;

/*! 
 * @brief The NSURLRequest object as configured by this class.
 * @brief Only available after calling -buildRequest.
 */
@property (strong, nonatomic, readonly) NSURLRequest *request;

/*!
 * @brief The (initial) NSURLSessionTask object created by a NotificareNetworkHost instance.
 * @brief Available once operation has been passed to -[NotificareNetworkHost startOperation:].
 */
@property (strong, nonatomic, readonly) NSURLSessionTask *task;

/*! @brief Progress value for NotificareNetworkOperationTaskTypeDownload and NotificareNetworkOperationTaskTypeUpload taskTypes. */
@property (nonatomic, readonly) double progress;

/*! @brief NSHTTPURLResponse object available once task has completed. */
@property (strong, nonatomic, readonly) NSHTTPURLResponse *HTTPResponse;

/*! @brief Raw response data available once task has completed. */
@property (strong, nonatomic, readonly) NSData *responseData;

/*! @brief Error object available once task has completed with an error. */
@property (strong, nonatomic, readonly) NSError *error;

/*!
 * @brief The number of times request will be retried if there's no client error. Defaults to 0. Set to -1 for infinite.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 */
@property (nonatomic) NSInteger retries;

/*! @brief The number of times the task has failed. */
@property (nonatomic, readonly) NSInteger failures;

/*! @brief The number of remaining retries. */
@property (nonatomic, readonly) NSInteger remainingRetries;

/*!
 * @brief The duration for which the operation will stay valid after having started it.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 */
@property (nonatomic) NSTimeInterval longevity;

/*! @brief NSDate object created when starting or enqueuing the operation. */
@property (strong, nonatomic, readonly) NSDate *startDate;

/*! @brief Denotes whether the operation has expired. */
@property (nonatomic, readonly) BOOL isExpired;

/*!
 * @brief Code block that is executed when a task successfully completes.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 */
@property (copy, nonatomic) void (^successHandler)(NotificareNetworkOperation *operation);

/*!
 * @brief Code block that is executed when a task completes with an error.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 */
@property (copy, nonatomic) void (^errorHandler)(NotificareNetworkOperation *operation, NSError *error);

/*!
 * @brief Determines whether or not NotificareNetworkHost should wait for the host to become reachable before executing the operation.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig or NotificareNetworkOperationStateReady
 */
@property (nonatomic) BOOL waitForReachability;

/*!
 * @brief Denotes whether or not success and error handlers should be dispatched on main queue. Defaults to YES.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 */
@property (nonatomic) BOOL dispatchHandlersOnMainQueue;

/*!
 * @brief Creates a new NotificareNetworkOperation instance.
 * @param HTTPMethod HTTP method, i.e. @"POST"
 * @param URLString The full URL string, including scheme, domain, path and anything else
 */
- (instancetype)initWithHTTPMethod:(NSString *)HTTPMethod andWithURLString:(NSString *)URLString;

/*!
 * @brief Creates a new NotificareNetworkOperation instance.
 * @param HTTPMethod HTTP method, i.e. @"POST"
 * @param baseURLString A URL string with a scheme, domain and path but no query string
 * @param URLParams URL encoded parameters that will add a query string to the baseURLString
 */
- (instancetype)initWithHTTPMethod:(NSString *)HTTPMethod withBaseURLString:(NSString *)baseURLString andWithURLParams:(NSDictionary<NSString *, NSString *> *)URLParams;

/*!
 * @brief Method to set the URLString property.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 * @param baseURLString A URL string with a scheme, domain and path but no query string
 * @param URLParams URL encoded parameters that will add a query string to the baseURLString
 */
- (void)setURLString:(NSString *)baseURLString withURLParams:(NSDictionary<NSString *, NSString *> *)URLParams;

/*!
 * @brief Sets a header value for a specified field.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 * @param fieldValue The value to be set.
 * @parm fieldName The name of the field.
 */
- (void)setHeader:(NSString *)fieldValue forFieldName:(NSString *)fieldName;

/*!
 * @brief Sets multiple header values.
 * @brief Can only be added if state equals NotificareNetworkOperationStateConfig.
 * @param headers Dictionary where the key equals the header's field name and the value the header's field value.
 */
- (void)addHeaders:(NSDictionary<NSString *, NSString *> *)headers;

/*!
 * @brief Removes specific header values.
 * @brief Can only be removed if state equals NotificareNetworkOperationStateConfig.
 * @param fieldNames The header field names that will be removed.
 */
- (void)removeHeaders:(NSArray<NSString *> *)fieldNames;

/*!
 * @brief Removes all header values.
 * @brief Can only be cleared if state equals NotificareNetworkOperationStateConfig.
 */
- (void)clearHeaders;

/*!
 * @brief Sets username, password and useBasicAuth properties.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 * @param username The user name that will be used for authenticated requests
 * @param password The password that will be used for authenticated requests
 * @param useBasicAuth Denotes whether or not basic authentication should be used
 */
- (void)setUsername:(NSString *)username password:(NSString *)password useBasicAuth:(BOOL)useBasicAuth;

/*!
 * @brief Creates a url encoded query string to use as a request body.
 * @brief Sets Content-Type header to application/x-www-form-urlencoded.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 * @param params Dictionary where keys will be uses for parameter names and values for parameter values
 */
- (void)setRequestBodyDataWithParams:(NSDictionary<NSString *, NSString *> *)params;

/*!
 * @brief Creates a multipart request body from parameters and attachments.
 * @brief Sets Content-Type header to multipart/form-data.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 * @param params Dictionary where keys will be uses for parameter names and values for parameter values
 * @param attachment List of NotificareNetworkAttachment objects
 */
- (void)setRequestBodyDataWithParams:(NSDictionary<NSString *, NSString *> *)params andWithAttachments:(NSArray<NotificareNetworkAttachment *> *)attachments;

/*!
 * @brief Sets request body from a JSON object.
 * @brief Sets Content-Type header to application/json.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 * @param JSON An object that can be converted to JSON, such as an NSArray or NSDictionary object
 */
- (void)setRequestBodyDataWithJSON:(id)JSON;

/*! 
 * @brief Sets request body from a UIImage object.
 * @brief Sets Content-Type header to image/jpeg or image/png, depepending on type.
 * @brief Can only be set if state equals NotificareNetworkOperationStateConfig.
 * @param image The image object to be encoded
 * @param type "jpeg" or "png"
 */
- (void)setRequestBodyDataWithImage:(UIImage *)image type:(NSString *)type;

/*!
 * @brief Creates an NSURLRequest object based on HTTPMethod, URLString, headers and requestBody.
 * @brief Can only be built if state equals NotificareNetworkOperationStateConfig.
 * @brief Sets state to NotificareNetworkOperationStateRunning.
 */
- (void)buildRequest;

/*!
 * @brief Cancels the task and will trigger errorHandler if set.
 * @brief Can only be cancelled if state equals NotificareNetworkOperationStateRunning.
 */
- (void)cancel;

/*!
 * @brief Converts responseData to a UTF8 encoded string.
 * @return A UTF8 encoded NSString object.
 */
- (NSString *)responseDataToUTF8String;

/*!
 * @brief Tries to deserialize responseData into a JSON object.
 * @return A JSON object such as an NSArray or NSDictionary object.
 */
- (id)responseDataToJSON;

/*!
 * @brief Creates a UIImage object with the responseData.
 * @return A UIImage object.
 */
- (UIImage *)responseDataToImage;



@end