import torch
import torch.nn as nn
from torch.nn import LSTM
from net.sublayer import MultiHeadAttention, PositionwiseFeedForward


class EncoderLayer(nn.Module):
    def __init__(self, d_model, n_head, d_k, d_v, d_inner, dropout=0.1):
        super().__init__()
        self.slf_attn = MultiHeadAttention(d_model, n_head, d_k, d_v, dropout=dropout)
        self.pos_ffn = PositionwiseFeedForward(d_model, d_inner, dropout=dropout)

    def forward(self, enc_input, slf_attn_mask=None):
        enc_output, enc_slf_attn = self.slf_attn(enc_input, enc_input, enc_input, mask=slf_attn_mask)
        enc_output = self.pos_ffn(enc_output)

        return enc_output, enc_slf_attn


class LSTM_10(nn.Module):
    def __init__(self, n_feature_in, n_feature_out, n_layer):
        super().__init__()

        self.LSTM00 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM01 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM02 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM03 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM04 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM05 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM06 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM07 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM08 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM09 = LSTM(n_feature_in, n_feature_out, n_layer)

    def forward(self, x):
        y00, (h00, c00) = self.LSTM00(x[ 0, :, :].unsqueeze(0))
        y01, (h01, c01) = self.LSTM01(x[ 1, :, :].unsqueeze(0), (h00, c00))
        y02, (h02, c02) = self.LSTM02(x[ 2, :, :].unsqueeze(0), (h01, c01))
        y03, (h03, c03) = self.LSTM03(x[ 3, :, :].unsqueeze(0), (h02, c02))
        y04, (h04, c04) = self.LSTM04(x[ 4, :, :].unsqueeze(0), (h03, c03))
        y05, (h05, c05) = self.LSTM05(x[ 5, :, :].unsqueeze(0), (h04, c04))
        y06, (h06, c06) = self.LSTM06(x[ 6, :, :].unsqueeze(0), (h05, c05))
        y07, (h07, c07) = self.LSTM07(x[ 7, :, :].unsqueeze(0), (h06, c06))
        y08, (h08, c08) = self.LSTM08(x[ 8, :, :].unsqueeze(0), (h07, c07))
        y09, (h09, c09) = self.LSTM09(x[ 9, :, :].unsqueeze(0), (h08, c08))

        y = torch.cat(
            [y00, y01, y02, y03, y04, y05, y06, y07, y08, y09],
            dim=0)
        h = h09
        c = c09

        return y, (h, c)


class LSTM_30(nn.Module):
    def __init__(self, n_feature_in, n_feature_out, n_layer):
        super().__init__()

        self.LSTM00 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM01 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM02 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM03 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM04 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM05 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM06 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM07 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM08 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM09 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM10 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM11 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM12 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM13 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM14 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM15 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM16 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM17 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM18 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM19 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM20 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM21 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM22 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM23 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM24 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM25 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM26 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM27 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM28 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM29 = LSTM(n_feature_in, n_feature_out, n_layer)

    def forward(self, x):
        y00, (h00, c00) = self.LSTM00(x[ 0, :, :].unsqueeze(0))
        y01, (h01, c01) = self.LSTM01(x[ 1, :, :].unsqueeze(0), (h00, c00))
        y02, (h02, c02) = self.LSTM02(x[ 2, :, :].unsqueeze(0), (h01, c01))
        y03, (h03, c03) = self.LSTM03(x[ 3, :, :].unsqueeze(0), (h02, c02))
        y04, (h04, c04) = self.LSTM04(x[ 4, :, :].unsqueeze(0), (h03, c03))
        y05, (h05, c05) = self.LSTM05(x[ 5, :, :].unsqueeze(0), (h04, c04))
        y06, (h06, c06) = self.LSTM06(x[ 6, :, :].unsqueeze(0), (h05, c05))
        y07, (h07, c07) = self.LSTM07(x[ 7, :, :].unsqueeze(0), (h06, c06))
        y08, (h08, c08) = self.LSTM08(x[ 8, :, :].unsqueeze(0), (h07, c07))
        y09, (h09, c09) = self.LSTM09(x[ 9, :, :].unsqueeze(0), (h08, c08))
        y10, (h10, c10) = self.LSTM10(x[10, :, :].unsqueeze(0), (h09, c09))
        y11, (h11, c11) = self.LSTM11(x[11, :, :].unsqueeze(0), (h10, c10))
        y12, (h12, c12) = self.LSTM12(x[12, :, :].unsqueeze(0), (h11, c11))
        y13, (h13, c13) = self.LSTM13(x[13, :, :].unsqueeze(0), (h12, c12))
        y14, (h14, c14) = self.LSTM14(x[14, :, :].unsqueeze(0), (h13, c13))
        y15, (h15, c15) = self.LSTM15(x[15, :, :].unsqueeze(0), (h14, c14))
        y16, (h16, c16) = self.LSTM16(x[16, :, :].unsqueeze(0), (h15, c15))
        y17, (h17, c17) = self.LSTM17(x[17, :, :].unsqueeze(0), (h16, c16))
        y18, (h18, c18) = self.LSTM18(x[18, :, :].unsqueeze(0), (h17, c17))
        y19, (h19, c19) = self.LSTM19(x[19, :, :].unsqueeze(0), (h18, c18))
        y20, (h20, c20) = self.LSTM20(x[20, :, :].unsqueeze(0), (h19, c19))
        y21, (h21, c21) = self.LSTM21(x[21, :, :].unsqueeze(0), (h20, c20))
        y22, (h22, c22) = self.LSTM22(x[22, :, :].unsqueeze(0), (h21, c21))
        y23, (h23, c23) = self.LSTM23(x[23, :, :].unsqueeze(0), (h22, c22))
        y24, (h24, c24) = self.LSTM24(x[24, :, :].unsqueeze(0), (h23, c23))
        y25, (h25, c25) = self.LSTM25(x[25, :, :].unsqueeze(0), (h24, c24))
        y26, (h26, c26) = self.LSTM26(x[26, :, :].unsqueeze(0), (h25, c25))
        y27, (h27, c27) = self.LSTM27(x[27, :, :].unsqueeze(0), (h26, c26))
        y28, (h28, c28) = self.LSTM28(x[28, :, :].unsqueeze(0), (h27, c27))
        y29, (h29, c29) = self.LSTM29(x[28, :, :].unsqueeze(0), (h28, c28))

        y = torch.cat(
            [y00, y01, y02, y03, y04, y05, y06, y07, y08, y09, y10, y11, y12, y13, y14, y15, y16, y17, y18, y19, y20, y21, y22, y23, y24, y25, y26, y27, y28, y29],
            dim=0)
        h = h29
        c = c29

        return y, (h, c)


class LSTM_70(nn.Module):
    def __init__(self, n_feature_in, n_feature_out, n_layer):
        super().__init__()

        self.LSTM00 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM01 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM02 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM03 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM04 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM05 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM06 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM07 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM08 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM09 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM10 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM11 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM12 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM13 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM14 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM15 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM16 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM17 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM18 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM19 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM20 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM21 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM22 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM23 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM24 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM25 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM26 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM27 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM28 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM29 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM30 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM31 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM32 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM33 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM34 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM35 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM36 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM37 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM38 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM39 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM40 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM41 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM42 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM43 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM44 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM45 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM46 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM47 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM48 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM49 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM50 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM51 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM52 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM53 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM54 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM55 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM56 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM57 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM58 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM59 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM60 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM61 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM62 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM63 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM64 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM65 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM66 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM67 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM68 = LSTM(n_feature_in, n_feature_out, n_layer)
        self.LSTM69 = LSTM(n_feature_in, n_feature_out, n_layer)

    def forward(self, x):
        y00, (h00, c00) = self.LSTM00(x[ 0, :, :].unsqueeze(0))
        y01, (h01, c01) = self.LSTM01(x[ 1, :, :].unsqueeze(0), (h00, c00))
        y02, (h02, c02) = self.LSTM02(x[ 2, :, :].unsqueeze(0), (h01, c01))
        y03, (h03, c03) = self.LSTM03(x[ 3, :, :].unsqueeze(0), (h02, c02))
        y04, (h04, c04) = self.LSTM04(x[ 4, :, :].unsqueeze(0), (h03, c03))
        y05, (h05, c05) = self.LSTM05(x[ 5, :, :].unsqueeze(0), (h04, c04))
        y06, (h06, c06) = self.LSTM06(x[ 6, :, :].unsqueeze(0), (h05, c05))
        y07, (h07, c07) = self.LSTM07(x[ 7, :, :].unsqueeze(0), (h06, c06))
        y08, (h08, c08) = self.LSTM08(x[ 8, :, :].unsqueeze(0), (h07, c07))
        y09, (h09, c09) = self.LSTM09(x[ 9, :, :].unsqueeze(0), (h08, c08))
        y10, (h10, c10) = self.LSTM10(x[10, :, :].unsqueeze(0), (h09, c09))
        y11, (h11, c11) = self.LSTM11(x[11, :, :].unsqueeze(0), (h10, c10))
        y12, (h12, c12) = self.LSTM12(x[12, :, :].unsqueeze(0), (h11, c11))
        y13, (h13, c13) = self.LSTM13(x[13, :, :].unsqueeze(0), (h12, c12))
        y14, (h14, c14) = self.LSTM14(x[14, :, :].unsqueeze(0), (h13, c13))
        y15, (h15, c15) = self.LSTM15(x[15, :, :].unsqueeze(0), (h14, c14))
        y16, (h16, c16) = self.LSTM16(x[16, :, :].unsqueeze(0), (h15, c15))
        y17, (h17, c17) = self.LSTM17(x[17, :, :].unsqueeze(0), (h16, c16))
        y18, (h18, c18) = self.LSTM18(x[18, :, :].unsqueeze(0), (h17, c17))
        y19, (h19, c19) = self.LSTM19(x[19, :, :].unsqueeze(0), (h18, c18))
        y20, (h20, c20) = self.LSTM20(x[20, :, :].unsqueeze(0), (h19, c19))
        y21, (h21, c21) = self.LSTM21(x[21, :, :].unsqueeze(0), (h20, c20))
        y22, (h22, c22) = self.LSTM22(x[22, :, :].unsqueeze(0), (h21, c21))
        y23, (h23, c23) = self.LSTM23(x[23, :, :].unsqueeze(0), (h22, c22))
        y24, (h24, c24) = self.LSTM24(x[24, :, :].unsqueeze(0), (h23, c23))
        y25, (h25, c25) = self.LSTM25(x[25, :, :].unsqueeze(0), (h24, c24))
        y26, (h26, c26) = self.LSTM26(x[26, :, :].unsqueeze(0), (h25, c25))
        y27, (h27, c27) = self.LSTM27(x[27, :, :].unsqueeze(0), (h26, c26))
        y28, (h28, c28) = self.LSTM28(x[28, :, :].unsqueeze(0), (h27, c27))
        y29, (h29, c29) = self.LSTM29(x[29, :, :].unsqueeze(0), (h28, c28))
        y30, (h30, c30) = self.LSTM30(x[30, :, :].unsqueeze(0), (h29, c29))
        y31, (h31, c31) = self.LSTM31(x[31, :, :].unsqueeze(0), (h30, c30))
        y32, (h32, c32) = self.LSTM32(x[32, :, :].unsqueeze(0), (h31, c31))
        y33, (h33, c33) = self.LSTM33(x[33, :, :].unsqueeze(0), (h32, c32))
        y34, (h34, c34) = self.LSTM34(x[34, :, :].unsqueeze(0), (h33, c33))
        y35, (h35, c35) = self.LSTM35(x[35, :, :].unsqueeze(0), (h34, c34))
        y36, (h36, c36) = self.LSTM36(x[36, :, :].unsqueeze(0), (h35, c35))
        y37, (h37, c37) = self.LSTM37(x[37, :, :].unsqueeze(0), (h36, c36))
        y38, (h38, c38) = self.LSTM38(x[38, :, :].unsqueeze(0), (h37, c37))
        y39, (h39, c39) = self.LSTM39(x[39, :, :].unsqueeze(0), (h38, c38))
        y40, (h40, c40) = self.LSTM40(x[40, :, :].unsqueeze(0), (h39, c39))
        y41, (h41, c41) = self.LSTM41(x[41, :, :].unsqueeze(0), (h40, c40))
        y42, (h42, c42) = self.LSTM42(x[42, :, :].unsqueeze(0), (h41, c41))
        y43, (h43, c43) = self.LSTM43(x[43, :, :].unsqueeze(0), (h42, c42))
        y44, (h44, c44) = self.LSTM44(x[44, :, :].unsqueeze(0), (h43, c43))
        y45, (h45, c45) = self.LSTM45(x[45, :, :].unsqueeze(0), (h44, c44))
        y46, (h46, c46) = self.LSTM46(x[46, :, :].unsqueeze(0), (h45, c45))
        y47, (h47, c47) = self.LSTM47(x[47, :, :].unsqueeze(0), (h46, c46))
        y48, (h48, c48) = self.LSTM48(x[48, :, :].unsqueeze(0), (h47, c47))
        y49, (h49, c49) = self.LSTM49(x[49, :, :].unsqueeze(0), (h48, c48))
        y50, (h50, c50) = self.LSTM50(x[50, :, :].unsqueeze(0), (h49, c49))
        y51, (h51, c51) = self.LSTM51(x[51, :, :].unsqueeze(0), (h50, c50))
        y52, (h52, c52) = self.LSTM52(x[52, :, :].unsqueeze(0), (h51, c51))
        y53, (h53, c53) = self.LSTM53(x[53, :, :].unsqueeze(0), (h52, c52))
        y54, (h54, c54) = self.LSTM54(x[54, :, :].unsqueeze(0), (h53, c53))
        y55, (h55, c55) = self.LSTM55(x[55, :, :].unsqueeze(0), (h54, c54))
        y56, (h56, c56) = self.LSTM56(x[56, :, :].unsqueeze(0), (h55, c55))
        y57, (h57, c57) = self.LSTM57(x[57, :, :].unsqueeze(0), (h56, c56))
        y58, (h58, c58) = self.LSTM58(x[58, :, :].unsqueeze(0), (h57, c57))
        y59, (h59, c59) = self.LSTM59(x[59, :, :].unsqueeze(0), (h58, c58))
        y60, (h60, c60) = self.LSTM60(x[60, :, :].unsqueeze(0), (h59, c59))
        y61, (h61, c61) = self.LSTM61(x[61, :, :].unsqueeze(0), (h60, c60))
        y62, (h62, c62) = self.LSTM62(x[62, :, :].unsqueeze(0), (h61, c61))
        y63, (h63, c63) = self.LSTM63(x[63, :, :].unsqueeze(0), (h62, c62))
        y64, (h64, c64) = self.LSTM64(x[64, :, :].unsqueeze(0), (h63, c63))
        y65, (h65, c65) = self.LSTM65(x[65, :, :].unsqueeze(0), (h64, c64))
        y66, (h66, c66) = self.LSTM66(x[66, :, :].unsqueeze(0), (h65, c65))
        y67, (h67, c67) = self.LSTM67(x[67, :, :].unsqueeze(0), (h66, c66))
        y68, (h68, c68) = self.LSTM68(x[68, :, :].unsqueeze(0), (h67, c67))
        y69, (h69, c69) = self.LSTM69(x[69, :, :].unsqueeze(0), (h68, c68))

        y = torch.cat(
            [y00, y01, y02, y03, y04, y05, y06, y07, y08, y09, y10, y11, y12, y13, y14, y15, y16, y17, y18, y19, y20, y21, y22, y23, y24, y25, y26, y27, y28, y29, y30, y31, y32, y33, y34, y35, y36, y37, y38, y39, y40, y41, y42, y43, y44, y45, y46, y47, y48, y49, y50, y51, y52, y53, y54, y55, y56, y57, y58, y59, y60, y61, y62, y63, y64, y65, y66, y67, y68, y69],
            dim=0)
        h = h69
        c = c69

        return y, (h, c)