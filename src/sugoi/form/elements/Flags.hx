package sugoi.form.elements;
import sugoi.form.Form;
import sugoi.form.FormElement;
import sugoi.form.Formatter;
#if php
import php.Web;
#else
import neko.Web;
#end


enum FakeFlag {
	Flag1;
	Flag2;
	Flag3;
	Flag4;
	Flag5;
	Flag6;
	Flag7;
	Flag8;
	Flag9;
	Flag10;
	Flag11;
	Flag12;
	Flag13;
	Flag14;
	Flag15;
	Flag16;
	Flag17;
	Flag18;
	Flag19;
	Flag20;
	Flag21;
	Flag22;
	Flag23;
	Flag24;
	Flag25;
	Flag26;
	Flag27;
	Flag28;
	Flag29;
	Flag30;
	Flag31;
	Flag32;
}

/**
 * Manage flags stored in an Int , various flags are defined by an Enum
 */
class Flags<T> extends FormElement<Int>
{
	public var data:Array<String>;
	public var selectMessage:String;
	public var labelLeft:Bool;
	public var verticle:Bool;
	public var labelRight:Bool;
	var checked : Array<Bool>;
	public var excluded : Array<Int>; //indexes of flags you want to exclude

	public var columns:Int;

	public var flagsToRemove:Array<String>;
	
	/**
	 *
	 * @param	name
	 * @param	label
	 * @param	data			list of enums
	 * @param	value			int
	 * @param	?verticle
	 * @param	?labelRight
	 */
	public function new(name:String, label:String, data:Array<String>, value:Int, ?verticle:Bool=true, ?labelRight:Bool=true)
	{
		super();
		this.name = name;
		this.label = label;
		this.data = data;
		this.value = value;
		this.verticle = verticle;
		this.labelRight = labelRight;
		this.excluded = [];
		if (value == null) value = 0;
		
		checked = [];
		var i = 0;
		for( f in data) {
			checked.push( value & (1 << i) != 0 );
			i++;
		}
		
		columns = 1;

		this.flagsToRemove = new Array();
	}

	public function setFlagsToRemove(flagsToRemove:Array<String>)
	{
		this.flagsToRemove = flagsToRemove;
	}
	
	override public function populate()
	{
		var v  = Web.getParamValues(parentForm.name + "_" + name);
		value = 0;
		
		if (v != null) {
			var val = new haxe.EnumFlags<FakeFlag>();
			for (vv in v) {
				val.set( FakeFlag.createByIndex(Std.parseInt(vv)) );
			}
			value = val.toInt();
		}
	}
	
	override public function render():String
	{
		var s = "";
		var n = parentForm.name + "_" +name;


		var array = Lambda.array(data);
		
		var tagCss = getClasses();
		var labelCss = getLabelClasses();
			
		var c = 0;




		if (array != null)
		{
			//trace("L" + array.length);
			var rowsPerColumn = Math.ceil(array.length / columns);
			s = "<table><tr>";
			for (i in 0...columns)
			{
				s += "<td valign=\"top\">\n";
				s += "<table>\n";
				
				for (j in 0...rowsPerColumn)
				{
					if (c >= array.length) break;
					if( Lambda.has(excluded,c)) {
						c++;
						continue;
					}
					
					s += "<tr>";
					
					var row:Dynamic = array[c];
					
					var checkbox = "";
					if(flagsToRemove.indexOf(row)==-1)
					{
						checkbox = "<input type=\"checkbox\" class=\"" + tagCss + "\" name=\""+n+"[]\" id=\""+n+c+"\" value=\""+c+"\" " + (checked[c]? "checked":"") +" ></input>\n";
					}
					else
					{
						checkbox = "<input type=\"hidden\" class=\"" + tagCss + "\" name=\""+n+"[]\" id=\""+n+c+"\" value=\""+c+"\" " + (checked[c]? "checked":"") +" ></input>\n";
					}
					var label = "";
					
					var t = Form.translator;
					
					if(flagsToRemove.indexOf(row)==-1)
					{
						label = "<label for=\"" + n + c + "\" class=\""+''/*labelCss*/+"\" > " + t._(row)  +"</label>\n";
					}
					
					
					
					if (labelRight)
					{
						s += "<td style='vertical-align:middle;'>" + checkbox + "</td>\n";
						s += "<td style='vertical-align:middle;'>" + label + "</td>\n";
					} else {
						s += "<td style='vertical-align:middle;'>" + label + "</td>\n";
						s += "<td style='vertical-align:middle;'>" + checkbox + "</td>\n";
					}
					s += "</tr>";
					
					c++;
				}
				s += "</table>";
				s += "</td>";
			}
			s += "</tr></table>\n";
			
		}
		
		return s;
	}
	
}