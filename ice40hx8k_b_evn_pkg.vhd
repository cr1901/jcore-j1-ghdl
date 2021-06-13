library ieee;
use ieee.std_logic_1164.all;

package ice40hx8k_b_evn_pack is

   component ice40hx8k_b_evn is port (
      clk : in std_logic;
      led : out std_logic_vector(7 downto 0));
   end component ice40hx8k_b_evn;

end ice40hx8k_b_evn_pack;
