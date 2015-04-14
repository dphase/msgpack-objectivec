//
//  MessagePackParser.m
//  Fetch TV Remote
//
//  Created by Chris Hulbert on 23/06/11.
//  Copyright 2011 Digital Five. All rights reserved.
//

#import  "msgpack_c/msgpack/object.h"
#include "msgpack_c/msgpack.h"
#import  "MessagePackParser.h"
#import  "MessagePackExtType.h"

static const int kUnpackerBufferSize = 1024;

static id unpacked_object(msgpack_object obj, MessagePackExtTypeHandler ext_type_handler) {
  switch (obj.type) {
    case MSGPACK_OBJECT_BOOLEAN:
      return [[NSNumber alloc] initWithBool:obj.via.boolean];
    case MSGPACK_OBJECT_POSITIVE_INTEGER:
      return [[NSNumber alloc] initWithUnsignedLongLong:obj.via.u64];
    case MSGPACK_OBJECT_NEGATIVE_INTEGER:
      return [[NSNumber alloc] initWithLongLong:obj.via.i64];
    case MSGPACK_OBJECT_FLOAT:
      return [[NSNumber alloc] initWithDouble:obj.via.f64];
    case MSGPACK_OBJECT_STR:
      return [[NSString alloc] initWithBytes:obj.via.str.ptr length:obj.via.str.size encoding:NSUTF8StringEncoding];
    case MSGPACK_OBJECT_BIN:
      return [[NSData alloc] initWithBytes:obj.via.bin.ptr length:obj.via.bin.size];
    case MSGPACK_OBJECT_ARRAY: {
      NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:obj.via.array.size];
      msgpack_object *const pend = obj.via.array.ptr + obj.via.array.size;
      for (msgpack_object *p = obj.via.array.ptr; p < pend; p++) {
        id newArrayItem = unpacked_object(*p, ext_type_handler);
        [arr addObject:newArrayItem];
      }
      return arr;
    }
    case MSGPACK_OBJECT_MAP: {
      NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:obj.via.map.size];
      msgpack_object_kv *const pend = obj.via.map.ptr + obj.via.map.size;
      for (msgpack_object_kv *p = obj.via.map.ptr; p < pend; p++) {
        id key = unpacked_object(p->key, ext_type_handler);
        id val = unpacked_object(p->val, ext_type_handler);
        dict[key] = val;
      }
      return dict;
    }
    case MSGPACK_OBJECT_EXT: {
      if (ext_type_handler == nil) {
        MessagePackExtType *ext = [[MessagePackExtType alloc] init];
        ext.type = (NSUInteger) obj.via.ext.type;
        ext.data = [[NSData alloc] initWithBytes:obj.via.ext.ptr length:obj.via.ext.size];
        return ext;
      } else {
        return ext_type_handler(obj.via.ext.type, obj.via.ext.ptr, obj.via.ext.size);
      }
    }
    case MSGPACK_OBJECT_NIL:
    default:
      return [NSNull null];
  }
}

@implementation MessagePackParser

// Parse the given messagepack data into a NSDictionary or NSArray typically
+ (id)parseData:(NSData *)data {
  return [self parseData:data withExtTypeHandler:nil];
}

+ (id)parseData:(NSData *)data withExtTypeHandler:(MessagePackExtTypeHandler)handler {
  msgpack_unpacked msg;
  msgpack_unpacked_init(&msg);

  BOOL success = msgpack_unpack_next(&msg, data.bytes, data.length, NULL);
  id results = success ? unpacked_object(msg.data, handler) : nil;

  msgpack_unpacked_destroy(&msg); // Free the parser

  return results;
}

- (id)init {
  return [self initWithBufferSize:kUnpackerBufferSize];
}

- (id)initWithBufferSize:(int)bufferSize {
  if (self = [super init]) {
    msgpack_unpacker_init(&unpacker, bufferSize);
  }
  return self;
}

// Feed chunked messagepack data into buffer.
- (void)feed:(NSData *)chunk {
  msgpack_unpacker_reserve_buffer(&unpacker, [chunk length]);
  memcpy(msgpack_unpacker_buffer(&unpacker), [chunk bytes], [chunk length]);
  msgpack_unpacker_buffer_consumed(&unpacker, [chunk length]);
}

// Put next parsed messagepack data. If there is not sufficient data, return nil.
- (id)next {
  id unpackedObject;
  MessagePackExtTypeHandler handler = nil;
  msgpack_unpacked result;
  msgpack_unpacked_init(&result);
  if (msgpack_unpacker_next(&unpacker, &result)) {
    msgpack_object obj = result.data;
     unpackedObject = unpacked_object(obj, handler); 
    //unpackedObject = [MessagePackParser createUnpackedObject:obj];
  }
  msgpack_unpacked_destroy(&result);

#if !__has_feature(objc_arc)
    return [unpackedObject autorelease];
#else
  return unpackedObject;
#endif
}

@end
