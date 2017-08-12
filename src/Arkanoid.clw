  PROGRAM

  PRAGMA('project(#pragma define(_SVDllMode_ => 0))')
  PRAGMA('project(#pragma define(_SVLinkMode_ => 1))')
  !- link manifest
  PRAGMA('project(#pragma link(arkanoid.EXE.manifest))')

  INCLUDE('GameLoop.inc'), ONCE

  MAP
    MODULE('Win API')
      win::ShowCursor(BOOL bShow),LONG,PASCAL,NAME('ShowCursor'),PROC
    END
  END

Window                        WINDOW('Arcanoid'),AT(,,855,492),CENTER,GRAY,FONT('Microsoft Sans Serif', |
                                8,COLOR:Yellow),WALLPAPER('wallpaper.jpg')
                                PROMPT('Set in code'),AT(708,2),USE(?lblLevel),TRN,FONT(,16,COLOR:Yellow)
                                PROMPT('Set in code'),AT(708,23),USE(?lblScore),TRN,FONT(,16,COLOR:Yellow)
                              END
  

game                          GameLoop

  CODE
  OPEN(Window)
  
  Window{PROP:Buffer} = 1
  Window{PROP:Timer} = 1
  
  ?lblLevel{PROP:Text} = ''
  ?lblScore{PROP:Text} = ''

  win::ShowCursor(FALSE)
  
  game.SetViewport(0, 0, Window{PROP:Width}, Window{PROP:Height})
  game.LoadLevel(1)

  ACCEPT
    CASE EVENT()
    OF EVENT:CloseWindow
      IF game.IsRunning()
        game.Pause()
        CASE MESSAGE('Are you sure?', 'Arcanoid', ICON:Question, BUTTON:YES + button:No)
        OF BUTTON:YES
          BREAK
        OF BUTTON:NO
          game.Play()
          CYCLE
        END
      END
    END
    
    game.Refresh()
    
    ?lblLevel{PROP:Text} = 'Level: '& game.level
    ?lblScore{PROP:Text} = 'Score: '& game.score
  END
  
