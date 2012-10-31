node-objects
==========

Simple objects' utilities for Node.js

# Overview

Simple utility libraries that have common methods to deal with objects.

## Use

Install

`npm install objects`


Code

``` coffee

objects = require "objects"


```

That's easy!

## Subtraction (Change Log)

```coffeescript
  a = {
    aa: 2
    ab: {a:1, c:3}
  }
  b = {
    aa: 1
    ab: {a:1, b:2, c:3}
  }
  objects.subtract a, b
```

results in a return object of:

```coffeescript
{
    added: {}
    changed: { aa: 2 }
    removed: { ab: { b: 2 } }
    numChanged: 
      {
        add: 0
        modify: 1
        removed: 1
        total: 2
      }
}
```

## Contributions

If you need any feature tell us or fork project and implement it by yourself.

We appreciate feedback!

## License

(The MIT License)

Copyright (c) 2011 CircuitHub., https://circuithub.com/

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.