/*
 * Copyright 2017–2021 elementary, Inc. (https://elementary.io)
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

private class Granite.SettingsSidebarRow : Gtk.ListBoxRow {
    public SettingsPage.StatusType status_type {
        set {
            switch (value) {
                case SettingsPage.StatusType.ERROR:
                    status_icon.icon_name = "emblem-error";
                    break;
                case SettingsPage.StatusType.OFFLINE:
                    status_icon.icon_name = "emblem-disabled";
                    break;
                case SettingsPage.StatusType.SUCCESS:
                    status_icon.icon_name = "emblem-enabled";
                    break;
                case SettingsPage.StatusType.WARNING:
                    status_icon.icon_name = "emblem-warning";
                    break;
                case SettingsPage.StatusType.NONE:
                    status_icon.clear ();
                    break;
            }
        }
    }

    public Gtk.Widget display_widget { get; construct; }

    public string? header { get; set; }

    public unowned SettingsPage page { get; construct; }

    public string icon_name {
        get {
            return _icon_name;
        }
        set {
            _icon_name = value;
            if (display_widget is Gtk.Image) {
                ((Gtk.Image) display_widget).icon_name = value;
                ((Gtk.Image) display_widget).icon_size = Gtk.IconSize.LARGE;
            }
        }
    }

    public string status {
        set {
            status_label.label = value;
            status_label.visible = true;
        }
    }

    public string title {
        get {
            return _title;
        }
        set {
            _title = value;
            title_label.label = value;
        }
    }

    private Gtk.Image status_icon;
    private Gtk.Label status_label;
    private Gtk.Label title_label;
    private string _icon_name;
    private string _title;

    public SettingsSidebarRow (SettingsPage page) {
        Object (
            page: page
        );
    }

    construct {
        title_label = new Gtk.Label (page.title) {
            ellipsize = Pango.EllipsizeMode.END,
            vexpand = true,
            xalign = 0
        };
        title_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);

        status_icon = new Gtk.Image () {
            halign = Gtk.Align.END,
            valign = Gtk.Align.END
        };

        status_label = new Gtk.Label (null) {
            use_markup = true,
            ellipsize = Pango.EllipsizeMode.END,
            vexpand = true,
            xalign = 0,
            visible = false
        };
        status_label.add_css_class (Granite.STYLE_CLASS_SMALL_LABEL);

        if (page.icon_name != null) {
            display_widget = new Gtk.Image ();
            icon_name = page.icon_name;
        } else {
            display_widget = page.display_widget;
        }

        var overlay = new Gtk.Overlay ();
        overlay.set_child (display_widget);
        overlay.add_overlay (status_icon);

        var grid = new Gtk.Grid ();
        grid.attach (overlay, 0, 0, 1, 2);
        grid.attach (title_label, 1, 0);
        grid.attach (status_label, 1, 1);

        child = grid;

        header = page.header;
        page.bind_property ("icon-name", this, "icon-name", BindingFlags.DEFAULT);
        page.bind_property ("status", this, "status", BindingFlags.DEFAULT);
        page.bind_property ("status-type", this, "status-type", BindingFlags.DEFAULT);
        page.bind_property ("title", this, "title", BindingFlags.DEFAULT);

        if (page.status != null) {
            status = page.status;
        }

        if (page.status_type != SettingsPage.StatusType.NONE) {
            status_type = page.status_type;
        }
    }
}
