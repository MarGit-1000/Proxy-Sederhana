-- Simple Proxy Module
SimpleProxyModule = [[
{
  "sub_name": "Simple Proxy",
  "icon": "Verified",
  "menu": [
    {
      "type": "labelapp",
      "icon": "Loop",
      "text": "Simple Proxy"
    },
    {
      "type": "divider"
    }, 
    {
      "type": "tooltip",
      "icon": "note_icon",
      "text": "Fitur Wrench",
      "support_text": "Pilih salah satu mode untuk menggunakan wrench secara otomatis"
    },
    {
      "type": "toggle",
      "text": "Auto Pull",
      "alias": "auto_pull_enable",
      "default": false
    },
    {
      "type": "toggle",
      "text": "Auto Kick",
      "alias": "auto_kick_enable",
      "default": false
    },
    {
      "type": "toggle",
      "text": "Auto Ban",
      "alias": "auto_ban_enable",
      "default": false
    },
    {
      "type": "divider"
    },
    {
      "type": "tooltip",
      "icon": "note_icon",
      "text": "Drop Cepat",
      "support_text": "Aktifkan untuk menggunakan command drop cepat"
    },
    {
      "type": "toggle",
      "text": "/wl <jumlah>",
      "alias": "fast_drop_wl_enable",
      "default": false
    },
    {
      "type": "toggle",
      "text": "/dl <jumlah>",
      "alias": "fast_drop_dl_enable",
      "default": false
    },
    {
      "type": "toggle",
      "text": "/bgl <jumlah>",
      "alias": "fast_drop_bgl_enable",
      "default": false
    },
    {
      "type": "divider"
    },
    {
      "type": "tooltip",
      "icon": "note_icon",
      "text": "Command Kustom Drop Item",
      "support_text": "Buat command kustom untuk drop item tertentu"
    },
    {
      "type": "input_string",
      "text": "Command",
      "default": "/",
      "icon": "Edit",
      "alias": "custom_command_input"
    },
    {
      "type": "toggle",
      "text": "Gunakan Item Picker",
      "default": false,
      "alias": "use_item_picker",
      "expandable": true, 
      "always_expand": false,
      "background": true, 
      "list_child": [    
        {
          "type": "item_picker",
          "text": "Pilih Item",
          "item": "Blank",
          "default": "Blank",
          "alias": "selected_item_picker"
        }
      ]
    },
    {
      "type": "toggle",
      "text": "Gunakan Input Item ID",
      "default": false,
      "alias": "use_item_id_input",
      "expandable": true, 
      "always_expand": false,
      "background": true, 
      "list_child": [    
        {
          "type": "input_string",
          "text": "Tulis Item ID",
          "default": "",
          "icon": "Edit",
          "alias": "item_id_input"
        }
      ]
    },
    {
      "type": "button",
      "text": "Tambahkan Command Kustom",
      "alias": "add_custom_command_btn"
    }
  ]
}
]]

-- BTK Module - Fixed according to instructions
BTKModule = [[
{
  "sub_name": "BTK Mode",
  "icon": "Verified",
  "menu": [
    {
      "type": "labelapp",
      "icon": "Loop",
      "text": "BTK"
    },
    {
      "type": "divider"
    }, 
    {
      "type": "tooltip",
      "icon": "note_icon",
      "text": "Position Manager",
      "support_text": "Kelola posisi untuk pathfinding. Gunakan /pos <nomor> untuk berpindah ke posisi."
    },
    {
      "type": "button",
      "text": "Add Pos",
      "alias": "add_pos"
    },
    {
      "type": "button",
      "text": "Clear All Pos",
      "alias": "clear_all_pos"
    }
  ]
}
]]

addIntoModule(SimpleProxyModule)
addIntoModule(BTKModule)

-- variable tax
local set_tax
local tax = 5

-- variable btk v2
local gemskiri_x_1
local gemskiri_y_1
local gemskiri_x_2
local gemskiri_y_2
local gemskiri_x_3
local gemskiri_y_3
local gemskiri_x_4
local gemskiri_y_4
local gemskiri_x_5
local gemskiri_y_5
local display_kiri_x
local display_kiri_y

local gemskanan_x_1
local gemskanan_y_1
local gemskanan_x_2
local gemskanan_y_2
local gemskanan_x_3
local gemskanan_y_3
local gemskanan_x_4
local gemskanan_y_4
local gemskanan_x_5
local gemskanan_y_5
local display_kanan_x
local display_kanan_y

local displaykanan
local displaykiri

local pos_btk = {}

local set_kanan_1
local set_kanan_2
local set_kanan_3
local set_kanan_4
local set_kanan_5
local set_display_kanan

local set_kiri_1
local set_kiri_2
local set_kiri_3
local set_kiri_4
local set_kiri_5
local set_display_kiri


-- Variabel Simple Proxy
local currentProxyMode = nil
local targetPlayerNetId = nil
local fastDropWlEnabled = false
local fastDropDlEnabled = false
local fastDropBglEnabled = false
local sudah_dapat = false

-- Variabel penyimpanan untuk custom commands
local customCommandList = {}
local tempCustomCommand = {
  command = nil,
  item_id = nil
}

-- Variabel untuk toggle eksklusif
local useItemPicker = false
local useItemIdInput = false

-- Variable BTK Mode (Simplified)
local number_set_pos = 1
local pos_x_y = {}
local created_npcs = {}
local MAX_POSITIONS = 50
local is_processing = false


-- function config_btk
function serialize_table(tbl)
  local function serialize(val)
    if type(val) == "table" then
      local s = "{"
      for k, v in pairs(val) do
        s = s .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ","
      end
      return s .. "}"
    elseif type(val) == "string" then
      return string.format("%q", val)
    else
      return tostring(val)
    end
  end
  return serialize(tbl)
end

function save_config(nama)
  if not nama or nama == "" then
    LogToConsole("`4Name cannot be empty.")
    return
  end

  -- Bersihkan whitespace dan newline
  nama = nama:gsub("^%s*(.-)%s*$", "%1")
  nama = nama:gsub("[\r\n]", "")

  if nama == "" then
    LogToConsole("`4Name cannot be empty after being sanitized.")
    return
  end

  local data = {
    tax = tax,
    gemskiri = {
      {x = gemskiri_x_1, y = gemskiri_y_1},
      {x = gemskiri_x_2, y = gemskiri_y_2},
      {x = gemskiri_x_3, y = gemskiri_y_3},
      {x = gemskiri_x_4, y = gemskiri_y_4},
      {x = gemskiri_x_5, y = gemskiri_y_5},
    },
    display_kiri = {x = display_kiri_x, y = display_kiri_y},
    gemskanan = {
      {x = gemskanan_x_1, y = gemskanan_y_1},
      {x = gemskanan_x_2, y = gemskanan_y_2},
      {x = gemskanan_x_3, y = gemskanan_y_3},
      {x = gemskanan_x_4, y = gemskanan_y_4},
      {x = gemskanan_x_5, y = gemskanan_y_5},
    },
    display_kanan = {x = display_kanan_x, y = display_kanan_y}
  }

  local folder_path = "/storage/emulated/0/Android/data/launcher.powerkuy.growlauncher/files/cache/audio/"
  local file_name = "config-" .. nama .. ".txt"
  local file_name_1 = "config-" .. nama
  local full_path = folder_path .. file_name
  local index_path = folder_path .. "config-index.txt"

  local encoded = serialize_table(data)

  -- Pastikan config-index.txt ada, kalau tidak buat kosong
  local check_index = io.open(index_path, "r")
  if not check_index then
    local create_index = io.open(index_path, "w")
    if create_index then
      create_index:write("") -- buat file kosong
      create_index:close()
    else
      LogToConsole("`4Failed to create config-index.txt")
      return
    end
  else
    check_index:close()
  end

  -- Simpan file config
  local file, err = io.open(full_path, "w")
  if file then
    local success, write_err = pcall(function()
      file:write(encoded)
      file:close()
    end)

    if success then
      LogToConsole("`2Config successfully saved to " .. file_name_1)

      -- Tambahkan ke index jika belum ada
      local index = io.open(index_path, "r")
      local sudah_ada = false

      if index then
        for line in index:lines() do
          if line == nama then
            sudah_ada = true
            break
          end
        end
        index:close()
      end

      if not sudah_ada then
        local index_append = io.open(index_path, "a")
        if index_append then
          index_append:write(nama .. "\n")
          index_append:close()
        else
          LogToConsole("`4Failed to add to config-index.txt")
        end
      else
        LogToConsole("`6Config name '" .. nama .. "' already exists in the index, not added again.")
        LogToConsole("`2Config '" .. nama .. "' has been updated.")
      end

    else
      LogToConsole("`4Failed to write to file: " .. tostring(write_err))
    end
  else
    LogToConsole("`4Failed to open file: " .. full_path)
    if err then
      LogToConsole("`4Error detail: " .. tostring(err))
    end
    LogToConsole("`4Possible causes:")
    LogToConsole("`4- Folder does not exist or lacks permission")
    LogToConsole("`4- File name contains illegal characters")
    LogToConsole("`4- Disk is full or read-only")
  end
end

function load_config(nama)
  if not nama or nama == "" then
    LogToConsole("`4Name must not be empty.")
    return
  end

  local file_name = "/storage/emulated/0/Android/data/launcher.powerkuy.growlauncher/files/cache/audio/config-" .. nama .. ".txt"
  local f = io.open(file_name, "r")
  if not f then
    LogToConsole("`4Config '" .. nama .. "' not found.")
    return
  end

  local raw = f:read("*a")
  f:close()

  local data = load("return " .. raw)()
  if not data then
    LogToConsole("`4Failed to load config.")
    return
  end

  tax = data.tax

  gemskiri_x_1, gemskiri_y_1 = data.gemskiri[1].x, data.gemskiri[1].y
  gemskiri_x_2, gemskiri_y_2 = data.gemskiri[2].x, data.gemskiri[2].y
  gemskiri_x_3, gemskiri_y_3 = data.gemskiri[3].x, data.gemskiri[3].y
  gemskiri_x_4, gemskiri_y_4 = data.gemskiri[4].x, data.gemskiri[4].y
  gemskiri_x_5, gemskiri_y_5 = data.gemskiri[5].x, data.gemskiri[5].y
  display_kiri_x, display_kiri_y = data.display_kiri.x, data.display_kiri.y

  gemskanan_x_1, gemskanan_y_1 = data.gemskanan[1].x, data.gemskanan[1].y
  gemskanan_x_2, gemskanan_y_2 = data.gemskanan[2].x, data.gemskanan[2].y
  gemskanan_x_3, gemskanan_y_3 = data.gemskanan[3].x, data.gemskanan[3].y
  gemskanan_x_4, gemskanan_y_4 = data.gemskanan[4].x, data.gemskanan[4].y
  gemskanan_x_5, gemskanan_y_5 = data.gemskanan[5].x, data.gemskanan[5].y
  display_kanan_x, display_kanan_y = data.display_kanan.x, data.display_kanan.y

  LogToConsole("`2Config '" .. nama .. "' loaded.")
end

function getObjectIdAt(x, y)
    for _, obj in pairs(getObjectList()) do
        if (obj.posX // 32) == x and (obj.posY // 32) == y then
            return obj.id
        end
    end
    return nil -- jika tidak ditemukan
end

-- function pos_x_y
function pos(px, py)
    if not px and not py then
        return "`2Click This To Set``"
    else
        return "`b[`2X: `5"..px.."`w,`2Y: `5"..py.."`b]"
    end
end

function taxa(taxaa)
    if not taxaa then
        return "`2Click This To Set``"
    else
        return "`b[`2TAX : ".. tostring(taxaa).."%`b]"
    end
end

function jumlah_object(x, y, id)
  if not x or not y then return 0 end
  local jumlah = 0
  for _, obj in pairs(GetObjectList()) do
    if (obj.posX // 32 == x and obj.posY // 32 == y and obj.itemid == id) then
      jumlah = jumlah + obj.amount
    end
  end
  return jumlah
end



function show_help_btk()
  local dialog = 
  "\nadd_label_with_icon|big|`9HELPER BTK BY `cX|left|340|"..
  "\nadd_textbox|`wCommand|left|"..
  "\nadd_smalltext|`5/btk `w(Edit Config BTK)".. 
  "\nadd_smalltext|`5/gems `w(show gems left & right|left|"..
  "\nadd_smalltext|`5/take <gems/lock> `w(take gems or lock)|left|"..
  "\nadd_smalltext|`5/saveconfig `w(save config btk)|left|".. 
  "\nadd_smalltext|`5/loadconfig `w(load config btk)|left|"..
  "\nadd_smalltext|`5/deleteconfig `w(delete config btk)|left|"..
  "\nadd_quick_exit||"..
  "\nend_dialog|gatau|Cancel|OK|"
  SendVariant({
        v1 = "OnDialogRequest",
        v2 = dialog
    })

end

function hapus_config(nama)
  if not nama or nama == "" then
    LogToConsole("`4Name cannot be empty.")
    return
  end

  -- Bersihkan nama
  nama = nama:gsub("^%s*(.-)%s*$", "%1")
  nama = nama:gsub("[\r\n]", "")

  local folder_path = "/storage/emulated/0/Android/data/launcher.powerkuy.growlauncher/files/cache/audio/"
  local file_path = folder_path .. "config-" .. nama .. ".txt"
  local index_path = folder_path .. "config-index.txt"

  -- Hapus file config
  local deleted_file = os.remove(file_path)
  if deleted_file then
    LogToConsole("`2Config file '" .. nama .. "' deleted successfully.")
  else
    LogToConsole("`4Failed to delete config file '" .. nama .. "'. File might not exist.")
  end

  -- Update index: hapus nama dari config-index.txt
  local index = io.open(index_path, "r")
  if not index then
    LogToConsole("`4Failed to read config-index.txt.")
    return
  end

  local lines = {}
  for line in index:lines() do
    if line ~= nama then
      table.insert(lines, line)
    end
  end
  index:close()

  -- Tulis ulang index tanpa nama tersebut
  local index_rewrite = io.open(index_path, "w")
  if index_rewrite then
    for _, line in ipairs(lines) do
      index_rewrite:write(line .. "\n")
    end
    index_rewrite:close()
    LogToConsole("`2Index successfully updated after deletion.")
else
  LogToConsole("`4Failed to rewrite config-index.txt.")
  end
end

function add_config()
  local dialog = "\nadd_textbox|`5Save BTK Config|left|"..
  "\nadd_smalltext|Enter config name (max 20 characters)|left|"..
  "\nadd_smalltext|`[WARNING] If a config with the same name already exists, it will be overwritten."..
  "\nadd_text_input|nama_config|||20|left|"..
  "\nadd_quick_exit||"..
  "\nend_dialog|gathau|Cancel|OK|"
SendVariant({
        v1 = "OnDialogRequest",
        v2 = dialog
    })
end

function add_config_sudah_ada(nama)
  local dialog = "\nadd_textbox|`5Save BTK Config|left|"..
  "\nadd_smalltext|Enter config name (max 20 characters)|left|"..
  "\nadd_smalltext|`4A config with the name '" .. name .. "' already exists.|left|"..
   "\nadd_text_input|nama_config|||20|left|"..
     "\nadd_quick_exit||"..
  "\nend_dialog|gathau|Cancel|OK|"
SendVariant({
        v1 = "OnDialogRequest",
        v2 = dialog
    })
end

function create_list_button_config()
  local path = "/storage/emulated/0/Android/data/launcher.powerkuy.growlauncher/files/cache/audio/"
  local index_path = path .. "config-index.txt"
  local index = io.open(index_path, "r")
  if not index then
    LogToConsole("`4Unable to read config index.")
    return ""
  end

  local buttons = ""
  for line in index:lines() do
    local file = line:match("^%s*(.-)%s*$") -- hapus spasi depan belakang
    
    
    if file ~= "" then
      buttons = buttons .. "\nadd_button|" .. file .. "|" .. file .. "|left|"
    end
  end
  index:close()
  return buttons
end

function list_config()
  
  local dialog = "\nadd_textbox|`wCLICK A BUTTON TO LOAD CONFIG|left|"..
  create_list_button_config()..
  "\nadd_quick_exit||"..
  "\nend_dialog|config_dialog|Cancel|Cancel|"
  
  SendVariant({
        v1 = "OnDialogRequest",
        v2 = dialog
    })
end

function list_config_hapus()
  
  local dialog = "\nadd_textbox|`wCLICK A BUTTON TO DELETE CONFIG|left|"..
  create_list_button_config()..
  "\nadd_quick_exit||"..
  "\nend_dialog|config_delete_dialog|Cancel|Cancel|"
  
  SendVariant({
        v1 = "OnDialogRequest",
        v2 = dialog
    })
  end
-- fungsi munculin btk dialog_return
function createBTKDialog()
    local setupbtk = "\nadd_label_with_icon|big|`2Configuration BTK``                                                            |left|9438|"..
    "\nadd_label_with_icon|small|`pRight `5[Kanan]|left|340|"..
    "\nadd_button|gemskanan1|Right 1 : ".. pos(gemskanan_x_1, gemskanan_y_1) .. "|left|"..
    "\nadd_button|gemskanan2|Right 2 : ".. pos(gemskanan_x_2, gemskanan_y_2) .. "|left|"..
    "\nadd_button|gemskanan3|Right 3 : ".. pos(gemskanan_x_3, gemskanan_y_3) .. "|left|"..
    "\nadd_button|gemskanan4|Right 4 : ".. pos(gemskanan_x_4, gemskanan_y_4) .. "|left|"..
    "\nadd_button|gemskanan5|Right 5 : ".. pos(gemskanan_x_5, gemskanan_y_5) .. "|left|"..
    "\nadd_spacer|small|"..
    "\nadd_label_with_icon|small|`pLeft `5[Kiri]|left|340|"..
    "\nadd_button|gemskiri1|Left 1 : ".. pos(gemskiri_x_1, gemskiri_y_1) .. "|left|"..
    "\nadd_button|gemskiri2|Left 2 : ".. pos(gemskiri_x_2, gemskiri_y_2) .. "|left|"..
    "\nadd_button|gemskiri3|Left 3 : ".. pos(gemskiri_x_3, gemskiri_y_3) .. "|left|"..
    "\nadd_button|gemskiri4|Left 4 : ".. pos(gemskiri_x_4, gemskiri_y_4) .. "|left|"..
    "\nadd_button|gemskiri5|Left 5 : ".. pos(gemskiri_x_5, gemskiri_y_5) .. "|left|"..
    "\nadd_spacer|small|"..
    "\nadd_textbox|Display|left|"..
    "\nadd_button|display_kanan|Right : ".. pos(display_kanan_x, display_kanan_y).."|left|"..
"\nadd_button|display_kiri|Left : "..pos(display_kiri_x, display_kiri_y).."|left|"..
"\nadd_spacer|small|".. 
    "\nadd_textbox|Tax|left|"..
    "\nadd_button|tax_btk|Tax : "..taxa(tax).."|left|"..
    "\nadd_spacer|small|"..
    "\nadd_smalltext|Thanks To NaniJPX|left|"..
    
    "\nadd_spacer|small|"..
    "\nadd_button|reset_all|`4RESET ALL|left|"..
    "\nadd_quick_exit||"..
    "\nend_dialog|setupcoy|Cancel|Apply|"

    SendVariant({
        v1 = "OnDialogRequest",
        v2 = setupbtk
    })
end

function take(zz)
  if zz == "gems" then
    local semua_posisi = {
      {gemskanan_x_1, gemskanan_y_1},
      {gemskanan_x_2, gemskanan_y_2},
      {gemskanan_x_3, gemskanan_y_3},
      {gemskanan_x_4, gemskanan_y_4},
      {gemskanan_x_5, gemskanan_y_5},
      {gemskiri_x_1, gemskiri_y_1},
      {gemskiri_x_2, gemskiri_y_2},
      {gemskiri_x_3, gemskiri_y_3},
      {gemskiri_x_4, gemskiri_y_4},
      {gemskiri_x_5, gemskiri_y_5},
    }

    for _, posisi in pairs(semua_posisi) do
  local x, y = posisi[1], posisi[2]
  if x and y then
    for _, obj in pairs(GetObjectList()) do
      if (obj.posX // 32 == x and obj.posY // 32 == y) then
        SendPacketRaw(false, { type = 11, value = obj.id, x = obj.posX, y = obj.posY })
        sleep(200)
      end
    end
  end
end

  elseif zz == "lock" then
    if not display_kiri_x or not display_kiri_y or not display_kanan_x or not display_kanan_y then
      LogToConsole("`4[ERROR] Display lock position has not been set")
      return
    end

    local posisi_lock = {
      {display_kanan_x, display_kanan_y},
      {display_kiri_x, display_kiri_y},
    }

    for _, posisi in pairs(posisi_lock) do
      local x, y = posisi[1], posisi[2]
      if x and y then
        local posisi_sekitar = {
          {x, y},
          {x + 1, y + 1},
          {x - 1, y - 1},
          {x + 1, y},
          {x - 1, y},
          {x, y + 1},
          {x, y - 1},
        }

        for _, p in pairs(posisi_sekitar) do
          local x_sekitar, y_sekitar = p[1], p[2]
          local hasil_x = x_sekitar * 32
          local hasil_y = y_sekitar * 32

          local valuee = getObjectIdAt(x_sekitar, y_sekitar)
          if valuee and valuee > 0 then
            SendPacketRaw(false, { type = 11, value = valuee, x = hasil_x, y = hasil_y })
            sleep(200)
          end
        end
      end
    end

  else
    LogToConsole("`4[TAKE] Not Found, Only 'gems' or 'lock'")
  end
end

-- Fungsi untuk reset nilai UI
local function resetUIValues()
  editValue("custom_command_input", "/")
  editValue("item_id_input", "")
  editValue("selected_item_picker", "Blank")
end

-- Fungsi untuk membersihkan NPC yang dibuat
local function cleanupNPCs()
  for i, npc in ipairs(created_npcs) do
    created_npcs[i] = nil
  end
  created_npcs = {}
end

function show_tax_dialog()
dialog = "\nadd_label_with_icon|big|`pTax Configuration|left|2|"..
"\nadd_textbox|Input Tax:|left|"..
"\nadd_text_input|change_tax|||3|left|"..
"\nadd_quick_exit\n"..
"\nend_dialog|setutax|Cancel|Apply|"

sendVariant({ v1 = "OnDialogRequest", v2 = dialog})
end


function show_btk_model()
  setupbtk = "\nadd_label_with_icon|big|`2Configuration BTK``                                                            |left|9438|"..
"\nadd_label_with_icon|small|`pRight `5[Kanan]|left|340|"..
"\nadd_button|gemskanan1|Right 1|left|"..
"\nadd_button|gemskanan2|Right 2|left|"..
"\nadd_button|gemskanan3|Right 3|left|"..
"\nadd_button|gemskanan4|Right 4|left|"..
"\nadd_button|gemskanan5|Right 5|left|"..
"\nadd_spacer|small|"..
"\nadd_label_with_icon|small|`pLeft `5[Kiri]|left|340|"..
"\nadd_button|gemskiri1|Left 1|left|"..
"\nadd_button|gemskiri2|Left 2|left|"..
"\nadd_button|gemskiri3|Left 3|left|"..
"\nadd_button|gemskiri4|Left 4|left|"..
"\nadd_button|gemskiri5|Left 5|left|"..
"\nadd_spacer|small|"..
"\nadd_smalltext|Thanks To NaniJPX|left|"..
"\nadd_spacer|small|"..
"\nadd_button|gemskiri1|Left 1|left|"..
"\nadd_button|gemskiri2|Left 2|left|"..
"\nadd_quick_exit||"..
"\nend_dialog|setupcoy|Cancel|Apply|"
SendVariant({ v1 = "OnDialogRequest", v2 = setupbtk })
end

-- Fungsi untuk validasi posisi
local function isValidPosition(pos)
  return pos and pos.x and pos.y and pos.x >= 0 and pos.y >= 0
end

-- Fungsi untuk membuat posisi dengan error handling
local function createPositionSafe(pos_number, x, y)
  return runThread(function()
    CSleep(50)
    
    local success, err = pcall(function()
      local npc = createPlayer("`cPOS " .. pos_number, "id", -1, x, y)
      if npc then
        table.insert(created_npcs, npc)
        LogToConsole("Created position " .. pos_number .. " at " .. x .. "," .. y)
      end
    end)
    
    if not success then
      LogToConsole("Error creating position NPC: " .. tostring(err))
      growtopia.notify("Error creating position visual")
    end
  end)
end

-- Fungsi untuk mengirim packet proxy
function sendProxyPacket(playerNetId, localNetId, actionMode)
  LogToConsole("Player Tujuan NetID = " .. playerNetId .. ", NetID saya " .. localNetId)
  sendPacket(2, "action|dialog_return\ndialog_name|popup\nnetID|" .. localNetId .. "|\nnetID|" .. playerNetId .. "|\nbuttonClicked|" .. actionMode .. "\n\n")
  LogToConsole(tostring(targetPlayerNetId))
end

function cleanName(raw)
    -- 1. Hapus prefix backtick + 1 char
    if raw:sub(1,1) == "`" then
        local thirdChar = raw:sub(3,3)
        if not thirdChar:match("[%w]") then
            raw = raw:sub(4)
        else
            raw = raw:sub(3)
        end
    end

    -- 2. Hapus teks dalam kurung seperti (AFK)
    raw = raw:gsub("%s*%b()", "")

    -- 3. Hapus simbol seperti @ dan #
    raw = raw:gsub("[@#]", "")

    -- 4. Deteksi dan hilangkan gelar nempel, misal: Dr.Japp, Mr.Arif
    local titlePattern = {"Dr.", "mr", "ketua", "admin", "mod", "gm"}
    for _, title in ipairs(titlePattern) do
        raw = raw:gsub("^" .. title .. "[%.%-]?", ""):gsub("^%s+", "")
    end

    -- 5. Ambil kata pertama yang valid
    for word in raw:gmatch("%S+") do
        return word
    end

    return "Unknown"
end

-- Ganti Fungsi
function proxy123(name, mode)
  local success, err = pcall(function()
    sendPacket(2,"action|input|text|/" .. mode .. " " .. name)
  end)
  
  if not success then
    LogToConsole("Error sending proxy command: " .. tostring(err))
  end
end

-- Fungsi untuk drop item dengan error handling
function dropItem(itemId, itemCount)
  local success, err = pcall(function()
    sendPacket(2, "action|dialog_return\ndialog_name|drop_item\nitemID|" .. itemId .. "|\ncount|" .. itemCount .. "\n")
  end)
  
  if not success then
    LogToConsole("Error dropping item: " .. tostring(err))
    growtopia.notify("Error dropping item")
  end
end

-- Fungsi untuk mendapatkan item dari inventory
local function getItemFromInventory(targetItemId)
  local success, result = pcall(function()
    for _, item in pairs(getInventory()) do
      if item.id == targetItemId then
        return item
      end
    end
    return nil
  end)
  
  if success then
    return result
  else
    LogToConsole("Error getting item from inventory: " .. tostring(result))
    return nil
  end
end

-- Fungsi untuk pathfinding dengan error handling
local function safeFindPath(x, y)
  local success, err = pcall(function()
    findPath(x, y)
  end)
  
  if not success then
    LogToConsole("Error finding path: " .. tostring(err))
    growtopia.notify("Error finding path to position")
  end
end

-- Hook untuk menangani perubahan nilai dari UI
addHook(function(valueType, valueName, newValue)
    
  -- BTK Mode handlers - Simplified to only Add Pos and Clear All Pos
  if valueName == "add_pos" and newValue == false then
    if is_processing then
      growtopia.notify("Already processing, please wait...")
      return
    end
    
    if number_set_pos > MAX_POSITIONS then
      growtopia.notify("Maximum positions reached (" .. MAX_POSITIONS .. ")")
      return
    end
    
    is_processing = true
    
    runThread(function()
      local success, err = pcall(function()
        local player = getLocal()
        if not player then
          growtopia.notify("Player data not available")
          return
        end
        
        if not isValidPosition(player.pos) then
          growtopia.notify("Invalid player position")
          return
        end
        
        -- Create position entry
        local pos_keberapa = "Pos" .. number_set_pos
        pos_x_y[pos_keberapa] = {player.pos.x//32, player.pos.y//32}
        
        -- Create visual NPC
        createPositionSafe(number_set_pos, player.pos.x, player.pos.y)
        
        growtopia.notify("Position " .. number_set_pos .. " added at " .. 
                        math.floor(player.pos.x/32) .. "," .. math.floor(player.pos.y/32))
        
        number_set_pos = number_set_pos + 1
      end)
      
      if not success then
        LogToConsole("Error adding position: " .. tostring(err))
        growtopia.notify("Error adding position")
      end
      
      CSleep(100)
      is_processing = false
    end)
    
  elseif valueName == "clear_all_pos" and newValue == false then
    if is_processing then
      growtopia.notify("Already processing, please wait...")
      return
    end
    
    is_processing = true
    
    runThread(function()
      local success, err = pcall(function()
        pos_x_y = {}
        cleanupNPCs()
        number_set_pos = 1
        growtopia.notify("All positions cleared")
      end)
      
      if not success then
        LogToConsole("Error clearing positions: " .. tostring(err))
        growtopia.notify("Error clearing positions")
      end
      
      CSleep(100)
      is_processing = false
    end)
  
  -- Handle Simple Proxy toggles
  elseif valueName == "auto_pull_enable" then
    if newValue == true then
      editToggle("Auto Kick", false)
      editToggle("Auto Ban", false)
      currentProxyMode = "pull"
    else
      if currentProxyMode == "pull" then
        currentProxyMode = nil
      end
    end

  elseif valueName == "auto_kick_enable" then
    if newValue == true then
      editToggle("Auto Ban", false)
      editToggle("Auto Pull", false)
      currentProxyMode = "kick"
    else
      if currentProxyMode == "kick" then
        currentProxyMode = nil
      end
    end

  elseif valueName == "auto_ban_enable" then
    if newValue == true then
      editToggle("Auto Kick", false)
      editToggle("Auto Pull", false)
      currentProxyMode = "worldban"
    else
      if currentProxyMode == "worldban" then
        currentProxyMode = nil
      end
    end

  -- Handle fast drop toggles
  elseif valueName == "fast_drop_wl_enable" then
    fastDropWlEnabled = newValue

  elseif valueName == "fast_drop_dl_enable" then
    fastDropDlEnabled = newValue

  elseif valueName == "fast_drop_bgl_enable" then
    fastDropBglEnabled = newValue

  -- Handle custom command input
  elseif valueName == "custom_command_input" then
    tempCustomCommand.command = newValue

  -- Handle exclusive toggles untuk item selection
  elseif valueName == "use_item_picker" then
    if newValue == true then
      editToggle("Gunakan Input Item ID", false)
      useItemPicker = true
      useItemIdInput = false
    else
      useItemPicker = false
    end

  elseif valueName == "use_item_id_input" then
    if newValue == true then
      editToggle("Gunakan Item Picker", false)
      useItemPicker = false
      useItemIdInput = true
    else
      useItemIdInput = false
    end

  -- Handle item picker selection
  elseif valueName == "selected_item_picker" then
    if useItemPicker then
      local success, itemId = pcall(function()
        return growtopia.getItemID(newValue)
      end)
      
      if success and itemId then
        tempCustomCommand.item_id = itemId
      else
        growtopia.notify("Invalid item selected")
      end
    end

  -- Handle item ID input
  elseif valueName == "item_id_input" then
    if useItemIdInput then
      local itemId = tonumber(newValue)
      if itemId and itemId > 0 then
        tempCustomCommand.item_id = itemId
      else
        growtopia.notify("Invalid item ID")
      end
    end

  -- Handle add custom command button
  elseif valueName == "add_custom_command_btn" then
    if newValue == false then
      if tempCustomCommand.command and tempCustomCommand.item_id then
        -- Validate command format
        if not tempCustomCommand.command:match("^/") then
          growtopia.notify("Command must start with /")
          return
        end
        
        table.insert(customCommandList, {
          command = tempCustomCommand.command,
          item_id = tempCustomCommand.item_id
        })

        growtopia.notify("Custom command added: " .. tempCustomCommand.command)
        
        -- Reset temp command
        tempCustomCommand = {
          command = nil,
          item_id = nil
        }
        
        -- Reset UI values
        resetUIValues()
      else
        growtopia.notify("Please fill all fields")
      end
    end
  end
end, "onValue")

-- Hook untuk menangkap dan memproses packet
addHook(function(packetType, packet)
  local success, err = pcall(function()
    -- Handle custom commands
    for _, cmd in ipairs(customCommandList) do
      if packet:find(cmd.command) then
        local count = packet:match(cmd.command .. " (%d+)")
        if count then
          count = tonumber(count)
          if count and count > 0 then
            local itemInInventory = getItemFromInventory(cmd.item_id)
            if itemInInventory and count <= itemInInventory.amount then
              dropItem(cmd.item_id, count)
            else
              growtopia.notify("Not enough items in inventory")
            end
          end
        end
      end
    end
    -- Handle wrench actions
    if packetType == 2 and packet:find("action|wrench") then

      local netId = packet:match("netid|(%d+)")
      if netId then
        netId = tonumber(netId)
        local localNetId = GetLocal().netID
        local targetPlayer = getPlayerByNetID(netId)
        
        if targetPlayer and targetPlayer.name then
          local playerName = targetPlayer.name
          local hasil = cleanName(playerName)
          
          if currentProxyMode == "pull" then
            proxy123(hasil, "pull")
sudah_dapat = true
            return true
          elseif currentProxyMode == "kick" then
            proxy123(hasil, "kick")
sudah_dapat = true
            return true
          elseif currentProxyMode == "worldban" then
            proxy123(hasil, "ban")
sudah_dapat = true
            return true
          end
        end
      end
    end
    
    if packetType == 2 and packet:find("/loadconfig") then
      list_config()
      end
    
    if packetType == 2 and packet:find("/saveconfig") then
    add_config()
    end
    
    if packetType == 2 and packet:find("/deleteconfig") then
      list_config_hapus()
      end
    -- Handle /pos command - This is the main functionality you wanted
    if packetType == 2 and packet:find("/take") then
  -- Daftar semua posisi yang dibutuhkan
  local semua_koordinat = {
    gemskanan_x_1, gemskanan_y_1, gemskanan_x_2, gemskanan_y_2,
    gemskanan_x_3, gemskanan_y_3, gemskanan_x_4, gemskanan_y_4,
    gemskanan_x_5, gemskanan_y_5,
    gemskiri_x_1, gemskiri_y_1, gemskiri_x_2, gemskiri_y_2,
    gemskiri_x_3, gemskiri_y_3, gemskiri_x_4, gemskiri_y_4,
    gemskiri_x_5, gemskiri_y_5,
    display_kiri_x, display_kiri_y, display_kanan_x, display_kanan_y
  }

  -- Cek berapa yang valid
  local valid = 0
  for _, v in pairs(semua_koordinat) do
    if v ~= nil then
      valid = valid + 1
    end
  end

  if valid == 0 then
    LogToConsole("`4[ERROR] Not all positions are set (empty)")
growtopia.notify("`4[ERROR] All positions are still empty")
    return
  end

  -- lanjut hitung jumlah
  jumlah_kanan_1 = 
    (jumlah_object(gemskanan_x_1, gemskanan_y_1, 112) or 0) +
    (jumlah_object(gemskanan_x_2, gemskanan_y_2, 112) or 0) +
    (jumlah_object(gemskanan_x_3, gemskanan_y_3, 112) or 0) +
    (jumlah_object(gemskanan_x_4, gemskanan_y_4, 112) or 0) +
    (jumlah_object(gemskanan_x_5, gemskanan_y_5, 112) or 0)

  jumlah_kiri_1 = 
    (jumlah_object(gemskiri_x_1, gemskiri_y_1, 112) or 0) +
    (jumlah_object(gemskiri_x_2, gemskiri_y_2, 112) or 0) +
    (jumlah_object(gemskiri_x_3, gemskiri_y_3, 112) or 0) +
    (jumlah_object(gemskiri_x_4, gemskiri_y_4, 112) or 0) +
    (jumlah_object(gemskiri_x_5, gemskiri_y_5, 112) or 0)

  local item = packet:match("/take%s+(%S+)")
  if item == "gems" then
    LogToConsole("`p[X] Take Gems")
    growtopia.notify("`p[X] Take Gems")
    sendPacket(2,"action|input|text|`b[`2LEFT : `5"..jumlah_kiri_1.."`b] `b[`2RIGHT : `5"..jumlah_kanan_1.."`b]\n")
    take(item)
  elseif item == "lock" then
    LogToConsole("`p[X] Take Lock")
    growtopia.notify("`p[X] Take Lock")
    sendPacket(2,"action|input|text|`cGO BREAK\n")
    take(item)
  else
    LogToConsole("`4[ERROR] Unknown take item: " .. tostring(item))
  end
end

if packetType == 2 and packet:find("/pos") then
  local count = tonumber(packet:match("/pos (%d+)") or "0")
  if count > 0 then
    runCoroutine(function(posNum)
  local pos_key = "Pos" .. posNum
  if pos_x_y[pos_key] then
    local x_path = pos_x_y[pos_key][1]
    local y_path = pos_x_y[pos_key][2]

    if isValidPosition({x = x_path, y = y_path}) then
      CSleep(200) -- jeda dulu
      safeFindPath(x_path, y_path)
      growtopia.notify("Moving to position " .. posNum)
    else
      growtopia.notify("Invalid position data for Pos " .. posNum)
    end
  else
    growtopia.notify("Pos " .. posNum .. " not found")
  end
end, count)
  else
    growtopia.notify("Invalid position number")
  end
end
   
    -- Handle fast drop commands with improved validation
    if packetType == 2 and fastDropWlEnabled and packet:find("/wl") then
      local wlInInventory = getItemFromInventory(242)
      local count = packet:match("/wl (%d+)")
      if count then 
        count = tonumber(count)
        if count and count > 0 and wlInInventory then
          if count <= wlInInventory.amount then
            dropItem(242, count)
          else
            growtopia.notify("Not enough World Locks")
          end
        end
      end
    end

if packetType == 2 and packet:find("/btkhelp") then
    show_help_btk()
elseif packetType == 2 and packet:find("/btk") then
    createBTKDialog()
end
if packetType == 2 and packet:find("/gems") then
  local semua_kiri_kosong = not gemskiri_x_1 and not gemskiri_y_1 and
                            not gemskiri_x_2 and not gemskiri_y_2 and
                            not gemskiri_x_3 and not gemskiri_y_3 and
                            not gemskiri_x_4 and not gemskiri_y_4 and
                            not gemskiri_x_5 and not gemskiri_y_5

  local semua_kanan_kosong = not gemskanan_x_1 and not gemskanan_y_1 and
                             not gemskanan_x_2 and not gemskanan_y_2 and
                             not gemskanan_x_3 and not gemskanan_y_3 and
                             not gemskanan_x_4 and not gemskanan_y_4 and
                             not gemskanan_x_5 and not gemskanan_y_5

  if semua_kiri_kosong or semua_kanan_kosong then
    growtopia.notify("`4Set Area First, Type /btk to set")
    return
  end

  jumlah_kanan = 
    (jumlah_object(gemskanan_x_1, gemskanan_y_1, 112) or 0) +
    (jumlah_object(gemskanan_x_2, gemskanan_y_2,112) or 0) +
    (jumlah_object(gemskanan_x_3, gemskanan_y_3,112) or 0) +
    (jumlah_object(gemskanan_x_4, gemskanan_y_4,112) or 0) +
    (jumlah_object(gemskanan_x_5, gemskanan_y_5,112) or 0)

  jumlah_kiri = 
    (jumlah_object(gemskiri_x_1, gemskiri_y_1,112) or 0) +
    (jumlah_object(gemskiri_x_2, gemskiri_y_2,112) or 0) +
    (jumlah_object(gemskiri_x_3, gemskiri_y_3,112) or 0) +
    (jumlah_object(gemskiri_x_4, gemskiri_y_4,112) or 0) +
    (jumlah_object(gemskiri_x_5, gemskiri_y_5,112) or 0)

local display_kosong_kanan = not display_kanan_x and not display_kanan_y

local display_kosong_kiri = not display_kiri_x and not display_kiri_y

if display_kosong_kiri or display_kosong_kanan then
  LogToConsole("Set display using /btk")
  return
  end

total_wl = (jumlah_object(display_kanan_x, display_kanan_y, 242) or 0) + 
           (jumlah_object(display_kiri_x, display_kiri_y, 242) or 0)

total_dl = (jumlah_object(display_kanan_x, display_kanan_y, 1796) or 0) + 
           (jumlah_object(display_kiri_x, display_kiri_y, 1796) or 0)

total_bgl = (jumlah_object(display_kanan_x, display_kanan_y, 7188) or 0) + 
            (jumlah_object(display_kiri_x, display_kiri_y, 7188) or 0)

hasil_total_wl = total_wl + (total_dl * 100) + (total_bgl * 10000)

local jumlah_akhir = math.floor(hasil_total_wl - (hasil_total_wl * tax / 100))


local bgl = math.floor(jumlah_akhir / 10000)
local sisa_bgl = jumlah_akhir % 10000
local dl = math.floor(sisa_bgl / 100)
local wl = sisa_bgl % 100

local hasil_pecah = bgl .. " BGL " .. dl .. " DL " .. wl .. " WL"

if jumlah_kiri > jumlah_kanan then
  sendPacket(2,"action|input|text|`b[`2LEFT : `5"..jumlah_kiri.."`b] `b[`2RIGHT : `5"..jumlah_kanan.."`b]\n")
  sendPacket(2,"action|input|text|`w<- `cWIN LEFT\n")
             local vs = hasil_total_wl // 2
             
    LogToConsole("")
    LogToConsole("`2Detail :")
    LogToConsole("`b[ `2".. vs .." `w WL`b] `9VS `b[ `2".. vs .." `w WL`b]")
    LogToConsole("`b[`2RIGHT`b]`w = `5" ..jumlah_kanan.. " `9GEMS")
    LogToConsole("`b[`2LEFT`b]`w = `5" ..jumlah_kiri.. " `9GEMS")
    
    LogToConsole("`p===========================")
    
    LogToConsole("`b[`2TAX `5".. tax .."%`b]")
    LogToConsole("`2Normal = `5" .. hasil_total_wl .." `wWL")
    LogToConsole("`2With Tax = `5" .. jumlah_akhir.." `wWL `9Or `5" .. hasil_pecah)
LogToConsole("")

elseif jumlah_kiri < jumlah_kanan then
  sendPacket(2,"action|input|text|`b[`2LEFT : `5"..jumlah_kiri.."`b] `b[`2RIGHT : `5"..jumlah_kanan.."`b]\n")
  sendPacket(2,"action|input|text|`cWIN RIGHT `w->\n")
  
  local vs = hasil_total_wl // 2
  LogToConsole("")
    LogToConsole("`2Detail :")
    LogToConsole("`b[ `2".. vs .." `w WL`b] `9VS `b[ `2".. vs .." `w WL`b]")
    LogToConsole("`b[`2RIGHT`b]`w = `5" ..jumlah_kanan.. " `9GEMS")
    LogToConsole("`b[`2LEFT`b]`w = `5" ..jumlah_kiri.. " `9GEMS")
    
    LogToConsole("`p===========================")
    
    LogToConsole("`b[`2TAX `5".. tax .."%`b]")
    LogToConsole("`2Normal = `5" .. hasil_total_wl .." `wWL")
    LogToConsole("`2With Tax = `5" .. jumlah_akhir.." `wWL `9Or `5" .. hasil_pecah)
LogToConsole("")
    

elseif jumlah_kiri == jumlah_kanan then
  sendPacket(2,"action|input|text|`b[`2LEFT : `5"..jumlah_kiri.."`b] `b[`2RIGHT : `5"..jumlah_kanan.."`b]\n")
  sendPacket(2,"action|input|text|`wTIE\n")
  local vs = hasil_total_wl // 2
    LogToConsole("")
    LogToConsole("`2Detail :")
    LogToConsole("`b[ `2".. vs .." `w WL`b] `9VS `b[ `2".. vs .." `w WL`b]")
    LogToConsole("`b[`2RIGHT`b]`w = `5" ..jumlah_kanan.. " `9GEMS")
    LogToConsole("`b[`2LEFT`b]`w = `5" ..jumlah_kiri.. " `9GEMS")
    
    LogToConsole("`p===========================")
    
    LogToConsole("`b[`2TAX `5".. tax .."%`b]")
    LogToConsole("`2Normal = `5" .. hasil_total_wl .." `wWL")
    LogToConsole("`2With Tax = `5" .. jumlah_akhir.." `wWL `9Or `5" .. hasil_pecah)
LogToConsole("")
    
end
end

  

    if packetType == 2 and fastDropDlEnabled and packet:find("/dl") then
      local dlInInventory = getItemFromInventory(1796)
      local count = packet:match("/dl (%d+)")
      if count then 
        count = tonumber(count)
        if count and count > 0 and dlInInventory then
          if count <= dlInInventory.amount then
            dropItem(1796, count)
          else
            growtopia.notify("Not enough Diamond Locks")
          end
        end
      end
    end

    if packetType == 2 and fastDropBglEnabled and packet:find("/bgl") then
      local bglInInventory = getItemFromInventory(7188)
      local count = packet:match("/bgl (%d+)")
      if count then 
        count = tonumber(count)
        if count and count > 0 and bglInInventory then
          if count <= bglInInventory.amount then
            dropItem(7188, count)
          else
            growtopia.notify("Not enough Blue Gem Locks")
          end
        end
      end
    end
  end)
  
  if not success then
    LogToConsole("Error in packet handler: " .. tostring(err))
  end
if sudah_dapat == true and packet:find("wrench") then
sudah_dapat = false
return true
end

if packet:find("gemskanan1") then
  growtopia.notify("`cPunch")
  set_kanan_1 = true
  elseif packet:find("gemskanan2") then
  growtopia.notify("`cPunch")
  set_kanan_2 = true
  elseif packet:find("gemskanan3") then
  growtopia.notify("`cPunch")
  set_kanan_3 = true
  elseif packet:find("gemskanan4") then
  growtopia.notify("`cPunch")
  set_kanan_4 = true
  elseif packet:find("gemskanan5") then
  growtopia.notify("`cPunch")
  set_kanan_5 = true
  elseif packet:find("gemskiri1") then
  growtopia.notify("`cPunch")
  set_kiri_1 = true
  elseif packet:find("gemskiri2") then
  growtopia.notify("`cPunch")
  set_kiri_2 = true
  elseif packet:find("gemskiri3") then
  growtopia.notify("`cPunch")
  set_kiri_3 = true
  elseif packet:find("gemskiri4") then
  growtopia.notify("`cPunch")
  set_kiri_4 = true
  elseif packet:find("gemskiri5") then
  growtopia.notify("`cPunch")
  set_kiri_5 = true
  elseif packet:find("change_tax") then
    tax = packet:match("change_tax|(%d+)")
    growtopia.notify("Set Tax To ".. tax .."%")
    createBTKDialog()
  elseif packet:find("display_kanan") then
    growtopia.notify("`cPunch Display")
    set_display_kanan = true
    elseif packet:find("display_kiri") then
    growtopia.notify("`cPunch Display")
    set_display_kiri = true
    elseif packet:find("tax_btk") then
      show_tax_dialog()
  elseif packet:find("reset_all") then
    verifikasi = "\nadd_label_with_icon|big|`4WARNING``                                                            |left|2|"..
    "\nadd_smalltext|`4Are you sure you want to reset everything? This cannot be undone later.|left|"..
"\nadd_quick_exit||"..
"\nend_dialog|resetnjir|Cancel|`4RESET|"
SendVariant({ v1 = "OnDialogRequest", v2 = verifikasi })
elseif packet:find("resetnjir")
  then
    gemskiri_x_1 = nil
gemskiri_y_1 = nil
gemskiri_x_2 = nil
gemskiri_y_2 = nil
gemskiri_x_3 = nil
gemskiri_y_3 = nil
gemskiri_x_4 = nil
gemskiri_y_4 = nil
gemskiri_x_5 = nil
gemskiri_y_5 = nil

gemskanan_x_1 = nil
gemskanan_y_1 = nil
gemskanan_x_2 = nil
gemskanan_y_2 = nil
gemskanan_x_3 = nil
gemskanan_y_3 = nil
gemskanan_x_4 = nil
gemskanan_y_4 = nil
gemskanan_x_5 = nil
gemskanan_y_5 = nil
display_kanan_x = nil
display_kanan_y = nil
display_kiri_x = nil
display_kiri_y = nil
tax = 5
growtopia.notify("`pSuccess Reset")
Sleep(1000)
growtopia.notify("`pTax has been reset to 5%")
createBTKDialog()
elseif packet:find("nama_config") then
  config_name = packet:match("nama_config|(.+)")
  growtopia.notify("Config Save With Name " .. config_name)

  local base_path = "/storage/emulated/0/Android/data/launcher.powerkuy.growlauncher/files/cache/audio/"
  local index_path = base_path .. "config-index.txt"
  local config_file_path = base_path .. config_name .. ".txt"

  -- Cek apakah nama sudah ada di index
  local sudah_ada = false
  local index_file = io.open(index_path, "r")
  if index_file then
    for line in index_file:lines() do
      if line == config_name then
        sudah_ada = true
        break
      end
    end
    index_file:close()
  end

  -- Cek juga apakah file nya sudah ada
  local file_udah_ada = io.open(config_file_path, "r") ~= nil

  if sudah_ada or file_udah_ada then
    growtopia.notify("Config already exists.")
    add_config_sudah_ada(config_name) -- ganti ini sesuai fungsi kamu
  else
    save_config(config_name)
  end
  elseif packetType == 2 and packet:find("dialog_name|config_dialog") and packet:find("buttonClicked|") then
  local config_name = packet:match("buttonClicked|([^\n\r|]+)")
  if config_name then
    growtopia.notify("Loading config: " .. config_name)
    load_config(config_name)
  else
    growtopia.notify("`4Failed to read config name from button.")
  end
  elseif packetType == 2 and packet:find("dialog_name|config_delete_dialog") and packet:find("buttonClicked|") then
  local config_name = packet:match("buttonClicked|([^\n\r|]+)")
  if config_name then
    growtopia.notify("Delete config: " .. config_name)
    hapus_config(config_name)
  else
    growtopia.notify("`4Failed to read config name from button.")
  end
end
end,"OnSendPacket")

addHook(function(packet)
  if packet.type == 3 and packet.value == 18 and set_kanan_1 then
    gemskanan_x_1 = packet.px
    gemskanan_y_1 = packet.py
    set_kanan_1 = false
   
    createBTKDialog()  -- ✅ Perbarui dialog
end
if packet.type == 3 and packet.value == 18 and set_kanan_2 then
    gemskanan_x_2 = packet.px
    gemskanan_y_2 = packet.py
    set_kanan_2 = false
    createBTKDialog()
end  
  if packet.type == 3 and packet.value == 18 and set_kanan_3 then
    gemskanan_x_3 = packet.px
    gemskanan_y_3 = packet.py
    set_kanan_3 = false
    createBTKDialog()
  end 
  if packet.type == 3 and packet.value == 18 and set_kanan_4 then
    gemskanan_x_4 = packet.px
    gemskanan_y_4 = packet.py
    set_kanan_4 = false
    createBTKDialog()
  end  
  if packet.type == 3 and packet.value == 18 and set_kanan_5 then
    gemskanan_x_5 = packet.px
    gemskanan_y_5 = packet.py
    set_kanan_5 = false
    createBTKDialog()
  end  
  if packet.type == 3 and packet.value == 18 and set_kiri_1 then
    gemskiri_x_1 = packet.px
    gemskiri_y_1 = packet.py
    set_kiri_1 = false
    createBTKDialog()
  end  
  if packet.type == 3 and packet.value == 18 and set_kiri_2 then
    gemskiri_x_2 = packet.px
    gemskiri_y_2 = packet.py
    set_kiri_2 = false
    createBTKDialog()
  end  
  if packet.type == 3 and packet.value == 18 and set_kiri_3 then
    gemskiri_x_3 = packet.px
    gemskiri_y_3 = packet.py
    set_kiri_3 = false
    createBTKDialog()
  end  
  if packet.type == 3 and packet.value == 18 and set_kiri_4 then
    gemskiri_x_4 = packet.px
    gemskiri_y_4 = packet.py
    set_kiri_4 = false
    createBTKDialog()
  end  
  if packet.type == 3 and packet.value == 18 and set_kiri_5 then
    gemskiri_x_5 = packet.px
    gemskiri_y_5 = packet.py
    set_kiri_5 = false
    createBTKDialog()
  end  
  if packet.type == 3 and packet.value == 18 and set_display_kanan then
    
    display_kanan_x = packet.px
    display_kanan_y = packet.py
    set_display_kanan = false
    createBTKDialog()
end
    if packet.type == 3 and packet.value == 18 and set_display_kiri then
      
    display_kiri_x = packet.px
    display_kiri_y = packet.py
    set_display_kiri = false
    createBTKDialog()
end
  end, "onSendPacketRaw")

-- Initialize
LogToConsole("Growlauncher Script Loaded Successfully!")