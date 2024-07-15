import torch.nn as nn
from net.model import Rnn1d, Encoder, CNN, MLP, FC, Rnn2d


class BuildCA1(nn.Module):
    def __init__(self, type_model, d_seq, d_feature1, d_feature2, d_rnn_outpt, d_mlp, nChannel, nKernel, nMaxpooling, n_layer, d_model, n_head, d_k, d_v, d_inner, nNeuron_fc_input, nNeuron_fc_output, dropout):
        super().__init__()
        if type_model == 1 or type_model == 2 or type_model == 3:
            self.model01 = Rnn1d(d_feature1, d_feature2, dropout)
        elif type_model == 4 or type_model == 5 or type_model == 6:
            self.model01 = Rnn2d(d_seq, d_feature1, d_feature2, dropout)

        if type_model == 1 or type_model == 4:
            self.model02 = MLP(d_rnn_outpt, d_mlp, dropout)
        elif type_model == 2 or type_model == 5:
            self.model02 = CNN(nChannel, nKernel, nMaxpooling, dropout)
        elif type_model == 3 or type_model == 6:
            self.model02 = Encoder(n_layer, d_model, n_head, d_k, d_v, d_inner, dropout)

        self.model03 = FC(nNeuron_fc_input, nNeuron_fc_output, dropout)

    def forward(self, code_input, type_model, isPhase, d_rnn_outpt, d_cnn, enc_mask):
        code_target = self.model01(code_input)

        if type_model == 1 or type_model == 4:
            code_target = self.model02(code_target, d_rnn_outpt)
        elif type_model == 2 or type_model == 5:
            code_target = self.model02(code_target, d_cnn)
        elif type_model == 3 or type_model == 6:
            code_target, _ = self.model02(code_target, d_rnn_outpt, enc_mask)

        code_target = self.model03(code_target, isPhase)

        return code_target
