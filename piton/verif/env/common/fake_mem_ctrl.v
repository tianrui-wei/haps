// Copyright (c) 2015 Princeton University
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of Princeton University nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

//==================================================================================================
//  Filename      : fake_mem_ctrl.v
//  Created On    : 2014-04-15
//  Last Modified : 2018-11-23 13:03:10
//  Revision      :
//  Author        : Yaosheng Fu
//  Company       : Princeton University
//  Email         : yfu@princeton.edu
//
//  Description   : fake memory controller for the L2 cache
//
//
//==================================================================================================

`include "l2.tmp.h"
`include "define.tmp.h"
`include "iop.h"
`include "noc_axi4_bridge_define.vh"

module fake_mem_ctrl(

    input wire clk,
    input wire rst_n,

    input wire noc_valid_in,
    input wire [`NOC_DATA_WIDTH-1:0] noc_data_in,
    output reg noc_ready_in,


    output reg noc_valid_out,
    output reg [`NOC_DATA_WIDTH-1:0] noc_data_out,
    input wire noc_ready_out

);


    wire uart_boot_en = 0;
    wire phy_init_done = 1;
    wire [`AXI4_ID_WIDTH-1:0] m_axi_awid;
    wire [`AXI4_ADDR_WIDTH-1:0] m_axi_awaddr;
    wire [`AXI4_LEN_WIDTH-1:0] m_axi_awlen;
    wire [`AXI4_SIZE_WIDTH-1:0] m_axi_awsize;
    wire [`AXI4_BURST_WIDTH-1:0] m_axi_awburst;
    wire m_axi_awlock;
    wire [`AXI4_CACHE_WIDTH-1:0] m_axi_awcache;
    wire [`AXI4_PROT_WIDTH-1:0] m_axi_awprot;
    wire [`AXI4_QOS_WIDTH-1:0] m_axi_awqos = 0;
    wire [`AXI4_REGION_WIDTH-1:0] m_axi_awregion = 0;
    wire [`AXI4_USER_WIDTH-1:0] m_axi_awuser;
    wire m_axi_awvalid;
    wire m_axi_awready;
    wire [`AXI4_ID_WIDTH-1:0] m_axi_wid;
    wire [`AXI4_DATA_WIDTH-1:0] m_axi_wdata;
    wire [`AXI4_STRB_WIDTH-1:0] m_axi_wstrb;
    wire m_axi_wlast;
    wire [`AXI4_USER_WIDTH-1:0] m_axi_wuser;
    wire m_axi_wvalid;
    wire m_axi_wready;
    wire [`AXI4_ID_WIDTH-1:0] m_axi_arid;
    wire [`AXI4_ADDR_WIDTH-1:0] m_axi_araddr;
    wire [`AXI4_LEN_WIDTH-1:0] m_axi_arlen;
    wire [`AXI4_SIZE_WIDTH-1:0] m_axi_arsize;
    wire [`AXI4_BURST_WIDTH-1:0] m_axi_arburst;
    wire m_axi_arlock;
    wire [`AXI4_CACHE_WIDTH-1:0] m_axi_arcache;
    wire [`AXI4_PROT_WIDTH-1:0] m_axi_arprot;
    wire [`AXI4_QOS_WIDTH-1:0] m_axi_arqos = 0;
    wire [`AXI4_REGION_WIDTH-1:0] m_axi_arregion = 0;
    wire [`AXI4_USER_WIDTH-1:0] m_axi_aruser;
    wire m_axi_arvalid;
    wire m_axi_arready;
    wire [`AXI4_ID_WIDTH-1:0] m_axi_rid;
    wire [`AXI4_DATA_WIDTH-1:0] m_axi_rdata;
    wire [`AXI4_RESP_WIDTH-1:0] m_axi_rresp;
    wire m_axi_rlast;
    wire [`AXI4_USER_WIDTH-1:0] m_axi_ruser;
    wire m_axi_rvalid;
    wire m_axi_rready;
    wire [`AXI4_ID_WIDTH-1:0] m_axi_bid;
    wire [`AXI4_RESP_WIDTH-1:0] m_axi_bresp;
    wire [`AXI4_USER_WIDTH-1:0] m_axi_buser;
    wire m_axi_bvalid;
    wire m_axi_bready;


noc_axi4_bridge i_noc_axi4_bridge (
    .clk                   (clk                   ),
    .rst_n                 (rst_n                 ),
    .uart_boot_en          (uart_boot_en          ),
    .phy_init_done         (phy_init_done         ),
    .src_bridge_vr_noc2_val(noc_valid_in),
    .src_bridge_vr_noc2_dat(noc_data_in),
    .src_bridge_vr_noc2_rdy(noc_ready_in),
    .bridge_dst_vr_noc3_val(noc_valid_out),
    .bridge_dst_vr_noc3_dat(noc_data_out),
    .bridge_dst_vr_noc3_rdy(noc_ready_out),
    .m_axi_awid            (m_axi_awid            ),
    .m_axi_awaddr          (m_axi_awaddr          ),
    .m_axi_awlen           (m_axi_awlen           ),
    .m_axi_awsize          (m_axi_awsize          ),
    .m_axi_awburst         (m_axi_awburst         ),
    .m_axi_awlock          (m_axi_awlock          ),
    .m_axi_awcache         (m_axi_awcache         ),
    .m_axi_awprot          (m_axi_awprot          ),
    .m_axi_awqos           (m_axi_awqos           ),
    .m_axi_awregion        (m_axi_awregion        ),
    .m_axi_awuser          (m_axi_awuser          ),
    .m_axi_awvalid         (m_axi_awvalid         ),
    .m_axi_awready         (m_axi_awready         ),
    .m_axi_wid             (m_axi_wid             ),
    .m_axi_wdata           (m_axi_wdata           ),
    .m_axi_wstrb           (m_axi_wstrb           ),
    .m_axi_wlast           (m_axi_wlast           ),
    .m_axi_wuser           (m_axi_wuser           ),
    .m_axi_wvalid          (m_axi_wvalid          ),
    .m_axi_wready          (m_axi_wready          ),
    .m_axi_arid            (m_axi_arid            ),
    .m_axi_araddr          (m_axi_araddr          ),
    .m_axi_arlen           (m_axi_arlen           ),
    .m_axi_arsize          (m_axi_arsize          ),
    .m_axi_arburst         (m_axi_arburst         ),
    .m_axi_arlock          (m_axi_arlock          ),
    .m_axi_arcache         (m_axi_arcache         ),
    .m_axi_arprot          (m_axi_arprot          ),
    .m_axi_arqos           (m_axi_arqos           ),
    .m_axi_arregion        (m_axi_arregion        ),
    .m_axi_aruser          (m_axi_aruser          ),
    .m_axi_arvalid         (m_axi_arvalid         ),
    .m_axi_arready         (m_axi_arready         ),
    .m_axi_rid             (m_axi_rid             ),
    .m_axi_rdata           (m_axi_rdata           ),
    .m_axi_rresp           (m_axi_rresp           ),
    .m_axi_rlast           (m_axi_rlast           ),
    .m_axi_ruser           (m_axi_ruser           ),
    .m_axi_rvalid          (m_axi_rvalid          ),
    .m_axi_rready          (m_axi_rready          ),
    .m_axi_bid             (m_axi_bid             ),
    .m_axi_bresp           (m_axi_bresp           ),
    .m_axi_buser           (m_axi_buser           ),
    .m_axi_bvalid          (m_axi_bvalid          ),
    .m_axi_bready          (m_axi_bready          )
);



axi_ram #(.DATA_WIDTH(`AXI4_DATA_WIDTH), .ADDR_WIDTH(16), .ID_WIDTH(`AXI4_ID_WIDTH)) i_axi_ram (
    .clk          (clk          ),
    .rst          (!rst_n        ),
    .s_axi_awid   (m_axi_awid   ),
    .s_axi_awaddr (m_axi_awaddr ),
    .s_axi_awlen  (m_axi_awlen  ),
    .s_axi_awsize (m_axi_awsize ),
    .s_axi_awburst(m_axi_awburst),
    .s_axi_awlock (m_axi_awlock ),
    .s_axi_awcache(m_axi_awcache),
    .s_axi_awprot (m_axi_awprot ),
    .s_axi_awvalid(m_axi_awvalid),
    .s_axi_awready(m_axi_awready),
    .s_axi_wdata  (m_axi_wdata  ),
    .s_axi_wstrb  (m_axi_wstrb  ),
    .s_axi_wlast  (m_axi_wlast  ),
    .s_axi_wvalid (m_axi_wvalid ),
    .s_axi_wready (m_axi_wready ),
    .s_axi_bid    (m_axi_bid    ),
    .s_axi_bresp  (m_axi_bresp  ),
    .s_axi_bvalid (m_axi_bvalid ),
    .s_axi_bready (m_axi_bready ),
    .s_axi_arid   (m_axi_arid   ),
    .s_axi_araddr (m_axi_araddr ),
    .s_axi_arlen  (m_axi_arlen  ),
    .s_axi_arsize (m_axi_arsize ),
    .s_axi_arburst(m_axi_arburst),
    .s_axi_arlock (m_axi_arlock ),
    .s_axi_arcache(m_axi_arcache),
    .s_axi_arprot (m_axi_arprot ),
    .s_axi_arvalid(m_axi_arvalid),
    .s_axi_arready(m_axi_arready),
    .s_axi_rid    (m_axi_rid    ),
    .s_axi_rdata  (m_axi_rdata  ),
    .s_axi_rresp  (m_axi_rresp  ),
    .s_axi_rlast  (m_axi_rlast  ),
    .s_axi_rvalid (m_axi_rvalid ),
    .s_axi_rready (m_axi_rready )
);

endmodule

