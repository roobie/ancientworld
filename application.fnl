(let [view (require :fennelview)

      battle-scene (require :battle-scene)

      gra love.graphics
      kbd love.keyboard

      font-size 12
      fonts {}]

  (var scene nil)

  (set scene (battle-scene.create))

  (fn love.load []
    (set fonts.tile-font
         (gra.newFont "resources/square.ttf" font-size))
    (set fonts.text-font
         (gra.newFont "resources/FiraCode-Regular.ttf" font-size))

    (gra.setFont (. fonts :text-font))

    (kbd.setTextInput true)
    (kbd.setKeyRepeat true)
    )

  (fn love.update [dt]
    (scene.update dt))

  (fn love.draw []
    (scene.draw))

  (fn love.keypressed []
    )
  )
