layer = new Layer


class AnimationGroup extends Framer.EventEmitter

	constructor: (animations=[]) ->
		@setAnimations(animations)
		@_currentAnimation = null
	
	setAnimations: (animations) ->
		# Copy all animations so we can use the same one for repeat
		@_animations = _.map animations, (animation) -> animation.copy()

	start: ->
		@emit("start")

		_.map @_animations, (animation, index) =>

			nextAnimation = @_animations[index+1]

			if nextAnimation
				animation.on Events.AnimationEnd, =>
					nextAnimation.start()
					@_currentAnimation = animation
			else
				animation.on Events.AnimationEnd, =>
					@emit("end")
					@_currentAnimation = null

		@_animations[0].start()

	stop: ->
		@_currentAnimation?.stop()


# runAnimations = (inputAnimations) ->

# 	copiedAnimations = []

# 	for animation in inputAnimations
# 		copiedAnimations.push(animation.copy())

# 	_.map copiedAnimations, (animation, index) ->

# 		nextAnimation = copiedAnimations[index+1]

# 		if nextAnimation
# 			animation.on Events.AnimationEnd, ->
# 				print "Start", index
# 				nextAnimation.start()

# 	copiedAnimations[0].start()


a = new Animation
	layer: layer
	properties:
		x: -> layer.x + 100
	time: 2


ag = new AnimationGroup([a, a, a])


ag.start()