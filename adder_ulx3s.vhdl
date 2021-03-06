library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_ulx3s is
    port(
        wifi_gpio0 : out std_logic;
        led : out std_logic_vector(7 downto 0);
        btn : in std_logic_vector(6 downto 0) 
    );
end adder_ulx3s;

architecture rtl of adder_ulx3s is
    signal carry : std_logic;
begin
    adder : entity work.adder(rtl)
        port map(
            i0 => btn(1),
            i1 => btn(2),
            ci => carry,
            s => led(0),
            co => led(1)
        );
    
    wifi_gpio0 <= '1';
    carry <= '0';
    led(7 downto 2) <= "000000";
end rtl;