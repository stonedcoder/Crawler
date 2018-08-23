package CConfig;


# Parse and return data from mediawords.yml config file.




use strict;

use Carp;
use Dir::Self

use Config::Any;
# cache config object so that it remains the same from call to call

my $_config;

# base dir
my $_base_dir = __DIR__;

sub get_config 
{

    if ($_config)
    {
        return $_config;
    }

    # TODO : this should be standardized 
    set_config_file($_base_dir . '/Crawler_config.yml);


    return $_config
}

# set the cache config object given a file path 

sub set_config_file
{
    my $config_file = shift ;
    -r $config_file or croak "Can't read from $config_file";

     #print "config:file: $config_file\n";
    set_config( Config::Any->load_files( { files => [ $config_file ], use_ext => 1 } )->[ 0 ]->{ $config_file } );
    
 }

 #set the cached config object 
 
 sub set_config 
{
    my ($config) = @_;

    if ($config){
        carp("config object already cached")
    }

    $_config  = set_defaults($config);
    verify_settings($_config);
}


sub set_defaults
{
    my ($_config) = @_;

    $config->{ mediawords }->{ script_dir } ||= "$_base_dir/script";
    $config->{ mediawords }->{ data_dir }   ||= "$_base_dir/data";
    $config->{ session }->{ storage }       ||= "$ENV{HOME}/tmp/mediacloud-session";

    return $config;
}



sub verify_settings
{
    my ($config) = @_;

    defined( $config->{database}) or croak "No DB connection configured."
}

1;