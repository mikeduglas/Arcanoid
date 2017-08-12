  MEMBER

  MAP
  END

  INCLUDE('MathHelper.inc'), ONCE
  
TVector2.Set                  PROCEDURE(REAL pX, REAL pY)
  CODE
  SELF.x = pX
  SELF.y = pY
  
TVector2.Set                  PROCEDURE(CONST *TVector2 pV)
  CODE
  SELF.x = pV.x
  SELF.y = pV.y
  
TVector2.Set                  PROCEDURE(CONST *TVector2 pV, REAL pScalar)
  CODE
  SELF.Set(pV)
  SELF.Mul(pScalar)

TVector2.Length               PROCEDURE()
  CODE
  RETURN SQRT(SELF.x ^ 2 + SELF.y ^ 2)
  
TVector2.SquareLength         PROCEDURE()
  CODE
  RETURN SELF.x ^ 2 + SELF.y ^ 2
  
TVector2.Add                  PROCEDURE(TVector2 pV)
  CODE
  SELF.x += pV.x
  SELF.y += pV.y
  RETURN SELF
  
TVector2.Sub                  PROCEDURE(TVector2 pV)
  CODE
  SELF.x -= pV.x
  SELF.y -= pV.y
  RETURN SELF

TVector2.Mul                  PROCEDURE(REAL pScalar)
  CODE
  SELF.x *= pScalar
  SELF.y *= pScalar
  RETURN SELF

TVector2.Mul                  PROCEDURE(CONST *TVector2 pV)
  CODE
  RETURN (SELF.x * pV.x) + (SELF.y * pV.y)

TVector2.Normalize            PROCEDURE()
  CODE
  SELF.Mul(1.0 / SELF.Length())
  RETURN SELF

TVector2.DIfference           PROCEDURE(TVector2 v1, TVector2 v2)
  CODE
  SELF.Set(v1)
  RETURN SELF.Sub(v2)
  
  
TRectF.Init                   PROCEDURE(REAL pLeft, REAL pTop, REAL pWidth, REAL pHeight)
v1                              TVector2
v2                              TVector2
  CODE
  SELF.left = pLeft
  SELF.top = pTop
  SELF.width = pWidth
  SELF.height = pHeight
  SELF.right = SELF.left + SELF.width
  SELF.bottom = SELF.top + SELF.height
  
  v1.Set(SELF.left, SELF.top)
  v2.Set(SELF.right, SELF.bottom)
  v2.Add(v1)
  v2.Mul(0.5)
  SELF.centerX = v2.x
  SELF.centerY = v2.y
  
TRectF.Intersect              PROCEDURE(TRectF rect)
  CODE
!  IF (rect.right >= SELF.left AND rect.left <= SELF.right) |
!    AND (rect.bottom >= SELF.top AND rect.top <= SELF.bottom)
!    RETURN TRUE
!  END
  IF (rect.right > SELF.left AND rect.left < SELF.right) |
    AND (rect.bottom > SELF.top AND rect.top < SELF.bottom)
    RETURN TRUE
  END
  
  RETURN FALSE
