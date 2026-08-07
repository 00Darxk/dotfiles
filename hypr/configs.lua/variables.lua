-- For all categories, see https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
    general = {
        gaps_in      = 5,
        gaps_out     = 10,
        border_size  = 1,
        col          = {
            active_border   = "#cdd6f4",
            inactive_border = "#595959aa"
        },
        layout       = "dwindle"
    },
    input   = {
        kb_layout    = "it",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "",
        kb_rules     = "",
        follow_mouse = 1,
        touchpad     = { natural_scroll = true },
        sensitivity  = 0 -- -1.0 - 1.0, 0 means no modification.
    },
    decoration = {
        rounding = 10,
        blur     = {
            enabled = true,
            size    = 3,
            passes  = 1,
            xray    = true
        },
        shadow  = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "#1a1a1aee"
        }
    },
    -- master  = { new_status             = true },
    dwindle = { preserve_split         = true },
    misc    = { disable_hyprland_logo  = true },
    binds   = { allow_workspace_cycles = true }
})


hl.gesture({
   fingers   = 3,
   direction = "horizontal",
   action    = "workspace"
})
