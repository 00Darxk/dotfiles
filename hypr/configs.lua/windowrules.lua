-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/ for more


hl.window_rule({
    match     = { class = "^(pavucontrol)$"},
    float     = true
})
hl.window_rule({
    match     = { class = "^(blueman-manager)$"},
    float     = true
})
hl.window_rule({
    match     = { class = "^(nm-connection-editor)$"},
    float     = true
})
hl.window_rule({
    match     = { class = "^(zenity)$"},
    float     = true
})
hl.window_rule({
    match     = { class = "^(chromium)$"},
    float     = true,
    enabled   = false
})
hl.window_rule({
    match     = { class = "^(btop)$"},
    float     = true,
    enabled   = false
})
hl.window_rule({
    match     = { class = "^(nmtui)$"},
    float     = true,
    enabled   = false
})
hl.window_rule({
    match     = { class = "^(unityhub)$"},
    float     = true
})
hl.window_rule({
    match     = { title = "^(Aggiornamenti)$"},
    float     = true,
    animation = "popin",
    enabled   = false
})
hl.window_rule({
    match     = { title = "^(Media Viewer)$"},
    float     = true
})
hl.window_rule({
    match     = { class = "^(kitty)$"},
    opacity   = "0.95 0.6"
})
hl.window_rule({
    match     = { class = "^(org.gnome.Terminal)$"},
    opacity   = "0.95 0.6"
})
hl.window_rule({
    match     = { class = "^(XTerm)$"},
    opacity   = "0.95 0.6"
})
hl.window_rule({
    match     = { class = "^(thunar)$"},
    float     = true,
    opacity   = "0.95 0.8",
})
hl.window_rule({
    match     = { class = "^(codium)$"},
    opacity   = "0.95 0.8"
})
hl.window_rule({
    match     = { class = "^(chromium)$"},
    opacity   = "0.95 0.8",
    animation = "popin"
})
hl.window_rule({
    match     = { class = "^(rofi)$"},
    opacity   = "0.95 0.8",
    no_anim   = true
})


hl.layer_rule({
    match          = { namespace = "rofi" },
    blur           = true,
    xray           = true,
    ignore_alpha   = 0
})