*&---------------------------------------------------------------------*
*& Report ZSCH_09_BEER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsch_09_beer.

CLASS lcl_bier DEFINITION.
  PUBLIC SECTION.
    DATA: gd_stammwuerze TYPE p  LENGTH 3 DECIMALS 2 VALUE '12.50'.
    METHODS: write_stammwuerze.
    TYPES: gdt_alkoholgehalt TYPE p LENGTH 3 DECIMALS 2.
    METHODS: set_alkoholgehalt
      IMPORTING id_aloholgehalt TYPE gdt_alkoholgehalt.
    METHODS: brauen.
  PROTECTED SECTION.
    DATA: gd_volumen TYPE i VALUE '333'.
    METHODS: write_volumen.
  PRIVATE SECTION.
    DATA: gd_alkoholgehalt TYPE gdt_alkoholgehalt
                           VALUE '4.50'.
ENDCLASS.

CLASS lcl_bier IMPLEMENTATION.
  METHOD write_stammwuerze.
    WRITE: me->gd_stammwuerze.
  ENDMETHOD.
  METHOD write_volumen.
    WRITE: gd_volumen.
  ENDMETHOD.
  METHOD set_alkoholgehalt.
    me->gd_alkoholgehalt = id_aloholgehalt.
  ENDMETHOD.
  METHOD brauen.
    WRITE: / 'Ich braue und braue den ganzen Tag'.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_bier_untergaerig DEFINITION
                           INHERITING FROM lcl_bier.
  PUBLIC SECTION.
    METHODS: brauen REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_bier_untergaerig IMPLEMENTATION.
  METHOD brauen.
    CALL METHOD super->brauen.
    WRITE: /'Sogar untergärig'.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_bier_obergaerig DEFINITION
                          INHERITING FROM lcl_bier.
  PUBLIC SECTION.
    METHODS: brauen REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_bier_obergaerig IMPLEMENTATION.
  METHOD brauen.
    CALL METHOD super->brauen.
    WRITE: /'Lieber obergärig?'.
  ENDMETHOD.
ENDCLASS.

DATA: gr_untergaerig TYPE REF TO lcl_bier_untergaerig.
DATA: gr_obergaerig TYPE REF TO zcl_bier_obergaerig.
DATA: gr_bier TYPE REF TO zcl_bier.

START-OF-SELECTION.

* Untergäriges
  CREATE OBJECT gr_untergaerig.
* Ausgabe
  CALL METHOD gr_untergaerig->write_stammwuerze.
* Andere Ausgabe "von aussen
  WRITE: gr_untergaerig->gd_stammwuerze.

* Obergäriges
  CREATE OBJECT gr_obergaerig.
* Stammwürze
  CALL METHOD gr_obergaerig->write_stammwuerze.

  CREATE OBJECT gr_bier.
* Geschützer Down-Cast.
  TRY.
      gr_obergaerig ?= gr_bier.
    CATCH cx_sy_move_cast_error.
      WRITE: 'Das ging leider in die Hose'.
  ENDTRY.
