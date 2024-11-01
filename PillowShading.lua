local sprite = app.site.sprite
if sprite.selection.isEmpty then
	return app.alert("I cannot process an empty selection!")
end

local data
local dlg = Dialog():number{ id="max_iterations", label="Max Iterations (0 is max possible iterations):", text="0", decimals=0 }
dlg:modify{ title = "Pillow Shader" }
dlg:number{ id="iteration_size", label="Iteration size:", text="1", decimals=0 }
dlg:newrow{ always=false }
dlg:radio { id="selection_circle", label = "Selection settings", text = "Circle", selected = true,
	onclick = function()
		dlg:modify {
			id = "selection_rectangle",
			selected = false
		}
	end
} 
dlg:newrow()
dlg:radio { id="selection_rectangle", label = "", text = "Square", selected = false,
	onclick = function()
		dlg:modify {
			id = "selection_circle",
			selected = false
		}
	end
}
dlg:newrow()
dlg:newrow()
dlg:radio { id="contract", label="", text="Shrink", selected = true,
	onclick = function()
		dlg:modify {
			id = "expand",
			selected = false
		}
	end
}
dlg:newrow()
dlg:radio { id="expand", label="", text="Expand", selected = false,
	onclick = function()
		dlg:modify {
			id = "contract",
			selected = false
		}
	end
}
dlg:newrow()
dlg:check { id="force_grayscale", label="Act as heightmap", selected = false, 
	onclick = function()
		if not dlg.data.force_grayscale then
			dlg:modify {
				id = "hue_interp",
				selected = true
			}
			dlg:modify {
				id = "sat_interp",
				selected = true
			}
			dlg:modify {
				id = "val_interp",
				selected = true
			}
			dlg:modify {
				id = "alpha_interp",
				selected = true
			}
		else
			dlg:modify {
				id = "hue_interp",
				selected = false
			}
			dlg:modify {
				id = "sat_interp",
				selected = false
			}
			dlg:modify {
				id = "val_interp",
				selected = false
			}
			dlg:modify {
				id = "alpha_interp",
				selected = false
			}
		end
	end
}
dlg:newrow()
dlg:check { id="hue_interp", label = "Interpolate in (Hue, Sat, Val, Alpha)", text = "h", selected = true, last_selection = true }
dlg:check { id="sat_interp", text = "s", selected = true, last_selection = true }
dlg:check { id="val_interp", text = "v", selected = true, last_selection = true }
dlg:check { id="alpha_interp", text = "a", selected = true, last_selection = true }
dlg:newrow()
dlg:button { id="confirm", text="Confirm", focus = true }
dlg:button { id="cancel", text="Cancel" }
dlg:show()
data = dlg.data
if data.confirm then
	if (data.iteration_size < 1) then
		app.alert("I cannot process an iteration size that is not a positive number, so iteration size has been set to 1!")
		data.iteration_size = 1
	end
	local iterations = 0
	local brush_type = "circle"
	local size_change = data.iteration_size
	local max_iterations = data.max_iterations
	if data.selection_rectangle == true then
		brush_type = "square"
	end
	
	if data.contract == true then
		while (not sprite.selection.isEmpty) do
			if (max_iterations > 0 and iterations > max_iterations) then
				break
			end
			iterations = iterations + 1
			app.command.modifySelection {
				modifier = "contract",
				quantity = size_change,
				brush = brush_type
			}
		end
	else
		while (sprite.selection.bounds.width < sprite.bounds.width or sprite.selection.bounds.height < sprite.bounds.height) do
			if (max_iterations > 0 and iterations > max_iterations) then
				break
			end
			iterations = iterations + 1
			app.command.modifySelection {
				modifier = "expand",
				quantity = size_change,
				brush = brush_type
			}
		end
	end
		
	
	local start_col = app.fgColor
	local return_start_col = start_col
	local end_col = app.bgColor
	local return_end_col = end_col
	local iter = iterations - 1
	local h_inc = 0
	local s_inc = 0
	local v_inc = 0
	local a_inc = 0
	local r_inc = 0
	local g_inc = 0
	local b_inc = 0
	local greyscale = data.force_grayscale
	if not greyscale then
		if (data.hue_interp) then
			h_inc = ((end_col.hue - start_col.hue) / iter)
		end
		if (data.sat_interp) then
			s_inc = ((end_col.saturation - start_col.saturation) / iter)
		end
		if (data.val_interp) then
			v_inc = ((end_col.value - start_col.value) / iter)
		end
		if (data.alpha_interp) then
			a_inc = ((end_col.alpha - start_col.alpha) / iter)
		end
	else
		local new_start = Color {
			red = app.fgColor.gray,
			green = app.fgColor.gray,
			blue = app.fgColor.gray
		}
		start_col = new_start
		app.fgColor = start_col

		local new_end = Color {
			red = app.bgColor.gray,
			green = app.bgColor.gray,
			blue = app.bgColor.gray,
		}
		end_col = new_end
		app.bgColor = end_col

		r_inc = ((end_col.red - start_col.red) /  iter)
		if r_inc < 1 and r_inc > 0 then
			r_inc = 1
		elseif r_inc > -1 and r_inc < 0 then
			r_inc = -1
		end

		g_inc = ((end_col.green - start_col.green) / iter)
		if g_inc < 1 and g_inc > 0 then
			g_inc = 1
		elseif g_inc > -1 and g_inc < 0 then
			g_inc = -1
		end

		b_inc = ((end_col.blue - start_col.blue) / iter)
		if b_inc < 1 and b_inc > 0 then
			b_inc = 1
		elseif b_inc > -1 and b_inc < 0 then
			b_inc = -1
		end
	end
	
	local undo_num = iterations;
	while undo_num > 0 do
		app.command.Undo()
		undo_num = undo_num - 1
	end
	
	local current_iteration = 0
	if data.contract == true then
		while (not sprite.selection.isEmpty) do
			if (max_iterations > 0 and current_iteration > max_iterations) then
				break
			end
			app.command.Fill()
			if not greyscale then
				app.fgColor = Color {
					hue 		= app.fgColor.hue + h_inc,
					saturation 	= app.fgColor.saturation + s_inc,
					value 		= app.fgColor.value + v_inc,
					alpha 		= app.fgColor.alpha + a_inc
				}
			else
				app.fgColor = Color {
					r		= app.fgColor.red + r_inc,
					g		= app.fgColor.green + g_inc,
					b		= app.fgColor.blue + b_inc
				}
			end
			app.command.ModifySelection {
				modifier = "contract",
				quantity = size_change,
				brush = brush_type
			}
			current_iteration = current_iteration + 1
		end
	else
		app.command.modifySelection {
			modifier = "expand",
			quantity = size_change * iterations,
			brush = brush_type
		}
		max_iterations = iterations;
		while (not sprite.selection.isEmpty) do
			if (max_iterations > 0 and current_iteration > max_iterations) then
				break
			end
			app.command.Fill()
			if not greyscale then
				app.fgColor = Color {
					hue 		= app.fgColor.hue + h_inc,
					saturation 	= app.fgColor.saturation + s_inc,
					value 		= app.fgColor.value + v_inc,
					alpha 		= app.fgColor.alpha + a_inc
				}
			else
				app.fgColor = Color {
					r		= app.fgColor.red + r_inc,
					g		= app.fgColor.green + g_inc,
					b		= app.fgColor.blue + b_inc
				}
			end
			app.command.ModifySelection {
				modifier = "contract",
				quantity = size_change,
				brush = brush_type
			}
			current_iteration = current_iteration + 1
		end
	end
	app.fgColor = return_start_col
	app.bgColor = return_end_col
end