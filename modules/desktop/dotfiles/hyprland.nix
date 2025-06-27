{
  cfg,
  lib,
}:
with lib; let
in ''
  # Monitors
  ${concatMapStringsSep "\n" (monitor: "monitor = ${monitor}") cfg.hyprland.monitors}

  # Aliases for programs
  $terminal = wezterm
  $browser = brave

  # Autostart necessary processes
  exec-once = hyprpaper
  exec-once = hyprctl setcursor Bibata-Modern-Classic ${toString cfg.cursor_size}

  # Cursor
  env = XCURSOR_THEME,Bibata-Modern-Classic
  env = XCURSOR_SIZE,${toString cfg.cursor_size}
  ${concatMapStringsSep "\n" (env: "env = ${env}") cfg.variables}

  # https://wiki.hyprland.org/Configuring/Variables/
  general {
      gaps_in = ${toString (cfg.hyprland.gaps / 2)}
      gaps_out = ${toString cfg.hyprland.gaps}
      border_size = ${toString cfg.hyprland.border_size}
      col.active_border = rgba(514d4add)
      col.inactive_border = rgba(2a2624dd)
      resize_on_border = true
      allow_tearing = true
      layout = master
      no_focus_fallback = true
  }
  decoration {
      rounding = ${toString cfg.hyprland.rounding}
      rounding_power = 2
      active_opacity = 1.0
      inactive_opacity = 1.0
      dim_inactive = true
      dim_strength = 0.05
      shadow {
          enabled = true
          range = 200
          scale = 0.9
          render_power = 4
          color = rgba(1a1a1aaf)
          color_inactive = rgba(1a1a1a8c)
      }
      blur {
          enabled = false
      }
  }
  misc {
      force_default_wallpaper = 0 # Set to 0 or 1 to disable the anime mascot wallpapers
      disable_hyprland_logo = true # If true disables the random hyprland logo / anime girl background. :(
  }

  # https://wiki.hyprland.org/Configuring/Animations/
  animations {
      enabled = no
  }

  master {
    mfact = 0.50
  }

  # https://wiki.hyprland.org/Configuring/Variables/#input
  input {
      kb_layout = us
      follow_mouse = 1
      sensitivity = ${toString cfg.hyprland.mouse_sensitivity}
  }

  # https://wiki.hyprland.org/Configuring/Variables/#gestures
  gestures {
      workspace_swipe = false
  }

  # Keybinds
  # https://wiki.hyprland.org/Configuring/Keywords/
  $mainMod = SUPER

  bind = $mainMod, T, exec, $terminal
  bind = $mainMod, Q, killactive,
  bind = $mainMod, M, exit,
  bind = $mainMod, W, togglefloating,
  bind = $mainMod, P, exec, $menu
  bind = $mainMod, B, exec, $browser
  bind = $mainMod, S, exec, hyprshot -m window

  # Move focus through list of windows
  bind = $mainMod, K, layoutmsg, cyclenext
  bind = $mainMod, J, layoutmsg, cycleprev
  bind = $mainMod SHIFT, K, layoutmsg, swapnext
  bind = $mainMod SHIFT, J, layoutmsg, swapprev

  # Change layout orientation
  bind = $mainMod, grave, layoutmsg, orientationcycle left right
  # Repeatable binds for resizing the active window
  binde = $mainMod,L,resizeactive,50 0
  binde = $mainMod,H,resizeactive,-50 0

  # increase decrease master
  bind = $mainMod,A,layoutmsg,addmaster
  bind = $mainMod,R,layoutmsg,removemaster

  # Switch workspaces with mainMod + [0-9]
  bind = $mainMod, 1, workspace, 1
  bind = $mainMod, 2, workspace, 2
  bind = $mainMod, 3, workspace, 3
  bind = $mainMod, 4, workspace, 4
  bind = $mainMod, 5, workspace, 5
  bind = $mainMod, 6, workspace, 6
  bind = $mainMod, 7, workspace, 7
  bind = $mainMod, 8, workspace, 8
  bind = $mainMod, 9, workspace, 9
  bind = $mainMod, 0, workspace, 10

  # Move active window to a workspace with mainMod + SHIFT + [0-9]
  bind = $mainMod SHIFT, 1, movetoworkspace, 1
  bind = $mainMod SHIFT, 2, movetoworkspace, 2
  bind = $mainMod SHIFT, 3, movetoworkspace, 3
  bind = $mainMod SHIFT, 4, movetoworkspace, 4
  bind = $mainMod SHIFT, 5, movetoworkspace, 5
  bind = $mainMod SHIFT, 6, movetoworkspace, 6
  bind = $mainMod SHIFT, 7, movetoworkspace, 7
  bind = $mainMod SHIFT, 8, movetoworkspace, 8
  bind = $mainMod SHIFT, 9, movetoworkspace, 9
  bind = $mainMod SHIFT, 0, movetoworkspace, 10

  # Scroll through existing workspaces with mainMod + scroll
  bind = $mainMod, mouse_down, workspace, e+1
  bind = $mainMod, mouse_up, workspace, e-1

  # Move/resize windows with mainMod + LMB/RMB and dragging
  bindm = $mainMod, mouse:272, movewindow
  bindm = $mainMod, mouse:273, resizewindow

  # Bindings
  ${concatMapStringsSep "\n" (bind: "${bind}") cfg.hyprland.binds}
  bindl = , XF86AudioPlay, exec, playerctl play-pause

  # Ignore maximize requests from apps
  windowrule = suppressevent maximize, class:.*
  # Fix some dragging issues with XWayland
  windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
''
