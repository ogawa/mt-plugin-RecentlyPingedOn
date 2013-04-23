# recently_pinged_on Plugin

A plugin for adding ''recently_pinged_on'' option to MTEntries container.

## Changes

 * 0.10(2005.01.29):
   * First Release
 * 0.11(2005.01.29):
   * Several fixes for better performance
 * 0.12(2005.02.06):
   * Performance tuning.
   * And now MTEntryDate, MTEntriesHeader, MTEntriesFooter, MTEntryIfExtended, MTEntryIfAllowComments, MTEntryIfCommentsOpen, and MTEntryIfAllowPings can be used in MTEntries container.
 * 0.15(2005.02.13):
   * Now disables the plugin function if specified with lastn, days, or recently_commented_on options.
   * And if using in category or date-based archives, the plugin lists up only pinged entries which are included in targeted archives.
 * 0.16(2005.02.19):
   * Fix an embarrassing bug.
 * 0.18(2005.09.01):
   * Fix for Movable Type 3.2.

## Overview

The default MTEntries container tag does not have a function listing up recent incoming TB pings, as opposed to recent incoming comments.  This plugin adds "recently_pinged_on" option to MTEntries and allows you to list up recent incoming pings as like comments.

## Example

    <dl>
      <MTEntries recently_pinged_on="10">
        <dt><a href="<$MTEntryLink$>"><$MTEntryTitle$></a></dt>
        <MTPings lastn="5">
          <dd><a href="<$MTPingURL$>" rel="nofollow"><$MTPingBlogName$>: <$MTPingTitle$></a></dd>
        </MTPings>
      </MTEntries>
    </dl>

## See Also

## License

This code is released under the Artistic License. The terms of the Artistic License are described at [http://www.perl.com/language/misc/Artistic.html](http://www.perl.com/language/misc/Artistic.html).

## Author & Copyright

Copyright 2005, Hirotaka Ogawa (hirotaka.ogawa at gmail.com)
