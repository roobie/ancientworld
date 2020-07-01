(let [rand love.math.random
      atan2 (. math :atan2)
      cos (. math :cos)
      sin (. math :sin)
      floor (. math :floor)
      min (. math :min)
      pi (. math :pi)
      pi/2 (/ pi 2)
      tau (* pi 2)

      view (require :fennelview)

      component-size 3

      gra love.graphics
      module {}]

  (var window-dimensions nil)
  (let [(x y) (gra.getDimensions)]
    (set window-dimensions {:x x :y y}))

  (fn processor-bounds [actor]
    (let [position (. actor :position)
          [x y] position]
      (when (< x 0)
        (tset position 1 0))
      (when (< y 0)
        (tset position 2 0))
      (when (> x (. window-dimensions :x))
        (tset position 1 (. window-dimensions :x)))
      (when (> y (. window-dimensions :y))
        (tset position 2 (. window-dimensions :y)))
      ))

  (fn hypotenuse-length [x y]
    (math.sqrt (+ (math.pow x 2) (math.pow y 2))))

  (fn processor-mover [actor]
    ;; this seems crazy much. Probably possible to dumb down a bit.
    (let [position (. actor :position)
          [x y] position
          [target-x target-y] (. actor :move-target)
          dx (- target-x x)
          dy (- target-y y)
          theta (atan2 dy dx)
          magx (cos theta)
          magy (sin theta)
          base-speed (. actor :base-speed)
          distance (floor (hypotenuse-length dx dy))
          speed (min base-speed distance)
          ax (* magx speed)
          ay (* magy speed)
          new-x (+ x ax)
          new-y (+ y ay)]
      (if (< distance 1)
          (do
            (tset position 1 target-x)
            (tset position 2 target-y))
          (do
            (tset position 1 new-x)
            (tset position 2 new-y)))))

  (fn random-visible-point []
    [(rand (. window-dimensions :x))
     (rand (. window-dimensions :y))])

  (fn processor-ai [actor]
    (let [position (. actor :position)
          [x y] position
          [target-x target-y] (. actor :move-target)
          fx (floor x)
          fy (floor y)
          ftx (floor target-x)
          fty (floor target-y)]
      (when (and (= fx ftx) (= fy fty))
        (tset actor :move-target (random-visible-point)))
      ;; (each [_ component (ipairs (. actor :components))])
      ))

  (fn processor-renderer [actor]
    (let [position (. actor :position)
          [x y] position
          [target-x target-y] (. actor :move-target)
          ]
      (each [_ component (ipairs (. actor :components))]
        (let [[cx cy] (. component :position)
              color (. component :color)]
        (gra.setColor (unpack color))
        (gra.circle "fill" (+ x cx) (+ y cy) component-size)
        ;; (gra.setColor 0.5 0.5 0.5 0.5)
        ;; (gra.line x y target-x target-y)
        ))))

  (fn add-unit [actors]
    ; a legion century
    (var century-components [])
    (var orientation (/ tau 3))
    (var century {:id "century-1"
                  :position [100 100]
                  :move-target [400 400]
                  :base-speed 0.95
                  :components century-components
                  :orientation orientation})

    (let [spacing (* 3 component-size)
          rx (cos orientation)
          ry (sin orientation)]
      (for [i 0 20]
        (let [x (* rx spacing i)
              y (* ry spacing i)]
        (table.insert century-components
                      {:position [x y]
                       :color [1 0 0 1]})))
      (for [i 0 20]
        (let [x (- (* rx spacing i)
                   (* spacing (cos (- orientation pi/2))))
              y (- (* ry spacing i)
                   (* spacing (sin (- orientation pi/2))))]
          (table.insert century-components
                        {:position [x y]
                         :color [0 1 0 1]})))
      )
    (table.insert actors century))

  (fn module.create []
    (var actors [])
    (add-unit actors)
    (fn battle-scene-update [dt]
      (for [i 1 (length actors)]
        (processor-mover (. actors i))
        (processor-bounds (. actors i))
        (processor-ai (. actors i))
        ))
    (fn battle-scene-draw []
      (for [i 1 (length actors)]
        (processor-renderer (. actors i))
        ))
    {:actors []
     :update battle-scene-update
     :draw battle-scene-draw
     })

  module)
