----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   clock
-- Description  :   converts input frequency to output frequency
--                  signal is low during first halt of the period and
--                  high for the second half of the period
--                  when hlt is high the clock will halt and the
--                  ouput will be reset
--
-- Authors      :   Philipp Semmel
-- Created      :   15.04.2023
-- Last update  :   02.05.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.comp_pkg.ALL;

ENTITY clock IS
    GENERIC(
        INPUT_FREQUENCY  : natural := FPGA_CLOCK_FREQUENCY_HZ;
        OUTPUT_FREQUENCY : natural := COMPUTER_CLOCK_FREQUENCY
    );
    PORT(
        sys_clk : IN  std_ulogic;
        rst     : IN  std_ulogic;
        hlt     : IN  std_ulogic;
        out_clk : OUT std_ulogic
    );
END ENTITY clock;

ARCHITECTURE RTL OF clock IS

    COMPONENT generic_counter
        GENERIC(
            COUNT_MAX : natural
        );
        PORT(
            clk       : IN     std_ulogic;
            rst       : IN     std_ulogic;
            count_en  : IN     std_ulogic;
            load      : IN     std_ulogic;
            count_in  : IN     unsigned(integer(ceil(log2(real(COUNT_MAX)))) - 1 DOWNTO 0);
            count_out : BUFFER unsigned(integer(ceil(log2(real(COUNT_MAX)))) - 1 DOWNTO 0);
            overflow  : OUT    std_ulogic
        );
    END COMPONENT generic_counter;

    CONSTANT DIVIDE_BY : natural := integer(INPUT_FREQUENCY / OUTPUT_FREQUENCY);
    SIGNAL count       : unsigned(integer(ceil(log2(real(DIVIDE_BY)))) - 1 DOWNTO 0);
    SIGNAL hlt_re      : std_ulogic;

BEGIN

    -- input wiring
    hlt_re <= '1' WHEN (hlt'event AND hlt = '1') ELSE '0';

    counter : COMPONENT generic_counter
        GENERIC MAP(
            COUNT_MAX => DIVIDE_BY
        )
        PORT MAP(                                                     --@suppress
            clk       => sys_clk,
            rst       => rst OR hlt_re,
            count_en  => NOT hlt,
            load      => '0',
            count_in  => (OTHERS => '0'),
            count_out => count
        );

    -- output wiring
    out_clk <= '0' WHEN count < (DIVIDE_BY / 2) ELSE '1';

END ARCHITECTURE RTL; 