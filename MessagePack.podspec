Pod::Spec.new do |s|
  s.name        = "MessagePack"
  s.version     = "1.0.0"
  s.license     = "Apache License, Version 2.0"
  s.summary     = "Extremely efficient object serialization library. It's like JSON, but very fast and small."
  s.description = "This is a wrapper for the C MessagePack parser, building the bridge to\nObjective-C. In a similar way to the JSON framework, this parses MessagePack\ninto NSDictionaries, NSArrays, NSNumbers, NSStrings, and NSNulls. This contains\na small patch to the C library so that it doesn't segfault with a byte alignment\nerror when running on the iPhone in armv7 mode. Please note that the parser has\nbeen extensively tested, however the packer has not been. Please get in touch if\nit has issues.\n"
  s.homepage    = "https://github.com/dphase/msgpack-objectivec"
  s.authors     = { "Chris Hulbert" => "chris.hulbert@gmail.com" }

  s.source = {
    :git => "https://github.com/dphase/msgpack-objectivec.git",
    :tag => "1.0.0"
  }

  s.source_files = [
    "*.{h,m}",
    "msgpack_c/*.{c,h}",
    "msgpack_c/msgpack/*.h"
  ]

  s.requires_arc = true
end
