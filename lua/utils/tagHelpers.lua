--- Given an object and a list of tagNames, returns whether all the tags exist on the object
---@param obj table
---@param tags string[]
---@return boolean
local function objHasAllTags(obj, tags)
  if (obj == nil) then return false end
  local hasAllTags = true
  table.forEach(tags, function(tag)
    if (not obj.hasTag(tag)) then
      hasAllTags = false
    end
  end)
  return hasAllTags
end

--- Given a snapPoint and a tagName, returns whether the tag exists on the snapPoint
---@param snap table
---@param tag string
---@return boolean
local function snapHasTag(snap, tag)
  return table.includes(snap.tags, tag)
end

--- Given a snapPoint and a list of tagNames, returns whether all the tags exist on the snapPoint
---@param snap table
---@param tags string[]
---@return boolean
local function snapHasAllTags(snap, tags)
  local hasAllTags = true
  table.forEach(tags, function(tag)
    if (not snapHasTag(snap, tag)) then
      hasAllTags = false
    end
  end)
  return hasAllTags
end


return {
  objHasAllTags = objHasAllTags,
  snapHasAllTags = snapHasAllTags,
  snapHasTag = snapHasTag,
}
