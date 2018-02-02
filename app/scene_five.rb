class SceneFive < SKScene
  include ScreenSizes

  attr_accessor :root

  def didMoveToView view
    self.scaleMode = SKSceneScaleModeAspectFit
    self.backgroundColor = UIColor.whiteColor
    self.view.multipleTouchEnabled = true

    # Add instructions for this scene.
    add_label <<-HERE
    HERE

    # Spoiler alert. Buttons are just sprites. Everything is a sprite. Everything.
    @button_next = add_sprite( 50, 45, 'button.png', 'button-next', self)
    @button_next.zPosition = 1000
    @button_out  = add_sprite(190, 30, 'button.png', 'button-out', self)
    @button_out.zPosition = 1000
    @button_in   = add_sprite(190, 80, 'button.png', 'button-in', self)
    @button_in.zPosition = 1000
    @button_prev = add_sprite(330, 45, 'button.png', 'button-prev', self)
    @button_prev.zPosition = 1000
    @camera = Camera.new self
    @camera.scale_rate = 0.1

    @squares = []
  end

  def touchesBegan touches, withEvent: _
    # This is how you get the node at a specific location that was touched.
    node = nodeAtPoint(touches.allObjects.first.locationInNode(self))

    # once you have the node location, you can look at its name to determine what you want to do with the node.
    case node.name
    when 'button-next'
      node.xScale = 2
      node.yScale = 2
      @camera.pan_left
    when 'button-out'
      node.xScale = 2
      node.yScale = 2
      @camera.target_scale -= @camera.target_scale * 0.1
    when 'button-in'
      node.xScale = 2
      node.yScale = 2
      @camera.target_scale += @camera.target_scale * 0.1
    when 'button-prev'
      node.xScale = 2
      node.yScale = 2
      @camera.pan_right
    else
      first_touch = touches.allObjects.first

      @squares << add_sprite(first_touch.locationInNode(@camera.node).x,
                             first_touch.locationInNode(@camera.node).y,
                             'square.png',
                             "square-#{@squares.length + 1}",
                             @camera)
    end

    return unless touches.allObjects.count > 1

    root.present_scene_five
  end

  def update _
    @squares.each { |s| s.zRotation += 0.1 }
    bring_node_to_target_scale @button_next
    bring_node_to_target_scale @button_out
    bring_node_to_target_scale @button_in
    bring_node_to_target_scale @button_prev

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

  def add_label text
    font_size = 12
    wrapped_text = wrap 50, text
    wrapped_text.each_with_index do |s, i|
      label = SKLabelNode.labelNodeWithText s
      label.fontName = 'Courier'
      label.fontColor = UIColor.blackColor
      label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft
      label.fontSize = font_size
      label.position = CGPointMake(10,
                                   device_screen_height - ((i + 1) * font_size))
      addChild label
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