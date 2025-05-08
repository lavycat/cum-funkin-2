## SCRIPT BY NEBULA ZORUA ##
# Grabs the SpriteFrames of the parent AnimatedSprite and adds them to the AnimationPlayer automatically

@tool

extends AnimationPlayer
@export var sprite:AnimatedSprite2D = get_parent().get_node("sprite");

@export var export:bool: 
	set(value):
		if(!has_animation_library("")):
			add_animation_library("", AnimationLibrary.new());
			
		var lib:AnimationLibrary = get_animation_library("")
		for shit in sprite.sprite_frames.animations:
			var name: String = shit.name;
			var step = shit.speed
			for dir: String in ["left", "down", "up", "right"]:
				if name.substr(0, dir.length()) == dir:
					name = 'sing_%s' % [name]
				elif name.substr(0, dir.length() + 5) == 'miss ' + dir:
					name = 'sing_%s_miss' % [name.substr(5)]
					
			var anim = Animation.new();
			anim.length = 0;
			
			if lib.has_animation(name):
				anim = lib.get_animation(name);
				
			var frameCount = shit.frames.size() - 1;
			var length = frameCount * (1 / shit.speed);
			anim.step = 1.0/step
				
			if anim.length < length:
				anim.length = length;
			
			var anim_track_idx = anim.add_track(Animation.TYPE_VALUE)
			var frame_track_idx = anim.add_track(Animation.TYPE_VALUE)
			var offset_track_idx = anim.add_track(Animation.TYPE_VALUE)
			anim.track_set_path(anim_track_idx, sprite.name + ":animation")
			anim.track_insert_key(anim_track_idx, 0.0, shit.name)
			
			anim.track_set_path(frame_track_idx, sprite.name + ":frame")
			anim.track_insert_key(frame_track_idx, 0.0, 0)
			anim.track_insert_key(frame_track_idx, length, frameCount)
			
			anim.track_set_path(anim_track_idx, sprite.name + ":animation")
			anim.track_insert_key(anim_track_idx, 0.0, shit.name)
			
			anim.track_set_path(offset_track_idx, sprite.name + ":offset")
			anim.track_insert_key(offset_track_idx, 0.0, Vector2.ZERO)
			

					
			lib.add_animation(name, anim)
			
