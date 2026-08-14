-- Directional window move that copes with the cases Hyprland's movewindow
-- gets wrong: it no-ops between equal siblings, and when the neighbour is a
-- different size or lives on another monitor the window lands on the wrong
-- side of it. Each case gets a correcting dispatch.

local function metrics(window)
  local at, size = window.at, window.size

  return {
    address = window.address,
    x = at.x,
    y = at.y,
    width = size.x,
    height = size.y,
    center_x = at.x + size.x / 2,
    center_y = at.y + size.y / 2,
    monitor = window.monitor and window.monitor.name,
  }
end

-- Hyprland has no "what window is over there" query, so borrow the focus
-- dispatcher: focus the neighbour, read it, focus back.
local function neighbour(direction, origin)
  hl.dispatch(hl.dsp.focus({ direction = direction }))
  local found = hl.get_active_window()
  hl.dispatch(hl.dsp.focus({ window = origin }))

  if found and found.address ~= origin.address then
    return found
  end
end

local function move(direction)
  local active = hl.get_active_window()
  if not active then
    return
  end

  local from = metrics(active)
  local target = neighbour(direction, active)
  local to = target and metrics(target) or from
  local horizontal = direction == "l" or direction == "r"

  hl.dispatch(hl.dsp.window.move({ direction = direction }))

  if to.monitor ~= from.monitor then
    if from.center_y > to.center_y then
      hl.dispatch(hl.dsp.window.swap({ direction = "d" }))
    end
  elseif horizontal and from.height ~= to.height then
    if direction == "r" and from.center_y > to.center_y then
      hl.dispatch(hl.dsp.window.move({ direction = "d" }))
    elseif direction == "l" and from.center_y < to.center_y then
      hl.dispatch(hl.dsp.window.move({ direction = "u" }))
    end
  elseif not horizontal and from.width ~= to.width then
    if direction == "u" and from.center_x < to.center_x then
      hl.dispatch(hl.dsp.window.move({ direction = "l" }))
    elseif direction == "d" and from.center_x > to.center_x then
      hl.dispatch(hl.dsp.window.move({ direction = "r" }))
    end
  else
    local moved = hl.get_active_window()
    if moved and moved.at.x == from.x and moved.at.y == from.y then
      hl.dispatch(hl.dsp.window.swap({ direction = direction }))
    end
  end
end

return { move = move }
