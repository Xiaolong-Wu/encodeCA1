import torch
import torch.nn as nn
from torch.nn import LSTM, Conv2d, MaxPool2d, Linear
from net.layer import EncoderLayer, LSTM_10, LSTM_30, LSTM_70


class Rnn1d(nn.Module):
    def __init__(self, d_feature1, d_feature2, dropout):
        super().__init__()
        self.LSTM = LSTM(d_feature1, d_feature2, 1)

        self.dropout = nn.Dropout(p=dropout)

    def forward(self, code_input):
        code_input = code_input.transpose(0, 1).contiguous()

        code_input, (h, c) = self.LSTM(code_input)
        code_input = self.dropout(code_input)
        code_input = nn.functional.relu(code_input)

        code_input = code_input.transpose(0, 1).contiguous()

        return code_input


class Encoder(nn.Module):
    def __init__(self, n_layer, d_model, n_head, d_k, d_v, d_inner, dropout):
        super().__init__()

        self.layer_stack = nn.ModuleList([
            EncoderLayer(d_model, n_head, d_k, d_v, d_inner, dropout=dropout)
            for _ in range(n_layer)])

    def forward(self, enc_output, d_rnn_outpt, enc_mask, return_attns=False):
        enc_slf_attn_list = []

        for enc_layer in self.layer_stack:
            enc_output, enc_slf_attn = enc_layer(enc_output, slf_attn_mask=enc_mask)
            enc_slf_attn_list += [enc_slf_attn] if return_attns else []

        enc_output = enc_output.view(-1, d_rnn_outpt)

        return enc_output, enc_slf_attn_list


class CNN(nn.Module):
    def __init__(self, nChannel, nKernel, nMaxpooling, dropout):
        super().__init__()

        self.conv2d = Conv2d(1, nChannel, (nKernel[0], nKernel[1]), stride=[1, 1])
        self.maxpool2d = MaxPool2d((nMaxpooling[0], nMaxpooling[1]), stride=(nMaxpooling[0], nMaxpooling[1]))

        self.dropout = nn.Dropout(p=dropout)

    def forward(self, cnn_output, d_cnn):
        cnn_output = cnn_output.unsqueeze(1)

        cnn_output = self.conv2d(cnn_output)
        cnn_output = nn.functional.relu(cnn_output)
        cnn_output = self.maxpool2d(cnn_output)

        cnn_output = cnn_output.view(-1, d_cnn)

        return cnn_output


class MLP(nn.Module):
    def __init__(self, d_rnn_outpt, d_mlp, dropout):
        super().__init__()

        self.linear = Linear(d_rnn_outpt, d_mlp)

        self.dropout = nn.Dropout(p=dropout)

    def forward(self, mlp_output, d_rnn_outpt):
        mlp_output = mlp_output.view(-1, d_rnn_outpt)

        mlp_output = self.linear(mlp_output)
        mlp_output = self.dropout(mlp_output)
        mlp_output = nn.functional.relu(mlp_output)

        return mlp_output


class FC(nn.Module):
    def __init__(self, nNeuron_fc_input, nNeuron_fc_output, dropout):
        super().__init__()

        self.linear = Linear(nNeuron_fc_input, nNeuron_fc_output)

        self.dropout = nn.Dropout(p=dropout)
        self.softmax = nn.Softmax(dim=1)

    def forward(self, fc_output, isPhase):
        fc_output = self.linear(fc_output)
        if isPhase == 1:
            fc_output1 = torch.sign(fc_output)

            fc_output2 = self.softmax(torch.abs(fc_output))
            fc_output2 = torch.sqrt(fc_output2)

            fc_output = fc_output1*fc_output2

        return fc_output


class Rnn2d(nn.Module):
    def __init__(self, d_seq, d_feature1, d_feature2, dropout):
        super().__init__()
        if d_seq == 10:
            self.LSTM = LSTM_10(d_feature1, d_feature2, 1)
        elif d_seq == 30:
            self.LSTM = LSTM_30(d_feature1, d_feature2, 1)
        elif d_seq == 70:
            self.LSTM = LSTM_70(d_feature1, d_feature2, 1)

        self.dropout = nn.Dropout(p=dropout)

    def forward(self, code_input):
        code_input = code_input.transpose(0, 1).contiguous()

        code_input, (h, c) = self.LSTM(code_input)
        code_input = self.dropout(code_input)
        code_input = nn.functional.relu(code_input)

        code_input = code_input.transpose(0, 1).contiguous()

        return code_input
