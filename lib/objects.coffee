_          = require "underscore"
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




# **merge** - Deep Object Extension (merge)
#    *  USAGE: mergedObject = objectUtils.merge(grandparent, child, grandchild, greatgrandchild)
#    1. Priority of objects is right-to-left; first param is overwritten by second param, etc...
#    2. Based conceptually on the _.extend() function in underscore.js ( http://documentcloud.github.com/underscore/#extend )
#    3. From deepExtend gist by author: Kurt Milam - http://xioup.com
#    4. https://gist.github.com/1868955
# + *firstParam* - Parameter description and notes  
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

# Deep Clone
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








