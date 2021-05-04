*&---------------------------------------------------------------------*
*& Report ZSCH_08_C_MACHINE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsch_08_c_machine.

TYPE-POOLS: abap.

CLASS lcl_wasserbehaelter DEFINITION.
* Hier kommen die Definitionen hinein.
* Öffentlicher Bereich
  PUBLIC SECTION.
* Wasserhärte Grenze in °dH
    CONSTANTS: gc_wasser_haerte_grenze TYPE f VALUE '14.0'.
*               METHODS get_wasserstand EXPORTING ed_wasserstand TYPE i.
    METHODS get_wasserstand
      RETURNING VALUE(rd_wasserstand) TYPE i.
* Wasserstand
    METHODS set_wasserstand
      IMPORTING VALUE(id_wasserstand) TYPE i.

* Wasserhärte prüfen
    METHODS check_wasser_haerte.

* Geschützter Bereich
  PROTECTED SECTION.

* Privater Bereich
  PRIVATE SECTION.
* Wasserstand
    DATA gd_wasserstand TYPE i.

* Wasserhärte
    DATA: gd_wasser_haerte TYPE f.

ENDCLASS.

CLASS lcl_wasserbehaelter IMPLEMENTATION.
* Hier kommen die Implementierungen hinen
* Wasserstand holen
  METHOD get_wasserstand.
* Wasserstand zurückliefern
    rd_wasserstand = me->gd_wasserstand.
  ENDMETHOD.
* Wasserstand leer?
  METHOD set_wasserstand.
    id_wasserstand = me->gd_wasserstand.
  ENDMETHOD.

* Wasserhärte prüfen
  METHOD check_wasser_haerte.
    IF me->gd_wasser_haerte > gc_wasser_haerte_grenze.
      MESSAGE 'AU, das tut weh!' TYPE 'I'.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

*Definitionsteil des Kaffeevollautomaten
CLASS lcl_kaffeevollautomat DEFINITION.
* Hier kommen die Definitionen hinein.
* Öffentlicher Bereich
  PUBLIC SECTION.
* Anzahl der Objekte
    CLASS-DATA: anz_kva TYPE i.
* Kaffee bitte
    METHODS ein_kaffee_sil_vous_plait
      IMPORTING
        VALUE(id_espresso)      TYPE abap_bool OPTIONAL
        VALUE(id_verlaengerter) TYPE abap_bool OPTIONAL.
* Die Assoziation zum Wasserbehälter
    DATA gr_wasserbehaelter
            TYPE REF TO lcl_wasserbehaelter.
* Bohne ergänzen
    METHODS bohne_nachfuellen
      IMPORTING
        ir_bohne TYPE REF TO zcl_sch_08_cbean.
* Hochzähler
    CLASS-METHODS add_1_to_anz_kva.
* Konstrukteur
    METHODS: constructor.
* Behandle den Schrei des Bohnenbehälters
    METHODS: on_loaded
        FOR EVENT loaded
        OF zcl_sch_08_cbean_box.

* Geschützter Bereich
  PROTECTED SECTION.

* Privater Bereich
  PRIVATE SECTION.
* Die Assoziation zum Bohnenbehälter
    DATA gr_bohnenbehaelter
            TYPE REF TO zcl_sch_08_cbean_box.
ENDCLASS.

* Implementationsteil des Kaffeevollautomaten
CLASS lcl_kaffeevollautomat IMPLEMENTATION.
* Hier kommen die Implementierungen hinen,
* Constructor
  METHOD constructor.
* Initialisierung für das Objekt
* Mit Methodenaufruf
    CALL METHOD add_1_to_anz_kva.
* Wasserbehälter erzeugen
    CREATE OBJECT me->gr_wasserbehaelter.
* Wasserstand setzen
    me->gr_wasserbehaelter->set_wasserstand(
    id_wasserstand = 1000 ).
* Bohnenbehälter erzeugen
    CREATE OBJECT me->gr_bohnenbehaelter.
* Bohnenbehälter zuhören
    SET HANDLER me->on_loaded
    FOR me->gr_bohnenbehaelter.
  ENDMETHOD.


* Bohne nachfüllen
  METHOD bohne_nachfuellen.
* Bohne übergeben
    me->gr_bohnenbehaelter->add_bean_to_box(
      ir_cbean = ir_bohne ).
  ENDMETHOD.
* Schreibehandlung
  METHOD on_loaded.
* Mach was als Reaktion auf den Schrei
  ENDMETHOD.

* Einen Kaffee bitte
  METHOD ein_kaffee_sil_vous_plait.
* Hier kommen die Implementierungen hinen,
  ENDMETHOD.
* Hochzählen
  METHOD add_1_to_anz_kva.
* Hier kommen die Implementierungen hinen,
  ENDMETHOD.

ENDCLASS.
**********************************************************************
* Kaffee Zubereitungsart
DATA gd_zubereitungsart TYPE char40.
*Referenz auf Kaffeevollautomat
DATA gr_rolands_kva TYPE REF TO lcl_kaffeevollautomat.
DATA gr_mein_kva TYPE REF TO lcl_kaffeevollautomat.
DATA gr_golden_bean TYPE REF TO zcl_sch_08_cbean.

START-OF-SELECTION.
* Rolands KVA anlegen
  CREATE OBJECT gr_rolands_kva.
* Mein KVA
  CREATE OBJECT gr_mein_kva.
* Bohnenschleife
* 7.150 Bohnen sind in wie viel Kilogramm Kaffee ?
  DO 7000 TIMES.
* Bohne anlegen
    CREATE OBJECT gr_golden_bean.
* Bohne übergeben
    gr_mein_kva->bohne_nachfuellen(
      ir_bohne = gr_golden_bean ).
  ENDDO.
