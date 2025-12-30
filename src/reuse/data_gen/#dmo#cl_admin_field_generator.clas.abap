CLASS /dmo/cl_admin_field_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /dmo/if_admin_field_generator.

    METHODS constructor
      IMPORTING reference_date TYPE d OPTIONAL.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA user            TYPE /dmo/if_admin_field_generator~user_type.
    DATA date_generator  TYPE REF TO /DMO/IF_DATE_GENERATOR.
    DATA reference_date  TYPE d.
    DATA created_at_date TYPE d.
    DATA changed_at_tmsp TYPE timestampl.

    METHODS generate_changed
      RETURNING VALUE(last_changed_at) TYPE timestampl.

    METHODS get_created_at_date RETURNING VALUE(result) TYPE d.

    METHODS generate_user
      RETURNING VALUE(result) TYPE /dmo/if_admin_field_generator~user_type.
ENDCLASS.



CLASS /dmo/cl_admin_field_generator IMPLEMENTATION.


  METHOD constructor.
    me->reference_date = reference_date.
    IF date_generator IS NOT BOUND.
      date_generator = /dmo/cl_data_gen_util_factory=>/dmo/if_data_gen_util_factory~create_date_gen_instance( ).
    ENDIF.
  ENDMETHOD.

  METHOD generate_user.
    IF user IS INITIAL.
      DATA(name) = /dmo/cl_data_gen_util_factory=>/dmo/if_data_gen_util_factory~create_name_gen_instance( )->generate( ).
      user = |{ to_upper( name-last ) }{ to_upper( name-first(1) ) }|.
    ENDIF.

    RETURN USER.
  ENDMETHOD.

  METHOD /dmo/if_admin_field_generator~generate_local_created_by.
    RETURN generate_user( ).
  ENDMETHOD.

  METHOD /dmo/if_admin_field_generator~generate_local_last_changed_by.
    RETURN generate_user( ).
  ENDMETHOD.

  METHOD /dmo/if_admin_field_generator~generate_local_created_at.
    created_at_date = get_created_at_date( ).
    RETURN date_generator->date_to_timestamp( created_at_date ).
  ENDMETHOD.

  METHOD generate_changed.
    IF changed_at_tmsp IS INITIAL.
      DATA(lastchanged_date) = date_generator->generate_new_date_with_offset( get_created_at_date( ) ).
      changed_at_tmsp = date_generator->date_to_timestamp( lastchanged_date ).
    ENDIF.
    RETURN changed_at_tmsp.
  ENDMETHOD.

  METHOD /dmo/if_admin_field_generator~generate_last_changed_at.
    RETURN generate_changed( ).
  ENDMETHOD.

  METHOD /dmo/if_admin_field_generator~generate_local_last_changed_at.
    RETURN generate_changed( ).
  ENDMETHOD.

  METHOD get_created_at_date.
    IF created_at_date IS INITIAL.
      created_at_date = date_generator->calc_days_before_ref_or_today( reference_date ).
    ENDIF.
    RETURN me->created_at_date.
  ENDMETHOD.
ENDCLASS.
