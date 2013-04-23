# recently_pinged_onプラグイン

MTEntriesコンテナにrecently_pinged_onオプションを追加するプラグイン。

## 更新履歴

 * 0.10(2005.01.29):
   * 公開開始。
 * 0.11(2005.01.29):
   * 性能チューニングのための複数の修正。
 * 0.12(2005.02.06):
   * さらに性能チューニング。
   * MTEntryDate, MTEntriesHeader, MTEntriesFooter, MTEntryIfExtended, MTEntryIfAllowComments, MTEntryIfCommentsOpen, MTEntryIfAllowPingsなどを使えるように修正(したつもり)。
 * 0.15(2005.02.13):
   * BerkeleyDBを使用している場合にうまく動作しないことがあるのを修正。
   * lastn, days, recently_commented_onと一緒に指定されたときに、プラグインが無効になるように修正。
   * カテゴリーアーカイブ、日別アーカイブで使用したときに、その範囲内のエントリーだけを表示するように動作を変更。
 * 0.16(2005.02.19):
   * モジュールの読み込み順に関わるバグを修正。
 * 0.17(2005.03.06):
   * Storable.pmが存在しないときに動作しない問題への対策。
 * 0.18(2005.09.01):
   * Movable Type 3.2で正常に動作するように修正。
 * 0.19(2005.10.01):
   * 0.18で直し損ねていた問題(moderated/junkトラックバックを除外していない)に対処したつもり。MTの過去のバージョンとの互換性も維持したつもり。

## 概要

MTEntriesコンテナにrecently_pinged_onオプションを追加するプラグインです。recently_commented_onと同様に、最近トラックバックを受信したエントリーをリストアップすることができます。

以下が使用例です。

    <dl>
      <MTEntries recently_pinged_on="5">
        <dt><a href="<$MTEntryLink$>"><$MTEntryTitle$></a></dt>
        <MTPings lastn="5">
          <dd><a href="<$MTPingURL$>" rel="nofollow">
              <$MTPingBlogName$>: <$MTPingTitle$></a></dd>
        </MTPings>
      </MTEntries>
    </dl>

既存のMTタグにオプションを追加する技法の習作です。

## TODO

 * lastn, days, recently_commented_onと一緒に指定されたときに、プラグインが無効になるようにする。→対策済み
 * カテゴリーアーカイブ、日別アーカイブで使用したときに、その範囲内のエントリーだけを表示するようにする。→対策済み

## See Also

## License

This code is released under the Artistic License. The terms of the Artistic License are described at [http://www.perl.com/language/misc/Artistic.html]().

## Author & Copyright

Copyright 2005, Hirotaka Ogawa (hirotaka.ogawa at gmail.com)
