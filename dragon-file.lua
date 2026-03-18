-- calls dragon command on current file
-- assumes you have https://github.com/krayon/dragon-drag-drop-tool

require "mp"

local MAX_SIZE = 10000000 -- discord 10MB limit, feel free to remove or change
local force_upload = false

-- in input.conf
-- ctrl+d script-binding dragon-video
mp.add_key_binding(nil, "dragon-video", function ()
   if mp.get_property_native("file-size") > MAX_SIZE and not force_upload then
      mp.osd_message("large, retry to force")
      force_upload = true
   else
      mp.command("show-text \"size: " .. "${file-size}\"")
      -- might need to put path to dragon executable
      os.execute("dragon --and-exit \""..mp.get_property_native("path").."\"")
   end
end)
