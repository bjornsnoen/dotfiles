local one_screen = {
    { rule = { class = 'Slack' }, properties = { tag = '9' } },
    { rule = { class = 'Brave-browser' }, properties = { tag = '2' } },
    { rule = { class = 'kitty' }, properties = { tag = '1' } },
    { rule = { class = 'Evolution' }, properties = { tag = '3' } },
}

local two_screens = {
    { rule = { class = 'Slack' }, properties = { screen = 2, tag = '1' } },
    { rule = { class = 'kitty' }, properties = { screen = 1, tag = '1' } },
    { rule = { class = 'Brave-browser' }, properties = { screen = 1, tag = '2' } },
    { rule = { class = 'Evolution' }, properties = { screen = 1, tag = '3' } },
}

local three_screens = {
    { rule = { class = 'Slack' }, properties = { screen = 2, tag = '1' } },
    { rule = { class = 'kitty' }, properties = { screen = 1, tag = '1' } },
    { rule = { class = 'Brave-browser' }, properties = { screen = 1, tag = '1' } },
    { rule = { class = 'Evolution' }, properties = { screen = 3, tag = '3' } },
}

local setups = {
    one_screen,
    two_screens,
    three_screens,
}

local function get_layout(num_screens)
    -- tables are 1 indexed
    return setups[num_screens]
end

return get_layout
