pacakge DB;

use strict;
use warnings;

use Carp;
use List::Util qw(first);


use MediaWords;

use CConfig;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_classes;


# Created by DBIx::Class::Schema::Loader 
# DO NOT MODIFY THIS OR ANYTHING ABOVE!


my $_connect_settings;


# takes a hashref to a hash of settings and returns an array
#  with DBI connect info

sub _create_connect_info_fron_settings
{
    my($settings) = @_;
    return(
      'dbi:Pg:dbname=' . $settings->{ db } . ';host=' . $settings->{ host },
        $settings->{ user },
        $settings->{ pass },
        {
            AutoCommit     => 1,
            pg_enable_utf8 => 1,
            RaiseError     => 1
        }  
    ); 
}




# returns connection info from the configuration file
# if no connection label is supplied and no connections have been made,
# the first connection in the config is used otherwise the last used settings
# are returned



sub connect_info
{
    my ($label) = @_;
    my $settings = connect_settings($label);
    return _create_connect_info_fron_settings($settings);
}



sub connect_to_db
{
    my ( $label ) = @_;

    return MediaWords->connect( connect_info( $label ) );
}



sub connect_settings
{
    my ( $label ) = @_;

    my $all_settings = CConfig->get_config->{ database };
    
    defined( $all_settings ) or croak( "No database connections configured" );
    #TODO temporary settelment
    $label = "LABEL";
    if ( defined( $label ) )
    {
        $_connect_settings = first { $_->{ label } eq $label } @{ $all_settings }
          or croak "No database connection settings labeled '$label'";
    }

    if ( !defined( $_connect_settings ) )
    {
        $_connect_settings = $all_settings->[ 0 ];
    }

    return $_connect_settings;
}

sub authenticate
{
    my ( $self, $label ) = @_;

    return __PACKAGE__->connect( connect_info( $label ) );
}

# You can replace this text with custom content, and it will be preserved on regeneration
1;
