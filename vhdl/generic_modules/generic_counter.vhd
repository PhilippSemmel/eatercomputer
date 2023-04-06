----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   GenericCounter
-- Description  :   Counts to a given value and reset then while
--                  emitting an overflow signal.
--                  Asynchronous reset.
--                  Can load count values.
--
-- Authors      :   Philipp Semmel
-- Created      :   21.02.2023
-- Last update  :   26.03.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY generic_counter IS
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
END ENTITY generic_counter;

ARCHITECTURE RTL OF generic_counter IS

    SIGNAL count_ff, count_nxt : unsigned(integer(ceil(log2(real(COUNT_MAX)))) - 1 DOWNTO 0);

BEGIN

    seq : PROCESS(ALL) IS
    BEGIN
        IF rst = '1' THEN
            count_ff <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF load = '1' THEN
                count_ff <= count_in;
            ELSIF count_en = '1' THEN
                count_ff <= count_nxt;
            END IF;
        END IF;
    END PROCESS seq;

    count_nxt <= (OTHERS => '0') WHEN (count_ff = COUNT_MAX - 1) ELSE
                 count_ff + 1;

    overflow <= '1' WHEN (count_out = COUNT_MAX - 1) ELSE
                '0';

    count_out <= count_ff;

END ARCHITECTURE RTL;
