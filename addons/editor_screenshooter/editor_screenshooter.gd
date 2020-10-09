# Godot Editor Screenshooter: Take screenshots of the editor viewport
#
# Copyright © 2019-2020 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

tool
extends EditorPlugin

func _input(event):
	if Input.is_key_pressed(KEY_F12):
		var viewport := get_editor_interface().get_editor_viewport().get_viewport()

		viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
		var image := viewport.get_texture().get_data()

		# The viewport must be flipped to match the rendered window
		image.flip_y()

		viewport.set_clear_mode(Viewport.CLEAR_MODE_ALWAYS)

		# Screenshot file name with ISO 8601-like date
		var datetime := OS.get_datetime()
		for key in datetime:
			datetime[key] = str(datetime[key]).pad_zeros(2)

		var error := image.save_png(
				"user://editor_{year}-{month}-{day}_{hour}.{minute}.{second}.png" \
						.format(datetime)
		)

		if error != OK:
			push_error("Couldn't save screenshot.")
