/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import "MessagePackExtType.h"


@implementation MessagePackExtType
@synthesize data;

- (NSString *)description {
  NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
  [description appendFormat:@"self.type=%lu", self.type];
  [description appendFormat:@", self.data=%@", self.data];
  [description appendString:@">"];
  return description;
}

- (NSUInteger)datatype {
  return self.type;
}

@end
