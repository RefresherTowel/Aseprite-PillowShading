local sprite = app.site.sprite
if sprite.selection.isEmpty then
	return app.alert("I cannot process an empty selection!")
end

local data
local dlg = Dialog():number{ id="max_iterations", label="Max Iterations (0 to perform the maximum possible iterations):", text="0", decimals=0 }
dlg:modify{ title = "Pillow Shader" }
dlg:number{ id="iteration_size", label="Iteration size:", text="1", decimals=0 }
dlg:newrow()
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
dlg:button{ id="confirm", text="Confirm" }
dlg:button{ id="cancel", text="Cancel" }
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
	local end_col = app.bgColor
	local h_inc = ((end_col.hue - start_col.hue) / iterations)
	local s_inc = ((end_col.saturation - start_col.saturation) / iterations)
	local v_inc = ((end_col.value - start_col.value) / iterations)
	
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
			app.fgColor = Color {
				hue = app.fgColor.hue + h_inc,
				saturation = app.fgColor.saturation + s_inc,
				value = app.fgColor.value + v_inc
			}
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
			app.fgColor = Color {
				hue = app.fgColor.hue + h_inc,
				saturation = app.fgColor.saturation + s_inc,
				value = app.fgColor.value + v_inc
			}
			app.command.ModifySelection {
				modifier = "contract",
				quantity = size_change,
				brush = brush_type
			}
			current_iteration = current_iteration + 1
		end
	end
	app.fgColor = start_col
	app.bgColor = end_col
end