--- === HSKeybindings ===
---
--- Display Keybindings registered with bindHotkeys() and Spoons 
--- 
--- Spoons need to set the mapping in obj
---
--- Originally based on KSheet.spoon by ashfinal <ashfinal@gmail.com>
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/HSKeybindings.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/HSKeybindings.spoon.zip)

local obj={}
obj.__index = obj

-- Metadata
obj.name = "HSKeybindings"
obj.version = "1.0"
obj.author = "Alfred Schilken <alfred@schilken.de>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Workaround for "Dictation" menuitem
hs.application.menuGlyphs[148]="fn fn"

obj.commandEnum = {
    cmd = '⌘',
    shift = '⇧',
    alt = '⌥',
    ctrl = '⌃',
}

function obj:init()
    self.sheetView = hs.webview.new({x=0, y=0, w=0, h=0})
    self.sheetView:windowTitle("HSKeybindings")
    self.sheetView:windowStyle("utility")
    self.sheetView:allowGestures(true)
    self.sheetView:allowNewWindows(false)
    self.sheetView:level(hs.drawing.windowLevels.modalPanel)
end


--[[ 
  local CmdModifiers = ''
  for key, value in pairs(val.AXMenuItemCmdModifiers) do
      CmdModifiers = CmdModifiers .. obj.commandEnum[value]
  end
  local CmdChar = val.AXMenuItemCmdChar
  local CmdGlyph = hs.application.menuGlyphs[val.AXMenuItemCmdGlyph] or ''
  local CmdKeys = CmdChar .. CmdGlyph
  menu = menu .. "<li><div class='cmdModifiers'>" .. CmdModifiers .. " " .. CmdKeys .. "</div><div class='cmdtext'>" .. " " .. val.AXTitle .. "</div></li>"

--]] 

local function getModifiers(modslist)
  --print("getModifiers:" .. inspect(mods))
  local mods = ''
  for ix, val in ipairs(modslist) do
    mods = mods .. obj.commandEnum[val]
  end
  return mods
end

local function processHotkeys()
  local menu = ""
  local col = 0
  local allKeys = hs.hotkey.getHotkeys()

  for spoonKey, spoonTable in pairs(spoon) do
    if spoonTable.mapping then
      allKeys[#allKeys + 1] = { msg = "Spoon " .. spoonKey }
      for k,v in pairs(spoonTable.mapping) do
          allKeys[#allKeys + 1] = { msg = getModifiers(v[1]) .. " " .. v[2] .. " "  .. k }
        end
    end
  end

  --print(inspect(allKeys))

  for ix, entry in ipairs(allKeys) do
    if ((ix - 1) % 15) == 0 then
      if ix > 1 then
        menu = menu .. "</ul>"
      end  
      col = col + 1
      menu = menu .. "<ul class='col col" .. col .. "'>"
    end
    menu = menu .. "<li><div class='cmdtext'>" .. " " .. entry.msg .. "</div></li>"
  end

  menu = menu .. "</ul>"
  return menu
end

local function generateHtml()
    local app_title = "Hammerspoon Keybindings"
    local allmenuitems = processHotkeys()

    local html = [[
        <!DOCTYPE html>
        <html>
        <head>
        <style type="text/css">
            *{margin:0; padding:0;}
            html, body{
              background-color:#eee;
              font-family: arial;
              font-size: 13px;
            }
            a{
              text-decoration:none;
              color:#000;
              font-size:12px;
            }
            li.title{ text-align:center;}
            ul, li{list-style: inside none; padding: 0 0 5px;}
            footer{
              position: fixed;
              left: 0;
              right: 0;
              height: 48px;
              background-color:#eee;
            }
            header{
              position: fixed;
              top: 0;
              left: 0;
              right: 0;
              height:48px;
              background-color:#eee;
              z-index:99;
            }
            footer{ bottom: 0;
                padding:20px 20px 20px 20px;
             }
            header hr,
            footer hr {
              border: 0;
              height: 0;
              border-top: 1px solid rgba(0, 0, 0, 0.1);
              border-bottom: 1px solid rgba(255, 255, 255, 0.3);
            }
            .title{
                padding: 15px;
            }
            li.title{padding: 0  10px 15px}
            .content{
              padding: 0 0 15px;
              font-size:12px;
              overflow:hidden;
            }
            .content.maincontent{
            position: relative;
              height: 577px;
              margin-top: 46px;
            }
            .content > .col{
              width: 23%;
              padding:20px 0 20px 20px;
            }

            li:after{
              visibility: hidden;
              display: block;
              font-size: 0;
              content: " ";
              clear: both;
              height: 0;
            }
            .cmdtext{
              float: left;
              overflow: hidden;
              width: 165px;
            }
        </style>
        </head>
          <body>
            <header>
              <div class="title"><strong>]] .. app_title .. [[</strong></div>
              <hr />
            </header>
            <div class="content maincontent">]] .. allmenuitems .. [[</div>
            <br>

          <footer>
            <hr />
              <div class="content" >
              <br/>
                  adapted by <a href="https://github.com/schilken" target="_parent">Alfred Schilken</a>
                  based on KSheet Spoon made by <a href="https://github.com/dharmapoudel" target="_parent">dharma poudel</a>
              </div>
          </footer>
          <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.isotope/2.2.2/isotope.pkgd.min.js"></script>
            <script type="text/javascript">
              var elem = document.querySelector('.content');
              var iso = new Isotope( elem, {
                // options
                itemSelector: '.col',
                layoutMode: 'masonry'
              });
            </script>
          </body>
        </html>
        ]]

    return html
end

--- HSKeybindings:show()
--- Method
--- Show current application's keybindings in a webview
---

function obj:show()
    local cscreen = hs.screen.mainScreen()
    local cres = cscreen:fullFrame()
    self.sheetView:frame({
        x = cres.x+cres.w*0.15/2,
        y = cres.y+cres.h*0.25/2,
        w = cres.w*0.6,
        h = cres.h*0.6
    })
    local webcontent = generateHtml()
    self.sheetView:html(webcontent)
    self.sheetView:show()
end

--- HSKeybindings:hide()
--- Method
--- Hide the cheatsheet webview
---

function obj:hide()
    self.sheetView:hide()
end

return obj
