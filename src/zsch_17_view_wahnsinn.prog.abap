*&---------------------------------------------------------------------*
*& Report ZSCH_17_VIEW_WAHNSINN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsch_17_view_wahnsinn.

TYPE-POOLS: abap.
* Mit Fremdschlüsselverprobung
PARAMETERS: pa_cust TYPE zsch016address-customid.
* Kunden und Adressen
DATA: lt_vca TYPE TABLE OF zsch017vca,
      ls_vca LIKE LINE OF lt_vca.
* Intervallpflege für die Adressen-ID
SELECT-OPTIONS: so_adr FOR ls_vca-addressid.
* Flags für Gruppenwechsel
DATA: ld_new_customid  TYPE abap_bool VALUE abap_false,
      ld_new_addressid TYPE abap_bool VALUE abap_false.
* Hier geht es los mit der Datenselektion
START-OF-SELECTION.
* Lesen vom View
  SELECT * FROM zsch017vca
  INTO TABLE lt_vca
  UP TO 2 ROWS
  WHERE customid = pa_cust
  AND addressid IN so_adr
  ORDER BY customid plz ASCENDING.
  IF lines( lt_vca ) > 0.
* In den LOOP kommt man nur, wenn Daten vorhanden sind
    LOOP AT lt_vca INTO ls_vca.
      AT NEW customid.
        ld_new_customid = abap_true.
      ENDAT.
      AT NEW addressid.
        ld_new_addressid = abap_true.
      ENDAT.
      IF ld_new_customid = abap_true.
        ld_new_customid = abap_false.
* Ausgabe des Namens
        WRITE: / 'Kunde'(t01),
        ls_vca-customid,
        ':', ls_vca-vorname,
        ls_vca-nachname.
      ENDIF.
      IF ld_new_addressid = abap_true.
        ld_new_addressid = abap_false.
        WRITE: / 'Adresse '(t02), sy-tabix, ': ',
        ls_vca-plz, ls_vca-ort, ls_vca-strasse.
      ENDIF.
    ENDLOOP.
  ELSE.
    WRITE: / 'Leider nichts gefunden'(t03).
  ENDIF.
