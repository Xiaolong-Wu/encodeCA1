import torch.nn as nn
from net.module import ScaledDotProductAttention


class MultiHeadAttention(nn.Module):
    def __init__(self, d_model, n_head, d_k, d_v, dropout=0.1):
        super().__init__()

        self.n_head = n_head
        self.d_k = d_k
        self.d_v = d_v

        self.w_qs = nn.Linear(d_model, n_head * d_k, bias=False)
        self.w_ks = nn.Linear(d_model, n_head * d_k, bias=False)
        self.w_vs = nn.Linear(d_model, n_head * d_v, bias=False)
        self.fc = nn.Linear(n_head * d_v, d_model, bias=False)

        self.attention = ScaledDotProductAttention(temperature=d_k ** 0.5)

        self.dropout = nn.Dropout(p=dropout)
        self.layer_norm = nn.LayerNorm(d_model, eps=1e-6)

    def forward(self, q, k, v, mask=None):

        d_k = self.d_k
        d_v = self.d_v
        n_head = self.n_head

        sz_b = q.size(0)
        len_q = q.size(1)
        len_k = k.size(1)
        len_v = v.size(1)

        residual = q

        # pass through the pre-attention projection, batchSize * seqLength * (nHead * d_k):
        # sz_b * len_k * (n_head * d_k)
        # separate different heads:
        # sz_b * len_k * n_head * d_k
        q = self.w_qs(q).view(sz_b, len_q, n_head, d_k)
        k = self.w_ks(k).view(sz_b, len_k, n_head, d_k)
        v = self.w_vs(v).view(sz_b, len_v, n_head, d_v)

        # transpose for attention dot product:
        # sz_b * n_head * len_k * d_k
        q = q.transpose(1, 2)
        k = k.transpose(1, 2)
        v = v.transpose(1, 2)

        if mask is not None:
            mask = mask.unsqueeze(1)   # for n_head axis broadcasting.

        q, attn = self.attention(q, k, v, mask=mask)

        # transpose to move the head dimension back:
        # sz_b * len_k * n_head * d_k
        # combine the last two dimensions to concatenate all the heads together:
        # sz_b * len_q * (n_head * d_k)
        q = q.transpose(1, 2).contiguous().view(sz_b, len_q, -1)
        q = self.dropout(self.fc(q))
        q += residual

        q = self.layer_norm(q)

        return q, attn


class PositionwiseFeedForward(nn.Module):
    def __init__(self, d_in, d_hid, dropout=0.1):
        super().__init__()
        self.w_1 = nn.Linear(d_in, d_hid)
        self.w_2 = nn.Linear(d_hid, d_in)
        self.layer_norm = nn.LayerNorm(d_in, eps=1e-6)
        self.dropout = nn.Dropout(p=dropout)

    def forward(self, x):

        residual = x

        x = self.w_1(x)
        x = nn.functional.relu(x)

        x = self.w_2(x)
        x = self.dropout(x)
        x += residual

        x = self.layer_norm(x)

        return x
