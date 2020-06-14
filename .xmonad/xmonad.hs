import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.FloatKeys
import XMonad.Actions.GridSelect
import XMonad.Hooks.DynamicHooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.SetWMName
import XMonad.Layout.ComboP
import XMonad.Layout.LayoutCombinators hiding ((|||))
import XMonad.Layout.LayoutHints
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.TwoPane
import XMonad.ManageHook
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig
import XMonad.Util.Run
import Control.Monad (liftM2)
import Data.Monoid
import Graphics.X11
import System.Exit
import System.IO

import qualified XMonad.Actions.FlexibleResize as Flex
import qualified XMonad.StackSet               as W
import qualified Data.Map                      as M

main = do
--xmproc <- spawnPipe "/usr/bin/xmobar /home/bpaterni/.xmobarrc"
  dzen2pipe0 <- spawnPipe dzenCommand0
  dzen2pipe1 <- spawnPipe dzenCommand1
--  spawn "~/.xmonad/dzen_script"
  xmonad $ defaultConfig {
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

    keys               = myKeys,
    mouseBindings      = myMouseBindings,

    layoutHook         = myLayout,
    logHook            = dynamicLogWithPP $ mPP dzen2pipe0,
    manageHook         = manageDocks <+> myManageHook
--    startupHook    = myStartupHook
  }
    `additionalKeys` [
      ((controlMask .|. mod1Mask, xK_b), spawn "iceweasel-pl"),
      ((controlMask .|. mod1Mask, xK_i), spawn "icedove"),
      ((controlMask .|. mod1Mask, xK_f), spawn "/usr/bin/worker"),
      ((controlMask .|. mod1Mask, xK_g), spawn "/usr/bin/gedit"),
      --((controlMask .|. mod1Mask, xK_t), spawn "/usr/bin/urxvt"),
      ((controlMask .|. mod1Mask, xK_t), spawn "/usr/bin/kitty"),
      ((controlMask .|. mod1Mask, xK_c), spawn "/usr/bin/gnome-calculator"),
      ((controlMask .|. mod1Mask, xK_l), spawn "/usr/bin/xscreensaver-command -lock")
    ]

colorOrange          = "#ff7701"

--myTerminal           = "urxvt"
myTerminal           = "kitty"
myFocusFollowsMouse  = True
myBorderWidth        = 1
myModMask            = mod4Mask
myWorkspaces         = ["1","2","3","4","5","6","7","8","9","0"]
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full) ||| Full
  where
    tiled  = Tall nmaster delta ratio
    nmaster  = 1
    ratio  = 1/2
    delta  = 3/100

--dzenCommand0  = "/usr/bin/dzen2 -fg grey -bg '#000000' -w 1920 -x 0 -y 0 -ta l"
--dzenCommand0  = "/usr/bin/dzen2 -w 1920 -x 0 -y 0 -ta l"
--dzenCommand0  = "/usr/bin/dzen2 -fg grey -bg black -fn '-*-*-bold-*-*-*-*-*-*-*-*-*-*-*' -w 1920 -x 0 -y 0 -ta l"
-- Single Monitor
--dzenCommand0  = "/usr/bin/dzen2 -fg grey -bg black -fn '-*-*-bold-*-*-*-*-*-*-*-*-*-*-*' -w 1280 -x 0 -y 0 -ta l"
dzenCommand0  = "/usr/bin/dzen2 -fg grey -bg black -fn '-*-*-bold-*-*-*-*-*-*-*-*-*-*-*' -w 2560 -x 0 -y 0 -ta l"
--dzenCommand1  = "~/.xmonad/dzen_script | dzen2 -bg '#000000' -fg '#aaaaaa' -w 1440 -ta r -x 1920"
--dzenCommand1  = "~/.xmonad/dzen_script | dzen2 -w 1440 -ta r -x 1920"
--dzenCommand1  = "~/.xmonad/dzen_script | dzen2 -fg grey -bg black -fn '-*-*-bold-*-*-*-*-*-*-*-*-*-*-*' -w 1920 -ta r -x 1920"
dzenCommand1  = "~/.xmonad/dzen_script | dzen2 -fg grey -bg black -fn '-*-*-bold-*-*-*-*-*-*-*-*-*-*-*' -w 2560 -ta r -x 2560"


mPP h = defaultPP
  {
    ppCurrent  = wrap ("^fg(green)^bg(black)^p(2)") "^p(2)^fg()^bg()",
    ppVisible  = wrap ("^fg(" ++ colorOrange ++ ")^bg(black)^p(2)") "^p(2)^fg()^bg()",
    ppSep      = " ^fg(grey60)^r(1x8)^fg() ",
    ppTitle    = dzenColor "green" "" . trim,
    ppOutput   = hPutStrLn h
  }


myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $ [
  ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf),
  ((mod1Mask,           xK_F4),     kill),
  ((modm,               xK_space),  sendMessage NextLayout),
  ((modm .|. shiftMask, xK_space),  setLayout $ XMonad.layoutHook conf),
  ((modm,               xK_n),      refresh),
  ((mod1Mask,           xK_Tab),    windows W.focusDown),
  ((modm,               xK_j),      windows W.focusDown),
  ((modm,               xK_k),      windows W.focusUp),
  ((modm,               xK_m),      windows W.focusMaster),
  ((modm,               xK_Return), windows W.swapMaster),
  ((modm .|. shiftMask, xK_j),      windows W.swapDown),
  ((modm .|. shiftMask, xK_k),      windows W.swapUp),
  ((modm,               xK_h),      sendMessage Shrink),
  ((modm,               xK_l),      sendMessage Expand),
  ((modm,               xK_t),      withFocused $ windows . W.sink),
  ((modm,               xK_comma),  sendMessage (IncMasterN 1)),
  ((modm,               xK_period), sendMessage (IncMasterN (-1))),
  ((modm .|. shiftMask, xK_q),      io (exitWith ExitSuccess)),
  ((modm,               xK_q),      spawn "xmonad --recompile; xmonad --restart")
  ]
  ++
  [((m .|. modm, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
      (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
  ]
  ++
  [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..],
      (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $ [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster)),
    -- mod-button2, Raise the window to the top of the stack
    ((modm, button2), (\w -> focus w >> windows W.shiftMaster)),
    -- mod-button3, Set the window to floating mode and resize by dragging
  ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
  ]


myManageHook = composeAll [
  isDialog                      --> doFloat,
  isFullscreen                  --> doFullFloat,
  className =? "mplayer2"       --> doFloat,
  className =? "mpv"            --> doFloat,
  className =? "Gimp"           --> doFloat,
  className =? "Gcalctool"      --> doFloat,
  className =? "Java"           --> doFloat,
  className =? "Gedit"          --> doFloat,
  className =? "Synaptic"       --> doFloat,
  className =? "Audacity"       --> doFloat,
  className =? "Pidgin"         --> doFloat,
  className =? "Buddy List"     --> doFloat,
  className =? "Hoop World"     --> doFloat,
  className =? "java"           --> doFloat,
  className =? "hl_linux"       --> doFloat,
  className =? "stalonetray"    --> doIgnore,
  resource  =? "desktop_window" --> doIgnore,
  resource  =? "kdesktop"       --> doIgnore
  ]
