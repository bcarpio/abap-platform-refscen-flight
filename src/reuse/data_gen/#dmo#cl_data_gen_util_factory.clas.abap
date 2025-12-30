CLASS /dmo/cl_data_gen_util_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES /dmo/if_data_gen_util_factory.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS /dmo/cl_data_gen_util_factory IMPLEMENTATION.
  METHOD /dmo/if_data_gen_util_factory~create_adm_field_gen_instance.
    RETURN new /dmo/cl_admin_field_generator( reference_date ).
  ENDMETHOD.

  METHOD /dmo/if_data_gen_util_factory~create_date_gen_instance.
    RETURN /dmo/cl_date_generator=>/dmo/if_date_generator~get_instance( ).
  ENDMETHOD.

  METHOD /dmo/if_data_gen_util_factory~create_name_gen_instance.
    RETURN /dmo/cl_name_generator=>/dmo/if_name_generator~get_instance( ).
  ENDMETHOD.

  METHOD /dmo/if_data_gen_util_factory~create_text_output_instance.
    RETURN /dmo/cl_text_output_util=>/dmo/if_text_output_util~get_instance( out ).
  ENDMETHOD.

ENDCLASS.
