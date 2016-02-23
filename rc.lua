
--Awesome 3.5.5
--Использовала тему multicolor, библиотеки: lain, vicious

--------------------------------------------------------------------------------------
-- Стандартные библиотеки --
--------------------------------------------------------------------------------------
local gears = require("gears")
local awful = require("awful")  --стандартная библиотека
awful.rules = require("awful.rules")  --библиотека реализующая правила работы с клиентами
require("awful.autofocus")
require("eminent")  --скрывает неиспользуемые теги
--------------------------------------------------------------------------------------
-- Библиотека виджетов и layout --
--------------------------------------------------------------------------------------
local wibox = require("wibox")
local vicious = require("vicious")  --модульная библ. виджетов
vicious.contrib = require("vicious.contrib")
require("vain")  --модульная библ. виджетов (альтернативные схемы)
local lain = require("lain")  --модульная библ. виджетов (наследница vain)
--------------------------------------------------------------------------------------
-- Библиотека стилей и тем --
--------------------------------------------------------------------------------------
local beautiful = require("beautiful")  --позволяет настраивать темы и т.д.
--------------------------------------------------------------------------------------
-- Библиотека уведомлений --
--------------------------------------------------------------------------------------
local naughty = require("naughty")  --реализует всплывающие сообщения
local menubar = require("menubar")  --dmenu-лайт расширенное

--------------------------------------------------------------------------------------
-- Устанавливаем системную локаль --
--------------------------------------------------------------------------------------
os.setlocale("ru_RU.UTF-8")

--------------------------------------------------------------------------------------
-- Ошибка запуска awesome (не трогать) --
--------------------------------------------------------------------------------------
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Захват ошибок после запуска --------------------------------------------------------
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end

--------------------------------------------------------------------------------------
-- Определение переменных --
--------------------------------------------------------------------------------------
-- Темы, иконки, шрифты, обои --
--------------------------------------------------------------------------------------
beautiful.init("/usr/share/awesome/themes/default/theme.lua")  --путь до темы
--------------------------------------------------------------------------------------
-- Устанавливаем приложения по умолчанию --
--------------------------------------------------------------------------------------
--Системные
modkey = "Mod4"
altkey = "Mod1"
terminal = "urxvt"
editor = os.getenv("EDITOR") or "subl"
editor_cmd = terminal .. " -e " .. editor

--Пользовательские
browser = "firefox"
browser2 = "google-chrome-unstable"
gis = "2gis"
gui_editor = "gvim"
graphics = "gimp"
fileman = "pcmanfm"
mail = "thunderbird"

--------------------------------------------------------------------------------------
-- Layouts - способы расположения окон на экране --
--------------------------------------------------------------------------------------
local layouts =
{
    awful.layout.suit.floating, --плавающие окна (можно изменить размер окна)
    awful.layout.suit.tile, --главное окно слева, справа второстепенные (мелкие)
    awful.layout.suit.tile.left,  --слева второстепенные окна
    awful.layout.suit.tile.bottom,  --внизу второстепенные окна
    awful.layout.suit.tile.top,  --второстепенные окна вверху
    awful.layout.suit.fair, --главное окно справа 
    awful.layout.suit.fair.horizontal, --главное окно внизу
    awful.layout.suit.spiral,  --главное окно справа 
    awful.layout.suit.spiral.dwindle,  --главное окно справа 
    awful.layout.suit.max, --окно на весь экран
    awful.layout.suit.max.fullscreen, --окна на весь экран, включая панели
    awful.layout.suit.magnifier  --главное окно в центре
}

--------------------------------------------------------------------------------------
-- Обои --
--------------------------------------------------------------------------------------
if beautiful.wallpaper then  --если в теме заданы обои
    for s = 1, screen.count() do  --перебираем все экраны
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)  --на каждый экран кладем обои 
    end                                               --(можно в принципе на каждый экран свои)
end

--------------------------------------------------------------------------------------
-- Теги --
--------------------------------------------------------------------------------------
tags = {  --список тэгов 
    names = { "subl", "internet", "terminal", "video", "torrent", "audio", "settings" },    --имена тэгов
     layout = { layouts[3], layouts[1], layouts[2], layouts[4], layouts[7],  --макеты тэгов
              layouts[1],  layouts[7]
}}      
for s = 1, screen.count() do  --перебираем все экраны
    tags[s] = awful.tag(tags.names, s, tags.layout)  --на каждом создаем список тэгов,      
end                                             --устанавливая макет отображения окон   

--------------------------------------------------------------------------------------
-- Главное Меню --
--------------------------------------------------------------------------------------
-- Медиа меню --
media_menu = {                                         
   { "Audacious", "audacious", beautiful.audio_icon },   -- Формат описания пункта меню  
   { "Vlc", "vlc", beautiful.vlc_icon },  -- {<Название пункта меню>, <Команда запуска>, <Иконка>}
   { "Skype", "skype", beautiful.skype_icon },
   { "TeamViewer", "teamviewer", beautiful.teamv_icon },
   { "Thunderbird", mail, beautiful.mail_icon }
}
-- Интернет меню --
internet_menu = {
   { "Firefox", browser, beautiful.firefox_icon },
   { "Google Chrome", browser2, beautiful.chrome_icon },
   { "Steam", "steam", beautiful.steam_icon },
   { "Tor Browser", "/usr/bin/tor-browser-en", beautiful.tor_icon },
   { "Transmission", "transmission-gtk", beautiful.torrent_icon },
   { "Vidalia", "vidalia", beautiful.vidalia_icon }
}
-- Офис меню --
office_menu = {
   { "Менеджер архивов", "file-roller", beautiful.arhiv_icon },
   { "Просмотр документов", "evince", beautiful.evince_icon },
   { "Просмотр изображений", "gpicview", beautiful.gpic_icon },
   { "ПИзоб. ristretto", "ristretto", beautiful.ristrerro_icon },
   { "7-Zip FM", "7zFM", beautiful.zip_icon },
   { "FBReader", "FBReader", beautiful.fbreader_icon },
   { "LibreOffice", "libreoffice", beautiful.libre_icon },
   { "PCManFM", fileman, beautiful.fileman_icon },
   { "Sublime Text", "subl", beautiful.subl_icon }
}
-- Настройка меню --
settings_menu = {
   { "Adobe Flash Player", "flash-player-properties", beautiful.flash_icon },
   { "GParted", "gparted", beautiful.gparted_icon },
   { "Lxappearance", "lxappearance", beautiful.lxap_icon },
   { "NVIDIA X Server Settings", "nvidia-settings", beautiful.nvidia_icon },
   { "VirtualBox", "virtualbox", beautiful.vibox_icon },
   { "URxvt", terminal, beautiful.terminal_icon }  
}
-- Разное меню --
other_menu = {
    { "2GIS", gis, beautiful.gis_icon },
    { "Gimp", graphics, beautiful.gimp_icon }, 
    { "Shutter", "shutter", beautiful.shutter_icon }
}
-- Выключение меню --
poweroff_menu = {
   { "Рестарт", awesome.restart, beautiful.restart_icon },
   { "Выход", awesome.quit, beautiful.quit_icon },
   { "Перезагрузка", "reboot", beautiful.reboot_icon },
   { "Выключение", "poweroff", beautiful.poweroff_icon }
}
-- Таблица пунктов главного меню --
cat_menu = awful.menu({ 
    items = {                                               -- Формат описания пункта меню  
        { "Интернет", "internet_menu", beautiful.internet_icon },  -- {<Название пункта меню>, <Команда запуска>, <Иконка>}
        { "Медиа", "media_menu", beautiful.media_icon },
        { "Настройка", "settings_menu", beautiful.settings_icon },
        { "Офис", "office_menu", beautiful.office_icon },
        { "Стандартное", "other_menu", beautiful.other_icon },
        { "Выключение", "poweroff_menu", beautiful.power_icon }
    }
})

--------------------------------------------------------------------------------------
--- Лаунчер - та кнопка что на панели слева --- 
--------------------------------------------------------------------------------------
mylauncher = awful.widget.launcher({ image = beautiful.archlinux_icon, menu = cat_menu })

--------------------------------------------------------------------------------------
--  Кнопки приложений на панели задач --
--------------------------------------------------------------------------------------
-- Firefox --
browser_button = awful.widget.button({ image = beautiful.browser_icon})
browser_button:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn(browser) end)
 ))
-- Chrome --
browser2_button = awful.widget.button({ image = beautiful.browser2_icon})
browser2_button:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn(browser2) end)
 ))
-- Gimp --
graphics_button = awful.widget.button({ image = beautiful.graphics_icon})
graphics_button:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn(graphics) end)
 ))
-- Mail --
mail_button = awful.widget.button({ image = beautiful.mail_icon})
mail_button:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn(mail) end)
 ))
-- Sublime-text --
editor_button = awful.widget.button({ image = beautiful.editor_icon})
editor_button:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn(editor) end)
 ))
-- 2GIS --
gis_button = awful.widget.button({ image = beautiful.giss_icon})
gis_button:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn(gis) end)
 ))
-- PcmanFM --
fileman_button = awful.widget.button({ image = beautiful.fileman_icon})
fileman_button:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn(fileman) end)
 ))

--------------------------------------------------------------------------------------
-- Виджеты --
--------------------------------------------------------------------------------------
-- Часы -- 
-----------------------------
clockicon = wibox.widget.imagebox(beautiful.widget_clock)  --иконка часов   (библиотека wibox)
mytextclock = awful.widget.textclock(markup("#343639", ">") .. markup("#de5e1e", " %H:%M "))  --цвет и формат времени

-----------------------------
-- Календарь --
-----------------------------
lain.widgets.calendar:attach(mytextclock, { font_size = 10 })  --привязываем и задаем размер (библиотека lain)

-----------------------------
-- Сепаратор --
-----------------------------
separator = wibox.widget.textbox()  --добавляем виджет на панель (библиотека wibox)
separator:set_text(" | ")  --указываем иконку " | "

-----------------------------
-- Раскладка клавиатуры --
-----------------------------
kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
kbdcfg.layout = { { "us", "" }, { "ru", "" } }  --указываем языки
kbdcfg.current = 1  -- выбираем язык по умолчанию
kbdcfg.widget = wibox.widget.textbox()  --добавляем виджет на панель (библиотека wibox)
kbdcfg.widget:set_text(" " .. kbdcfg.layout[kbdcfg.current][1] .. " ")
kbdcfg.switch = function ()  --добавляем функционал
  kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
  local t = kbdcfg.layout[kbdcfg.current]
  kbdcfg.widget:set_text(" " .. t[1] .. " ")
  os.execute( kbdcfg.cmd .. " " .. t[1] .. " " .. t[2] )
end
-- Настройка мыши --
kbdcfg.widget:buttons(  --добавляем кнопку (виджет) на панель 
 awful.util.table.join(awful.button({ }, 1, function () kbdcfg.switch() end))  --указываем кнопку мыши (лкм)
)

----------------------------
-- Погода --
----------------------------
weathericon = wibox.widget.imagebox(beautiful.widget_weather)  --иконка виджета 
yawn = lain.widgets.yawn(2123177, {  --пишем свой zip-код города (библиотека lain)
    settings = function()  --добавляем функционал
        widget:set_markup(markup("#eca4c4", forecast:lower() .. " @ " .. units .. "°C "))  --цвет и градусы
    end
})

----------------------------
-- Alsa громкость --
----------------------------
volicon = wibox.widget.imagebox(beautiful.widget_vol)  --иконка виджета
volumewidget = lain.widgets.alsa({  --(библиотека lain)
    settings = function()  --добавляем функционал
        if volume_now.status == "off" then  --включаем
            volume_now.level = volume_now.level .. "M"
        end
        widget:set_markup(markup("#7493d2", volume_now.level .. "% "))  --указываем цвет и громкость в "%""
    end
})

----------------------------
-- Скорость интернета --
----------------------------
netdownicon = wibox.widget.imagebox(beautiful.widget_netdown)  --иконка виджета
netdowninfo = wibox.widget.textbox()  --скорость принятия
netupicon = wibox.widget.imagebox(beautiful.widget_netup)  --иконка виджета
netupinfo = lain.widgets.net({  --скорость отдачи (библиотека lain)
    settings = function()  --добавляем функционал
        widget:set_markup(markup("#e54c62", net_now.sent .. " "))  --задаем цвет отдачи
        netdowninfo:set_markup(markup("#87af5f", net_now.received .. " "))  --задаем цвет принятия
    end
})

---------------------------
-- Загрузка RAM --
---------------------------
memicon = wibox.widget.imagebox(beautiful.widget_mem)  --иконка виджета
memwidget = lain.widgets.mem({  --(библиотека lain)
    settings = function()  --добавляем функционал
        widget:set_markup(markup("#e0da37", mem_now.used .. "M "))  --задаем цвет и указываем значение в МБ
    end
})

---------------------------
-- Загрузка CPU --
---------------------------
cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)  --иконка виджета
cpuwidget = lain.widgets.cpu({  --(библиотека lain)
    settings = function()  --добавляем функционал
        widget:set_markup(markup("#e33a6e", cpu_now.usage .. "% "))  --задаем цвет и указываем значение в "%""
    end
})

---------------------------
-- Время вкл. компа --
---------------------------
uptime = wibox.widget.textbox()  --добавляем виджет на панель                      --(библиотека vicious)
vicious.register(uptime, vicious.widgets.uptime, " $2 hours $3 minutes ")  --указываем значение: часы и минуты
uptimewidget = wibox.widget.background()  --фон виджета
uptimewidget:set_widget(uptime)  --выбираем наш виджет 
uptimewidget:set_bgimage(beautiful.widget_bg)  --цвет виджета
uptime_icon = wibox.widget.imagebox(beautiful.uptime)  --иконка виджета

----------------------------
-- Обновление Pacman --
----------------------------
pacicon = wibox.widget.imagebox()
pacicon:set_image(beautiful.widget_pacman)
pacwidget = wibox.widget.textbox()
vicious.register(pacwidget, vicious.widgets.pkg, "<span color='" .. beautiful.fg_blue .. "'>$1</span>", 60, "Arch")

--------------------------------------------------------------------------------------
-- Декларируем список тэгов #1 --
--------------------------------------------------------------------------------------
mywibox = {}
mypromptbox = {}
mylayoutbox = {}  --контейнер переключателей макетов расположения окон
mytaglist = {}  --контейнер панели переключения тегов
mytaglist.buttons = awful.util.table.join(  --задаем обработку кнопок мыши для списка тегов
                    awful.button({ }, 1, awful.tag.viewonly),  --отобразить тэг 
                    awful.button({ modkey }, 1, awful.client.movetotag),  --переместить клиент на данный тэг 
                    awful.button({ }, 3, awful.tag.viewtoggle),  --отобразить выбранный тэг вместе с текущим
                    awful.button({ modkey }, 3, awful.client.toggletag),  --отобразить текущий клиент в текущем и выбранном тэге
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),  --следующий тэг
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)  --предыдущий тэг
                    )
--------------------------------------------------------------------------------------
--- Декларируем список задач #1 ---
--------------------------------------------------------------------------------------
mytasklist = {}  --создаем таблицу панели задач
mytasklist.buttons = awful.util.table.join(  --прикрепляем клавиши мыши к панели задач
                     awful.button({ }, 1, function (c)  --нажатие левой кнопки
                                              if c == client.focus then  --если клиент имеет фокус, тогда
                                                  c.minimized = true  --свернуть приложение
                                              else  -- иначе, передать фокус на клиент 
                                                  c.minimized = false  --не сворачивая
                                                  if not c:isvisible() then  --если не видно, тогда
                                                      awful.tag.viewonly(c:tags()[1])  --переводим на 1-ый тег
                                                  end
                                                  client.focus = c  --это также не-минимизировать клиента, 
                                                  c:raise()  --если это необходимо
                                              end
                                          end),
                     awful.button({ }, 3, function (c)  --нажатие правой клавиши
                                               c:kill()  --щелчок правой кнопкой - закрыть окно
                                          end)
                     --awful.button({ }, 4, function ()  --боковые кнопки  --закоментирую эти строчки, так как мне не нужна прокрутка на панели задач
                                              --awful.client.focus.byidx(1)  --перейти на следующий клиент
                                              --if client.focus then client.focus:raise() end
                                          --end),
                     --awful.button({ }, 5, function ()  --боковые кнопки
                                              --awful.client.focus.byidx(-1)  --перейти на предыдущий клиент
                                              --if client.focus then client.focus:raise() end
                                          --end))
)
--------------------------------------------------------------------------------------
--- Создаем для каждого экрана панель задач #1 ---
--------------------------------------------------------------------------------------
for s = 1, screen.count() do  --цикл, перебирающий все экраны
    mypromptbox[s] = awful.widget.prompt()  --командная строка - виджет реализующий командную строку на панели задач
    mylayoutbox[s] = awful.widget.layoutbox(s)  -- кнопка переключения макетов расположения окон
    mylayoutbox[s]:buttons(awful.util.table.join(  --декларируем для неё назначения кнопок мыши
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),  --переключить на макет вперед
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),  --переключить на макет назад
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),  --то же самое для боковых кнопок
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))  --то же самое для боковых кнопок
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)  --Список тэгов: передаем номер экрана, и назначения кнопок мыши
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)  --Список запущенных задач: передаем номер экрана, и назначения кнопок мыши

--------------------------------------------------------------------------------------
-- Контейнер для всех виджетов - наша панель задач --
--------------------------------------------------------------------------------------    
    mywibox[s] = awful.wibox({ position = "top", height = "20", screen = s })  --расположенная вверху экрана номер s и шириной в 20 px

--------------------------------------------
-- Создаем виджеты расположенные слева --
--------------------------------------------
    local left_layout = wibox.layout.fixed.horizontal()  --добавляем слева виджеты последовательно
    left_layout:add(mylauncher)  --лаунчер (кнопка главного меню)
    left_layout:add(mytaglist[s])  --список тэгов
    left_layout:add(mypromptbox[s])  --командную строку
    --- Кнопки приложений --- 
    left_layout:add(browser_button)  --firefox
    left_layout:add(browser2_button)  --chrome
    left_layout:add(mail_button)  --trunderbird
    left_layout:add(graphics_button)  --gimp
    left_layout:add(editor_button)     --sublime-text

--------------------------------------------
-- Создаем виджеты расположенные справа --
--------------------------------------------    
    local right_layout = wibox.layout.fixed.horizontal()  --добавляем справа виджеты последовательно
    if s == 1 then right_layout:add(wibox.widget.systray()) end  --системный трей делаем почему-то только на первом экране
    right_layout:add(uptime_icon)  --иконка времени за компом
    right_layout:add(uptimewidget)  --время за компом
    right_layout:add(separator)  --сепаратор
    right_layout:add(pacwidget)  --Pacman обновления
    right_layout:add(separator)  --сепаратор
    right_layout:add(netdownicon)  --иконка принятия скорости
    right_layout:add(netdowninfo)  --принятие скорости
    right_layout:add(netupicon)  --иконка отдачи скорости
    right_layout:add(netupinfo)  --отдача скорости
    right_layout:add(separator)  --сепаратор
    right_layout:add(cpuicon)  --иконка CPU
    right_layout:add(cpuwidget)  --CPU
    right_layout:add(separator)  --сепаратор
    right_layout:add(memicon)  --иконка RAM
    right_layout:add(memwidget)  --RAM
    right_layout:add(separator)  --сепаратор
    right_layout:add(weathericon)  --иконка погоды
    right_layout:add(yawn.widget)  --погода
    right_layout:add(separator)  --сепаратор
    right_layout:add(kbdcfg.widget)  --раскладка клавиатуры
    right_layout:add(separator)  --сепаратор
    right_layout:add(volicon)  --иконка громкости
    right_layout:add(volumewidget)  --громкость
    right_layout:add(separator)  --сепаратор
    right_layout:add(mytextclock)  --часы
    right_layout:add(separator)  --сепаратор
    right_layout:add(mylayoutbox[s])  --кнопку переключения макетов

-----------------------------------------------
-- Создаем контейнер для всей панели задач --
-----------------------------------------------    
    local layout = wibox.layout.align.horizontal()  --добавляем везде виджеты последовательно
    layout:set_left(left_layout)  --добавляем виджеты слева
    layout:set_middle(mytasklist[s])  --располагаем список задач в центре панели
    layout:set_right(right_layout)  --добавляем виджеты справа

    mywibox[s]:set_widget(layout)  --контейнер для всех виджетов
end

--------------------------------------------------------------------------------------
-- Горячие клавиши для всей системы--
--------------------------------------------------------------------------------------
-- Назначения мыши --
--------------------------------------------
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),  --правая кнопка - вызов меню
    awful.button({ }, 4, awful.tag.viewnext),  --боковые кнопки - переключение тэгов по порядку
    awful.button({ }, 5, awful.tag.viewprev)  --боковые кнопки - переключение тэгов по порядку
))

--------------------------------------------------------------------------------------
-- Назначения клавиатуры --
--------------------------------------------------------------------------------------
-- Глобальные назначения клавиш --
--------------------------------------------
globalkeys = awful.util.table.join(  --переключение рабочих столов
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),  --переключение назад
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),  --переключение вперед
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),  --выбрать предыдущий выбранный набор тегов

--------------------------------------------
-- Переключение фокуса клиентских окон
--------------------------------------------
    awful.key({ modkey,           }, "j",  --следующий клиент
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",  --предыдущий клиент
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),  --Открыть главное меню

---------------------------------------------------------------
-- Манипуляция областями экрана (перестановка клиентов) --
---------------------------------------------------------------
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),  --поменять текущий и следующий за ним клиенты местами
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),  --поменять текущий и предыдущий клиенты местами
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),  --следующий экран
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),  --предыдущий экран
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),  --первый клиент в режиме повышенного внимания
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

--------------------------------------------
-- Переключение раскладки клавы --
--------------------------------------------
    awful.key({ "Mod1" }, "Shift_R", function () kbdcfg.switch() end)  --переключаем раскладку

--------------------------------------------
-- Запуск стандартных программ --
--------------------------------------------
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),  --запустить эмулятор терминала
    awful.key({ modkey, "Control" }, "r", awesome.restart),  --перезапустить awesome
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),  --выйти из awesome
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),  --увеличить главную зона на 5%
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),  --уменьшить главную зону на 5%
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),  --увеличить число окон в главной зоне на 1
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),  --уменьшить число окон в главной зоне на 1
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),  --увеличить число колонок для стековой зоны на 1
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),  --уменьшить число колонок для стековой зоны на 1
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),  --выбрать следующую схему
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),  --выбрать предыдущую схему
    awful.key({ modkey, "Control" }, "n", awful.client.restore),  --восстановить

--------------------------------------------
-- Alsa громкость --
--------------------------------------------
awful.key({ altkey }, "Up",  --увеличить громкость
function ()
    awful.util.spawn("amixer set Master 1%+")
    volumewidget.update()
end),
awful.key({ altkey }, "Down",  --уменьшить громкость
function ()
    awful.util.spawn("amixer set Master 1%-")
    volumewidget.update()
end),
awful.key({ altkey }, "m",  --
function ()
    awful.util.spawn("amixer set Master playback toggle")
    volumewidget.update()
end),
awful.key({ altkey, "Control" }, "m",  --  
function ()
    awful.util.spawn("amixer set Master playback 100%", false )
    volumewidget.update()
end),

--------------------------------------------
-- Строка запуска приложений --
--------------------------------------------
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),  --открыть командную строку

    awful.key({ modkey }, "x",  --открыть командную строку для выполнения Lua-кода
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

--------------------------------------------
-- Dmenu --
--------------------------------------------    
awful.key({modkey }, "p", function()  --открывает dmenu
  awful.util.spawn_with_shell( "exe=`dmenu_path | dmenu -b -nf '#DFF70B' -nb '#06422D' -sf '#FFFFFF' -sb '#06A592'` && exec $exe")
end)
)

--------------------------------------------    
-- Клиентские назначения клавиш --
--------------------------------------------        
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),  --полноэкранный режим
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),  --убить выбранный клиент
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),  --переключить плавающий режим для текущего клиента
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),  --поменять текущий и главный клиенты местами
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),  --отправить клиент на следующий экран
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),  --прикрепить поверх всех
    awful.key({ modkey,           }, "n",  --свернуть
        function (c)
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",  --Развернуть на весь экран
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

--------------------------------------------------------------------------------------
-- Переключение тэгов и операции с клиентами и тэгами на каждом из экранов --
--------------------------------------------------------------------------------------
for i = 1, 9 do                                      --форма: modkey + <номер тэга>
    globalkeys = awful.util.table.join(globalkeys,  
        awful.key({ modkey }, "#" .. i + 9,  --переключиться в выбранный тэг
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),                                 --форма: modkey + Ctrl + <номер тэга>
        awful.key({ modkey, "Control" }, "#" .. i + 9,  --совместить выбранный тэг с текущим
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),                                --форма: modkey + <номер тэга>
        awful.key({ modkey, "Shift" }, "#" .. i + 9,  --Переместить клиент в фокусе на выбранный тэг
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),                                          --форма: modkey + <номер тэга>
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,  --переместить клиент в фокусе на выбранный тэг, оставив его и в текущем тэге
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

--------------------------------------------------------------------------------------
-- Назначение кнопок мыши для каждого клиент --
--------------------------------------------------------------------------------------
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),  --переключить фокус
    awful.button({ modkey }, 1, awful.mouse.client.move),  --переместить
    awful.button({ modkey }, 3, awful.mouse.client.resize))  --изменить размер

-- Задать глобальные клавиши --
root.keys(globalkeys)

--------------------------------------------------------------------------------------
-- Роли приложений --
--------------------------------------------------------------------------------------
awful.rules.rules = {  
    { rule = { },  --главная роль для всех приложений
      properties = { border_width = beautiful.border_width,  --задается толщина рамки окна
                     border_color = beautiful.border_normal,  --цвет рамки окна не в фокусе
                     focus = awful.client.focus.filter,  --передает фокус на заданное окно
                     raise = true,  --поднять
                     keys = clientkeys,  --горячие клавиши
                     buttons = clientbuttons } },  --кнопки мыши
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "URxvt" },
      properties = { tag = tags[1][3] } },
    { rule = { class = "Transmission-gtk" },
      properties = { tag = tags[1][5] } },
    { rule = { class = "Vlc" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "sublime-text" },
      properties = { tag = tags[1][1] } },
    { rule = { class = "Pcmanfm" },
      properties = { tag = tags[1][1] } },
    { rule = { class = "Audacious" },
      properties = { tag = tags[1][6] } },
    { rule = { class = "Gpicview" },
      properties = { tag = tags[1][7] } },
    { rule = { class = "Evince" },
      properties = { tag = tags[1][7] } },
    { rule = { class = "Ristretto" },
      properties = { tag = tags[1][7] } },
    { rule = { class = "Steam" },
      properties = { tag = tags[1][5] } },
    { rule = { class = "Google-chrome-unstable" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Skype" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Thunderbird" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "FBReader" },
      properties = { tag = tags[1][7] } },
    { rule = { class = "libreoffice-writer" },
      properties = { tag = tags[1][1] } },                
    { rule = { class = "Gimp" },
      properties = { tag = tags[1][7] } },
    { rule = { class = "Wine" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "Tor Browser" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Vidalia" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "File-roller" },
      properties = { tag = tags[1][7] } },
    { rule = { class = "Ristretto" },
      properties = { tag = tags[1][7] } },
    { rule = { class = "7zFM" },
      properties = { tag = tags[1][7] } },
    { rule = { class = "Lxappearance" },
      properties = { tag = tags[1][7] } },
    { rule = { class = "VirtualBox" },
      properties = { tag = tags[1][7] } },
    { rule = { instance = "plugin-container"},  --для отображения flash в firefox на весь экран
      properties = { onfocus = true, floating = true, border_width = 0, ontop = true, fullscreen = true } }

--------------------------------------------------------------------------------------
-- Сигналы --
--------------------------------------------------------------------------------------
client.connect_signal("manage", function (c, startup)  --включить неаккуратный фокус
    c:connect_signal("mouse::enter", function(c)  --сигналы терминала
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then  --если не напускается, то

        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then

        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)

--------------------------------------------------------------------------------------
-- Нарисовать заголовок окна --
--------------------------------------------------------------------------------------
-- Виджет слева от заголовка окна --
--------------------------------------------        
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

--------------------------------------------
-- Виджеты в правой части заголовка окна --
--------------------------------------------
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

--------------------------------------------
-- Заголовок окна --
--------------------------------------------
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

--------------------------------------------
-- Расставляем блоки виджетов по местам --
--------------------------------------------        
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)
-- Добавляем их на заголовок окна --
        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)  --у окон в фокусе и раскрасить рамку соответствено
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)  --у окон не в фокусе и раскрасить рамку нормально

--------------------------------------------
-- Авто-старт программ --
--------------------------------------------
os.execute("pgrep -u $USER -x nm-applet || (nm-applet &)")
os.execute("pgrep -u $USER -x kbdd || (kbdd &)")
os.execute("pgrep -u $USER -x xscreensaver || (xscreensaver -nosplash &)")
