class SceneDVD < SKScene
  include ScreenSizes

  attr_accessor :root

  # This method is invoked when a scene is presented.
  def didMoveToView _
    # Set the aspect ratio.
    self.scaleMode = SKSceneScaleModeAspectFit

    self.backgroundColor = UIColor.grayColor

    @logo_x = device_screen_width.fdiv(2)
    @logo_y = device_screen_height.fdiv(2)
    @go_up = false
    @go_left = false

    # Add sprite (which will be updated in the render loop).
    # Assets are located inside of the resources folder.
    @logo = add_sprite @logo_x, @logo_y, 'dvd.png'
    @logo.size = CGSizeMake(75, 50)


    @colors = Array.new
    @colors.push(UIColor.blueColor)
    @colors.push(UIColor.whiteColor)
    @colors.push(UIColor.yellowColor)
    @colors.push(UIColor.redColor)
    @colors.push(UIColor.greenColor)
    @currentColor = 0


    $logo = @logo
  end

  def add_sprite x, y, path
    texture = SKTexture.textureWithImageNamed path
    sprite = SKSpriteNode.spriteNodeWithTexture texture
    sprite.position = CGPointMake x, y


    sprite.xScale = 0.1
    sprite.yScale = 0.1
    sprite.colorBlendFactor = 1.0


    addChild sprite
    sprite
  end

  def update currentTime
    if @go_up
      @logo_y += 1.5
      if @logo_y >= device_screen_height - @logo.size.height/2
        @logo_y = device_screen_height - @logo.size.height/2
        @go_up = !@go_up


        impact


      end
    else
      @logo_y -= 1.5
      if @logo_y <= 0 + @logo.size.height/2
        @logo_y = 0 + @logo.size.height/2
        @go_up = !@go_up


        impact


      end
    end

    if @go_left
      @logo_x -= 1.5
      if @logo_x <= 0 + @logo.size.width/2
        @logo_x = 0 + @logo.size.width/2
        @go_left = ! @go_left



        impact


      end
    else
      @logo_x += 1.5
      if @logo_x >= device_screen_width - @logo.size.width/2
        @logo_x = device_screen_width - @logo.size.width/2
        @go_left = !@go_left


        impact


      end
    end
    @logo.position = CGPointMake @logo_x, @logo_y


    def impact
      @logo.color =  @colors[@currentColor]
      @currentColor = @currentColor + 1
      if(@currentColor == @colors.size)
        @currentColor = 0
      end
    end


  end
end
