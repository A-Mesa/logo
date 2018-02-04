class SceneFive < SKScene
  include ScreenSizes

  attr_accessor :root

  def get_camera
    return @camera
  end

  def didMoveToView view
    self.scaleMode = SKSceneScaleModeAspectFit
    self.backgroundColor = UIColor.whiteColor
    self.view.multipleTouchEnabled = true

    @camera = Camera.new self
    @camera.scale_rate = 0.1

    # Add instructions for this scene.
    add_label <<-HERE, 0, 0, 0.5, 0.5, @camera.main_layer
    This is the first screen that will actually look pretty okay on all devices.

    Try running:
    `rake device_name='iPhone X'`
    `rake device_name='iPhone 8'`
    `rake device_name='iPhone 8 Plus'`
    `rake device_name='iPhone 5s'`
    `rake device_name='iPad Pro (12.9-inch)'`

    Tap anywhere to add squares. Use the buttons at the bottom to pan, zoom, and shake the camera.
    HERE

    $scene = self

    # Spoiler alert. Buttons are just sprites. Everything is a sprite. Everything.
    @button_left = add_sprite(50, 80, 'button.png', 'button-left', self)
    @button_left.zPosition = 1000
    @button_right = add_sprite(100, 80, 'button.png', 'button-right', self)
    @button_right.zPosition = 1000

    @button_up = add_sprite(75, 120, 'button.png', 'button-up', self)
    @button_up.zPosition = 1000
    @button_down = add_sprite(75, 40, 'button.png', 'button-down', self)
    @button_down.zPosition = 1000

    @button_out  = add_sprite(190, 40, 'button.png', 'button-out', self)
    @button_out.zPosition = 1000
    @button_in   = add_sprite(190, 90, 'button.png', 'button-in', self)
    @button_in.zPosition = 1000

    @button_camera_shake = add_sprite(device_screen_width - 75, 80, 'button.png', 'button-shake', self)
    @button_camera_shake.xScale = 1.5
    @button_camera_shake.yScale = 1.5
    @button_camera_shake.zPosition = 1000

    @squares = []
  end

  def touchesBegan touches, withEvent: _
    # This is how you get the node at a specific location that was touched.
    node = nodeAtPoint(touches.allObjects.first.locationInNode(self))

    # once you have the node location, you can look at its name to determine what you want to do with the node.
    case node.name
    when 'button-right'
      node.xScale = 2
      node.yScale = 2
      @camera.pan_left
    when 'button-out'
      node.xScale = 2
      node.yScale = 2
      @camera.target_scale = @camera.target_scale * 0.9
    when 'button-in'
      node.xScale = 2
      node.yScale = 2
      @camera.target_scale = @camera.target_scale * 1.1
    when 'button-left'
      node.xScale = 2
      node.yScale = 2
      @camera.pan_right
    when 'button-up'
      node.xScale = 2
      node.yScale = 2
      @camera.pan_up
    when 'button-down'
      node.xScale = 2
      node.yScale = 2
      @camera.pan_down
    when 'button-shake'
      node.xScale = 3
      node.yScale = 3
      @camera.trauma += 0.6
    else
      first_touch = touches.allObjects.first

      @squares << add_sprite(first_touch.locationInNode(@camera.main_layer).x,
                             first_touch.locationInNode(@camera.main_layer).y,
                             'square.png',
                             "square-#{@squares.length + 1}",
                             @camera)
    end

    return unless touches.allObjects.count > 1

    root.present_scene_five
  end

  def update _
    @squares.each { |s| s.zRotation += 0.1 }

    bring_node_to_target_scale @button_right
    bring_node_to_target_scale @button_out
    bring_node_to_target_scale @button_in
    bring_node_to_target_scale @button_left
    bring_node_to_target_scale @button_up
    bring_node_to_target_scale @button_down
    bring_node_to_target_scale @button_camera_shake, 1.5

    @camera.update
  end

  def bring_node_to_target_scale node, target_scale = 1
    scale_difference = target_scale - node.xScale
    node.xScale += scale_difference * 0.3
    node.yScale += scale_difference * 0.3
  end

  def wrap wrap_length, text
    StringWrapper.wrap wrap_length, text
  end

  def add_label text, x, y, anchor_x, anchor_y, parent
    labels = []
    font_size = 12
    wrapped_text = wrap 50, text
    wrapped_text.each_with_index do |s, i|
      label = SKLabelNode.labelNodeWithText s
      label.fontName = 'Courier'
      label.fontColor = UIColor.blackColor
      label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft
      label.fontSize = font_size
      label.position = CGPointMake(x, y - ((i + 1) * font_size))
      labels << label
      parent.addChild label
    end

    max_width = labels.map { |l| l.frame.size.width }.max
    total_height = labels.map { |l| l.frame.size.height }.inject(:+)

    labels.each do |l|
      delta_x = -max_width * anchor_x
      delta_y = total_height * (1 - anchor_y)
      l.position = CGPointMake(l.position.x + delta_x, l.position.y + delta_y)
    end
  end

  def add_sprite x, y, path, name, parent
    texture = SKTexture.textureWithImageNamed path
    sprite = SKSpriteNode.spriteNodeWithTexture texture
    sprite.position = CGPointMake x, y
    sprite.name = name
    sprite.size = CGSizeMake(50, 50)
    anchorPoint = CGPointMake 0.5, 0.5
    parent.addChild sprite
    sprite
  end
end
