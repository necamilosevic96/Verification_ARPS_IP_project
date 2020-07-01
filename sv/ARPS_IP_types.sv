/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_types.sv

    DESCRIPTION     contains all typedef-s used in project

 ****************************************************************************/

`ifndef ARPS_IP_TYPES_SV
`define ARPS_IP_TYPES_SV

typedef enum {
    ARPS_IP_WRITE = 0,
    ARPS_IP_READ  = 1
} ARPS_IP_direction_enum;

typedef enum {
	ARPS_IP_ACK  = 0,
	ARPS_IP_NACK = 1
} ARPS_IP_ack_enum;

`endif

