# A plugin for adding 'recently_pinged_on' option to MTEntries container
#
# Release 0.16 (Feb 19, 2005)
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
    $plugin->name("recently_pinged_on Plugin 0.16");
    $plugin->description("Add 'recently_ping_on' option to MTEntries container");
    $plugin->doc_link("http://as-is.net/hacks/2005/01/recently_pinged_on_plugin.html");
    MT->add_plugin($plugin);
}

use MT::Template::Context;
{
    local $SIG{__WARN__} = sub { };
    $mt_hdlr_entries = \&MT::Template::Context::_hdlr_entries;
    *MT::Template::Context::_hdlr_entries = \&hdlr_entries;
}

sub hdlr_entries {
    my ($ctx, $args, $cond) = @_;
    return &$mt_hdlr_entries(@_)
	if $args->{lastn} || $args->{days} || $args->{recently_commented_on};
    my $recently_pinged_on = $args->{recently_pinged_on} or
	return &$mt_hdlr_entries(@_);

    my $blog_id = $ctx->stash('blog_id');
    my ($start, $end) = ($ctx->{current_timestamp},
			 $ctx->{current_timestamp_end});
    my $cat = $ctx->stash('archive_category');

    require MT::TBPing;
    my $iter = MT::TBPing->load_iter({ blog_id => $blog_id },
				     { sort => 'created_on',
				       direction => 'descend' });
    my @entries = ();
    my %temp = ();
    my $count = 0;
    while (my $tbping = $iter->()) {
	my $tb_id = $tbping->tb_id;
	next if exists($temp{$tb_id});

	require MT::Trackback;
	my $trackback = MT::Trackback->load($tb_id) or next;
	my $entry_id = $trackback->entry_id or next;

	require MT::Entry;
	my $entry = MT::Entry->load($entry_id) or next;

	next if $entry->status != MT::Entry::RELEASE();
	next if $cat && !$entry->is_in_category($cat);
	next if $start && $end && ($entry->created_on < $start || $entry->created_on > $end);

	push(@entries, $entry);
	last if ++$count == $recently_pinged_on;
	$temp{$tb_id} = ();
    }

    my $res = '';
    my $tokens = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $i = 0;
    for my $e (@entries) {
	local $ctx->{__stash}{entry} = $e;
	local $ctx->{current_timestamp} = $e->created_on;
	local $ctx->{modification_timestamp} = $e->modified_on;
	my $out = $builder->build($ctx, $tokens, {
	    %$cond,
	    EntryIfExtended => $e->text_more ? 1 : 0,
	    EntryIfAllowComments => $e->allow_comments,
	    EntryIfCommentsOpen => $e->allow_comments && $e->allow_comments eq '1',
	    EntryIfAllowPings => $e->allow_pings,
	    EntriesHeader => !$i,
	    EntriesFooter => !defined $entries[$i+1]
	    });
	return $ctx->error($ctx->errstr) unless defined $out;
	$res .= $out;
	$i++;
    }
    $res;
}

1;
