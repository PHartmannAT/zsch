class ZCL_SCH_10_KATZE definition
  public
  final
  create public .

public section.

  interfaces ZIF_SCH_10_SEARCH .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SCH_10_KATZE IMPLEMENTATION.


  METHOD zif_sch_10_search~get_it.

    IF id_thing = 'Stockerl'.
      APPEND 'Sicher nicht!' TO et_things.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
