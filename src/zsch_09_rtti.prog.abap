*&---------------------------------------------------------------------*
*& Report ZSCH_09_RTTI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsch_09_rtti.
* Beschreibungsobjekte
DATA: gr_typedescr           TYPE REF TO cl_abap_typedescr, "*2
      gr_typedescr_typedescr TYPE REF TO cl_abap_typedescr. "*3

START-OF-SELECTION.
* Beispiel 1: Datenelement"*4
  WRITE: / 'Name des Datenelements: XUBNAME'.
* Beschreibung zum Datenelement
  gr_typedescr =
  cl_abap_typedescr=>describe_by_name( 'XUBNAME' )."*5
* Beschreibung des Beschreibungsobjektes, um Typ zu ermitteln
  gr_typedescr_typedescr =
  cl_abap_typedescr=>describe_by_object_ref( gr_typedescr )."*6
* Ausgabe des Klassennamens
  WRITE: / 'Beschreibungsobjekt Typname:',
  gr_typedescr_typedescr->absolute_name(30)."*7
  SKIP 2.

* Beispiel 2: Struktur
  WRITE: / 'Name der Struktur: USR01'.
* Beschreibung zur Struktur
  gr_typedescr = cl_abap_typedescr=>describe_by_name( 'USR01' ).
* Beschreibung des Beschreibungsobjektes, um Typ zu ermitteln
  gr_typedescr_typedescr =
  cl_abap_typedescr=>describe_by_object_ref( gr_typedescr ).
* Ausgabe des Klassennamens
  WRITE: / 'Typ des Beschreibungsobjektes:',
  gr_typedescr_typedescr->absolute_name(30).
