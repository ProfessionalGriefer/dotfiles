"""
Convert Subdecks to Tag Hierarchy (Anki Add-on)

Provides a new menu entry to convert the currently active deck's subdecks into
a tag hierarchy.

Copyright (c) 2017 Adel Qalieh <https://adelqalieh.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or any later
version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
"""

from aqt import mw
from anki.utils import intTime, ids2str
from aqt.qt import *
import re

SEPARATOR = "_"


def convert_subdecks_to_tags():
    """Main function to convert currently selected deck."""
    parent_deck_id = mw.col.decks.selected()
    children_decks = mw.col.decks.children(parent_deck_id)
    mw.checkpoint(_("convert subdeck to tags"))
    for child_deck_name, child_deck_id in children_decks:
        # Use dashes as word separators to avoid multiple tags
        tag = child_deck_name.replace(" ", SEPARATOR)
        # Remove trailing spaces
        tag = re.sub(r"-+::", "::", tag)
        tag = re.sub(r"::-+", "::", tag)
        # Remove spaces after commas
        tag = tag.replace(",-", ",")
        # Remove spaces around + signs
        tag = tag.replace(" +", "+")
        tag = tag.replace("+ ", "+")

        # Get old card properties
        child_cids = mw.col.decks.cids(child_deck_id)
        mod = intTime()
        usn = mw.col.usn()
        str_cids = ids2str(child_cids)

        # Move cards to new deck
       # mw.col.db.execute(
           # "update cards set usn=?, mod=?, did=? where id in " + str_cids,
            # usn, mod, parent_deck_id
      #  )
       ##I put the # on this line to keep decks## mw.col.decks.rem(child_deck_id)

        # New tag based on child deck name
        child_cards = (mw.col.getCard(cid) for cid in child_cids)
        child_nids = set(c.nid for c in child_cards)
        mw.col.tags.bulkAdd(list(child_nids), tag)
    mw.requireReset()


action = QAction("Convert subdecks to tags", mw)
action.triggered.connect(convert_subdecks_to_tags)
mw.form.menuTools.addAction(action)
