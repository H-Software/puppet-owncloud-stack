#########################################################
#                                                       
# owncloudstack php class
#
#########################################################
class owncloudstack::php ()
{
  if $::owncloudstack::php_extra_modules != undef {
    php::module { [ $::owncloudstack::php_extra_modules ]:
    }
  }
}
