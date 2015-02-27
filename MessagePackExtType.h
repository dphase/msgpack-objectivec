/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import <Foundation/Foundation.h>


@interface MessagePackExtType : NSObject

@property NSUInteger type;
@property NSData *data;

- (NSString *)description;

@end
