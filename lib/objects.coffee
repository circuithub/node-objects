_          = require "underscore"
_s         = require "underscore.string"
objectDiff = require "objectdiff"


classToType = {}
for name in "Boolean Number String Function Array Date RegExp".split(" ")
  classToType["[object " + name + "]"] = name.toLowerCase()

exports.type = (obj) ->
  if obj == undefined or obj == null
    return String obj
  myClass = Object.prototype.toString.call obj
  if myClass of classToType
    return classToType[myClass]
  return "object"

# Merge two array into one.
exports.mergeArrays = (first, second) -> Array::push.apply first, second

# Get only plain properties from object and skip nested objects.
exports.plainProperties = (object) ->
  if !object or !_.isObject(object)
    return {}
  attributes = {}
  for attribute, value of object when not _.isObject(value)
    attributes[attribute] = value
  return attributes  

# Find differences between two objects.
exports.diff = (object1, object2) ->
  changes = objectDiff.diff object1, object2
  diffs = []
  for changeName, change of changes when change.changed != "equals" and changeName != "id"
    diff = 
      property: changeName
      oldValue: change.removed
      newValue: change.added
    diffs.push diff
  return diffs

#  Deep object extension (merge).
#  Usage: mergedObject = objects.merge(grandparent, child, grandchild, greatgrandchild)
#    1. Priority of objects is right-to-left; first param is overwritten by second param, etc...
#    2. Based conceptually on the _.extend() function in underscore.js ( http://documentcloud.github.com/underscore/#extend )
#    3. From deepExtend gist by author: Kurt Milam - http://xioup.com
#    4. https://gist.github.com/1868955 
exports.merge = (obj) ->
  parentRE = /#{\s*?_\s*?}/
  slice = Array.prototype.slice
  hasOwnProperty = Object.prototype.hasOwnProperty

  _.each slice.call(arguments, 1), (source) =>
    for prop of source
      if hasOwnProperty.call source, prop
        if _.isUndefined obj[prop]
          obj[prop] = source[prop]        
        else if _.isString(source[prop]) and parentRE.test(source[prop])
          if _.isString obj[prop]
            obj[prop] = source[prop].replace(parentRE, obj[prop])        
        else if _.isArray(obj[prop]) or _.isArray(source[prop])
          if (not _.isArray(obj[prop])) or (not _.isArray(source[prop]))
            throw "Error: Trying to combine an array with a non-array (" + prop + ")"
          else 
            obj[prop] = _.reject @merge(obj[prop], source[prop]), (item) -> 
              return _.isNull(item)        
        else if _.isObject(obj[prop]) or _.isObject(source[prop])
          if (not _.isObject(obj[prop])) or (not _.isObject(source[prop]))
            throw "Error: Trying to combine an object with a non-object (" + prop + ")"
          else 
            obj[prop] = @merge obj[prop], source[prop]
        else
          obj[prop] = source[prop]
  
  return obj

# Deep clone
exports.clone = (obj) ->
  if not obj? or typeof obj isnt 'object'
    return obj

  if obj instanceof Date
    return new Date(obj.getTime()) 

  if obj instanceof RegExp
    flags = ''
    flags += 'g' if obj.global?
    flags += 'i' if obj.ignoreCase?
    flags += 'm' if obj.multiline?
    flags += 'y' if obj.sticky?
    return new RegExp(obj.source, flags) 

  newInstance = new obj.constructor()

  for key of obj
    newInstance[key] = @clone obj[key]

  return newInstance

#   Find a specific object in an array of objects where a specific property equals a specific value.
#     Returns undefined if not found.
#   Usage: theContainedObject = objects.find(myArray, "id", 4)
#   Notes: 
#       1. Pass by reference - objects are reference in, reference out (deep copy, see clone(..), the return value if so desired)
#       2. Short circuit analysis - returns only the first object found in array index ascending order 
exports.find = (array, property, value) ->
  for i in [0...array.length]
    if (array[i][property] == value)
      return array[i]
  return undefined
  
#   Find a specific object in an array of objects where a specific property equals a specific value.
#     Returns undefined if not found. Returns the index of the location otherwise.
#   Usage: theContainedObject = objects.findIndex(myArray, "id", 4)
#   Notes: 
#       1. Pass by reference - objects are reference in, reference out (deep copy, see clone(..), the return value if so desired)
#       2. Short circuit analysis - returns only the first object found in array index ascending order 
exports.findIndex = (array, property, value) ->
  for i in [0...array.length]
    if (array[i][property] == value)
      return i
  return undefined

#   Add a prefix to the name of all properties of an Object. Useful for avoiding collisions when merging/extending objects.
#   Follows lowerCamel convention
exports.prefix = (theObject, prefix) ->
  newObject = {}
  for eachProperty of theObject
    if eachProperty is "id"
      newObject[prefix + "ID"] = theObject["id"]
    else
      newObject[prefix + _s.capitalize eachProperty] = theObject[eachProperty]
  return newObject
