  MEMBER

  MAP
    MODULE('Win API')
      win::GetKeyState(LONG vKey),SHORT,PASCAL,NAME('GetKeyState')
      win::Sleep(LONG dwMilliseconds), PASCAL, NAME('Sleep')
      win::Beep(ULONG dwFreq, ULONG dwDuration), BOOL, PASCAL, PROC, NAME('Beep')
    END
  END

  INCLUDE('GameLoop.inc'), ONCE
  INCLUDE('Keycodes.clw'), ONCE

GameLoop.Construct            PROCEDURE()
  CODE
  SELF.viewport &= NEW TRectF
  SELF.bat &= NEW TBat
  SELF.bricks &= NEW TBrickQ
  SELF.ball &= NEW TBall
  
GameLoop.Destruct             PROCEDURE()
qIndex                          LONG, AUTO
  CODE
  DISPOSE(SELF.viewport)
  DISPOSE(SELF.bat)
  DISPOSE(SELF.ball)

  LOOP qIndex = 1 TO RECORDS(SELF.bricks)
    GET(SELF.bricks, qIndex)
    IF NOT SELF.bricks.brick &= NULL
      DISPOSE(SELF.bricks.brick)
      SELF.bricks.brick &= NULL
    END
  END
  
  FREE(SELF.bricks)
  DISPOSE(SELF.bricks)

GameLoop.SetViewport          PROCEDURE(SIGNED pX, SIGNED pY, SIGNED pW, SIGNED pH)
  CODE
  SELF.viewport.Init(pX, pY, pW, pH)

GameLoop.LoadLevel            PROCEDURE(SHORT pLevel)
vx                              REAL, AUTO
vy                              REAL, AUTO

  CODE
  SELF.level = pLevel
  IF SELF.level > 3
    SELF.level = 1
  END
  
  SELF.bat.Init(100, 20)
  SELF.bat.position.Set((SELF.viewport.width - SELF.bat.width) / 2, (SELF.viewport.height - SELF.bat.height - 20))

  SELF.LoadBricks(pLevel)
  
  SELF.ball.Init(20, 20)
  SELF.ball.position.Set((SELF.viewport.width - SELF.ball.width) / 2, (SELF.viewport.height - SELF.bat.height - SELF.ball.height - 20))
  
  !  SELF.ball.velocity.Set(1, -1)
  !- рандомный вектор скорости
  vx = RANDOM(-700, 700) / 1000.0
  vy = SQRT(2.0 - vx * vx)
  vx *= 2.0 + (SELF.level - 1) * 0.2
  vy *= 2.0 + (SELF.level - 1) * 0.2
  SELF.ball.velocity.Set(vx, -vy)

  SELF.bat.Draw()
  SELF.ball.Draw()
  
  SELF.isOver = FALSE
  
GameLoop.LoadBricks           PROCEDURE(SHORT pLevel)
i                               BYTE, AUTO
j                               BYTE, AUTO
sLine                           STRING(10), AUTO
  CODE
  LOOP i = 1 TO 5
    sLine = GETINI('Level '& pLevel, 'Line'& i, '', '.\arkanoid.ini')
    IF sLine
      LOOP j = 1 TO 10
        IF sLine[j] <> ' '
          SELF.bricks.brick &= NEW TBrick
          ADD(SELF.bricks)
          SELF.bricks.brick.Init(55, 25, sLine[j])
          SELF.bricks.brick.position.Set((j - 1) * 55 + 120, (i - 1) * 25 + 50)
          SELF.bricks.brick.Draw()
        END
      END
    END
  END
  
GameLoop.Reset                PROCEDURE()
qIndex                          LONG, AUTO
  CODE
  PARENT.Reset()
  SELF.isOver = TRUE

  SELF.bat.Kill()
  SELF.ball.Kill()
  
  LOOP qIndex = 1 TO RECORDS(SELF.bricks)
    GET(SELF.bricks, qIndex)
    IF NOT SELF.bricks.brick &= NULL
      SELF.bricks.brick.Kill()
      DISPOSE(SELF.bricks.brick)
      SELF.bricks.brick &= NULL
      PUT(SELF.bricks)
    END
  END

  FREE(SELF.bricks)

  RETURN TRUE

GameLoop.Play                 PROCEDURE()
  CODE
  SELF.isOver = FALSE
  SELF.Start()
  
GameLoop.Pause                PROCEDURE()
  CODE
  SELF.Stop()
  
GameLoop.Collide              PROCEDURE(GameObject obj, TRectF rect)
objRect                         TRectF
  CODE
  obj.Bounds(objRect)
  
  IF rect.Left <= objRect.centerX AND objRect.centerX <= rect.right
    !- Обьект столкнулся сверху или снизу, отражаем направление полета по горизонтали
    obj.ReflectHorizontal()
  ELSIF rect.top <= objRect.centerY AND objRect.centerY <= rect.bottom
    !- Обьект столкнулся слева или справа, отражаем направление полета по вертикали
    obj.ReflectVertical()
  END
  
GameLoop.LevelCompleted       PROCEDURE()
qIndex                          LONG, AUTO
  CODE
  LOOP qIndex = 1 TO RECORDS(SELF.bricks)
    GET(SELF.bricks, qIndex)
    IF NOT SELF.bricks.brick &= NULL AND SELF.bricks.brick.isAlive
      RETURN FALSE
    END
  END
  
  RETURN TRUE

GameLoop.Refresh              PROCEDURE()
dt                              REAL, AUTO
delta                           TVector2
nextRect                        TRectF   !- будушее положение мяча
batRect                         TRectF   !- бита
brickRect                       TRectF   !- кирпич
leftKstate                      SHORT, AUTO !- стрелка влево
rightKstate                     SHORT, AUTO !- стрелка вправо
bitmask                         EQUATE(1000000000000000b)
kstate                          SHORT, AUTO
qIndex                          LONG, AUTO
  CODE
  leftKstate = win::GetKeyState(LeftKey)
  rightKstate = win::GetKeyState(RightKey)

  IF NOT SELF.IsRunning()
!    IF leftKstate OR rightKstate
    IF BAND(rightKstate, bitmask) OR BAND(leftKstate, bitmask)
      SELF.Play()
    END
    
    RETURN
  END
  
  dt = SELF.ElapsedMilliseconds() / 10.0  !- hundredths of second
  
  delta.Set(SELF.ball.velocity, dt)
  
  nextRect.Init(SELF.ball.position.x + delta.x, SELF.ball.position.y + delta.y, SELF.ball.width, SELF.ball.height)
  

  batRect.Init(SELF.bat.position.x, SELF.bat.position.y, SELF.bat.width, SELF.bat.height)

  IF nextRect.top < 0
    !- Столкновение с верхним краем игрового поля
    SELF.ball.ReflectHorizontal()
    SELF.PlaySound(Sound::Hit)
    
  ELSIF nextRect.top >= SELF.viewport.height - nextRect.Height
    !- При сталкивании мяча с нижним краем игрового поля, мячик "умирает"
    SELF.ball.isAlive = FALSE
    SELF.PlaySound(Sound::Lost)

  ELSIF (nextRect.left >= SELF.viewport.width - nextRect.width) OR (nextRect.left <= 0)
    !- Столкновение мячика с левым или правым краем игрового поля
    SELF.ball.ReflectVertical()
    SELF.PlaySound(Sound::Hit)

  ELSIF nextRect.Intersect(batRect)
    !- Столкновение мячика с ракеткой
    SELF.Collide(SELF.ball, batRect)
    SELF.PlaySound(Sound::Hit)

  ELSE
    !-- Столкновение мячика с кирпичами
    LOOP qIndex = 1 TO RECORDS(SELF.bricks)
      GET(SELF.bricks, qIndex)
      IF NOT SELF.bricks.brick &= NULL
        brickRect.Init(SELF.bricks.brick.position.x, SELF.bricks.brick.position.y, SELF.bricks.brick.width, SELF.bricks.brick.height)
        IF SELF.bricks.brick.isAlive AND nextRect.Intersect(brickRect)
          SELF.PlaySound(Sound::Hit)
          SELF.bricks.brick.Hit()
          SELF.score += SELF.bricks.brick.hitScore
          SELF.Collide(SELF.ball, brickRect)
          PUT(SELF.bricks)
        END
      END
    END
  END

  
      
  IF BAND(rightKstate, bitmask)
    !- Двигаем ракетку вправо
    SELF.bat.position.x += SELF.bat.moveDx
    IF SELF.bat.position.x > SELF.viewport.right - SELF.bat.width
      SELF.bat.position.x = SELF.viewport.right - SELF.bat.width
    END
    
    SELF.bat.isDirty = TRUE
  END
  
  IF BAND(leftKstate, bitmask)
    !- Двигаем ракетку влево
    SELF.bat.position.x -= SELF.bat.moveDx
    IF SELF.bat.position.x < SELF.viewport.left
      SELF.bat.position.x = SELF.viewport.left
    END
    
    SELF.bat.isDirty = TRUE
  END
  
  !- пересчитаем новое положение ракетки
  batRect.Init(SELF.bat.position.x, SELF.bat.position.y, SELF.bat.width, SELF.bat.height)
  
  IF nextRect.Intersect(batRect)
    !- Столкновение мячика с боковиной ракетки, клгда она движется
    IF BAND(rightKstate, bitmask) AND nextRect.left <= batRect.right AND nextRect.bottom > batRect.top
      SELF.ball.position.x += SELF.bat.moveDx
    ELSIF BAND(leftKstate, bitmask) AND nextRect.right >= batRect.left AND nextRect.bottom > batRect.top
      SELF.ball.position.x -= SELF.bat.moveDx
    END
  END
  
  
  SELF.ball.Move(dt)
  SELF.ball.Draw()
  SELF.bat.Draw()
  
  IF SELF.ball.isAlive
    IF SELF.LevelCompleted()
      SELF.Reset()
      SELF.LoadLevel(SELF.level + 1)  !- next level
    ELSE
      SELF.Restart()
    END
  ELSE
    SELF.Reset()
    SELF.LoadLevel(SELF.level)  !- same level
  END
  
GameLoop.PlaySound            PROCEDURE(SoundEnum pSound)
freq                            ULONG, AUTO
duration                        ULONG, AUTO
  CODE
  CASE pSound
  OF Sound::Hit
    freq = 200
    duration = 10
    win::Beep(freq, duration)  
  
  OF Sound::Lost
    freq = 100
    duration = 800
    win::Beep(freq, duration)  
    
  ELSE
    RETURN
  END
