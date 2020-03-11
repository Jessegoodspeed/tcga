import pandas as pd
import torch
from torch.utils.data import Dataset


class TCGA_Dataset(Dataset):
    def __init__(self, tsv_file, transform=None):
        self.data_frame = pd.read_csv(tsv_file, sep='\t', header=0)
        self.tcga_frame = self.data_frame.iloc[:, 1:].T
        self.transform = transform

    def __len__(self):
        return len(self.tcga_frame)

    def __getitem__(self, idx):
        if torch.is_tensor(idx):
            idx = idx.tolist()

        tcga_i = torch.tensor(self.tcga_frame.iloc[idx, :])
        label = self.data_frame.columns[idx].split(sep='.')[0]
        sample = {'expression': tcga_i, 'cancer': label}

        if self.transform:
            sample = self.transform(sample)

        return sample


class AE3(torch.nn.Module):
    def __init__(self, **kwargs):
        super().__init__()
        self.eH0 = torch.nn.Linear(  # encoderHiddden
            in_features=kwargs["input_shape"], out_features=10
        )
        self.eO = torch.nn.Linear(  # encoderOutput
            in_features=10, out_features=10
        )
        self.dH0 = torch.nn.Linear(  # decoderHidden
            in_features=10, out_features=10
        )
        self.dO = torch.nn.Linear(
            in_features=10, out_features=kwargs["input_shape"]
        )

    def forward(self, features):
        a = self.eH0(torch.tanh(features))  # activation
        a = self.eO(torch.tanh(a))
        a = self.dH0(torch.tanh(a))
        return self.dO(torch.tanh(a))


class AE5(torch.nn.Module):
    def __init__(self, **kwargs):
        super().__init__()
        self.eH0 = torch.nn.Linear(  # encoderHiddden
            in_features=kwargs["input_shape"], out_features=8912
        )
        self.eH1 = torch.nn.Linear(
            in_features=8912, out_features=10
        )
        self.eO = torch.nn.Linear(  # encoderOutput
            in_features=10, out_features=10
        )
        self.dH0 = torch.nn.Linear(  # decoderHidden
            in_features=10, out_features=10
        )
        self.dH1 = torch.nn.Linear(
            in_features=10, out_features=8912
        )
        self.dO = torch.nn.Linear(
            in_features=8912, out_features=kwargs["input_shape"]
        )

    def forward(self, features):
        a = self.eH0(torch.tanh(features))  # activation
        a = self.eH1(torch.tanh(a))
        a = self.eO(torch.tanh(a))
        a = self.dH0(torch.tanh(a))
        a = self.dH1(torch.tanh(a))
        return self.dO(torch.tanh(a))


class AE7(torch.nn.Module):
    def __init__(self, **kwargs):
        super().__init__()
        self.eH0 = torch.nn.Linear(  # encoderHiddden
            in_features=kwargs["input_shape"], out_features=11880
        )
        self.eH1 = torch.nn.Linear(
            in_features=11880, out_features=5945
        )
        self.eH2 = torch.nn.Linear(
            in_features=5945, out_features=10
        )
        self.eO = torch.nn.Linear(  # encoderOutput
            in_features=10, out_features=10
        )
        self.dH0 = torch.nn.Linear(  # decoderHidden
            in_features=10, out_features=10
        )
        self.dH1 = torch.nn.Linear(
            in_features=10, out_features=5945
        )
        self.dH2 = torch.nn.Linear(
            in_features=5945, out_features=11880
        )
        self.dO = torch.nn.Linear(
            in_features=11880, out_features=kwargs["input_shape"]
        )

    def forward(self, features):
        a = self.eH0(torch.tanh(features))  # activation
        a = self.eH1(torch.tanh(a))
        a = self.eH2(torch.tanh(a))
        a = self.eO(torch.tanh(a))
        a = self.dH0(torch.tanh(a))
        a = self.dH1(torch.tanh(a))
        a = self.dH2(torch.tanh(a))
        return self.dO(torch.tanh(a))
