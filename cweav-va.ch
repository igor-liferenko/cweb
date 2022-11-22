@x
      default: err_print("! Improper macro definition"); break;
@y
      case dot_dot_dot: app_str("\\,\\ldots\\,"); @.\\,@> @.\\ldots@>
        app_scrap(raw_int,no_math);
        if ((next_control=get_next())==')') {
          app(next_control); next_control=get_next(); break;
        } /* otherwise fall through */
      default: err_print("! Improper macro definition"); break;
@z
