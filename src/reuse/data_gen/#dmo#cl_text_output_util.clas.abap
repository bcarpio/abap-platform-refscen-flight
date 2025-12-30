CLASS /dmo/cl_text_output_util DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.
    INTERFACES /dmo/if_text_output_util.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA:
      instance TYPE REF TO /dmo/cl_text_output_util.

    DATA:
      out TYPE REF TO if_oo_adt_classrun_out.

    METHODS:
      constructor
        IMPORTING
          out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.



CLASS /dmo/cl_text_output_util IMPLEMENTATION.

  METHOD /dmo/if_text_output_util~get_instance.
    IF instance IS NOT BOUND.
      instance = NEW /dmo/cl_text_output_util( out ).
    ENDIF.
    result = instance.
  ENDMETHOD.

  METHOD constructor.
    me->out = out.
  ENDMETHOD.

  METHOD /dmo/if_text_output_util~print_build.
    IF out IS BOUND.
      out->write( '--> Build Content.' ) ##NO_TEXT.
    ENDIF.
  ENDMETHOD.

  METHOD /dmo/if_text_output_util~print_delete.
    IF out IS BOUND.
      out->write( '--> Delete Content.' ) ##NO_TEXT.
    ENDIF.
  ENDMETHOD.

  METHOD /dmo/if_text_output_util~print_done.
    IF out IS BOUND.
      out->write( |--> Done.\r\n| ) ##NO_TEXT.
    ENDIF.
  ENDMETHOD.

  METHOD /dmo/if_text_output_util~print_insert.
    IF out IS BOUND.
      out->write( '--> Insert Content.' ) ##NO_TEXT.
    ENDIF.
  ENDMETHOD.

  METHOD /dmo/if_text_output_util~print_title.
    IF out IS BOUND.
      out->write( |Generating Data: { title }.| ) ##NO_TEXT.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
