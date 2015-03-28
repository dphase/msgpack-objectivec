//
//  MessagePackParser.h
//  Fetch TV Remote
//
//  Created by Chris Hulbert on 23/06/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "msgpack_c/msgpack.h"


typedef id (^MessagePackExtTypeHandler)(int8_t type, const char *data, uint32_t length);


@interface MessagePackParser : NSObject {
  // This is only for MessagePackParser+Streaming category.
  msgpack_unpacker unpacker;
}

+ (id)parseData:(NSData *)data;
+ (id)parseData:(NSData *)data withExtTypeHandler:(MessagePackExtTypeHandler)handler;

@end
