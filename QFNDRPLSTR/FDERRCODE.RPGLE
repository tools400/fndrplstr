      /IF NOT DEFINED(errCode_t )
      /DEFINE errCode_t
      *===============================================================*
      *  API error code                                               *
      *===============================================================*
     D errCode_t       DS                  qualified           based(pDummy)
     D  bytPrv                       10I 0
     D  bytAvl                       10I 0
     D  excID                         7A
     D  reserved_1                    1A
     D  excDta                      256A
      *
      /ENDIF
