

                     MEMBER('tziTest.clw')                 ! This is a MEMBER module

!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
Main PROCEDURE

LocalRequest         LONG                                  !
OriginalRequest      LONG                                  !
LocalResponse        LONG                                  !
FilesOpened          LONG                                  !
WindowOpened         LONG                                  !
WindowInitialized    LONG                                  !
ForceRefresh         LONG                                  !
lpSystemTime  GROUP,TYPE
wYear           USHORT
wMonth          USHORT
wDayOfWeek      USHORT
wDay            USHORT
wHour           USHORT
wMinute         USHORT
wSecond         USHORT
wMiliseconds    USHORT
              END
lpTimeZoneInformation GROUP,TYPE
Bias                    LONG
StandardName            STRING(32)
StandardDate            LIKE(lpSystemTime)
StandardBias            LONG
DaylightName            STRING(32)
DaylightDate            LIKE(lpSystemTime)
DaylightBias            LONG
                      END
lpDynamicTimeZoneInformation  GROUP,TYPE
Bias                            LONG
StandardName                    STRING(32)
StandardDate                    LIKE(lpSystemTime)
StandardBias                    LONG
DaylightName                    STRING(32)
DaylightDate                    LIKE(lpSystemTime)
DaylightBias                    LONG
TimeZoneKeyName                 STRING(128)
DynamicDaylightTimeDisabled     BYTE
                      END
st  StringTheory

dtzi_Bias            LONG                                  ! Dynamic time zone bias
dtzi_DaylightBias    LONG                                  ! Dynamic daylight bias
dtzi_DaylightDate    LIKE(lpSystemTime)                    ! Dynamic daylight date
dtzi_DaylightName    STRING(32)                            ! Dynamic daylight name
dtzi_DynamicDaylightTimeDisabled BYTE                      ! Dynamic daylight time disabled
dtzi_StandardBias    LONG                                  ! Dynamic standard bias
dtzi_StandardDate    LIKE(lpSystemTime)                    ! Dynamic standard date
dtzi_StandardName    STRING(32)                            ! Dynamic standard name
dtzi_TimeZoneKeyName STRING(128)                           ! Dynamic time zone key name

tzi_Bias             LONG                                  ! Time zone bias
tzi_DaylightBias     LONG                                  ! Daylight bias
tzi_DaylightDate     ULONG                                 ! Daylight date
tzi_DaylightName     STRING(32)                            ! Daylight time zone name
tzi_StandardBias     LONG                                  ! Standard bias
tzi_StandardDate     ULONG                                 ! Standard date
tzi_StandardName     STRING(32)                            ! Standard time zone name

tzi     GROUP(lpTimeZoneInformation)
        END
dtzi    GROUP(lpDynamicTimeZoneInformation)
        END
Window               WINDOW('Time Zone Informations'),AT(,,395,224),FONT('Microsoft Sans Serif',8),GRAY
                       BUTTON('GetTimeZoneInformation'),AT(17,19),USE(?getTZI:Button)
                       BUTTON('GetDynamicTimeZoneInformation'),AT(17,41),USE(?getDTZI:Button)
                     END
  MAP
    MODULE('winapi')
      GetTimeZoneInformation(ULONG lpTimeZoneInformation), ULONG, RAW, PASCAL, NAME('GetTimeZoneInformation')
    END
    MODULE('Kernel32')
      GetDynamicTimeZoneInformation(ULONG lpDynamicTimeZoneInformation), ULONG, RAW, PASCAL, NAME('GetDynamicTimeZoneInformation')
    END
  END
  CODE
  PUSHBIND
  LocalRequest    = GlobalRequest
  OriginalRequest = GlobalRequest
  LocalResponse   = RequestCancelled
  ForceRefresh    = False
  CLEAR(GlobalRequest)
  CLEAR(GlobalResponse)
  IF KEYCODE() = MouseRight
    SETKEYCODE(0)
  END
  DO PrepareProcedure
  ACCEPT
    CASE EVENT()
    OF EVENT:DoResize
      ForceRefresh = True
      DO RefreshWindow
    OF EVENT:GainFocus
      ForceRefresh = True
      IF NOT WindowInitialized
        DO InitializeWindow
        WindowInitialized = True
      ELSE
        DO RefreshWindow
      END
    OF EVENT:OpenWindow
      IF NOT WindowInitialized
        DO InitializeWindow
        WindowInitialized = True
      END
      SELECT(?getTZI:Button)
    OF EVENT:Sized
      POST(EVENT:DoResize,0,THREAD())
    OF Event:Rejected
      BEEP
      DISPLAY(?)
      SELECT(?)
    END
    CASE FIELD()
    OF ?getTZI:Button
      CASE EVENT()
      OF EVENT:Accepted
        DO Get:TimeZoneInformation
        DO SyncWindow
      END
    OF ?getDTZI:Button
      CASE EVENT()
      OF EVENT:Accepted
        DO Get:DynamicTimeZoneInformation
        DO SyncWindow
      END
    END
  END
  DO ProcedureReturn
!---------------------------------------------------------------------------
PrepareProcedure ROUTINE
  FilesOpened = TRUE
  DO BindFields
  OPEN(Window)
  WindowOpened=True
  Do DefineListboxStyle

!---------------------------------------------------------------------------
BindFields ROUTINE
!---------------------------------------------------------------------------
UnBindFields ROUTINE
!---------------------------------------------------------------------------
ProcedureReturn ROUTINE
!|
!| This routine provides a common procedure exit point for all template
!| generated procedures.
!|
!| First, all of the files opened by this procedure are closed.
!|
!| Next, if it was opened by this procedure, the window is closed.
!|
!| Next, GlobalResponse is assigned a value to signal the calling procedure
!| what happened in this procedure.
!|
!| Next, we replace the BINDings that were in place when the procedure initialized
!| (and saved with PUSHBIND) using POPBIND.
!|
!| Finally, we return to the calling procedure.
!|
  IF FilesOpened
    FilesOpened=False
    DO UnbindFields
  END
  IF WindowOpened
    CLOSE(Window)
  END
  Do UnBindFields
  IF LocalResponse
    GlobalResponse = LocalResponse
  ELSE
    GlobalResponse = RequestCancelled
  END
  POPBIND
  RETURN
!---------------------------------------------------------------------------
InitializeWindow ROUTINE
!|
!| This routine is used to prepare any control templates for use. It should be called once
!| per procedure.
!|
  DO RefreshWindow
!---------------------------------------------------------------------------
RefreshWindow ROUTINE
!|
!| This routine is used to keep all displays and control templates current.
!|
  IF Window{Prop:AcceptAll} THEN EXIT.
  Do LookupRelated
  DISPLAY()
  ForceRefresh = False
!---------------------------------------------------------------------------
SyncWindow ROUTINE
!|
!| This routine is used to insure that any records pointed to in control
!| templates are fetched before any procedures are called via buttons or menu
!| options.
!|
  Do LookupRelated
!---------------------------------------------------------------------------
LookupRelated  ROUTINE
!|
!| This routine fetch all related records.
!| It's called from SyncWindow and RefreshWindow
!|
!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It's called after the window open
!|
!---------------------------------------------------------------------------
Get:TimeZoneInformation ROUTINE
!|
!| Get timezone information
!|
  DATA
curReturn LONG
  CODE
  curReturn = GetTimeZoneInformation(ADDRESS(tzi))

  tzi_Bias         =  tzi.Bias
  st.SetValue(CLIP(LEFT(tzi.StandardName)))
  st.ToANSI(st:EncodeUtf16)
  tzi_StandardName =  st.GetValue()
  tzi_StandardDate =  tzi.StandardDate
  tzi_StandardBias =  tzi.StandardBias
  st.SetValue(CLIP(LEFT(tzi.DaylightName)))
  st.ToANSI(st:EncodeUtf16)
  tzi_DaylightName =  st.GetValue()
  tzi_DaylightDate =  tzi.DaylightDate
  tzi_DaylightBias =  tzi.DaylightBias
  EXIT
Get:DynamicTimeZoneInformation ROUTINE
!|
!| Get dynamic timezone information
!|
  DATA
curReturn LONG
  CODE
  curReturn = GetDynamicTimeZoneInformation(ADDRESS(dtzi))
  
  dtzi_Bias                        =  dtzi.Bias
  st.SetValue(CLIP(LEFT(dtzi.StandardName)))
  st.ToANSI(st:EncodeUtf16)
  dtzi_StandardName                =  st.GetValue()
  dtzi_StandardDate                =  dtzi.StandardDate
  dtzi_StandardBias                =  dtzi.StandardBias
  st.SetValue(CLIP(LEFT(dtzi.DaylightName)))
  st.ToANSI(st:EncodeUtf16)
  dtzi_DaylightName                =  st.GetValue()
  dtzi_DaylightDate                =  dtzi.DaylightDate
  dtzi_DaylightBias                =  dtzi.DaylightBias
  st.SetValue(CLIP(LEFT(dtzi.TimeZoneKeyName)))
  st.ToANSI(st:EncodeUtf16)
  dtzi_TimeZoneKeyName             =  st.GetValue()
  dtzi_DynamicDaylightTimeDisabled =  dtzi.DynamicDaylightTimeDisabled
  EXIT
