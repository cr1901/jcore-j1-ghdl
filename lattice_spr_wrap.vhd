-- A simple non initalized bulk RAM.
-- single 32 bit read/write port.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.bootrom.all;

entity bulk_ram is
  generic (
    -- 32-bit read/write port.  ADDR_WIDTH is in bytes, not words.
    ADDR_WIDTH : integer := 10 -- default 128k
    );
  port (
    clk : in std_logic;

    en : in std_logic;
    addr : in std_logic_vector(ADDR_WIDTH - 3 downto 0);
    do : out std_logic_vector(31 downto 0);

    we : in std_logic_vector(3 downto 0);
    di : in std_logic_vector(31 downto 0)
    );
end bulk_ram;

architecture behavioral of bulk_ram is
  type mem_t is array (0 to 256) of std_logic_vector(31 downto 0);
  constant NUM_WORDS : integer :=  2**(ADDR_WIDTH - 2);

  -- signal ram : rom_t; Will reserve 8k unconditionally and yosys will 
  --not optimize it out.

  signal ram : mem_t;
begin
    process (clk, en)
      variable read : std_logic_vector(31 downto 0);
    begin
      if clk'event and clk = '1' and en = '1' then
        if we(3) = '1' then
          ram(to_integer(unsigned(addr)))(31 downto 24) <= di(31 downto 24);
        end if;
        if we(2) = '1' then
          ram(to_integer(unsigned(addr)))(23 downto 16) <= di(23 downto 16);
        end if;
        if we(1) = '1' then
          ram(to_integer(unsigned(addr)))(15 downto 8 ) <= di(15 downto 8 );
        end if;
        if we(0) = '1' then
          ram(to_integer(unsigned(addr)))(7  downto 0 ) <= di(7  downto 0 );
        end if;
        read := ram(to_integer(unsigned(addr)));
        do <= read;
      end if;
    end process;
end behavioral;
