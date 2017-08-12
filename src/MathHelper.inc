TVector2                      CLASS, TYPE, MODULE('MathHelper.clw'), LINK('MathHelper.clw')
x                               REAL
y                               REAL

Set                             PROCEDURE(REAL pX, REAL pY)
Set                             PROCEDURE(CONST *TVector2 pV)
Set                             PROCEDURE(CONST *TVector2 pV, REAL pScalar) !self=v*s
Length                          PROCEDURE(), REAL
SquareLength                    PROCEDURE(), REAL
Add                             PROCEDURE(TVector2 pV), *TVector2, PROC
Sub                             PROCEDURE(TVector2 pV), *TVector2, PROC
Mul                             PROCEDURE(REAL pScalar), *TVector2, PROC
Mul                             PROCEDURE(CONST *TVector2 pV), REAL
Normalize                       PROCEDURE(), *TVector2, PROC
DIfference                      PROCEDURE(TVector2 v1, TVector2 v2), *TVector2, PROC  !v1 - v2
                              END

TRectF                        CLASS, TYPE, MODULE('MathHelper.clw'), LINK('MathHelper.clw')
x                               REAL
y                               REAL
left                            REAL, OVER(x)
top                             REAL, OVER(y)
right                           REAL
bottom                          REAL
width                           REAL
height                          REAL
centerX                         REAL
centerY                         REAL

Init                            PROCEDURE(REAL pLeft, REAL pTop, REAL pWidth, REAL pHeight)
Intersect                       PROCEDURE(TRectF rect), BOOL
                              END
