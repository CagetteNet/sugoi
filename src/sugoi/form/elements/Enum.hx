package sugoi.form.elements;
import sugoi.form.Form;
import sugoi.form.FormElement;
import sugoi.form.Formatter;
import sugoi.form.elements.Flags;

class Enum extends FormElement<Int>
{
	public var enumName:String;
	public var selectMessage:String;
	public var labelLeft:Bool;
	public var verticle:Bool;
	public var labelRight:Bool;
	var checked : Array<Bool>;
	public var activatedValues:Array<Int>;
	

	public var columns:Int;

	/**
	 *
	 * @param	name
	 * @param	label
	 * @param	data			list of enums
	 * @param	value			int (enum index)
	 * @param	?verticle
	 * @param	?labelRight
	 */
	public function new(name:String, label:String, enumName:String, value:Int, ?required=false, ?verticle:Bool=false, ?labelRight:Bool=true)
	{
		super();
		this.name = name;
		this.label = label;
		this.enumName = enumName;		
		
		this.verticle = verticle;
		this.labelRight = labelRight;

		
		//trace("value = " + value);
		
		if (required && value == null){
			this.value = /*Type.resolveEnum(enumName).createByIndex(0)*/0;
		}else{
			this.value = value;
		}

		columns = 1;


		this.activatedValues = new Array();
	}
	
	override function getTypedValue(str:String):Int {
		if (str == null) return null;
		
		str = StringTools.trim(str);
		if (str == "") {
			return null;
		}else{
			return Std.parseInt(str);
		}
	}
	
	override function getValue(){
		if (value == null) return null;
		return Type.resolveEnum(enumName).createByIndex(value);
	}

	public function setActivatedValues(activatedValues:Array<Int>)
	{
		this.activatedValues = activatedValues;
	}

	override public function render():String
	{
		var s = "";
		var n = parentForm.name + "_" +name;

		var tagCss = getClasses();
		//no label css otherwise the style col-sm-4 will be added, and we dont want that
		// as its for the left column labels
		//var labelCss = getLabelClasses(); 

		var c = 0;

		var array2 = Type.allEnums(Type.resolveEnum(enumName));
		//Filter the Enum with activatedValues
		var array = new Array();
		if(this.activatedValues.length == 0)
		{
			array = array2;
		}
		else
		{
			for(v in this.activatedValues)
			{
				array.push(array2[v]);
			}
		}
		



		var rowsPerColumn = Math.ceil(array.length / columns);
		s = "<table style='margin-bottom:8px;'><tr>";
		for (i in 0...columns)
		{
			s += "<td valign=\"top\">\n";
			s += "<table>\n";

			for (j in 0...rowsPerColumn)
			{
				if (c >= array.length) break;

				s += "<tr>";

				var row:Dynamic = array[c];
				var checked = value == Type.enumIndex(row);
				var checkbox = "<input type=\"radio\" class=\"" + tagCss + "\" name=\""+n+"\" id=\""+n+row+"\" value=\""+Type.enumIndex(row)+"\" " + (checked? "checked":"") +" ></input>\n";
				var label;

				var t = Form.translator;
				if (t == null){
					label = "<label for=\"" + n + c + "\" >" + Std.string(row)  +"</label>\n";
				}else{
					label = "<label for=\"" + n + c + "\" >" + t._(Std.string(row))  +"</label>\n";	
				}
				

				if (labelRight)
				{
					s += "<td style='vertical-align:middle;padding-right: 8px;'>" + checkbox + "</td> \n";
					s += "<td style='vertical-align:middle;'>" + label + "</td>\n";
				} else {
					s += "<td style='vertical-align:middle;padding-right: 8px;'>" + label + "</td> \n";
					s += "<td style='vertical-align:middle;'>" + checkbox + "</td>\n";
				}

				s += "</tr>";
				c++;
			}
			s += "</table>";
			s += "</td>";
		}
		s += "</tr></table>\n";



		return s;
	}

	
}