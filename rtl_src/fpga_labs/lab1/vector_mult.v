module vector_mult
  # (parameter N=4,                                //number of elements in a vector
               DW=2,
			   BRAM_DEPTH=32)                               //size of each element
    (input clk,
     input rst,
     output reg [(2*DW + $clog2(N))-1:0] result,
     input [DW -1:0] vect_a,
     input [DW -1:0] vect_b,
     output reg mem_rd_en,
	 output reg [$clog2(BRAM_DEPTH)-1:0] rd_addr,
	 output reg mem_wr_en,
	 output reg [$clog2(BRAM_DEPTH)-1:0] wr_addr
	 );

reg [$clog2(N):0] count;

//MAC
always@(posedge clk or posedge rst)
begin
  if (rst) begin
    result   <= 0;
  end else begin
    if (count <= 1) result <= vect_a*vect_b;
	else            result <= result + vect_a*vect_b;
  end
end

//counter
always@(posedge clk or posedge rst)
begin
  if (rst) begin
    count <= 0;
  end else begin
    if (count == N) count <= 0;
	else            count <= count + 1;
  end
end

//read address
always@(posedge clk or posedge rst)
begin
  if (rst) begin
    rd_addr   <= 0;
  end else begin
    if (mem_rd_en) rd_addr   <= rd_addr + 1'b1;
  end
end

// memory read enable
always@(posedge clk or posedge rst) begin
  if (rst) begin
    mem_rd_en <= 'b1;
  end else begin
    if (count == N-1) mem_rd_en <= 'b0;
    else              mem_rd_en <= 'b1;
  end
end

// memory write enable
always@(posedge clk or posedge rst) begin
  if (rst) begin
    mem_wr_en <= 'b0;
  end else begin
    if (count == N) mem_wr_en <= 'b1;
    else              mem_wr_en <= 'b0;
  end
end

//write address
always@(posedge clk or posedge rst)
begin
  if (rst) begin
    wr_addr   <= 0;
  end else begin
    if (mem_wr_en) wr_addr   <= wr_addr + 1'b1;
  end
end

endmodule