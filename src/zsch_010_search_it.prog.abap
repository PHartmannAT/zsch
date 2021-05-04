*&---------------------------------------------------------------------*
*& Report ZSCH_010_SEARCH_IT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsch_010_search_it.

*Interface zu suchen
INTERFACE lif_search.
  METHODS get_it
    IMPORTING
      id_thing  TYPE string
    EXPORTING
      et_things TYPE stringtab.
  DATA gd_things_count TYPE i.
ENDINTERFACE.

CLASS lcl_katze DEFINITION.
  PUBLIC SECTION.
    INTERFACES zif_sch_10_search.
    METHODS: get_it.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_lieblingssuchmaschine DEFINITION.
  PUBLIC SECTION.
    INTERFACES zif_sch_10_search.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_katze IMPLEMENTATION.
  METHOD zif_sch_10_search~get_it.
    DATA: ld_thing LIKE LINE OF et_things.
    CONCATENATE
    'Du suchst: '
    id_thing INTO ld_thing SEPARATED BY space.
    APPEND 'Ich bin es, die Katze' TO et_things.
    APPEND ld_thing TO et_things.
    APPEND 'Ich bringe dir sicher nichts!' TO et_things.
  ENDMETHOD.
  METHOD get_it.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_lieblingssuchmaschine IMPLEMENTATION.
  METHOD zif_sch_10_search~get_it.
    DATA: ld_thing LIKE LINE OF et_things.
    CONCATENATE
    'Du suchst: '
    id_thing INTO ld_thing SEPARATED BY space.
    APPEND 'Ich bin es, die Katze' TO et_things.
    APPEND ld_thing TO et_things.
    APPEND 'Ich bringe dir sicher nichts!' TO et_things.
  ENDMETHOD.
ENDCLASS.

INTERFACE lif_unddafueristdiemethodeaus.
  METHODS: demifumeinkleinesstuecklaenger.
ENDINTERFACE.

CLASS lcl_hotnunendlichlangennamen DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_unddafueristdiemethodeaus.
    ALIASES: kuerzer FOR lif_unddafueristdiemethodeaus~demifumeinkleinesstuecklaenger.
ENDCLASS.

CLASS lcl_hotnunendlichlangennamen IMPLEMENTATION.
  METHOD lif_unddafueristdiemethodeaus~demifumeinkleinesstuecklaenger.
  ENDMETHOD.
ENDCLASS.

DATA: gr_schroedingers_maschine TYPE REF TO lcl_lieblingssuchmaschine, "ORef
      gr_schroedingers_katze    TYPE REF TO lcl_katze, "ORef
      gr_search                 TYPE REF TO zif_sch_10_search, "Interface-Referenz
      gt_things                 TYPE stringtab.

START-OF-SELECTION.
*Objekte instanziieren
  CREATE OBJECT gr_schroedingers_maschine.
  CREATE OBJECT gr_schroedingers_katze.
*Sprich mit der Suchmaschine
* ?-Cast
  gr_search = gr_schroedingers_maschine.
  gr_search->get_it(
    EXPORTING
      id_thing  = 'Stockerl'
    IMPORTING
      et_things = gt_things ).
*Sprich mit der Katze
*?-Cast
  gr_search =  gr_schroedingers_katze.
  gr_search->get_it(
    EXPORTING
      id_thing  = 'Stockerl'
    IMPORTING
      et_things = gt_things ).

*  CALL METHOD gr_schroedingers_katze->zif_sch_10_search~get_it
*    EXPORTING
*      id_thing  = 'Stockerl'
*    IMPORTING
*      et_things = gt_things.
*
*  CALL METHOD gr_schroedingers_katze->get_it.
