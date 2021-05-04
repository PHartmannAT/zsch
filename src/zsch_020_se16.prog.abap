*&---------------------------------------------------------------------*
*& Report ZSCH_020_SE16
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsch_020_se16.

PARAMETERS: pa_tab TYPE string.
DATA: go_struct TYPE REF TO cl_abap_structdescr,
      go_table  TYPE REF TO cl_abap_tabledescr,
      gr_table  TYPE REF TO data.
FIELD-SYMBOLS: <gt_table> TYPE table.
go_struct = CAST #( cl_abap_structdescr=>describe_by_name( pa_tab ) ).
go_table = cl_abap_tabledescr=>create( go_struct ).
CREATE DATA gr_table TYPE HANDLE go_table.
ASSIGN gr_table->* TO <gt_table>.
SELECT * FROM (pa_tab) INTO TABLE <gt_table>.
* Ausgabe der Daten
DATA: gr_alv TYPE REF TO cl_salv_table.
cl_salv_table=>factory(
IMPORTING
r_salv_table = gr_alv
CHANGING
t_table = <gt_table> ).
gr_alv->display( ).
