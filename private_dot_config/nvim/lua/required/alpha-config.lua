local scp_header = {
    [[                 ,#############, ]],
    [[                 ##           ## ]],
    [[             m####             ####m ]],
    [[          m##*'        mmm        '*##m ]],
    [[        ###'         mm###mm         '### ]],
    [[      ###        m#############m        ### ]],
    [[     ##       m####*'  ###  '*####        ## ]],
    [[    ##      m####      ###      ####m      ## ]],
    [[   ##      ####      #######      ####      ## ]],
    [[  m#      ###'        #####        '###      #m ]],
    [[  ##     ####           #           ####     ## ]],
    [[  ##     ###    wwwwwwww wwwwwwww    ###     ## ]],
    [[  ##     ###m    ######   ######    m###     ## ]],
    [[,###     '### m#######     #######m ###'     ###, ]],
    [[##'      m######'   *       *   '######m      '## ]],
    [[ ##     *#*'######             ######'*#*     ## ]],
    [[  ##         '#######m     m#######'         ## ]],
    [[   *#m          '###############'          m#* ]],
    [[     ##m ,m,        ''*****''        ,m, m## ]],
    [[      *##'*###m                   m###*'##* ]],
    [[            '*#######m     m#######*' ]],
    [[                   '*#######*' ]],
}

frieren_header = {
    [[⠀⠀⠀⠀⠀⠀⢀⡴⢾⣶⣴⠚⣫⠏⠉⠉⠛⠛⢭⡓⢶⣶⠶⣦⡀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⣰⠋⡀⣠⠟⢁⣾⠇⠀⣀⣷⠀⠀⠓⣝⠂⠙⣆⢄⢻⡞⢢⠀⠀⠀]],
    [[⠀⠀⠀⠀⢠⡇⢸⢡⠃⢠⡞⠁⠀⣰⡟⠉⢦⣄⠀⠈⢆⠀⢻⣾⡄⢧⢸⠀⠀⠀]],
    [[⠀⠀⠀⠀⢸⠀⡇⡌⠀⡞⠀⢀⣴⡋⠀⠀⠀⣙⣷⡀⠘⡄⠘⣿⣧⢸⣼⣥⠀⠀]],
    [[⣀⣀⣀⣀⣞⣰⠁⡇⠀⣧⢴⡛⠛⠁⠀⠀⠀⠉⠉⡙⡦⡇⠀⣿⣸⣼⣿⣇⣀⣀]],
    [[⠳⢽⣷⠺⡟⡿⣯⡇⠰⣧⢩⣭⣥⠀⠀⠀⠀⢠⣭⣥⠁⡀⠀⣿⡟⣴⠶⢁⡨⠊]],
    [[⠀⠀⠉⢳⢦⣅⠘⣿⣄⢿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡇⢀⣏⣳⡇⢴⡞⠁⠀]],
    [[⠀⠀⠀⣼⢸⡅⢹⣿⣿⣾⣟⠀⠀⠠⣀⢄⡠⠀⠀⠠⡚⣿⡿⣿⢻⠁⢹⣷⡀⠀]],
    [[⠀⠀⠸⡏⠸⡇⢼⣿⡿⠟⠛⠓⣦⣄⣀⣀⣀⣀⡤⠴⠿⢿⡟⠛⠺⣦⣬⣗⠀⠀]],
    [[⠀⠀⢰⡇⠀⡇⠸⡏⠀⠀⢰⠋⠙⠛⠛⠉⠉⢹⠀⠀⠀⠀⡇⠀⠀⣿⣿⣿⣟⡃]],
    [[⠀⡐⣾⠀⡀⢹⠀⣿⣄⠀⢸⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⢠⣇⠀⠀⣿⣿⣿⣛⡃]],
    [[⠀⣾⣿⠀⡇⠘⡄⢸⣿⠆⠈⡇⠀⠀⠀⠀⠈⢉⠃⠀⣰⡾⠻⠃⢰⣿⣿⣛⡋⠀]],
    [[⠀⣿⣿⡆⢷⠀⢧⠈⣿⠤⠤⣇⠀⠀⠀⠀⢀⣸⣠⢾⠟⠓⡶⢤⣾⣿⣿⣟⣓⠀]],
}

local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = frieren_header


 dashboard.section.buttons.val = {
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("SPC ff", "󰈞  Find file", ":Telescope find_files <CR>"),
	dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua<CR>"),
	dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

-- local function footer()
--  return "Don't Stop Until You are Proud..."
-- end
--
-- dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
