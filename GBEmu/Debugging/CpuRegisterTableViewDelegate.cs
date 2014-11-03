using System;
using MonoMac.AppKit;
using MonoMac.Foundation;

namespace GBEmu
{
	class CpuRegisterTableViewDelegate : NSTableViewDelegate
	{
		public override NSView GetViewForItem (NSTableView tableView, NSTableColumn tableColumn, int row)
		{
			NSTableCellView view = tableView.MakeView ("cell", this) as NSTableCellView;

			view.TextField.StringValue = tableView.DataSource.GetObjectValue (tableView, tableColumn, row) as NSString;

			return view;
		}
	}
}

