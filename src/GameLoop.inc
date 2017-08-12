  INCLUDE('GameObjects.inc'), ONCE

TBrickQ                       QUEUE, TYPE
brick                           &TBrick
                              END

SoundEnum                     EQUATE(LONG)
Sound::Hit                    EQUATE(1)
Sound::Lost                   EQUATE(2)

GameLoop                      CLASS(TStopwatch), TYPE, MODULE('GameLoop.clw'), LINK('GameLoop.clw')
viewport                        &TRectF, PRIVATE       !- границы игрового поля
level                           SHORT
score                           UNSIGNED

bat                             &TBat
bricks                          &TBrickQ
ball                            &TBall

isOver                          BOOL

Construct                       PROCEDURE()
Destruct                        PROCEDURE(), DERIVED

SetViewport                     PROCEDURE(SIGNED pX, SIGNED pY, SIGNED pW, SIGNED pH)
LoadLevel                       PROCEDURE(SHORT pLevel)
LoadBricks                      PROCEDURE(SHORT pLevel)
Reset                           PROCEDURE(), BOOL, PROC, DERIVED

Play                            PROCEDURE()
Pause                           PROCEDURE()

Collide                         PROCEDURE(GameObject obj, TRectF rect)
LevelCompleted                  PROCEDURE(), BOOL

Refresh                         PROCEDURE()
PlaySound                       PROCEDURE(SoundEnum pSound)
                              END
