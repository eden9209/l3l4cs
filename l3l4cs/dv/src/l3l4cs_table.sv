`ifndef PDU_HDLR_TABLE_SV
`define PDU_HDLR_TABLE_SV

class l3l4cs_table extends ce_base_table;
   `uvm_object_utils(l3l4cs_table)
 
    string subsys_frefix[];
    
function new(string name="");
       super.new(name);
         COLUMN1_WD =0;
endfunction : new

function void init(int col, int row);
    super.init(col,row);
    subsys_frefix=new[col];
    foreach(subsys_frefix[i])
        subsys_frefix[i]=" ";
endfunction : init

function string get_table_hdr (int subsys_i);
   string s;
    string sep=subsys_build_en[subsys_i]?"|":" ";
      case(table_kind)
      
          default:begin
              int space[2];
              string hdr= subsys_name[subsys_i];
              string pre= subsys_frefix[subsys_i];
              hdr=set_str_len(hdr,padd[table_kind]);
              
              space[0]=padd[table_kind]-3;
              space[1]=padd[table_kind]-hdr.len;
            
          s=padd_cell({{space[0]{" "}},
              $sformatf("%-3s%0s%s",pre,sep,hdr),
              {space[1]{" "}}},
              padd[table_kind]);
            end
      endcase//table_kind
   return(s);
endfunction:get_table_hdr
endclass: l3l4cs_table 
`endif// PDU_HDLR_TABLE_SV
