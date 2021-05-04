class ZCL_SCH_11_BUCH definition
  public
  create public .

public section.

  class-methods CHECK_IN_TIME
    raising
      ZCX_SCH_011_TERMINTREUE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SCH_11_BUCH IMPLEMENTATION.


  method CHECK_IN_TIME.

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

  endmethod.
ENDCLASS.
