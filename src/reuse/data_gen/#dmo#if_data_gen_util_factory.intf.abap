INTERFACE /dmo/if_data_gen_util_factory
  PUBLIC.
  CLASS-METHODS create_adm_field_gen_instance
    IMPORTING reference_date TYPE d OPTIONAL
    RETURNING VALUE(instance) TYPE REF TO /dmo/if_admin_field_generator.

  CLASS-METHODS create_date_gen_instance
    RETURNING VALUE(instance) TYPE REF TO /dmo/if_date_generator.

  CLASS-METHODS create_name_gen_instance
    RETURNING VALUE(instance) TYPE REF TO /dmo/if_name_generator.

  CLASS-METHODS create_text_output_instance
    IMPORTING !out            TYPE REF TO if_oo_adt_classrun_out
    RETURNING VALUE(instance) TYPE REF TO /dmo/if_text_output_util.

ENDINTERFACE.
