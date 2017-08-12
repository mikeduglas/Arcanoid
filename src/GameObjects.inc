  INCLUDE('ednStopwatch.inc'), ONCE
  INCLUDE('MathHelper.inc'), ONCE


GameObject                    CLASS, TYPE, MODULE('GameObjects.clw'), LINK('GameObjects.clw')
position                        &TVector2
velocity                        &TVector2
width                           REAL
height                          REAL
isAlive                         BOOL
feq                             SIGNED
isDirty                         BOOL

Construct                       PROCEDURE()
Destruct                        PROCEDURE(), VIRTUAL

Init                            PROCEDURE(SIGNED pWidth, SIGNED pHeight), VIRTUAL
Kill                            PROCEDURE(), VIRTUAL

Bounds                          PROCEDURE(*TRectF rect)
ReflectHorizontal               PROCEDURE()
ReflectVertical                 PROCEDURE()
Move                            PROCEDURE(REAL dt), VIRTUAL
Draw                            PROCEDURE()
                              END

!- бита
TBat                          CLASS(GameObject), TYPE, MODULE('GameObjects.clw'), LINK('GameObjects.clw')
moveDx                          REAL  !-шаг биты

Init                            PROCEDURE(SIGNED pWidth, SIGNED pHeight), DERIVED
                              END

!- корпич
TBrick                        CLASS(GameObject), TYPE, MODULE('GameObjects.clw'), LINK('GameObjects.clw')
hitCounter                      BYTE, PRIVATE
hitScore                        UNSIGNED
type                            STRING(1), PRIVATE

Init                            PROCEDURE(SIGNED pWidth, SIGNED pHeight, STRING pType)

Hit                             PROCEDURE()
                              END

!- м€чик
TBall                         CLASS(GameObject), TYPE, MODULE('GameObjects.clw'), LINK('GameObjects.clw')
Init                            PROCEDURE(SIGNED pWidth, SIGNED pHeight), DERIVED
                              END
