from aqt.qt import *
from aqt import mw

from aqt.utils import showInfo

from ...config import get_config_value_or_default, update_config

"""class for all shortcut option items"""
class shortcut:
    def __init__(self, config_key, description, sort_id):
        self.description = description
        self.config_key = config_key
        self.sort_id = sort_id

        self.shortcut = get_config_value_or_default(config_key, None)
        self.current_shortcut = self.shortcut

        if self.current_shortcut is None:
            self.current_shortcut = ""

        self.edit_button = QPushButton("Edit")
        self.shortcut_label = QLabel("<i>" + self.current_shortcut + "</i>")

        self.manual_button = QPushButton("Manual")

class ShortcutSettingsTab(QWidget):
    def __init__(self):
        QWidget.__init__(self)

        self.setup_ui()

    def setup_ui(self):
        # setup vbox
        gridbox = QGridLayout()

        # group_ids
        id_pdf     = 0
        id_menubar = 1
        id_general = 2

        # group shortcuts logically, this determines the order!
        list_order = ( # name of section, id
            ("PDF",     id_pdf),
            ("Menubar", id_menubar),
            ("General", id_general),
        )

        # add items
        self.shortcut_list = (
            # PDF Shortcuts
            shortcut("pdf.shortcuts.toggle_search_on_select", "Toggle Search on Select",  id_pdf),
            shortcut("pdf.shortcuts.toggle_pdf_links",        "Toggle PDF Links",         id_pdf),
            shortcut("pdf.shortcuts.toggle_page_read",        "Toggle page read",         id_pdf),
            shortcut("pdf.shortcuts.done",                    "Done!",                    id_pdf),
            shortcut("pdf.shortcuts.later",                   "Postpone",                 id_pdf),
            shortcut("pdf.shortcuts.jump_to_last_page",       "Jump to last page",        id_pdf),
            shortcut("pdf.shortcuts.jump_to_first_page",      "Jump to first page",       id_pdf),
            shortcut("pdf.shortcuts.toggle_read_page_right",  "Read + Next Page",         id_pdf),
            shortcut("pdf.shortcuts.page_left",               "Page Left",                id_pdf),
            shortcut("pdf.shortcuts.page_right",              "Page Right",               id_pdf),
            shortcut("pdf.shortcuts.scissor_tool",            "Scissor Tool",             id_pdf),
            shortcut("pdf.shortcuts.init_area_highlight",     "Area Highlight",           id_pdf),

            # General Shortcuts
            shortcut("shortcuts.focus_search_bar",            "Focus Search Bar",         id_general),
            shortcut("shortcuts.trigger_search",              "Trigger Search",           id_general),
            shortcut("shortcuts.trigger_predef_search",       "Trigger predef. search",   id_general),
            shortcut("shortcuts.search_for_current_field",    "Search for current field", id_general),
            shortcut("shortcuts.trigger_current_filter",      "Trigger current filter",   id_general),
            shortcut("toggleShortcut",                        "Toggle Add-on",            id_general),

            # Shortcuts for the items in the menubar
            shortcut("shortcuts.menubar.import.create_new",    "Create New",              id_menubar),
            shortcut("shortcuts.menubar.import.zotero_csv",    "Import Zotero CSV",       id_menubar),
            shortcut("shortcuts.menubar.import.youtube",       "Import YouTube Link",     id_menubar),
            shortcut("shortcuts.menubar.queue_manager",        "Open Queue Manager",      id_menubar),
            shortcut("shortcuts.menubar.quick_open",           "Quick Open",              id_menubar),
            shortcut("shortcuts.menubar.addon_settings",       "Open Add-on Settings",    id_menubar)
        )

        line = -1

        for group_name, group_id in list_order:
            # initialise counter
            line += 1
            i = 0

            # add header, colspan over all columns
            gridbox.addWidget(QLabel("""<b>""" + group_name + "</b></span>"), line, 0, 1, 8)
            line +=1

            # find shortcuts with the same group id
            for item in self.shortcut_list:
                if item.sort_id is group_id:
                    # set up two columns, each with 4 elements (description, label, edit button, remove button)
                    column_shift = (i%2)*4

                    # reached new line
                    if column_shift == 0:
                        line +=1

                    gridbox.addWidget(QLabel(item.description), line, 0 + column_shift)
                    gridbox.addWidget(item.shortcut_label, line, 1 + column_shift)
                    gridbox.addWidget(item.edit_button, line, 2 + column_shift)
                    gridbox.addWidget(item.manual_button, line, 3 + column_shift)

                    item.edit_button.clicked.connect(GrabKeyDialog(self, item))
                    item.manual_button.clicked.connect(ManualShortcut(self, item))

                    i+=1

        self.setLayout(gridbox)

    def save_changes(self):
        count_changes = 0

        for item in self.shortcut_list:
            if item.shortcut is not item.current_shortcut:
                update_config(item.config_key, item.current_shortcut)
                count_changes += 1

        if count_changes == 0:
            return ""

        return str(count_changes) + " shortcuts changed.<br>"


class ManualShortcut(QDialog):
    def __init__(self, parent, shortcut_item):
        QDialog.__init__(self, parent = parent)

        self.shortcut_item = shortcut_item

        button_box = QDialogButtonBox(QDialogButtonBox.Ok|QDialogButtonBox.Cancel)
        button_box.accepted.connect(self.accept_clicked)
        button_box.rejected.connect(self.reject)

        self.line_edit = QLineEdit()

        layout = QVBoxLayout()

        layout.addWidget(QLabel("Manually edit "))
        layout.addWidget(self.line_edit)
        layout.addWidget(button_box)

        self.setLayout(layout)

    def __call__(self):
        self.line_edit.setText(self.shortcut_item.current_shortcut)
        self.exec_()

    def accept_clicked(self):
        # TODO: ugly, check for stupid user input
        new_shortcut = self.line_edit.text()

        self.shortcut_item.current_shortcut = new_shortcut
        self.shortcut_item.shortcut_label.setText("<i>" + new_shortcut + "</i>")

        self.close()


"""
grab key dialog

largely based on Image Occlusion by Glutanimate
which is in turn largely based on ImageResizer by searene
(https://github.com/searene/Anki-Addons)
"""
class GrabKeyDialog(QDialog):
    def __init__(self, parent, shortcut_item):
        QDialog.__init__(self, parent = parent)

        self.shortcut_item = shortcut_item

        self.setup_ui()

    def __call__(self):
        #reset everything
        self.active = 0
        self.ctrl = False
        self.alt = False
        self.shift = False
        self.extra = None
        self.new_shortcut = ""

        self.exec_()


    def setup_ui(self):
        mainLayout = QVBoxLayout()
        self.setLayout(mainLayout)

        mainLayout.addWidget(QLabel('Please press the new key combination'))

        self.setWindowTitle('Grab key combination')

    def keyPressEvent(self, evt):
        self.active += 1

        # some special keys
        if evt.key() == Qt.Key_Return:
            self.extra = "Return"

        # normal keys
        elif evt.key() > 0 and evt.key() < 127:
            self.extra = chr(evt.key())
            if evt.key() == Qt.Key_Space:
                self.extra = "Space"

        # base keys
        elif evt.key() == Qt.Key_Control:
            self.ctrl = True
        elif evt.key() == Qt.Key_Alt:
            self.alt = True
        elif evt.key() == Qt.Key_Shift:
            self.shift = True


    def keyReleaseEvent(self, evt):
        self.active -= 1

        if self.active != 0:
            return
        if not (self.shift or self.ctrl or self.alt):
            showInfo("Please use at least one keyboard "
                     "modifier (Ctrl, Alt, Shift)")
            return
        if (self.shift and not (self.ctrl or self.alt)):
            showInfo("Shift needs to be combined with at "
                     "least one other modifier (Ctrl, Alt)")
            return
        if not self.extra:
            showInfo("Please press at least one key "
                     "that is not a keyboard modifier (not Ctrl/Alt/Shift)")
            return

        combo = []
        if self.ctrl:
            combo.append("Ctrl")
        if self.shift:
            combo.append("Shift")
        if self.alt:
            combo.append("Alt")

        combo.append(self.extra)

        self.change_shortcut("+".join(combo))


    def change_shortcut(self, new_shortcut):
        self.shortcut_item.current_shortcut = new_shortcut
        self.shortcut_item.shortcut_label.setText("<i>" + new_shortcut + "</i>")

        self.close()
