#!/usr/bin/perl
use Data::Dumper;
use DBI;
use DBD::mysql;
package dh_utils;

require Exporter;

our @ISA= qw( Exporter );
our @EXPORT_OK= qw( updatePage form2data sqlQueryHandler );
our @EXPORT= qw( updatePage form2data sqlQueryHandler );

sub updatePage{
   my $template;
   my $fileName;
   my $replacement;
   my $pattern;

   my $oldFileContent="";

   ($template,$fileName,$replacement,$pattern) = @_;
  
   open(DATA, "<$template");

   while(<DATA>){
   	$oldFileContent.="$_";
   }
   close(DATA);

   $oldFileContent =~ s/$pattern/$replacement/;

   open(DATA,">$fileName");
   print DATA "$oldFileContent";
   close(DATA);
}

sub form2data{

my $FormData = shift;
my $parsedForm = shift;
# Get the name and value for each form input:
@pairs = split(/&/, $FormData);

# Then for each name/value pair....
foreach $pair (@pairs) {

	# Separate the name and value:
	($name, $value) = split(/=/, $pair);

	# Convert + signs to spaces:
	$value =~ tr/+/ /;

	# Convert hex pairs (%HH) to ASCII characters:
	$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

	# Store values in a hash called %FORM:
	$parsedForm->{$name} = $value;
}
return $parsedForm;
}


sub sqlQueryHandler{

# CONFIG VARIABLES
my $platform = "mysql";
my $database = "drunkathome";
my $host = "10.100.102.5";
my $port = "3306";
my $user = "mosh";
my $pw = "111";
my ($query,$feedback) = @_;
# DATA SOURCE NAME
my $dsn = "dbi:$platform:$database:$host:$port";

# PERL DBI CONNECT
my $connect = DBI->connect($dsn, $user, $pw);
# PREPARE THE QUERY
my $query = "$query";
$query_handle = $connect->prepare($query);
# EXECUTE THE QUERY
$query_handle->execute();
# BIND TABLE COLUMNS TO VARIABLES
#$query_handle->bind_columns(undef, $columnString);

if($feedback =~ /YES/)
{
return $query_handle;
}
}



1;
