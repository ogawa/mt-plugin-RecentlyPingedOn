# A plugin for adding 'recently_pinged_on' option to MTEntries container
#                   by Hirotaka Ogawa (http://as-is.net/blog/)
#
# Release 0.11 (Jan 29, 2005)
#
# This software is provided as-is. You may use it for commercial or 
# personal use. If you distribute it, please keep this notice intact.
#
# Copyright (c) 2005 Hirotaka Ogawa

use strict;
use vars qw($mt_hdlr_entries);

if (MT->can('add_plugin')) {
    require MT::Plugin;
    my $plugin = new MT::Plugin();
    $plugin->name("recently_pinged_on Plugin 0.11");
    $plugin->description("Add 'recently_ping_on' option to MTEntries container");
    $plugin->doc_link("http://as-is.net/hacks/2005/01/recently_pinged_on_plugin.html");
    MT->add_plugin($plugin);
}

{
    local $SIG{__WARN__} = sub { };
    $mt_hdlr_entries = \&MT::Template::Context::_hdlr_entries;
    *MT::Template::Context::_hdlr_entries = \&hdlr_entries;
}

sub hdlr_entries {
    my ($ctx, $args, $cond) = @_;

    my $recently_pinged_on = $args->{recently_pinged_on};
    return &$mt_hdlr_entries($ctx, $args, $cond) unless $recently_pinged_on;

    require MT::TBPing;
    my $iter = MT::TBPing->load_iter({ blog_id => $ctx->stash('blog_id') },
				     { sort => 'created_on',
				       direction => 'descend' });
    my @entries = ();
    my %temp = ();
    my $count = 0;
    while (my $tbping = $iter->()) {
	my $tb_id = $tbping->tb_id;
	next if exists($temp{$tb_id});

	require MT::Trackback;
	my $trackback = MT::Trackback->load($tb_id);
	my $entry_id = $trackback->entry_id or next;

	require MT::Entry;
	my $entry = MT::Entry->load($entry_id);
	next if $entry->status != MT::Entry::RELEASE();

	push(@entries, $entry);
	last if ++$count == $recently_pinged_on;
	$temp{$tb_id} = ();
    }

    my $tokens = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $res = '';
    my $saved_entry = $ctx->stash('entry');
    for my $e (@entries) {
	$ctx->stash('entry', $e);
	defined(my $out = $builder->build($ctx, $tokens))
	    or return $ctx->error($ctx->errstr);
	$res .= $out;
    }
    $ctx->stash('entry', $saved_entry);
    $res;
}

1;
