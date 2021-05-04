*&---------------------------------------------------------------------*
*& Report ZSCH_017_SELECT_VARIANTEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsch_017_select_varianten.

DATA: ls_customer TYPE zsch016customer,
      ls_address  TYPE zsch016address.

START-OF-SELECTION.

  SELECT DISTINCT ort FROM zsch016address
    INTO ls_address-ort.
    WRITE: / ls_address-ort.
  ENDSELECT.
