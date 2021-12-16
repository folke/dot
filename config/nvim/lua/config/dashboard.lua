vim.g.dashboard_default_executive = "telescope"
-- vim.g.dashboard_preview_command = "splashcii"
vim.g.dashboard_preview_pipeline = "lolcat"
-- vim.g.dashboard_preview_file = "beach"
-- vim.g.dashboard_preview_file_height = 20
-- vim.g.dashboard_preview_file_width = 80
vim.g.dashboard_enable_session = 0
vim.g.dashboard_disable_statusline = 0

vim.g.dashboard_custom_header = {
  " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
  " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
  " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
  " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
  " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
  " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
}

local logo = [[
                                                        *                  
     *                                                          *          
                                  *                  *        .--.         
      \/ \/  \/  \/                                        ./   /=*        
        \/     \/      *            *                ...  (_____)          
         \ ^ ^/                                       \ \_((^o^))-.     *  
         (o)(O)--)--------\.                           \   (   ) \  \._.   
         |    |  ||================((~~~~~~~~~~~~~~~~~))|   ( )   |     \  
          \__/             ,|        \. * * * * * * ./  (~~~~~~~~~~~)    \ 
   *        ||^||\.____./|| |          \___________/     ~||~~~~|~'\____/ *
            || ||     || || A            ||    ||          ||    |   jurcy 
     *      <> <>     <> <>          (___||____||_____)   ((~~~~~|   *     
]]
local lines = {}
for line in logo:gmatch("[^\n]+") do
  table.insert(lines, line)
end

vim.g.dashboard_custom_header = lines

vim.g.dashboard_custom_shortcut = {
  ["last_session"] = "SPC s l",
  ["find_history"] = "SPC f r",
  ["find_file"] = "SPC spc",
  ["new_file"] = "SPC f n",
  ["change_colorscheme"] = "SPC h c",
  ["find_word"] = "SPC f g",
  ["book_marks"] = "SPC f b",
}
