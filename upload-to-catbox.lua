-- uploads current playing file to catbox or at least attempts to
-- also puts x266 link embedder in front for better embedding on discord, feel free to modify it though
-- some os specific considerations if not on wayland

require "mp"
local utils = require "mp.utils"

local function upload_to_catbox()
   local file_path = mp.get_property_native("path")

   if not file_path or file_path == "" then 
      mp.osd_message("no file to upload")
      mp.msg.info(file_path)
      return
   end

   mp.osd_message("uploading...")

   local curl_cmd = {
      "curl",
      "-F",
      "reqtype=fileupload",
      "-F",
      "fileToUpload=@" .. file_path,
      "https://catbox.moe/user/api.php"
   }

   local res = mp.command_native({
      name = "subprocess",
      playback_only = false,
      capture_stdout = true,
      args = curl_cmd
   })

   if res.status == 0 then
      print("generated link: " .. res.stdout)
      local url = "https://x266.mov/e/" .. res.stdout:gsub("%s+", "")
      -- this is the only os specific part of the script that i'm aware of
      -- you'll have to change this if you use something other than wayland ie windows or x11 or macos
      os.execute("echo " .. url .. " | wl-copy")
      mp.osd_message("copied " .. url)
   else
      mp.osd_message("failure")
   end
end

-- either rebind here or script-binding in input.conf
-- ctrl+y script-binding upload-to-catbox
mp.add_key_binding(nil, "upload-to-catbox", upload_to_catbox)
