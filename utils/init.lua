local awful = require('awful')

local utils = {}

function utils.log(level, message, ...)
    -- level = 0
    if level == 0 then return end
    message = string.format(message,...)
    if level == 1 then
        io.stdout:write(message)
    elseif level ==2 then
        io.stderr:write(message)
    end
end

function utils.float_tostring(no)
    return tostring(no):gsub(",", ".")
end


function utils.update_user_name(update)
    awful.spawn.easy_async_with_shell([[
        fullname="$(getent passwd `whoami` | cut -d ':' -f 5 | cut -d ',' -f 1 | tr -d "\n")"
        if [ -z "$fullname" ];
        then
                printf "$(whoami)@$(hostname)"
        else
            printf "$fullname"
        fi
        ]], function(stdout)
        update(stdout:gsub('%\n', ''))
    end)
end


function utils.get_date_ordinal(date)
    local ordinal = nil
    local first_digit = string.sub(date, 0, 1)
    local last_digit = string.sub(date, -1)
    if first_digit == '0' then date = last_digit end

    if last_digit == '1' and date ~= '11' then
        ordinal = 'st'
    elseif last_digit == '2' and date ~= '12' then
        ordinal = 'nd'
    elseif last_digit == '3' and date ~= '13' then
        ordinal = 'rd'
    else
        ordinal = 'th'
    end

    return date .. ordinal
end

-- Get current time
function utils.current_time(format)
    return os.date(format or '%H:%M:%S')
end

-- Parse HH:MM:SS to seconds
function utils.parse_to_seconds(time)
    -- Convert HH in HH:MM:SS
    local hour_sec = tonumber(string.sub(time, 1, 2)) * 3600
    -- Convert MM in HH:MM:SS
    local min_sec = tonumber(string.sub(time, 4, 5)) * 60
    -- Get SS in HH:MM:SS
    local get_sec = tonumber(string.sub(time, 7, 8))
    -- Return computed seconds
    return (hour_sec + min_sec + get_sec)
end

-- Get time difference
function utils.time_diff(future, past)
    local diff = utils.parse_to_seconds(future) - utils.parse_to_seconds(past)
    if diff < 0 then
        diff = diff + (24 * 3600) --If time difference is negative, the future is meant for tomorrow
    end
    return diff
end

function utils.time_until(future)
    return utils.time_diff(future,utils.current_time())    
end

function utils.indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

function utils.clientIsVisible(c)
    if c.instance == "QuakeDD" then return false end
    if c.sticky and not c.hidden then return true end
    for s in screen do
        local tags = s.tags
        for _, t in ipairs(tags) do
            if t.selected then
                local ctags = c:tags()
                for _, v in ipairs(ctags) do
                    if v == t then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function utils.raiseVisibleClientsByIdx(idx)
    local clients = {}
    local  focusedIdx = nil 
    for _, c in ipairs(client.get()) do
        if utils.clientIsVisible(c) then
            table.insert(clients, c)
            if c.active == true then 
                focusedIdx = #clients
            end
        end
    end
    if focusedIdx == nil then return end
    local len = #clients
    focusedIdx = focusedIdx + idx
    focusedIdx = focusedIdx % len
    if focusedIdx == 0 then focusedIdx = len end
    clients[focusedIdx]:emit_signal("request::activate", "client.focus.byidx",
    {raise=true})
end

return utils