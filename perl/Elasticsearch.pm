#!/usr/bin/perl

package SyslogNG::Elasticsearch;

use warnings;
use strict;
use Search::Elasticsearch;
use Data::Dumper;
use Time::Piece;
use Try::Tiny;

my $es;
my $bulk;
my %default;

BEGIN {
	%default = (
		index => "syslog-ng",
		type => "syslog-ng",
		max_count => 256,
		nodes => [
			"esnode01:9200",
			"esnode02:9200",
			"esnode03:9200",
			"esnode04:9200",
			"esnode05:9200",
			"esnode06:9200",
		],
	);
}

sub init {
 	$es = Search::Elasticsearch -> new(
		nodes => $default{nodes},
		cxn_pool => 'Sniff',
	);

	$bulk = $es -> bulk_helper(
		index => $default{index},
		type => $default{type},
		max_count => $default{max_count},
		on_success => sub {
			1;
		},
		on_conflict => sub {
			print STDERR scalar localtime;
			print STDERR Dumper \@_;
		},
		on_error => sub {
			print STDERR scalar localtime;
			print STDERR Dumper \@_;
		},
	);
}

sub queue_daily {
	queue(@_, '%Y.%m.%d');
}

sub queue_monthly {
	queue (@_, '%Y.%m');
}

sub queue {
	my ($input,$fmt) = @_;
	$fmt ||= '%Y.%m.%d';
	my $index = $input -> {__es_index};
	my $type = $input -> {__es_type};
	my $dt = gmtime($input -> {__epoch});
	my $fmt_str = $dt -> strftime($fmt);
	$index = "${index}-$fmt_str";

	my $data = $input -> {__json};

	try {
		$bulk -> create(
			{ index => $index, type => $type, source => $data }
		);
	} catch {
		my $e = $_ || "N/A";
		warn "caught error: $e";
	};
}

sub deinit {
	$bulk -> flush
}

