  MEMBER

  MAP
  END

  INCLUDE('GameObjects.inc'), ONCE

GameObject.Construct          PROCEDURE()
  CODE
  SELF.position &= NEW TVector2
  SELF.velocity &= NEW TVector2
  SELF.isAlive = TRUE
  SELF.isDirty = TRUE
  
GameObject.Destruct           PROCEDURE()
  CODE
  DISPOSE(SELF.position)
  DISPOSE(SELF.velocity)
  
GameObject.Init               PROCEDURE(SIGNED pWidth, SIGNED pHeight)
  CODE
  SELF.width = pWidth
  SELF.height = pHeight
  SELF.isAlive = TRUE
  SELF.isDirty = TRUE

GameObject.Kill               PROCEDURE()
  CODE
  IF SELF.feq
    DESTROY(SELF.feq)
    SELF.feq = 0
  END
  
GameObject.Bounds             PROCEDURE(*TRectF rect)
  CODE
  rect.Init(SELF.position.x, SELF.position.y, SELF.width, SELF.height)
  
GameObject.ReflectHorizontal  PROCEDURE()
  CODE
  SELF.velocity.y = -SELF.velocity.y
  
GameObject.ReflectVertical    PROCEDURE()
  CODE
  SELF.velocity.x = -SELF.velocity.x

GameObject.Move               PROCEDURE(REAL dt)
delta                           TVector2
  CODE
  IF SELF.isAlive
    delta.Set(SELF.velocity, dt)
    SELF.position.Add(delta)
    
    IF delta.x <> 0.0 OR delta.y <> 0
      SELF.isDirty = TRUE
    END
  END
    
GameObject.Draw               PROCEDURE()
  CODE
  IF SELF.feq
    IF SELF.isDirty
      SETPOSITION(SELF.feq, SELF.position.x, SELF.position.y, SELF.width, SELF.height)
      SELF.feq{PROP:Hide} = FALSE
      SELF.isDirty = FALSE
    END
  END

TBat.Init                     PROCEDURE(SIGNED pWidth, SIGNED pHeight)
  CODE
  IF NOT SELF.feq
    PARENT.Init(pWidth, pHeight)
  
    SELF.feq = CREATE(0, CREATE:box)
    SELF.feq{PROP:LineWidth} = 1
    SELF.feq{PROP:Color} = COLOR:Black
    SELF.feq{PROP:Fill} = COLOR:Gray
    
    SELF.moveDx = 6.0
  END

TBrick.Init                   PROCEDURE(SIGNED pWidth, SIGNED pHeight, STRING pType)
  CODE
  IF NOT SELF.feq
    PARENT.Init(pWidth, pHeight)
    
    SELF.type = pType
  
    SELF.feq = CREATE(0, CREATE:box)
    SELF.feq{PROP:LineWidth} = 2
    SELF.feq{PROP:Color} = COLOR:Black
    
    CASE SELF.type
    OF 'A'
      SELF.feq{PROP:Fill} = COLOR:Green
      SELF.hitCounter = 1
      SELF.hitScore = 10
    OF 'B'
      SELF.feq{PROP:Fill} = COLOR:Lime
      SELF.hitCounter = 2
      SELF.hitScore = 20
    OF 'C'
      SELF.feq{PROP:Fill} = COLOR:Orange
      SELF.hitCounter = 3
      SELF.hitScore = 30
    ELSE
!      SELF.feq{PROP:Fill} = COLOR:Green
      SELF.hitCounter = 1
      SELF.hitScore = 1
    END
  END
  
TBrick.Hit                    PROCEDURE()
  CODE
  SELF.hitCounter -= 1
  IF SELF.hitCounter = 0
    SELF.isAlive = FALSE
    SELF.Kill()
  END

TBall.Init                    PROCEDURE(SIGNED pWidth, SIGNED pHeight)
  CODE
  IF NOT SELF.feq
    PARENT.Init(pWidth, pHeight)
  
    SELF.feq = CREATE(0, CREATE:ellipse)
    SELF.feq{PROP:LineWidth} = 1
    SELF.feq{PROP:Color} = COLOR:Black
    SELF.feq{PROP:Fill} = COLOR:Red
  END
  