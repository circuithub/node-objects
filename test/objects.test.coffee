should  = require "should"
objects = require "../lib/objects"

describe "#merge", ->
  it "should merge shallow objects", ->
    a = {a:1,b:2,c:3}
    b = {d:4}
    c = objects.merge a, b
    should.exist c
    c.should.eql {a:1,b:2,c:3,d:4}

  it "should merge deep objects", ->
    a = {a:1,b:{b1a:2, b1b:{b2:4}},c:3}
    b = {d:4,b:{e:7}}
    c = objects.merge a, b
    should.exist c
    c.should.eql {a:1,b:{b1a:2, b1b:{b2:4}, e:7},c:3, d:4} 