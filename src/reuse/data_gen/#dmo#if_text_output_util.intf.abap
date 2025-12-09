INTERFACE /dmo/if_text_output_util
  PUBLIC.
  CLASS-METHODS get_instance
    IMPORTING !out          TYPE REF TO if_oo_adt_classrun_out
    RETURNING VALUE(result) TYPE REF TO /dmo/cl_text_output_util.

  METHODS print_title
    IMPORTING !title TYPE string.

  METHODS print_delete.
  METHODS print_build.
  METHODS print_insert.
  METHODS print_done.

ENDINTERFACE.
