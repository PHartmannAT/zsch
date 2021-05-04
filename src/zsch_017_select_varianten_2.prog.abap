*&---------------------------------------------------------------------*
*& Report ZSCH_017_SELECT_VARIANTEN_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsch_017_select_varianten_2.

DATA: gd_int TYPE i.

START-OF-SELECTION.
*  SELECT DISTINCT ort FROM zsch016address INTO gd_int.
*  ENDSELECT.

  SELECT customid, vorname, nachname
    FROM zsch016customer
    INTO @DATA(ls_customer_sub)
    UP TO 1 ROWS.
    WRITE: / ls_customer_sub-vorname,
    ls_customer_sub-nachname.
    SELECT ort, strasse
      FROM zsch016address
      INTO  @DATA(ls_address_sub)
      UP TO 2 ROWS
      WHERE customid = @ls_customer_sub-customid.
      WRITE: / ls_address_sub-ort.
      WRITE: ls_address_sub-strasse.
    ENDSELECT.
  ENDSELECT.
