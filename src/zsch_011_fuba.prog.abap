*&---------------------------------------------------------------------*
*& Report ZSCH_011_FUBA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsch_011_fuba.

*DATA: gd_result TYPE string.
*
*START-OF-SELECTION.
*
*  CALL FUNCTION 'ICON_CREATE'
*    EXPORTING
*      name                  = 'Schrödinger'
**     TEXT                  = ' '
**     INFO                  = ' '
**     ADD_STDINF            = 'X'
*    IMPORTING
*      result                = gd_result
*    EXCEPTIONS
*      icon_not_found        = 1
*      outputfield_too_short = 2
*      OTHERS                = 3.
*
*  IF sy-subrc = 0.
*    WRITE: / 'Yippieh, alles OK'.
*  ELSEIF sy-subrc = 1.
*    WRITE: / 'Icon leider nicht gefunden'.
*  ELSEIF sy-subrc = 2.
*    WRITE: / 'Leider war ich bei der Definition der',
*             'Ergebnisvariable nicht vorsichtig genug.'.
*  ELSE.
*    WRITE: / 'Was da wohl passiert ist? ',
*             'Auf alle Fälle eine Ausnahme'.
*  ENDIF.

  DATA: gd_result TYPE i,
        gd_number TYPE i.

  CATCH SYSTEM-EXCEPTIONS arithmetic_errors = 4
                          OTHERS = 8.
    gd_result = 1 / gd_number.
  ENDCATCH.
  IF sy-subrc <> 0.
    WRITE: / 'Erwischt!'.
  ENDIF.
