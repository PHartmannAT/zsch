*&---------------------------------------------------------------------*
*& Report ZSCH_011_OO_EXEC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsch_011_oo_exec.

CLASS lcl_buch DEFINITION.
  PUBLIC SECTION.
* Ausnahme propagieren
    CLASS-METHODS: check_in_time
      RAISING zcx_sch_011_termintreue.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_buch IMPLEMENTATION.
  METHOD check_in_time.
* Die Nachricht
    DATA: ls_textid LIKE if_t100_message=>t100key.
* Hier kommen die komplexen Ermittlungen
* ...
* Nehmen wir mal an, dass der Autor mit dem Buch+
* nicht in der Zeit liegt. Ausnahme werfen!
    ls_textid-msgid = 'ZSCH_011'.
    ls_textid-msgno = 001.
* Lieber Autor! Deinen Termin wirst du nicht halten können.
* Schäme dich
    RAISE EXCEPTION TYPE zcx_sch_011_termintreue
      EXPORTING
        textid = ls_textid
*       previous =
      .
  ENDMETHOD.
ENDCLASS.

* Die Referenz auf das Ausnahmeobjekt
DATA: lr_exc  TYPE REF TO zcx_sch_011_termintreue,
* Der Text zur Ausnahme
      ld_text TYPE string.

START-OF-SELECTION.
* Behandlung
  TRY.
* Die Methode kann eine Ausnahme werfen
      lcl_buch=>check_in_time( ).
* Alles OK.
      WRITE: / 'Der Autor war brav und alles ist im Plan'.
* Falls eine Ausnahme auftritt, dann der CATCH-Teil
    CATCH zcx_sch_011_termintreue INTO lr_exc.
      ld_text = lr_exc->get_text( ).
      WRITE: / ld_text.
  ENDTRY.
