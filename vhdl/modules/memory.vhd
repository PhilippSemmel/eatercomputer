----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   memory
-- Description  :   description
--
-- Authors      :   Philipp Semmel
-- Created      :   05.06.2023
-- Last update  :   05.06.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;

ENTITY memory IS
    PORT(
        clk        : IN    std_ulogic;
        rst        : IN    std_ulogic;
        -- control signals
        load_addr  : IN    std_ulogic;
        load_ram   : in    std_ulogic;
        out_en_ram : in    std_ulogic;
        -- data
        addr       : IN    std_logic_vector(RAM_ADDR_WORD_WIDTH - 1 DOWNTO 0);
        data       : INOUT std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0)
    );
END ENTITY memory;

ARCHITECTURE RTL OF memory IS

    COMPONENT ram
        PORT(
            clk    : IN    std_ulogic;
            load   : IN    std_ulogic;
            addr   : IN    std_ulogic_vector(RAM_ADDR_WORD_WIDTH - 1 DOWNTO 0);
            out_en : IN    std_ulogic;
            data   : INOUT std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT ram;

    COMPONENT generic_register
        GENERIC(
            WORD_WIDTH : natural
        );
        PORT(
            clk      : IN  std_ulogic;
            rst      : IN  std_ulogic;
            data_in  : IN  std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0);
            load     : IN  std_ulogic;
            data_out : OUT std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT generic_register;

    SIGNAL addr_to_ram : std_ulogic_vector(RAM_ADDR_WORD_WIDTH - 1 DOWNTO 0);

BEGIN

    ram_module : ram
        PORT MAP(
            clk    => clk,
            load   => load_ram,
            addr   => addr_to_ram,
            out_en => out_en_ram,
            data   => data
        );

    memory_addr_reg : generic_register
        GENERIC MAP(
            WORD_WIDTH => RAM_ADDR_WORD_WIDTH
        )
        PORT MAP(
            clk      => clk,
            rst      => rst,
            data_in  => std_ulogic_vector(addr),
            load     => load_addr,
            data_out => addr_to_ram
        );

END ARCHITECTURE RTL;
