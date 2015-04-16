   PROGRAM

StringTheory:TemplateVersion equate('2.09')
   INCLUDE('Equates.CLW')
   INCLUDE('TplEqu.CLW')
   INCLUDE('Keycodes.CLW')
   INCLUDE('Errors.CLW')
  include('StringTheory.Inc'),ONCE
   MAP
     MODULE('tziTest001.clw')
       Main
     END
     MODULE('tziTe_SF.CLW')
       CheckOpen(FILE File,<BYTE OverrideCreate>,<BYTE OverrideOpenMode>)
       ReportPreview(QUEUE PrintPreviewQueue)
       Preview:JumpToPage(LONG Input:CurrentPage, LONG Input:TotalPages),LONG
       Preview:SelectDisplay(*LONG Input:PagesAcross, *LONG Input:PagesDown)
       StandardWarning(LONG WarningID),LONG,PROC
       StandardWarning(LONG WarningID,STRING WarningText1),LONG,PROC
       StandardWarning(LONG WarningID,STRING WarningText1,STRING WarningText2),LONG,PROC
       SetupStringStops(STRING ProcessLowLimit,STRING ProcessHighLimit,LONG InputStringSize,<LONG ListType>)
       NextStringStop,STRING
       SetupRealStops(REAL InputLowLimit,REAL InputHighLimit)
       NextRealStop,REAL
       INIRestoreWindow(STRING ProcedureName,STRING INIFileName)
       INISaveWindow(STRING ProcedureName,STRING INIFileName)
       RISaveError
     END
     MODULE('tziTe_RU.CLW')
     END
     MODULE('tziTe_RD.CLW')
     END
   END


SaveErrorCode        LONG
SaveError            CSTRING(255)
SaveFileErrorCode    LONG
SaveFileError        CSTRING(255)
GlobalRequest        LONG(0),THREAD
GlobalResponse       LONG(0),THREAD
VCRRequest           LONG(0),THREAD
!region File Declaration
!endregion

Sort:Name            STRING(ScrollSort:Name)                
Sort:Name:Array      STRING(3),DIM(100),OVER(Sort:Name)
Sort:Alpha           STRING(ScrollSort:Alpha)
Sort:Alpha:Array     STRING(2),DIM(100),OVER(Sort:Alpha)


  CODE
  Main
!---------------------------------------------------------------------------
