----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   ram
-- Description  :   description
--
-- Authors      :   Philipp Semmel
-- Created      :   31.03.2023
-- Last update  :   02.04.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;
USE work.config.ALL;

ENTITY ram IS
    PORT(
        clk    : IN    std_ulogic;
        load   : IN    std_ulogic;
        addr   : IN    std_ulogic_vector(RAM_ADDR_WORD_WIDTH - 1 DOWNTO 0);
        out_en : IN    std_ulogic;
        data   : INOUT std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0)
    );
END ENTITY ram;

ARCHITECTURE RTL OF ram IS

    COMPONENT generic_ram
        GENERIC(
            INITIAL_VALUES : ram_memory
        );
        PORT(
            clk      : IN  std_ulogic;
            load     : IN  std_ulogic;
            addr     : IN  unsigned(RAM_ADDR_WORD_WIDTH - 1 DOWNTO 0);
            data_in  : IN  std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
            data_out : OUT std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT generic_ram;

    COMPONENT generic_tri_state_buffer
        GENERIC(
            WORD_WIDTH : natural
        );
        PORT(
            out_en   : IN  std_ulogic;
            data_in  : IN  std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0);
            data_out : OUT std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT generic_tri_state_buffer;

    SIGNAL data_out : std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);

BEGIN

    ram : COMPONENT generic_ram
        GENERIC MAP(
            INITIAL_VALUES => INITIAL_RAM_VALUES
        )
        PORT MAP(
            clk      => clk,
            load     => load,
            addr     => unsigned(addr),
            data_in  => to_stdulogicvector(data),
            data_out => data_out
        );

    buf : COMPONENT generic_tri_state_buffer
        GENERIC MAP(
            WORD_WIDTH => DATA_WORD_WIDTH
        )
        PORT MAP(
            out_en                      => out_en,
            data_in                     => data_out,
            to_stdlogicvector(data_out) => data
        );

END ARCHITECTURE RTL; 