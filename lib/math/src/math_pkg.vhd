
package math_pkg is
	function log2c(constant value : in integer) return integer;
	function log10c(constant value : in integer) return integer;
	function max(constant value1, value2 : in integer) return integer;
	function max3(constant value1, value2, value3 : in integer) return integer;
	function min(constant value1, value2 : in integer) return integer;
	function min3(constant value1, value2, value3 : in integer) return integer;
end package;

package body math_pkg is

	function log2c(constant value : in integer) return integer is
		variable ret_value : integer;
		variable cur_value : integer;
	begin
		ret_value := 0;
		cur_value := 1;
		while cur_value < value loop
			ret_value := ret_value + 1;
			cur_value := cur_value * 2;
		end loop;
		return ret_value;
	end function;

	function log10c(constant value : in integer) return integer is
		variable ret_value : integer;
		variable cur_value : integer;
	begin
		ret_value := 0;
		cur_value := 1;
		while cur_value < value loop
			ret_value := ret_value + 1;
			cur_value := cur_value * 10;
		end loop;
		return ret_value;
	end function;

	function max(constant value1, value2 : in integer) return integer is
		variable ret_value : integer;
	begin
		if value1 > value2 then
			ret_value := value1;
		else
			ret_value := value2;
		end if;
		return ret_value;
	end function;

	function max3(constant value1, value2, value3 : in integer) return integer is
	begin
		return max(max(value1, value2), value3);
	end function;

	function min(constant value1, value2 : in integer) return integer is
		variable ret_value : integer;
	begin
		if value1 < value2 then
			ret_value := value1;
		else
			ret_value := value2;
		end if;
		return ret_value;
	end function;

	function min3(constant value1, value2, value3 : in integer) return integer is
	begin
		return min(min(value1, value2), value3);
	end function;

end package body;

