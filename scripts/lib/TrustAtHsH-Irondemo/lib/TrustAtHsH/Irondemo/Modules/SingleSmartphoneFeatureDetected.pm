package TrustAtHsH::Irondemo::Modules::SingleSmartphoneFeatureDetected;

use 5.006;
use strict;
use warnings;
use Carp qw(croak);
use File::Spec;
use File::Basename;
use lib '../../../';
use parent 'TrustAtHsH::Irondemo::AbstractIfmapCliModule';


my $DEVICE = "device";
my $ACCESS_REQUEST = "access-request";
my $FEATURE_ID = "feature-id";
my $FEATURE_TYPE = "feature-type";
my $FEATURE_VALUE = "feature-value";
my $IFMAP_USER = 'ifmap-user';
my $IFMAP_PASS = 'ifmap-pass';

my @REQUIRED_ARGS = (
	$DEVICE, $ACCESS_REQUEST, $FEATURE_ID, $FEATURE_TYPE, $FEATURE_VALUE, $IFMAP_USER, $IFMAP_PASS);


### INSTANCE METHOD ###
# Purpose     :
# Returns     : True value on success, false value on failure
# Parameters  : None
# Comments    :
sub execute {
	my $self = shift;
	my $data = $self->{'data'};

	my $result = 1;

	my @argsList = ($data->{$ACCESS_REQUEST}, $data->{$DEVICE});
	my @argsListFeature = ($data->{$FEATURE_ID}, $data->{$FEATURE_TYPE}, $data->{$FEATURE_VALUE}, $data->{$DEVICE});
	my $connectionArgs = {
		"ifmap-user" => $data->{$IFMAP_USER},
		"ifmap-pass" => $data->{$IFMAP_PASS}
	};

	$result &= $self->call_ifmap_cli({
			'cli_tool' => "ar-dev",
			'mode' => "update",
			'args_list' => \@argsList,
			'connection_args' => $connectionArgs});

	$result &= $self->call_ifmap_cli({
			'cli_tool' => "featureSingle",
			'mode' => "update",
			'args_list' => \@argsListFeature,
			'connection_args' => $connectionArgs});

	return $result;
}


### INSTANCE METHOD ###
# Purpose     :
# Returns     :
# Parameters  :
# Comments    :
sub get_required_arguments {
	my $self = shift;

	return @REQUIRED_ARGS;
}


### INTERNAL UTILITY ###
# Purpose     :
# Returns     :
# Parameters  : data ->
#                 ifmap-user          ->(optional)
#                 ifmap-pass          ->(optional)
#                 ifmap-url           ->(optional)
#                 ifmap-keystore-path ->(optional)
#                 ifmap-keystore-pass ->(optional)
#                 device              ->
#                 access-request      ->
#
# Comments    : Override, called from parent's constructor
sub _init {
	my $self = shift;
	my $args = shift;

	while ( my ($key, $val) = each %{$args} ) {
		$self->{'data'}->{$key} = $val;
	}
}


1;