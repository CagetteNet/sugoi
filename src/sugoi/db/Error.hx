package sugoi.db;
import sys.db.Types;

class Error extends sys.db.Object {

	public var id : SId;
	public var date : SDateTime;
	public var ip : SString<15>;
	public var uid : SNull<SInt>;
	public var url : STinyText;
	public var error : SText;

}
