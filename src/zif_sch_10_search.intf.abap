interface ZIF_SCH_10_SEARCH
  public .


  data GD_THINGS_COUNT type I .

  methods GET_IT
    importing
      !ID_THING type STRING
    exporting
      !ET_THINGS type STRINGTAB .
endinterface.
