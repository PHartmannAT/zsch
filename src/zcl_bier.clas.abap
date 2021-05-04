class ZCL_BIER definition
  public
  abstract
  create public .

public section.

  types:
    gdt_alkoholgehalt TYPE p LENGTH 3 DECIMALS 2 .

  data:
    gd_stammwuerze TYPE p  LENGTH 3 DECIMALS 2 value '12.50' ##NO_TEXT.

  methods WRITE_STAMMWUERZE .
  methods BRAUEN .
  methods SET_ALKOHOLGEHALT
    importing
      !ID_ALOHOLGEHALT type GDT_ALKOHOLGEHALT .
protected section.

  data GD_VOLUMEN type I value '333' ##NO_TEXT.

  methods WRITE_VOLUMEN .
private section.

  data GD_ALKOHOLGEHALT type GDT_ALKOHOLGEHALT value '4.50' ##NO_TEXT.
ENDCLASS.



CLASS ZCL_BIER IMPLEMENTATION.


  method BRAUEN.

    WRITE: / 'Ich braue und braue den ganzen Tag'.

  endmethod.


  method SET_ALKOHOLGEHALT.

    me->gd_alkoholgehalt = id_aloholgehalt.

  endmethod.


  method WRITE_STAMMWUERZE.

    WRITE: me->gd_stammwuerze.

  endmethod.


  method WRITE_VOLUMEN.

    WRITE: gd_volumen.

  endmethod.
ENDCLASS.
