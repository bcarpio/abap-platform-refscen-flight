INTERFACE /dmo/if_data_generator
  PUBLIC .
  CLASS-METHODS:
    create
      IMPORTING out TYPE REF TO if_oo_adt_classrun_out OPTIONAL.
ENDINTERFACE.
