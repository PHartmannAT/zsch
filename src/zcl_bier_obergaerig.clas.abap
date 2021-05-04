class ZCL_BIER_OBERGAERIG definition
  public
  inheriting from ZCL_BIER
  create public .

public section.

  methods BRAUEN
    redefinition .
  methods WRITE_STAMMWUERZE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BIER_OBERGAERIG IMPLEMENTATION.


  method BRAUEN.

    CALL METHOD super->brauen.
    WRITE: /'Lieber obergärig?'.

  endmethod.


  METHOD write_stammwuerze.
    WRITE 'Obergärige Stammwürze: '.
    CALL METHOD super->write_stammwuerze.
  ENDMETHOD.
ENDCLASS.
