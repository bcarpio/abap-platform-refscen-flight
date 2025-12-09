INTERFACE /dmo/if_admin_field_generator PUBLIC.
  TYPES user_type TYPE c LENGTH 40.

  METHODS generate_local_created_at
    RETURNING VALUE(local_created_at) TYPE timestampl.

  METHODS generate_last_changed_at
    RETURNING VALUE(last_changed_at) TYPE timestampl.

  METHODS generate_local_last_changed_at
    RETURNING VALUE(last_changed_at) TYPE timestampl.

  METHODS generate_local_created_by
    RETURNING VALUE(result) TYPE user_type.

  METHODS generate_local_last_changed_by
    RETURNING VALUE(result) TYPE user_type.
ENDINTERFACE.
