enum BrowserPopUpMenuItems {
  history,
  newTab,
  recentTabs,
  bookMarks,
  findInPage,
}

extension AdjustedName on BrowserPopUpMenuItems {
  String name() {
    switch (this) {
      case BrowserPopUpMenuItems.history:
        return 'History';
      case BrowserPopUpMenuItems.newTab:
        return 'New Tab';
      case BrowserPopUpMenuItems.recentTabs:
        return 'Recent Tabs';
      case BrowserPopUpMenuItems.bookMarks:
        return 'Bookmarks';
      case BrowserPopUpMenuItems.findInPage:
        return 'Bookmarks';
    }
  }
}
